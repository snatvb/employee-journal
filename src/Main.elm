module Main exposing (main)

import Action exposing (Action)
import Action.Store
import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Navigation
import Helpers exposing (packModelWithCmd)
import Model exposing (Model)
import Router exposing (handleUrl)
import Store exposing (initStore)
import Url exposing (Url)
import View.Home


init : () -> Url -> Navigation.Key -> ( Model, Cmd Action )
init _ url key =
    handleUrl (initStore key) url


subscriptions : Model -> Sub Action
subscriptions _ =
    Sub.none


updateStore : Action.Store.Action -> Model -> ( Model, Cmd Action )
updateStore action model =
    case model of
        Model.Home home ->
            packModelWithCmd Model.Home View.Home.updateStore action home


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        Action.None ->
            ( model, Cmd.none )

        Action.UrlChanged _ ->
            ( model, Cmd.none )

        Action.LinkClicked request ->
            updateByClickUrl request model

        Action.Store storeAction ->
            updateStore storeAction model

        _ ->
            ( model, Cmd.none )


updateByClickUrl : UrlRequest -> Model -> ( Model, Cmd Action )
updateByClickUrl request model =
    case request of
        Browser.Internal url ->
            case url.fragment of
                Nothing ->
                    -- If we got a link that didn't include a fragment,
                    -- it's from one of those (href "") attributes that
                    -- we have to include to make the RealWorld CSS work.
                    --
                    -- In an application doing path routing instead of
                    -- fragment-based routing, this entire
                    -- `case url.fragment of` expression this comment
                    -- is inside would be unnecessary.
                    ( model, Cmd.none )

                Just _ ->
                    ( model, Cmd.none )
                    -- ( model
                    -- , Navigation.pushUrl (model.store.navKey (toSession model)) (Url.toString url)
                    -- )

        Browser.External href ->
            ( model
            , Navigation.load href
            )


render : Model -> Document Action
render model =
    case model of
        Model.Home home ->
            View.Home.render home


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
