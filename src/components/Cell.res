open Models
@module external css: {..} = "./Cell.module.scss"

module GamePiece = {
  @react.component
  let make = (~className, ~onClick, ~isDraggable) => <div onClick className={css["gamePieceContainer"]}>
    <div draggable=isDraggable className={Js.Array2.joinWith([className, css["gamePiece"]], " ")}/>
  </div>
}

@react.component
let make = (~cell: BoardCell.t, ~onClick) => {
  Js.log2("cell", cell)
  let {x, y, player, _} = cell;
  // let rowColTuple = (x mod 2, y mod 2);
  let cellColor = switch (mod(x, 2), mod(y, 2)) {
    |(0, 0)
    |(1, 1) => css["mainColor"]
    |(_, _) => css["altColor"]
  };

  let cellCssFromState = switch cell.cellState {
    | Selected => css["selected"]
    | _ => ""
  }

  let onClick = _ => onClick(cell)

  let isDraggable = cell.cellState == BoardCell.Draggable

  let gamePiece = switch player {
    | Red => <GamePiece onClick isDraggable className={css["red"]}/>
    | White => <GamePiece onClick isDraggable className={css["white"]}/>
    | Empty => React.null
  }

  let className = Js.Array2.joinWith([cellColor, css["cell"], cellCssFromState], " ")

  //   | (0, 0) => Css.style(BoardFieldStyles.offWhite)
  //   | (1, 1) => Css.style(BoardFieldStyles.offWhite)
  //   | (_) => Css.style(BoardFieldStyles.green)
  // };
  <div className>{gamePiece}</div>
}