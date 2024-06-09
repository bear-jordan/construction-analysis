# Define server logic
server <- function(input, output, session) {
    data <- read.csv("./data/raw-data.csv")
    
    # Identify numerical and categorical columns
    numeric_cols <- names(data)[sapply(data, is.numeric)]
    factor_cols <- names(data)[sapply(data, function(col) is.factor(col) || is.character(col))]
    
    observe({
        updateSelectInput(session, "response", choices = numeric_cols)
        updateSelectInput(session, "factors", choices = factor_cols)
    })
    
    output$response_ui <- renderUI({
        selectInput("response", "Choose a response variable:", choices = numeric_cols)
    })
    
    output$factors_ui <- renderUI({
        selectInput("factors", "Choose a factor:", choices = factor_cols)
    })
    
    model <- eventReactive(input$analyze, {
        req(input$response, input$factors)
        factors <- input$factors
        response <- input$response
        
        if (length(unique(data[[factors]])) == 2) {
            formula <- as.formula(paste(response, "~", factors))
            list(test = "wilcoxon", model = wilcox.test(formula, data = data))
        } else {
            formula <- as.formula(paste(response, "~", factors))
            list(test = "kruskal-wallis", model = kruskal.test(formula, data = data))
        }
    })
    
    output$dataTable <- renderTable({
        head(data)
    })
    
    output$descriptiveStats <- renderPrint({
        req(input$response, input$factors)
        data %>%
            group_by_at(input$factors) %>%
            summarise(
                mean = mean(get(input$response), na.rm = TRUE),
                median = median(get(input$response), na.rm = TRUE),
                sd = sd(get(input$response), na.rm = TRUE),
                min = min(get(input$response), na.rm = TRUE),
                max = max(get(input$response), na.rm = TRUE)
            )
    })
    
    output$pairwiseComparisons <- renderPrint({
        req(model())
        if (model()$test == "kruskal-wallis") {
            dunn_test(data, formula = as.formula(paste(input$response, "~", input$factors)), p.adjust.method = "bonferroni")
        }
    })
    
    output$normalityCheck <- renderPrint({
        req(input$response, input$factors)
        data %>%
            group_by_at(input$factors) %>%
            summarise(shapiro_test = shapiro.test(get(input$response))$p.value)
    })
    
    output$qqPlot <- renderPlot({
        req(input$response, input$factors)
        ggplot(data, aes(sample = get(input$response))) +
            stat_qq() +
            stat_qq_line() +
            facet_wrap(as.formula(paste("~", input$factors))) +
            ggtitle("Q-Q Plot of Response by Factors") +
            theme(
                axis.text.x = element_text(angle = 0, hjust = 1), 
                axis.text.y = element_text(angle = 0, vjust = 0.5)
            )
    })
    
    output$leveneTest <- renderPrint({
        req(input$response, input$factors)
        formula <- as.formula(paste(input$response, "~", input$factors))
        leveneTest(formula, data = data)
    })
    
    output$histogramPlot <- renderPlot({
        req(input$response, input$factors)
        ggplot(data, aes_string(x = input$response)) +
            geom_histogram(binwidth = 1, fill = "skyblue", color = "black") +
            facet_wrap(as.formula(paste("~", input$factors)), scales = "free_x") +
            ggtitle("Histogram of Response by Factors") +
            theme(
                axis.text.x = element_text(angle = 0, hjust = 1), 
                axis.text.y = element_text(angle = 0, vjust = 0.5)
            )
    })
    
    output$boxPlot <- renderPlot({
        req(input$response, input$factors)
        ggplot(data, aes_string(x = input$factors, y = input$response)) +
            geom_boxplot() +
            ggtitle("Box Plot of Response by Factors") +
            theme(
                axis.text.x = element_text(angle = 0, hjust = 1), 
                axis.text.y = element_text(angle = 0, vjust = 0.5)
            )
    })
    
    output$downloadBoxPlot <- downloadHandler(
        filename = function() {
            paste("box_plot", Sys.Date(), ".png", sep = "")
        },
        content = function(file) {
            g <- ggplot(data, aes_string(x = input$factors, y = input$response)) +
                geom_boxplot() +
                ggtitle("Box Plot of Response by Factors") +
                theme(
                    axis.text.x = element_text(angle = 0, hjust = 1), 
                    axis.text.y = element_text(angle = 0, vjust = 0.5)
                )
            ggsave(file, plot = g, device = "png")
        }
    )
    
    output$testResult <- renderPrint({
        req(model())
        if (model()$test == "wilcoxon") {
            model()$model
        } else if (model()$test == "kruskal-wallis") {
            model()$model
        }
    })
    
    observe({
        req(model())
        if (model()$test == "wilcoxon") {
            updateTabsetPanel(session, "results_tabs", selected = "Test Result")
        } else {
            updateTabsetPanel(session, "results_tabs", selected = "Test Result")
        }
    })
}
