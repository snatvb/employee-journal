module View exposing (update)

import Action exposing (Action)
import Action.Views
import Helpers exposing (packModelWithCmd)
import Model exposing (Model, ViewModel)
import View.Home
import View.NewEmployee



updateViewModel : Action.Views.Action -> ViewModel -> ( ViewModel, Cmd Action )
updateViewModel action viewModel =
    case (action, viewModel) of
        (Action.Views.Home viewActon, Model.Home model) ->
            packModelWithCmd Model.Home View.Home.update viewActon model

        (Action.Views.NewEmployee viewActon, Model.NewEmployee model) ->
            packModelWithCmd Model.NewEmployee View.NewEmployee.update viewActon model

        _ ->
            ( viewModel, Cmd.none )


update : Action.Views.Action -> Model -> ( Model, Cmd Action )
update action model =
    let
        ( viewModel, cmd ) =
            updateViewModel action model.viewModel
    in
    ( { model | viewModel = viewModel }, cmd )
