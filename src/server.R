# Define server logic
server <- function(input, output, session) {
    data <- read.csv("./data/raw-data.csv")
    
    # Identify numerical and categorical columns
    numeric_cols <- names(data)[sapply(data, is.numeric)]
    factor_cols <- names(data)[sapply(data, function(col) is.factor(col) || is.character(col))]
    
    observe({
        updateSelectInput(session, "response", choices = numeric_cols)
        updateCheckboxGroupInput(session, "factors", choices = factor_cols)
    })
    
    output$response_ui <- renderUI({
        selectInput("response", "Choose a response variable:", choices = numeric_cols)
    })
    
    output$factors_ui <- renderUI({
        checkboxGroupInput("factors", "Choose factors:", choices = factor_cols)
    })
    
    model <- eventReactive(input$analyze, {
        req(input$response, input$factors)
        factors <- input$factors
        response <- input$response
        
        if (length(factors) == 1 && length(unique(data[[factors]])) == 2) {
            formula <- as.formula(paste(response, "~", factors))
            list(test = "t-test", model = t.test(formula, data = data))
        } else {
            formula <- as.formula(paste(response, "~", paste(factors, collapse = " + ")))
            list(test = "ANOVA", model = aov(formula, data = data))
        }
    })
    
    output$dataTable <- renderTable({
        head(data)
    })
    
    output$qqPlot <- renderPlot({
        req(model())
        if (model()$test == "ANOVA") {
            residuals <- residuals(model()$model)
            ggqqplot(residuals) + 
                ggtitle("Q-Q Plot of Residuals") +
                theme(
                    axis.text.x = element_text(angle = 0, hjust = 1), 
                    axis.text.y = element_text(angle = 0, vjust = 0.5)
                )
        }
    })
    
    output$shapiroTest <- renderPrint({
        req(model())
        if (model()$test == "ANOVA") {
            residuals <- residuals(model()$model)
            shapiro.test(residuals)
        }
    })
    
    output$residualsPlot <- renderPlot({
        req(model())
        if (model()$test == "ANOVA") {
            ggplot(data, aes(x = fitted(model()$model), y = residuals(model()$model))) +
                geom_point() +
                geom_hline(yintercept = 0, linetype = "dashed") +
                ggtitle("Residuals vs Fitted Values") +
                theme(
                    axis.text.x = element_text(angle = 0, hjust = 1), 
                    axis.text.y = element_text(angle = 0, vjust = 0.5)
                )
        }
    })
    
    output$leveneTest <- renderPrint({
        req(model())
        if (model()$test == "ANOVA") {
            formula <- as.formula(paste(input$response, "~", paste(input$factors, collapse = " + ")))
            leveneTest(formula, data = data)
        }
    })
    
    output$anovaResult <- renderPrint({
        req(model())
        if (model()$test == "ANOVA") {
            summary(model()$model)
        }
    })
    
    output$tukeyResult <- renderPrint({
        req(model())
        if (model()$test == "ANOVA") {
            TukeyHSD(model()$model)
        }
    })
    
    output$tukeyPlot <- renderPlot({
        req(model())
        if (model()$test == "ANOVA") {
            par(las = 1, mar = c(5, 10, 5, 5))
            plot(TukeyHSD(model()$model))
        }
    })
    
    output$testResult <- renderPrint({
        req(model())
        if (model()$test == "t-test") {
            model()$model
        }
    })
    
    observe({
        req(model())
        if (model()$test == "t-test") {
            updateTabsetPanel(session, "results_tabs", selected = "Test Result")
            hideTab("results_tabs", "Normality")
            hideTab("results_tabs", "Homogeneity")
            hideTab("results_tabs", "ANOVA Result")
            hideTab("results_tabs", "Tukey Result")
        } else {
            updateTabsetPanel(session, "results_tabs", selected = "ANOVA Result")
            showTab("results_tabs", "Normality")
            showTab("results_tabs", "Homogeneity")
            showTab("results_tabs", "ANOVA Result")
            showTab("results_tabs", "Tukey Result")
        }
    })
}
