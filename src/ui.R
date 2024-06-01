# Define UI
ui <- fluidPage(
    titlePanel("Multiway ANOVA Assumptions and Analysis"),
    sidebarLayout(
        sidebarPanel(
            uiOutput("response_ui"),
            uiOutput("factors_ui"),
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
