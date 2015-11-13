
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
source('drawBoard.R')
source('modifyBoard.R')
source('compFunctions.R')
source('shinyFunctions.R')

# Make the board a global variable so that it can always be modified and accessed
board <<- drawOriginalBoard()$board
prevBoard <<- board

shinyServer(function(input, output) {

  output$board <- renderPlot({

    #x <- input$cellNum
    #zz <- drawOriginalBoard()
    #viz <- zz$plot + annotate('text',label = x, x=8,y=8,size = 30)
    #print(viz)
    if(input$cellNum == 'ng'){
      zz <- drawOriginalBoard()
      viz <- zz$plot
      print(viz)
      #- board <- zz$board
      board$nums <<- -1
      #- saveBoard(board)
    } else{
      #- board <- getBoard()
      #print(drawBoard(board$board) + annotate('text', label = input$cellNum, x = 8, y = 8, size = 30))
      uI <- as.numeric(input$cellNum)
      
      # *** will need more robust determination of this when implementing undo,
      # *** or can have the undo remove the last move from the list!!
      
      # check if input and move are valid. If they are, then update board. Otherwise,
      # print warning message, and allow for them to input move again.
      if(checkUserInput(uI, board) == 0){
        # move is valid, so can update the board
        #- saveBoard(board,'prev')
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
        
        print(drawBoard(board$board) + annotate('text',label = winner, x = 8, y = 8, 
                                                size = 30))
        
        #- saveBoard(board)
      } else{
        # but still need to print the board so it can be seen for next move
        print(drawBoard(board$board))
      }
    }    
    
  })
  
  output$message <- renderText ({
    uI <- input$cellNum
    if(tolower(uI) == 'ng'){
      paste('New game started')
    } else {
      uI <- as.numeric(uI)
      
      #- board <- getBoard('prev')
      #- error <- checkUserInput(uI, board)
      error <- checkUserInput(uI, prevBoard)
      
      if(error != 0){
        errorMessage(error)
      } else{
        paste('last move was: ', uI)
      }
    }
  })

})
