module Model exposing (Model, ViewModel(..), buildModel)

import Store exposing (Store)
import View.Home
import View.Employee
import View.NewEmployee


type ViewModel
    = Home View.Home.Model
    | Employee View.Employee.Model
    | NewEmployee View.NewEmployee.Model


type alias Model =
    { viewModel : ViewModel
    , store : Store
    }


buildModel : Store -> ViewModel -> Model
buildModel store model =
    { viewModel = model
    , store = store
    }
