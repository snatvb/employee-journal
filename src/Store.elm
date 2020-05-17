module Store exposing (Store, initStore, update, updateUrl)

import Action exposing (Action)
import Action.Store as StoreActions
import Action.Store.Employees as EmployeesActions
import Browser.Navigation as Navigation
import Dict exposing (empty)
import Structures.Employee as Employee
import Json.Encode as Encoder
import Ports exposing (saveStore)
import Store.Employees
import Store.Features
import Url exposing (Url)


type alias Store =
    { employees : Store.Employees.Model
    , features : Store.Features.Model
    , navigationKey : Navigation.Key
    , url : Url
    }


initEmployeesForTest : Employee.Employees
initEmployeesForTest =
    Dict.fromList
        [ ( 0, { id = 0, name = "Ivan", surname = "Ivanov" } )
        , ( 1, { id = 1, name = "Sergey", surname = "Bulkin" } )
        , ( 2, { id = 2, name = "Vasiliy", surname = "Pechkin" } )
        ]


initStore : Url -> Navigation.Key -> Store
initStore url key =
    { employees = { nextId = 3, items = initEmployeesForTest }
    , features = Store.Features.init
    , navigationKey = key
    , url = url
    }


updateEmployees : EmployeesActions.Action -> Store -> ( Store, Cmd Action )
updateEmployees action model =
    let
        ( employees, cmd ) =
            Store.Employees.update action model.employees
    in
    ( { model | employees = employees }, cmd )


updateUrl : Url -> Store -> Store
updateUrl url store =
    { store | url = url }


updateModel : StoreActions.Action -> Store -> ( Store, Cmd Action )
updateModel action model =
    case action of
        StoreActions.Employees actionEmployees ->
            updateEmployees actionEmployees model


update : StoreActions.Action -> Store -> ( Store, Cmd Action )
update action model =
    let
        ( newModel, cmds ) =
            updateModel action model
    in
    ( newModel, Cmd.batch [ saveStore (encode newModel), cmds ] )


encode : Store -> Encoder.Value
encode store =
    Encoder.object
        [ ( "employees", Store.Employees.encode store.employees ) ]
