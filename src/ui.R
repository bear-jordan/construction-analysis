# Define UI
ui <- fluidPage(
    titlePanel("Construction Analysis"),
    sidebarLayout(
        sidebarPanel(
            uiOutput("response_ui"),
            uiOutput("factors_ui"),
            actionButton("analyze", "Analyze")
        ),
        mainPanel(
            tabsetPanel(
                id = "results_tabs",
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

