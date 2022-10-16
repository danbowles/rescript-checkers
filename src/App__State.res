open Models

module GameState = {
  type t = Playing(Player.t) | Winner(Player.t)

  let toString = state => {
    switch state {
      | Playing(player) => `Turn: ${player->Player.toString}`
      | Winner(player) => `Winner: ${player->Player.toString}`
    }
  }
}

module State = {
  type t = {
    gameState: GameState.t,
    gameBoard: Board.t,
  }

  type action = SelectBoardCell(BoardCell.t) | ResetGame

  let selectBoardCell = (state, boardCell: BoardCell.t) => {
    let {x: cellX, y: cellY} = boardCell
    state.gameBoard->Js.Array2.map((boardRow: BoardRow.t) => {
      ...boardRow,
      cells: boardRow.cells->Js.Array2.map((cell: BoardCell.t) => {
        switch (cell.x, cell.y, cell.cellState) {
          | (curX, curY, Default) when cellX == curX && cellY == curY => {...cell, cellState: Selected}
          | _ => {...cell, cellState: Default}
        }
      })
    })
      // gameBoard: state.gameBoard->Js.Array2.map((boardRow: BoardRow.t) => {
      //   boardRow.id != cellY ? boardRow : {
      //     ...boardRow,
      //     cells: boardRow.cells->Js.Array2.map((cell: BoardCell.t) => {
      //       cell.x != cellX ? {...cell, cellState: BoardCell.Default} : {
      //         ...cell,
      //         cellState: BoardCell.Selected,
      //       }
      //     })
      //   }
      // }),
      // gameState: switch (state.gameState, boardCell.player) {
      //   | (Playing(White), Red)|(Playing(Red), White) => state.gameState
      //   | (Playing(Red), _) => Playing(White)
      //   | (Playing(White), _) => Playing(Red)
      //   | _ => state.gameState
      // }
  }

  let reducer = (state, action) => {
    switch action {
      | SelectBoardCell(boardCell) => switch (state.gameState, boardCell.player) {
          | (Playing(White), Red)|(Playing(Red), White) => state
          | _ => { ...state, gameBoard: selectBoardCell(state, boardCell) }
      }
      | ResetGame => {
        gameState: Playing(Red),
        gameBoard: Board.make(),
      }
    }
  }
}

let useAppReducer = _ => {
  let initial: State.t = {
    gameState: Playing(Red),
    gameBoard: Board.make(),
  }

  let (state, dispatch) = React.useReducer(State.reducer, initial)

  (state, dispatch)
}
