@react.component
let make = (~state: App__State.State.t, ~onClick) =>
  <div>
    <p>{state.gameState->App__State.GameState.toString->React.string}</p>
    <p><button onClick>{"Reset Game"->React.string}</button></p>
  </div>