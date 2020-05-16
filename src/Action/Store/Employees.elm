module Action.Store.Employees exposing (Action(..))

import Employee exposing (Employee, Id)


type Action
    = Insert Employee
    | Change Id Employee
