module Action.Views exposing (Action(..))

import Action.Views.NewEmployee as NewEmployee
import Action.Views.Home as Home

type Action =
  Home Home.Action
  | NewEmployee NewEmployee.Action
