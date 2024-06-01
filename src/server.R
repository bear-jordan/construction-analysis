# Define server logic
server <- function(input, output, session) {
    data <- read.csv("./data/raw-data.csv")
    
    observe({
        updateSelectInput(session, "response", choices = names(data))
        updateCheckboxGroupInput(session, "factors", choices = names(data))
    })
    
    output$response_ui <- renderUI({
        selectInput("response", "Choose a response variable:", choices = names(data))
    })
    
    output$factors_ui <- renderUI({
        checkboxGroupInput("factors", "Choose factors:", choices = names(data))
    })
    
    model <- eventReactive(input$analyze, {
        req(input$response, input$factors)
        formula <- as.formula(paste(input$response, "~", paste(input$factors, collapse = " + ")))
        aov(formula, data = data)
    })
    
    output$dataTable <- renderTable({
        head(data)
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
        ggplot(data, aes(x = fitted(model()), y = residuals(model()))) +
            geom_point() +
            geom_hline(yintercept = 0, linetype = "dashed") +
            ggtitle("Residuals vs Fitted Values")
    })
    
    output$leveneTest <- renderPrint({
        req(model())
        formula <- as.formula(paste(input$response, "~", paste(input$factors, collapse = " + ")))
        leveneTest(formula, data = data)
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
