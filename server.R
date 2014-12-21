library(ggplot2)
library(UsingR)
library(shiny)
library(dplyr)

transformDataset <- function(dataset) {
  result <- dataset
  result$season <- factor(dataset$season)
  result$holiday <- factor(dataset$holiday)
  result$workingday <- factor(dataset$workingday)
  result$weather <- factor(dataset$weather)
  result$hour <- as.factor(substring(dataset$datetime, 12, 13))
  result$dayOfTheWeek <- as.factor(weekdays(as.Date(dataset$datetime)))
  result$dayOfTheWeek <- factor(result$dayOfTheWeek, levels(result$dayOfTheWeek)[c(4, 3, 1, 5, 7, 6, 2)])
  result$month <- as.factor(months(as.Date(dataset$datetime)))
  result$month <- factor(result$month, levels(result$month)[c(5, 4, 8, 1, 9, 7, 6, 2, 12, 11, 10, 3)])
  result
}

getFillByUserType <- function(userType) {
   if (userType == 'All') {
    fill <- aes(fill = count)  
  } else if (userType == 'Casual') {
    fill <- aes(fill = casual)
  } else if (userType == 'Registered') {
    fill <- aes(fill = registered)
  }
  fill
}

getPlotDataByGroupType <- function(data, byMonth) {
  if (byMonth == TRUE) {
    countGroup <- group_by(data, dayOfTheWeek, hour, month)
  } else {
    countGroup <- group_by(data, dayOfTheWeek, hour)
  }
  count <- summarise(countGroup, count=mean(count), casual=mean(casual), registered=mean(registered))
  count
}


shinyServer(
  function(input, output) {
    getPlotSizeByGroupType <- function() {
      height = 200
      if (input$by_month == TRUE) {
        height = height * 9
      }
      height
    }
    output$main_plot <- renderPlot({
      data <- transformDataset(read.csv("bike-sharing.csv"))
      plotData <- getPlotDataByGroupType(data, input$by_month)
      p <- ggplot(plotData, aes(x = hour, y = dayOfTheWeek)) + 
        scale_fill_gradient(name="Average Counts", low="white", high="violet") + 
        theme(axis.title.y = element_blank()) + 
        ggtitle("Bicycle sharing count density") +
        geom_tile(getFillByUserType(input$usertype))
      if (input$by_month == TRUE) {
        p <- p + facet_grid(month ~ .)
      }
      p
    }, height = getPlotSizeByGroupType)
  }
)
