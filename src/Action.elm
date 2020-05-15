module Action exposing (Action(..))

import Action.Example
import Action.Store
import Action.Views
import Browser exposing (UrlRequest)
import Url exposing (Url)


type Action
    = None
    | Store Action.Store.Action
    | Example Action.Example.Action
    | LinkClicked UrlRequest
    | UrlChanged Url
    | Views Action.Views.Action
