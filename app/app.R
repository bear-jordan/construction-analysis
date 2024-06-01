library(car)
library(ggpubr)
library(shiny)
library(tidyverse)

source("./src/ui.R")
source("./src/server.R")

# Run the application 
options(shiny.port = 8080)
shinyApp(ui = ui, server = server)

