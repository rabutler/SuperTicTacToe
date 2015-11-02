# play the game
source('drawBoard.R')
source('modifyBoard.R')
source('compFunctions.R')

playGame <- function()
{
  zz <- drawOriginalBoard()
  viz <- zz$plot
  print(viz)
  board <- zz$board
  prevBoard <- board
  # continue user input until every cell is filled
  nn <- 1
  pp <- 1
  gameOver <- FALSE
  while(nn <= 81 & !gameOver){
    error <- -1
    while(error != 0){
      if(error > 0){
        print(errorMessage(error))
      }
      uI <- readline(paste0('Player ',pp,': enter your selection. '))
      if(isAcceptableText(uI)){
        if(tolower(uI) == 's'){
          write.csv(board$board, 'board.csv')
          write.csv(board$majMat, 'majMat.csv')
          write.csv(board$nums, 'numsPlayed.csv')
        } else if(tolower(uI) == 'u') {
          # revert to the previous board (this will revert to the other player's move)
          subErr <- 1
          # verify they want to undo the move and let the last player play again
          # and make sure the entry is y or n
          while(subErr != 0){
            uI2 <- readline('This will undo the last player\'s move and allow them to play again.\ny to continue and n to cancel the undo. ')
            if(tolower(uI2) == 'y' | tolower(uI2) == 'n'){
              subErr <- 0
            }
          }
          if(tolower(uI2) == 'n'){
            uI <- 'uc'
          } else if(tolower(uI2) == 'y'){
            # revert to the previous board
            board <- prevBoard
            print(drawBoard(board$board))
            nn <- nn - 1
            # change to the other player
            if(pp == 1){
              pp <- 2
            } else{pp <- 1}
          }
        }
      } else {
        uI <- as.numeric(uI)
      }
      
      error <- checkUserInput(uI, board)
    }
    # modify Board for players move
    prevBoard <- board
    board <- modifyBoard(board, uI, pp)
    print(drawBoard(board$board))
    gameOver <- checkWin(board$majMat,pp) | checkCats(board$majMat)
    if(pp == 1){
      pp <- 2
    } else{pp <- 1}
    
    nn <- nn + 1
    
  }
  if(checkWin(board$majMat,1)){
    print('Player 1 Wins')
    print(drawBoard(board$board) + annotate('text',x = 8, y = 8, 
                                            label  = 'Player 1 Wins', size = 30))
  } else if(checkWin(board$majMat,2)){
    print('Player 2 Wins')
    print(drawBoard(board$board) + annotate('text',x = 8, y = 8, 
                                            label  = 'Player 2 Wins', size = 30))
  } else if(checkCats(board$majMat)){
    print('Cats')
    print(drawBoard(board$board) + annotate('text',x = 8, y = 8, 
                                            label  = 'Cats', size = 30))
  }
}