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

