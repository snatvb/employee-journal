module Action.Store exposing (Action(..))

import Action.Store.Employees
import Action.Store.Features

type Action =
  Employees Action.Store.Employees.Action
  | Features Action.Store.Features.Action
