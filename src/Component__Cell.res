open Models
@module external css: {..} = "./Component__Cell.module.scss"

module GamePiece = {
  @react.component
  let make = (~className, ~onClick) => <div onClick className={css["gamePieceContainer"]}>
    <div className={Js.Array2.joinWith([className, css["gamePiece"]], " ")}/>
  </div>
}

module Cell = {
  @react.component
  let make = (~className, ~player: Player.t, ~onClick) => {
    let gamePiece = switch player {
      | Red => <GamePiece onClick className={css["red"]}/>
      | White => <GamePiece onClick className={css["white"]}/>
      | Empty => React.null
    }
    <div className>{gamePiece}</div>
  }
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


  //   | (0, 0) => Css.style(BoardFieldStyles.offWhite)
  //   | (1, 1) => Css.style(BoardFieldStyles.offWhite)
  //   | (_) => Css.style(BoardFieldStyles.green)
  // };
  <Cell player onClick className={Js.Array2.joinWith([cellColor, css["cell"], cellCssFromState], " ")}/>
}