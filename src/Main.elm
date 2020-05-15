module Main exposing (main)

import Action exposing (Action)
import Action.Store
import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Navigation
import Helpers exposing (packModelWithCmd)
import Model exposing (Model, ViewModel)
import Router exposing (handleUrl)
import Store exposing (initStore)
import Url as URL exposing (Url)
import View
import View.Home
import View.NewEmployee


init : () -> Url -> Navigation.Key -> ( Model, Cmd Action )
init _ url key =
    handleUrl <| initStore url key


subscriptions : Model -> Sub Action
subscriptions _ =
    Sub.none


updateStore : Action.Store.Action -> Model -> ( Model, Cmd Action )
updateStore action model =
    let
        ( newStore, cmd ) =
            Store.update action model.store
    in
    ( { model | store = newStore }, cmd )


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        Action.None ->
            ( model, Cmd.none )

        Action.UrlChanged _ ->
            handleUrl model.store

        Action.LinkClicked request ->
            updateByClickUrl request model

        Action.Store storeAction ->
            updateStore storeAction model

        Action.Views viewsAction ->
            View.update viewsAction model

        _ ->
            ( model, Cmd.none )


updateUrl : Url -> Model -> Model
updateUrl url model =
    { model
        | store =
            Store.updateUrl url model.store
    }


updateByClickUrl : UrlRequest -> Model -> ( Model, Cmd Action )
updateByClickUrl request model =
    case request of
        Browser.Internal url ->
            ( updateUrl url model, Navigation.pushUrl model.store.navigationKey (URL.toString url) )

        Browser.External url ->
            ( model
            , Navigation.load url
            )


render : Model -> Document Action
render model =
    case model.viewModel of
        Model.Home home ->
            View.Home.render model.store home

        Model.NewEmployee newEmployee ->
            View.NewEmployee.render model.store newEmployee


main : Program () Model Action
main =
    Browser.application
        { init = init
        , update = update
        , onUrlChange = Action.UrlChanged
        , onUrlRequest = Action.LinkClicked
        , view = render
        , subscriptions = subscriptions
        }
