module Main exposing (main)

import Action exposing (Action)
import Browser exposing (Document)
import Browser.Navigation as Navigation
import Model exposing (Model)
import Router exposing (handleUrl)
import Store exposing (initStore)
import Update exposing (update)
import Url exposing (Url)
import View.Employee
import View.Home
import View.NewEmployee
import View.NewFeature


init : () -> Url -> Navigation.Key -> ( Model, Cmd Action )
init _ url key =
    handleUrl <| initStore url key


subscriptions : Model -> Sub Action
subscriptions model =
    case model.viewModel of
        Model.NewFeature submodel ->
            View.NewFeature.subscriptions submodel

        _ ->
            Sub.none


render : Model -> Document Action
render model =
    case model.viewModel of
        Model.Home home ->
            View.Home.render model.store home

        Model.NewEmployee newEmployee ->
            View.NewEmployee.render model.store newEmployee

        Model.NewFeature submodel ->
            View.NewFeature.render model.store submodel

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
