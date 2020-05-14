module Action.Store exposing (Action(..))

import Action.Store.Employees

type Action = Employees Action.Store.Employees.Action
