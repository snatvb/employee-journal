module Action.Store.Features exposing (Action(..))

import Structures.Feature exposing (Feature)

type Action =
  Add Feature
  | Remove Int
  | Update Int Feature
