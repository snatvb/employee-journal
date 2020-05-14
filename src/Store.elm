module Store exposing (Store, initStore, update)

import Browser.Navigation as Navigation
import Dict exposing (empty)

import Action exposing (Action)
import Action.Store as StoreActions
import Action.Store.Employees as EmployeesActions
import Store.Employees


type alias Store =
    { employees : Store.Employees.Model
    , navigationKey: Navigation.Key
    }


initStore : Navigation.Key -> Store
initStore key =
    { employees = { lastId = 0, items = empty }
    , navigationKey = key
    }


updateEmployees : EmployeesActions.Action -> Store -> ( Store, Cmd Action )
updateEmployees action model =
    let
        ( employees, cmd ) =
            Store.Employees.update action model.employees
    in
    ( { model | employees = employees }, cmd )


update : StoreActions.Action -> Store -> ( Store, Cmd Action )
update action model =
    case action of
        StoreActions.Employees actionEmployees ->
            updateEmployees actionEmployees model
