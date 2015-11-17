## Super Tic-Tac-Toe Instructions
Just like playing 9 different games of regular tic-tac-toe, with several important 
distinctions. One large tic-tac-toe board is composed of 9 smaller boards. The overall objective is to win 3 small games in a row so that you win the larger game.

### Other Important Rules
1. Your opponents play determines where you must play. For example if she plays in an upper right cell in one of the small boards, you must play in the upper right of the big board. The game only allows you to play in the correct board.
1. If your opponents play sends you to a small board that has already been won, then you get to play in any available cell you desire.
1. If the small board is a cats, then that cell in the big board becomes a cats as well.

## Shiny App Instructions
The input field will only accept numbers and the numbers will select the cell you wish to play in. 

The board is highlighted green in the region which a play is allowed. If the user
enters a cell that is outside the allowable region, the move is not accepted and
the user can try again.

If the player made a mistake, the "undo" button can be used to go back one move.
Currently, it is only allowable to undo once.

## Bugs

If something doesn't seem right to you, or there is an obvious bug please let me know. Please take a screen shot of the board, then head to the [GitHub Issues](https://github.com/rabutler/SuperTicTacToe/issues) page, and describe the last move, and the reason you think it is a bug.

## Code
The code is available at http://github.com/rabutler/SuperTicTacToe
