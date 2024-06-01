library(shiny)
library(tidyverse)
library(car)
library(ggpubr)

source("./src/ui.R")
source("./src/server.R")

# Run the application 
options(shiny.port = 8080)
shinyApp(ui = ui, server = server)

