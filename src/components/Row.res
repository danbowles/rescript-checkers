open Models
@module external styles: {..} = "./Row.module.scss"
@react.component
let make = (~row: BoardRow.t, ~onClick) => {
  <div className={styles["row"]} key={row.id->Js.Int.toString}>
    {row.cells->Js.Array2.map(cell => <Cell onClick key={cell.id} cell/>)->React.array}
  </div>
}