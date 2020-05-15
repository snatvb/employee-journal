module Router exposing (..)

import Action exposing (Action)
import Model exposing (Model, ViewModel, buildModel)
import Store exposing (Store)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string, top)
import View.Home
import View.NewEmployee


convertInitView : (m -> ViewModel) -> ( m, Cmd Action ) -> Store -> ( Model, Cmd Action )
convertInitView packer ( model, cmd ) store =
    ( buildModel store <| packer model, cmd )


getHome : Store -> ( Model, Cmd Action )
getHome store =
    convertInitView Model.Home View.Home.init store


getNewEmployee : Store -> ( Model, Cmd Action )
getNewEmployee store =
    convertInitView Model.NewEmployee View.NewEmployee.init store


parse : Store -> Parser (( Model, Cmd Action ) -> a) a
parse store =
    oneOf
        [ route top <|
            getHome store
        , route (s "add-employee") <|
            getNewEmployee store
        ]


handleUrl : Store -> ( Model, Cmd Action )
handleUrl store =
    case Parser.parse (parse store) store.url of
        Just answer ->
            answer

        Nothing ->
            getHome store


route : Parser a b -> a -> Parser (b -> c) c
route parser handler =
    Parser.map handler parser
