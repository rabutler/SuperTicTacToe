
library(shiny)
source('drawBoard.R')
source('modifyBoard.R')
source('compFunctions.R')

# Make the board a global variable so that it can always be modified and accessed
board <<- NULL
prevBoard <<- NULL

shinyServer(function(input, output) {

  errorCode <- reactiveValues(data = NULL)
  
  observeEvent(input$newGame, {
    errorCode$data$code <- 'ng'
    errorCode$data$text <- 'New game. Good luck.'
    board <<- drawOriginalBoard()$board
    board$nums <<- -1
  })
  
  observeEvent(input$submitMove, {
    errorCode$data$code <- checkUserInput(input$cellNum)
    if(errorCode$data$code == 0){
      # move is valid, so update board accordingly
      uI <- input$cellNum
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
      
      pp <- ifelse(pp==1, 2, 1)
      if(winner == ''){
        errorCode$data$text <- paste('Last move was:',uI,'<br/>Player',pp,'it is now your turn.')
      } else{
        errorCode$data$text <- winner
      }
    } else {
      # move is invalid for some reason, so set the error text accordingly
      errorCode$data$text <- errorMessage(errorCode$data$code)
    }
    
  })
  
  observeEvent(input$undoMove, {
    # check if undo is allowed (can only undo once)
    if(board$allowUndo){
      # can undo
      board <<- prevBoard
      board$allowUndo <<- FALSE
      # set the message:
      if(length(board$nums) %% 2 == 0){pp <- 2} else {pp <- 1}
      errorCode$data$text <- paste('Last move undone. Player', pp, 'it is now your turn')
    } else{
      # cannot undo
      if(length(board$nums) %% 2 == 0){pp <- 2} else {pp <- 1}
      errorCode$data$text <- paste('Cannot undo move. Player',pp,'it is still your turn.')
    }
  })
  
  output$board <- renderPlot({
    
    if(is.null(errorCode$data)) return()
    if(errorCode$data$code == 6) return()
    
    print(drawBoard(board$board) + annotate('text',label = board$winner, x = 8, y = 8, 
                                                size = 30))  
    
  })
  
  output$message <- renderUI ({
    if(is.null(errorCode$data)) return()
    
    HTML(errorCode$data$text)
  })

})
