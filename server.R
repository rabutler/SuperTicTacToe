
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
source('drawBoard.R')
source('modifyBoard.R')
source('compFunctions.R')

# Make the board a global variable so that it can always be modified and accessed
board <<- drawOriginalBoard()$board
prevBoard <<- board

shinyServer(function(input, output) {

  errorCode <- reactiveValues(data = NULL)
  
  observeEvent(input$newGame, {
    errorCode$data$code <- 'ng'
    errorCode$data$text <- 'New game. Good luck.'
    board <<- drawOriginalBoard()$board
    board$nums <<- -1
  })
  
  observeEvent(input$submitMove, {
    errorCode$data$code <- checkUserInput(as.numeric(input$cellNum))
    if(errorCode$data$code == 0){
      # move is valid, so update board accordingly
      uI <- as.numeric(input$cellNum)
      prevBoard <<- board
      
      if(length(board$nums) %% 2 == 0){pp <- 2} else {pp <- 1} 
      
      board <<- modifyBoard(board, uI, pp)
      
      if(checkWin(board$majMat,pp)){
        winner <- paste('Player',pp,'Wins!!')
      } else if(checkCats(board$majMat)){
        winner <- 'Cats...'
      } else {
        winner <- ''
      }
      
      board$winner <<- winner
      
      errorCode$data$text <- paste('Las move was:',uI)
      
    } else {
      # move is invalid for some reason, so set the error text accordingly
      errorCode$data$text <- errorMessage(errorCode$data$code)
    }
    
  })
#   undoMove <- eventReactive(isolate(input$undoMove), {
#     # check to see if undo is possible, since now we only allow one undo
#     if(board$allowUndo){
#       return(0)
#     } else{
#       return(1)
#     }
#   })
  
  output$board <- renderPlot({
    
    if(is.null(errorCode$data)) return()
    
    print(drawBoard(board$board) + annotate('text',label = board$winner, x = 8, y = 8, 
                                                size = 30))  
    
  })
  
  output$message <- renderText ({
    if(is.null(errorCode$data)) return()
    
    errorCode$data$text
  })

})
