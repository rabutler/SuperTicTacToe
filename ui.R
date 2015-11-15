
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Super Tic-Tac-Toe"),

  # text input of the next move
  sidebarLayout(
    sidebarPanel(
      textInput("cellNum", "Enter next move:", 'ng'),
      actionButton('submitMove','Submit move.'),
      actionButton('newGame','New Game'),
      actionButton('undoMove','Undo last move.')
    ),

    # Show a plot of the board
    mainPanel(
      plotOutput("board"),
      textOutput('message')
    )
  )
))
