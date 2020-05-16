module Store.Employees exposing (Model, update)

import Action exposing (Action)
import Action.Store.Employees as EmployeesActions
import Employee


type alias Model =
    { lastId : Int
    , items : Employee.Employees
    }


change : Employee.Id -> Employee.Employee -> Model -> Model
change id employee employees =
    { employees
        | items =
            Employee.insert employees.items id employee
    }


update : EmployeesActions.Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        EmployeesActions.Change id employee ->
            ( change id employee model, Cmd.none )

        EmployeesActions.Insert employee ->
            ( { lastId = model.lastId + 1
              , items = Employee.insert model.items model.lastId <| Employee.updateId model.lastId employee
              }
            , Cmd.none
            )
