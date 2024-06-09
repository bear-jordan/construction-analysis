# Load necessary libraries
library(shiny)
library(ggplot2)
library(dplyr)
library(FSA)
library(rstatix)
library(car)

source("./src/ui.R")
source("./src/server.R")

# Run the application 
options(shiny.port = 8080)
shinyApp(ui = ui, server = server)

