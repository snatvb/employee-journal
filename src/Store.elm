module Store exposing (Store, initStore, update, updateUrl)

import Action exposing (Action)
import Action.Store as StoreActions
import Action.Store.Employees as EmployeesActions
import Browser.Navigation as Navigation
import Dict exposing (empty)
import Store.Employees
import Url exposing (Url)


type alias Store =
    { employees : Store.Employees.Model
    , navigationKey : Navigation.Key
    , url : Url
    }


initStore : Url -> Navigation.Key -> Store
initStore url key =
    { employees = { lastId = 0, items = empty }
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


update : StoreActions.Action -> Store -> ( Store, Cmd Action )
update action model =
    case action of
        StoreActions.Employees actionEmployees ->
            updateEmployees actionEmployees model
