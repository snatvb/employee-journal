module Action.Views.NewFeature exposing (Action(..), Form(..))

type Action
    = Form Form

type Form =
  UpdateTitle String
  | UpdateDescription String
  | UpdatePM String
  | UpdateFO String
