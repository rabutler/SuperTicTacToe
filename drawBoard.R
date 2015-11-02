library(ggplot2)

majorDiv <<- c(5.5,10.5)
minorDiv <<- c(1.5:4.5,6.5:9.5,11.5:14.5)

drawBoard <- function(board)
{
  pLim <- c(.5,15.5)
  cc <- c('3' = 'white','1' = 'red', '2' = 'blue', '-1' = 'green', '0' = 'grey70', '-2' = 'grey70')
  ll <- c('3' = '','1' = 'Player 1', '2' = 'Player 2', '-1' = 'Board to Play In', '0' = '', '-2' = '')
  board$z <- as.factor(as.character(board$z))
  gg <- ggplot(board, aes(x,y,fill = z)) + geom_raster()
  gg <- gg + geom_hline(y = majorDiv, size = 2) + geom_vline(x = majorDiv, size = 2) +
    geom_hline(y = minorDiv) + geom_vline(x = minorDiv) + 
    scale_fill_manual(labels = ll, values = cc, guide = guide_legend(title = NULL,
                                                                     ncol = 6)) +
    coord_cartesian(xlim = pLim, ylim = pLim) + theme(legend.position = 'bottom')
#browser()
  board <- board[!is.na(board$cellNum),]
  gg <- gg + geom_text(data = board, label = board$cellNum) + 
    labs(x = '', y = '', title = 'Super Tic-Tac-Toe') + 
    theme(axis.ticks = element_blank(), axis.text = element_blank(),
          plot.title = element_text(size = rel(2)))
  gg
}

drawOriginalBoard <- function()
{
  # draw the blank board
  xx <- 1:15
  
  minorDivLims <- matrix(c(1.5,4.5,6.5,9.5,11.5,14.5),ncol = 2, byrow = T)
  board <- expand.grid(x=xx, y = xx)
  board$z <- -1
  
  # number each available cell
  n <- 1:81
  nCount <- 1
  board$cellNum <- NA
  
  for(i in 1:nrow(board)){
    for(j in 1:nrow(minorDivLims)){
      if(board$x[i] >= minorDivLims[j,1] & board$x[i] <= minorDivLims[j,2]){
        for(k in 1:nrow(minorDivLims)){
          if(board$y[i] >= minorDivLims[k,1] & board$y[i] <= minorDivLims[k,2]){
            board$cellNum[i] <- n[nCount]
            board$z[i] <- 3
            nCount <- nCount + 1
          }
        }
      }  
    }
  }
  
  boardN <- t(apply(board[,1:2], 1, coord2BoardNum))
  board$majorBoard <- boardN[,1]
  board$minorBoard <- boardN[,2]
  board$minorBoard[is.na(board$cellNum)] <- NA
  board$minBoardWon <- FALSE
  majMat <- matrix(0,nrow = 3, ncol = 3)
  gg <- drawBoard(board)
  board <- list(board = board, majMat = majMat, nums = c())
  
  return(list(plot = gg, board = board))
}