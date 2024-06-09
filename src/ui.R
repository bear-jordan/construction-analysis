ui <- fluidPage(
    titlePanel("Statistical Test App"),
    wellPanel(
        h4("General Workflow:"),
        p("1. Choose a response variable (must be numeric)."),
        p("2. Choose a factor (must be categorical)."),
        p("3. Click 'Analyze' to perform the appropriate test (Wilcoxon or Kruskal-Wallis)."),
        p("4. View the results in the respective tabs.")
    ),
    sidebarLayout(
        sidebarPanel(
            uiOutput("response_ui"),
            uiOutput("factors_ui"),
            actionButton("analyze", "Analyze"),
            downloadButton("downloadBoxPlot", "Download Box Plot")
        ),
        mainPanel(
            tabsetPanel(
                id = "results_tabs",
                selected = "Data",
                tabPanel("Data", 
                         tableOutput("dataTable"),
                         p("This table shows the first few rows of your dataset.")
                ),
                tabPanel("Descriptive Statistics", 
                         verbatimTextOutput("descriptiveStats"),
                         p("Descriptive statistics for the selected response variable by factor levels.")
                ),
                tabPanel("Pairwise Comparisons", 
                         verbatimTextOutput("pairwiseComparisons"),
                         p("Pairwise comparisons using the Dunn test for Kruskal-Wallis test.")
                ),
                tabPanel("Normality Check", 
                         verbatimTextOutput("normalityCheck"),
                         plotOutput("qqPlot"),
                         p("Shapiro-Wilk test and Q-Q plot for normality check.")
                ),
                tabPanel("Homogeneity of Variances", 
                         verbatimTextOutput("leveneTest"),
                         p("Levene's test for homogeneity of variances.")
                ),
                tabPanel("Histogram", 
                         plotOutput("histogramPlot"),
                         p("Histograms of the response variable across the factor levels.")
                ),
                tabPanel("Box Plot", 
                         plotOutput("boxPlot"),
                         p("Box Plot: Visualize the distribution of the response variable across the chosen factors.")
                ),
                tabPanel("Test Result", 
                         verbatimTextOutput("testResult"),
                         p("Test Result: Shows the result of the Wilcoxon rank-sum test or Kruskal-Wallis test. A significant p-value (typically < 0.05) indicates a statistically significant difference between the groups.")
                )
            )
        )
    )
)
