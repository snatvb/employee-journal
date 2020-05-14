module Helpers exposing (packDocument, packModelWithCmd)

import Browser exposing (Document)
import Html.Styled exposing (Html, toUnstyled)

import Action exposing (Action)

packDocument : String -> Html Action -> Document Action
packDocument title html =
    { title = title
    , body = [toUnstyled html]
    }

packModelWithCmd : (m -> pm) -> (a -> m -> ( m, Cmd Action )) -> a -> m -> ( pm, Cmd Action )
packModelWithCmd packer updateFn action model =
    let
        ( updatedModel, cmd ) =
            updateFn action model
    in
    ( packer updatedModel, cmd )