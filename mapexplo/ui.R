shinyUI(fluidPage(
  titlePanel("Playing with aggregation"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("lon", label="x-value", min=-120, max=-116, step=0.01, value=-119),
      sliderInput("lat", label="y-value", min=32, max=35, step=0.01, value=32),
      sliderInput("howmany", label="boxes", min=1, max=10, step=1, value=5)
      ),
  mainPanel(plotOutput("map"))
  )
))