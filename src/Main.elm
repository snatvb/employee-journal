module Main exposing (main)

import Action exposing (Action)
import Action.Store
import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Navigation
import Helpers exposing (fixPathInUrl)
import Model exposing (Model)
import Router exposing (handleUrl)
import Store exposing (initStore)
import Url as URL exposing (Url)
import View
import View.Employee
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

        Action.UrlChanged url ->
            handleUrl <| Store.updateUrl url model.store

        Action.LinkClicked request ->
            updateLink request model

        Action.Redirect request ->
            updateLink request model

        Action.RedirectAfterAction request actionAfterRedirect ->
            updateByRedirectAction actionAfterRedirect <|
                updateLink request model

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


updateByRedirectAction : Action -> ( Model, Cmd Action ) -> ( Model, Cmd Action )
updateByRedirectAction action ( model, cmds ) =
    let
        ( newModel, newCmds ) =
            update action model
    in
    ( newModel, Cmd.batch [ newCmds, cmds ] )


updateLink : UrlRequest -> Model -> ( Model, Cmd Action )
updateLink request model =
    case request of
        Browser.Internal url ->
            let
                fixedUrl =
                    fixPathInUrl url
            in
            ( updateUrl fixedUrl model, Navigation.pushUrl model.store.navigationKey (URL.toString fixedUrl) )

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

        Model.Employee employee ->
            View.Employee.render model.store employee


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
