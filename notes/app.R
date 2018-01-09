library(shiny)
library(rhandsontable)

ui <- shinyUI(fluidPage(
  titlePanel("Handsontable"),
  sidebarLayout(
    sidebarPanel(
      helpText("Test")
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Petit", rHandsontableOutput("hot_1")),
                  tabPanel("Grand", rHandsontableOutput("hot_2")))
    )
  )
))

server <- function(input, output) {
  data <- reactive({
    if (is.null(input$hot_1)) {
      df <- data.frame(cli = 1:5, adr = LETTERS[1:5],
                       stringsAsFactors = FALSE)
    } else {
      df <- hot_to_r(input$hot_1)
    }
    df
  })
  output$hot_1 <- renderRHandsontable({
    df <- data()
    rhandsontable(df, useTypes = FALSE, selectCallback = TRUE)
  })
  output$hot_2 <- renderRHandsontable({
    df_1 <- data()
    df_2 <- data.frame(traj = 1:3,
                       dep = factor(df_1$adr[1:3], levels = df_1$adr),
                       arr = factor(df_1$adr[3:5], levels = df_1$adr))
    rhandsontable(df_2, useTypes = FALSE, selectCallback = TRUE)
  })
}

shinyApp(ui = ui, server = server)