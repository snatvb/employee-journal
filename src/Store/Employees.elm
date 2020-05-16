module Store.Employees exposing (Model, encode, update)

import Action exposing (Action)
import Action.Store.Employees as EmployeesActions
import Employee
import Json.Encode as Encoder


type alias Model =
    { nextId : Int
    , items : Employee.Employees
    }


change : Employee.Id -> Employee.Employee -> Model -> Model
change id employee employees =
    { employees
        | items =
            Employee.insert employees.items id employee
    }


insert : Model -> Employee.Employee -> Model
insert model employee =
    { nextId = model.nextId + 1
    , items = Employee.insert model.items model.nextId <| Employee.updateId model.nextId employee
    }


update : EmployeesActions.Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        EmployeesActions.Change id employee ->
            ( change id employee model, Cmd.none )

        EmployeesActions.Insert employee ->
            ( insert model employee
            , Cmd.none
            )


encode : Model -> Encoder.Value
encode model =
    Encoder.object
        [ ( "nextId", Encoder.int model.nextId )
        , ( "items", Employee.encodeEmployees model.items )
        ]
