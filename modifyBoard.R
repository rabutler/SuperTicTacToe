# change the z value of cells not in a minor board so that they appear a different
# color. This will tell the players where the next play should be made
setMajorPlayCell <- function(board, majorCell)
{
  # check to see if the next play should be in a major cell that has already been won
  # if it is, then the next play is a free play
  ii <- cellNum2Index(majorCell)
  if(board$majMat[ii[1],ii[2]] != 0){
    # if it's a free play, set all major cells that are not won to green
    board$board$z[!(board$board$majorBoard %in% getMajorCellWon(board$majMat)) & 
                    is.na(board$board$minorBoard)] <- -1
        
  } else{
    board$board$z[board$board$majorBoard == majorCell & is.na(board$board$minorBoard)] <- -1
    # don't change boards that are won either
    board$board$z[board$board$majorBoard != majorCell & 
                    !(board$board$majorBoard %in% getMajorCellWon(board$majMat)) & 
                    is.na(board$board$minorBoard)] <- 0
  }
  board
}

setMinorBoardWon <- function(board, player, majorCell)
{
  board$board$cellNum[board$board$majorBoard == majorCell] <- NA
  board$board$z[board$board$majorBoard == majorCell & is.na(board$board$minorBoard)] <- player
  
  # set the major board matrix to player that won it
  ii <- cellNum2Index(majorCell)
  board$majMat[ii[1],ii[2]] <- player
  board
}

modifyBoard <- function(board, cellNum, player)
{
  ii <- which(board$board$cellNum == cellNum)
  
  board$board$z[ii] <- player
  board$nums <- c(board$nums, cellNum)
  
  # check if the board that was being played in, is now won
  if(checkWin(minorBoardToMatrix(board$board, board$board$majorBoard[ii]),player)){
    # if it is, set all other numbers to NA, and update the color to the players color, and 
    # update the cell in majorMat to the player number
    board <- setMinorBoardWon(board, player, board$board$majorBoard[ii])
  } else if(checkCats(minorBoardToMatrix(board$board, board$board$majorBoard[ii]))){
    board <- setMinorBoardWon(board, -2, board$board$majorBoard[ii])
  }
  
  # get the grid number that was played in the minor cell and color that major cell
  cellPlayed <- board$board$minorBoard[ii]
  board <- setMajorPlayCell(board, cellPlayed)
  
  # change number to NA so it no longer appears as available
  board$board$cellNum[ii] <- NA
  
  # set allow undo to true, because a move has been registered. 
  board$allowUndo <- TRUE
  board
}
