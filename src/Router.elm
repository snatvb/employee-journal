module Router exposing (..)

import Action exposing (Action)
import Model exposing (Model)
import Store exposing (Store)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string, top)
import View.Home


convertInitView : (m -> Model) -> (Store -> ( m, Cmd Action )) -> Store -> ( Model, Cmd Action )
convertInitView packer init store =
    let
        ( model, cmd ) =
            init store
    in
    ( packer model, cmd )


parse : Store -> Parser (( Model, Cmd Action ) -> a) a
parse store =
    oneOf
        [ route top <|
            convertInitView Model.Home View.Home.init store
        ]

handleUrl : Store -> Url.Url -> ( Model, Cmd Action )
handleUrl store url =
    case Parser.parse (parse store) url of
      Just answer ->
        answer

      Nothing ->
        convertInitView Model.Home View.Home.init store


route : Parser a b -> a -> Parser (b -> c) c
route parser handler =
    Parser.map handler parser
