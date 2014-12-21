shinyUI(bootstrapPage(
  selectInput(inputId = "usertype",
              label = "User type:",
              choices = c("All", "Casual", "Registered"),
              selected = 20),
  checkboxInput(inputId = "by_month",
                label = strong("Show by month"),
                value = FALSE),
  plotOutput(outputId = "main_plot", height = "auto")  
))