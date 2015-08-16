# ui.R

shinyUI(fluidPage(
    titlePanel("US Census Visualization"),
    
    sidebarLayout(
        sidebarPanel(
            helpText("Create demographic map with 
        information from the 2010 US Census."),
            helpText("Instructions: Select a demographic from the dropdown below and 
        adjust the slider for the percentage range that you are interested in. The 
        map will update with the chosen parameters so that you can easily visualize
        in which of the various US states the specified demographic resides."),
            
            selectInput("var", 
                        label = "Choose a demographic to display:",
                        choices = c("Percent White", "Percent Black",
                                    "Percent Hispanic", "Percent Asian"),
                        selected = "Percent White"),
            
            sliderInput("range", 
                        label = "Range of interest:",
                        min = 0, max = 100, value = c(0, 100))
        ),
        
        mainPanel(plotOutput("map"))
    )
))
