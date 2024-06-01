ui <- fluidPage(
    titlePanel("Statistical Test App"),
wellPanel(
        h4("General Workflow:"),
        p("1. Choose a response variable (must be numeric)."),
        p("2. Choose one or more factors (must be categorical)."),
        p("3. Click 'Analyze' to perform the appropriate test (t-test or ANOVA)."),
        p("4. View the results and interpretations in the respective tabs."),
        h4("Working Through the Plots:"),
        p("After performing the analysis, navigate through the tabs to check assumptions and interpret results:"),
        p("1. Normality: Check if the residuals are normally distributed using the Q-Q Plot and Shapiro-Wilk Test."),
        p("2. Homogeneity: Check if the variances are equal across groups using the Residuals vs Fitted Values plot and Levene's Test."),
        p("3. ANOVA Result: Review the ANOVA table to see if the factors have a significant effect on the response variable."),
        p("4. Tukey Result: If ANOVA is significant, use Tukey's HSD test to identify which groups differ from each other."),
        p("5. Test Result: If a t-test is performed, review the t-test result for significance between two groups.")
    ),
    sidebarLayout(
        sidebarPanel(
            uiOutput("response_ui"),
            uiOutput("factors_ui"),
            actionButton("analyze", "Analyze")
        ),
        mainPanel(
            tabsetPanel(
                id = "results_tabs",
                selected = "Data",
                tabPanel("Data", 
                         tableOutput("dataTable"),
                         p("This table shows the first few rows of your dataset.")
                ),
                tabPanel("Normality", 
                         plotOutput("qqPlot"),
                         verbatimTextOutput("shapiroTest"),
                         p("Q-Q Plot: Check if residuals follow a normal distribution. Points should lie on the 45-degree reference line if residuals are normally distributed."),
                         p("Shapiro-Wilk Test: Provides a formal test for normality. A p-value > 0.05 suggests normality.")
                ),
                tabPanel("Homogeneity", 
                         plotOutput("residualsPlot"),
                         verbatimTextOutput("leveneTest"),
                         p("Residuals vs Fitted Values: Check if residuals are spread equally across the range of fitted values. No clear pattern indicates homogeneity."),
                         p("Levene's Test: Tests for equal variances. A p-value > 0.05 suggests homogeneity of variances.")
                ),
                tabPanel("ANOVA Result", 
                         verbatimTextOutput("anovaResult"),
                         p("ANOVA Summary: Shows the F-statistic and p-value for each factor. A significant p-value (typically < 0.05) suggests that the factor has a statistically significant effect on the response variable.")
                ),
                tabPanel("Tukey Result", 
                         verbatimTextOutput("tukeyResult"), 
                         plotOutput("tukeyPlot"),
                         p("Tukey HSD Test: Provides pairwise comparisons between group means. Significant differences are indicated by intervals that do not cross zero.")
                ),
                tabPanel("Test Result", 
                         verbatimTextOutput("testResult"),
                         p("T-test Result: Shows the t-statistic, degrees of freedom, and p-value. A significant p-value (typically < 0.05) indicates a statistically significant difference between the two group means.")
                )
            )
        )
    )
)
