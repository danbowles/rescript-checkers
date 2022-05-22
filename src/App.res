open Models
@module external styles: {..} = "./App.module.scss"

@react.component
let make = _ => {
  let game = Game.make()
  <div className={styles["container"]}>
    <div className={styles["board"]}>
      {game.board->Js.Array2.map(row => <Component__Row key={row.id->Js.Int.toString} row />)->React.array}
    </div>
  </div>
}