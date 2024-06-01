library(shiny)
library(tidyverse)
library(car)
library(ggpubr)

# Define UI
ui <- fluidPage(
    titlePanel("One-Way ANOVA Assumptions and Analysis"),
    sidebarLayout(
        sidebarPanel(
            selectInput("variable", "Choose a variable:", 
                        choices = names(iris)[1:4]),
            actionButton("analyze", "Analyze")
        ),
        mainPanel(
            tabsetPanel(
                tabPanel("Data", tableOutput("dataTable")),
                tabPanel("Normality", plotOutput("qqPlot"), verbatimTextOutput("shapiroTest")),
                tabPanel("Homogeneity", plotOutput("residualsPlot"), verbatimTextOutput("leveneTest")),
                tabPanel("ANOVA", verbatimTextOutput("anovaResult")),
                tabPanel("Post-hoc", verbatimTextOutput("tukeyResult"), plotOutput("tukeyPlot"))
            )
        )
    )
)

# Define server logic
server <- function(input, output) {
    data <- reactive({
        iris
    })
    
    model <- eventReactive(input$analyze, {
        aov(as.formula(paste(input$variable, "~ Species")), data = data())
    })
    
    output$dataTable <- renderTable({
        head(data())
    })
    
    output$qqPlot <- renderPlot({
        req(model())
        residuals <- residuals(model())
        ggqqplot(residuals) + 
            ggtitle("Q-Q Plot of Residuals")
    })
    
    output$shapiroTest <- renderPrint({
        req(model())
        residuals <- residuals(model())
        shapiro.test(residuals)
    })
    
    output$residualsPlot <- renderPlot({
        req(model())
        ggplot(data(), aes(x = fitted(model()), y = residuals(model()))) +
            geom_point() +
            geom_hline(yintercept = 0, linetype = "dashed") +
            ggtitle("Residuals vs Fitted Values")
    })
    
    output$leveneTest <- renderPrint({
        req(model())
        leveneTest(as.formula(paste(input$variable, "~ Species")), data = data())
    })
    
    output$anovaResult <- renderPrint({
        req(model())
        summary(model())
    })
    
    output$tukeyResult <- renderPrint({
        req(model())
        TukeyHSD(model())
    })
    
    output$tukeyPlot <- renderPlot({
        req(model())
        plot(TukeyHSD(model()))
    })
}

# Run the application 
options(shiny.port = 8080)
shinyApp(ui = ui, server = server)

