@module external styles: {..} = "./App.module.scss"

open App__State.State

@react.component
let make = _ => {
  let (state, dispatch) = App__State.useAppReducer()
  let onResetGame = React.useCallback1(_ => dispatch(ResetGame), [dispatch])
  let onClickBoardCell = React.useCallback1(boardCell => dispatch(SelectBoardCell(boardCell)), [dispatch])
  <div className={styles["container"]}>
    <Component__GameHeader state onClick=onResetGame /> 
    <div className={styles["board"]}>
      {
        state.gameBoard
          ->Js.Array2.map(row =>
            <Component__Row key={row.id->Js.Int.toString} row onClick=onClickBoardCell />
          )
          ->React.array
      }
    </div>
  </div>
}