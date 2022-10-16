module Player = {
  type t = White | Red | Empty;

  let toString = player =>
    switch player {
      | Red => "Red"
      | White => "White"
      | Empty => ""
    }
}

module BoardCell = {
  type cellState =
  | Default
  | Draggable
  | Selected
  | ValidMove
  | ValidJump(array<(int, int)>);
  type t = {
    id: string,
    x: int,
    y: int,
    player: Player.t,
    cellState: cellState,
  }

  let make = (
    ~x: int,
    ~y: int,
    ~player: Player.t=Empty,
    ~cellState: cellState=Default,
    ()
  ): t => {
    id: x->Js.Int.toString++y->Js.Int.toString,
    x,
    y,
    player,
    cellState,
  }
}

module BoardRow = {
  let rowSize = 8;
  type t = {
    id: int,
    cells: array<BoardCell.t>
  }

  let make = (~index, ~currentPlayer: Player.t, ~player, ()) =>
    Belt.Array.makeBy(rowSize, i=>i)
    ->Js.Array2.map(x => {
      let cellState = currentPlayer == player ? BoardCell.Draggable : Default
      let makeCell = BoardCell.make(~x, ~y=index, ~cellState)
      switch (mod(x, 2), mod(index, 2)) {
      | (0, 1)|(1, 0) => makeCell(~player, ())
      | _ => makeCell(~player=Empty, ())
      }
    })
}

module Board = {
  let boardSize = 8;
  type t = array<BoardRow.t>

  let make = (~currentPlayer=Player.Red, ()) =>
    Belt.Array.makeBy(boardSize, i=>i)
    ->Js.Array2.map(y => {
      let row = BoardRow.make(~index=y, ~currentPlayer)
      switch y {
        | 0|1|2 => row(~player=Red, ())
        | 5|6|7 => row(~player=White, ())
        | _ => row(~player=Empty, ())
      }
    })
    ->Js.Array2.mapi((cells, id) => ({
      id, cells
    }: BoardRow.t))

  // let isMoveOnBoard = ((x, y)) => switch((x, y)) {
  //   | (-1, _)|(_, -1) => false
  //   | (x, _) when x === boardSize => false
  //   | (_, y) when y === boardSize => false
  //   | (_) => true
  // }

  // let findCellById = (checkerBoard: t, id) =>
  //   checkerBoard
  //   ->Js.Array2.map(row=>row.cells)
  //   ->Belt.Array.concatMany
  //   ->Js.Array2.find(gamePiece=>gamePiece.id === id)

  // let isCellEmpty = (checkerBoard: t, id) =>
  //   switch findCellById(checkerBoard, id) {
  //     | Some(field) => switch field.player {
  //       | Empty => true
  //       | _ => false
  //     }
  //     | _ => false
  //   }

  // let isLegalMove = ((x, y), selX, selY, gameState: gameState, kingStatus) =>
  //   switch(x, y, gameState, kingStatus) {
  //     | (_, y, Playing(Red(_)), Normal) when y > selY => true
  //     | (_, y, Playing(White(_)), Normal) when y < selY => true
  //     | (_, _, _, King) => true
  //     | (_) => false
  //   }
}

module Game = {
  type t = {
    board: Board.t,
  }

  let make = _ => Board.make()
}