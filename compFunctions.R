library(dplyr)

# COMPUTATION FUNCTIONS

# used to index into board; it's actually a mirror of the layout numbering described below
fullBoardGridIndex <- function()
{
  #zz <- matrix(c(7:9,4:6,1:3),byrow = T, nrow = 3)
  zz <- matrix(1:9, byrow = T, nrow = 3)
  zz <- cbind(zz,zz,zz)
  zz <- rbind(zz,zz,zz)
  zz
}

# convert from coordinates to a pair of numbers
# first number is major board number
# second number is minor board number
# both boards are numbered:
# 7 | 8 | 9
# 4 | 5 | 6
# 1 | 2 | 3
coord2BoardNum <- function(xx)
{
  x <- xx[1]
  y <- xx[2]
  # major break at 5.5 and 10.5
  if(x <= 5.5){
    if(y <= 5.5){
      mb <- 1
    } else if(y >= 10.5){
      mb <- 7
    } else {
      mb <- 4
    }
  } else if(x >= 10.5){
    if(y <= 5.5){
      mb <- 3
    } else if(y >= 10.5){
      mb <- 9
    } else {
      mb <- 6
    }
  } else{
    if(y <= 5.5){
      mb <- 2
    } else if(y >= 10.5){
      mb <- 8
    } else {
      mb <- 5
    }
  }
  
  # right and top limits of minor Division lines
  uL <- c(2.5, 3.5, 4.5, 7.5, 8.5, 9.5, 12.5, 13.5, 14.5)
  x1 <- which(x <= uL)[1]
  y1 <- which(y <= uL)[1]
  
  minB <- fullBoardGridIndex()[y1,x1]
  return(c(mb, minB))
}

# takes the board data frame and returns a matrix of the minor board with the player
# numbers layed out in tic tac toe fashion
minorBoardToMatrix <- function(board, majNum)
{
  bb <- board %>% dplyr::filter(majorBoard == majNum, !(is.na(minorBoard)))
  bb <- rbind(bb$z[7:9], bb$z[4:6],bb$z[1:3])
  bb[bb != 1 & bb != 2] <- 0
  bb
}

# checks if a player has won ttt, bb is the 3x3 matrix
# returns TRUE if won, othewise FALSE
checkWin <- function(bb, pNum)
{
  if(length(which(bb == pNum)) <3){
    # impossible to win if there are not three cells filled in by player
    rr <- FALSE
  } else{
    # brute force check wins
    if(bb[1,1] == pNum & bb[2,1] == pNum & bb[3,1] == pNum){
      rr <- TRUE
    } else if(bb[1,1] == pNum & bb[1,2] == pNum & bb[1,3] == pNum){
      rr <- TRUE
    } else if(bb[1,1] == pNum & bb[2,2] == pNum & bb[3,3] == pNum){
      rr <- TRUE
    } else if(bb[1,3] == pNum & bb[2,3] == pNum & bb[3,3] == pNum){
      rr <- TRUE
    } else if(bb[1,3] == pNum & bb[2,2] == pNum & bb[3,1] == pNum){
      rr <- TRUE
    } else if(bb[1,2] == pNum & bb[2,2] == pNum & bb[3,2] == pNum){
      rr <- TRUE
    } else if(bb[2,1] == pNum & bb[2,2] == pNum & bb[2,3] == pNum){
      rr <- TRUE
    } else if(bb[3,1] == pNum & bb[3,2] == pNum & bb[3,3] == pNum){
      rr <- TRUE
    } else{
      rr <- FALSE
    }
  }
  
  rr
}

checkCats <- function(bb)
{
  if(length(which(bb == 0)) == 0 & !checkWin(bb,1) & !checkWin(bb,2)){
    rr <- TRUE
  } else {
    rr <- FALSE
  }
  
  rr
}

cellNum2Index <- function(majorCell)
{
  rr <- c(3,3,3,2,2,2,1,1,1)
  cc <- rep(1:3,3)
  
  return(c(rr[majorCell],cc[majorCell]))
}

getMajorCellWon <- function(majMat)
{
  zz <- which(majMat != 0)
  iNum <- c(7,4,1,8,5,2,9,6,3)
  return(iNum[zz])
}

moveNotAllowable <- function(board, cellNum)
{
  # find all major cells that are green
  majorCells <- board$board$majorBoard[board$board$z == -1]
  # find major cell that was played 
  playedMajor <- board$board$majorBoard[which(board$board$cellNum == cellNum)]
  
  !(playedMajor %in% majorCells)
}

isAcceptableText <- function(uI)
{
  if(tolower(uI) == 's' | tolower(uI) == 'u'){
    return(TRUE)
  } else{
    return(FALSE)
  }
}

checkUserInput <- function(uI)
{
  
  if(!is.numeric(uI)){
    return(1)
  } else if (is.null(board)){
    return(6)
  } else if(board$winner != ''){
    return(5)
  } else if(is.na(uI)){
    return(1)
  } else if(uI < 1 | uI > 81){
    return(2)
  } else if(uI %% 1 != 0){
    return(7)
  } else if(uI %in% board$nums){
    return(3)
  } else if(moveNotAllowable(board, uI)){
    return(4)
  } else{
    return(0)
  }
}

errorMessage <- function(ii)
{
  em <- c('Input was not numeric. Please enter a number between 1 and 81.',
          'Input was a number beyond the allowable values',
          'Cell has already been played', 'Cell is not in correct board',
          'Game is over. <br/> Select \'New Game\' to play again.',
          'Please select New Game before submitting a move.',
          'Input needs to be a whole number.')
  em[ii]
}