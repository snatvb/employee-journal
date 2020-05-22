module Update exposing (update)

import Action exposing (Action)
import Action.Store
import Browser exposing (UrlRequest)
import Browser.Navigation as Navigation
import Helpers exposing (fixPathInUrl)
import Model exposing (Model)
import Router exposing (handleUrl)
import Store
import Url as URL exposing (Url)
import View


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        Action.None ->
            ( model, Cmd.none )

        Action.Batch actions ->
            List.foldl handleBatchActions ( model, Cmd.none ) actions

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


updateStore : Action.Store.Action -> Model -> ( Model, Cmd Action )
updateStore action model =
    let
        ( newStore, cmd ) =
            Store.update action model.store
    in
    ( { model | store = newStore }, cmd )


updateUrl : Url -> Model -> Model
updateUrl url model =
    { model
        | store =
            Store.updateUrl url model.store
    }


handleBatchActions : Action -> ( Model, Cmd Action ) -> ( Model, Cmd Action )
handleBatchActions action ( model, cmds ) =
    let
        ( newModel, newCmds ) =
            update action model
    in
    ( newModel, Cmd.batch [ newCmds, cmds ] )


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
