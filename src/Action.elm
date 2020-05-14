module Action exposing (Action(..))

import Browser exposing (UrlRequest)
import Url exposing (Url)
import Action.Store
import Action.Example

type Action
    = None
    | Store Action.Store.Action
    | Example Action.Example.Action
    | LinkClicked UrlRequest
    | UrlChanged Url