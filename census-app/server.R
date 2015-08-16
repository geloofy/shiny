# server.R

library(maps)
library(mapproj)
counties <- readRDS("data/counties.rds")

percent_map <- function(var, color, legend.title, min = 0, max = 100) {
    
    # generate vector of fill colors for map
    shades <- colorRampPalette(c("white", color))(100)
    
    # constrain gradient to percents that occur between min and max
    var <- pmax(var, min)
    var <- pmin(var, max)
    percents <- as.integer(cut(var, 100, 
                               include.lowest = TRUE, ordered = TRUE))
    fills <- shades[percents]
    
    # plot choropleth map
    map("county", fill = TRUE, col = fills, 
        resolution = 0, lty = 0, projection = "polyconic", 
        myborder = 0, mar = c(0,0,0,0))
    
    # overlay state borders
    map("state", col = "white", fill = FALSE, add = TRUE,
        lty = 1, lwd = 1, projection = "polyconic", 
        myborder = 0, mar = c(0,0,0,0))
    
    # add a legend
    inc <- (max - min) / 4
    legend.text <- c(paste0(min, " % or less"),
                     paste0(min + inc, " %"),
                     paste0(min + 2 * inc, " %"),
                     paste0(min + 3 * inc, " %"),
                     paste0(max, " % or more"))
    
    legend("bottomleft", 
           legend = legend.text, 
           fill = shades[c(1, 25, 50, 75, 100)], 
           title = legend.title)
}

shinyServer(
    function(input, output) {
        output$map <- renderPlot({
            args <- switch(input$var,
                           "Percent White" = list(counties$white, "darkgreen", "% White"),
                           "Percent Black" = list(counties$black, "black", "% Black"),
                           "Percent Hispanic" = list(counties$hispanic, "darkorange", "% Hispanic"),
                           "Percent Asian" = list(counties$asian, "darkviolet", "% Asian"))
            
            args$min <- input$range[1]
            args$max <- input$range[2]
            
            do.call(percent_map, args)
        })
    }
)
