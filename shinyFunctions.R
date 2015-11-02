# functions necessary for running the game in Shiny
# saves the state of the board
saveBoard <- function(board,addText = '')
{
  write.csv(board$board, paste0('board',addText,'.csv'), row.names = F)
  write.csv(board$majMat, paste0('majMat',addText,'.csv'), row.names = F)
  write.csv(board$nums, paste0('numsPlayed',addText,'.csv'), row.names = F)
}

getBoard <- function(addText = '')
{
  board <- read.csv(paste0('board',addText,'.csv'))
  majMat <- read.csv(paste0('majMat',addText,'.csv'))
  nums <- read.csv(paste0('numsPlayed',addText,'.csv'))
  
  return(list(board = board, majMat = majMat, nums = nums))
}