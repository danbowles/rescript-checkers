open Models
@module external styles: {..} = "./Component__Cell.module.scss"

module GamePiece = {
  @react.component
  let make = (~className) => <div className={styles["gamePieceContainer"]}>
    <div className={Js.Array2.joinWith([className, styles["gamePiece"]], " ")}/>
  </div>
}

module Cell = {
  @react.component
  let make = (~className, ~player) => {
    let gamePiece = switch player {
      | Red(kingStatus) => <GamePiece className={styles["red"]}/>
      | White(kingStatus) => <GamePiece className={styles["white"]}/>
      | Empty => React.null
    }
    <div className>{gamePiece}</div>
  }
}

@react.component
let make = (~cell: BoardCell.t) => {
  let {x, y, player, cellState} = cell;
  // let rowColTuple = (x mod 2, y mod 2);
  let cellColor = switch (mod(x, 2), mod(y, 2)) {
    |(0, 0)
    |(1, 1) => styles["mainColor"]
    |(_, _) => styles["altColor"]
  };


  //   | (0, 0) => Css.style(BoardFieldStyles.offWhite)
  //   | (1, 1) => Css.style(BoardFieldStyles.offWhite)
  //   | (_) => Css.style(BoardFieldStyles.green)
  // };
  <Cell player className={Js.Array2.joinWith([cellColor, styles["cell"]], " ")}/>
}