# if we want to save the state of each turn, we can write it out to a temp directory, then
# we could allow unlimited undo's

source('drawBoard.R')
source('modifyBoard.R')
source('compFunctions.R')

zz <- drawOriginalBoard()
viz <- zz$plot
print(viz)
board <- zz$board

i = 5
player = 1
board0 <- board

drawBoard(modifyBoard(board, i, player))

# check if valid move
# * is cell available
# * is cell in correct major board
# * is entry valid, e.g., numeric between 1 and 81
# function to select only portion of board for major cell
# check major board is won
# select minor board (all cells, background cells)

board <- read.csv('bug/board.csv',row.names = 1)
nums <- read.csv('bug/numsPlayed.csv',row.names = 1)
majMat <- read.csv('bug/majMat.csv', row.names = 1)
board <- list(board = board, nums = nums, majMat = majMat)

