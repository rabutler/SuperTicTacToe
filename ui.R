
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(navbarPage("Super Tic-Tac-Toe",

  # Application title
  tabPanel("Instructions",
           fluidRow(column(9,includeMarkdown('instructions.md')))
  ),

  tabPanel('Game',
  # text input of the next move
    sidebarLayout(
      sidebarPanel(
        textInput("cellNum", "Enter next move:", ''),
        actionButton('submitMove','Submit Move'),
        br(),
        actionButton('undoMove','Undo Last Move'),
        br(),br(),
        actionButton('newGame','New Game')
      ),
  
      # Show a plot of the board
      mainPanel(
        plotOutput("board"),
        htmlOutput('message')
      )
    )
  )
))
