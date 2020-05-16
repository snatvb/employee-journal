module Action exposing (Action(..))

import Action.Example
import Action.Store
import Action.Views
import Browser exposing (UrlRequest)
import Url exposing (Url)


type Action
    = None
    | LinkClicked UrlRequest
    | UrlChanged Url
    | Redirect UrlRequest
    | RedirectAfterAction UrlRequest Action
    | Store Action.Store.Action
    | Example Action.Example.Action
    | Views Action.Views.Action
