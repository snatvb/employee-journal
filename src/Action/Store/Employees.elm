module Action.Store.Employees exposing (Action(..))

import Employee exposing (Employee, Id)

type Action = Add Employee | Change Id Employee
