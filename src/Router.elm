module Router exposing (handleUrl)

import Action exposing (Action)
import Employee
import Model exposing (Model, ViewModel, buildModel)
import Store exposing (Store)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, top)
import View.Employee
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


getEmployee : Store -> Employee.Id -> ( Model, Cmd Action )
getEmployee store employeeId =
    convertInitView Model.Employee (View.Employee.init employeeId) store


parse : Store -> Parser (( Model, Cmd Action ) -> a) a
parse store =
    oneOf
        [ route top <|
            getHome store
        , route (s "add-employee") <|
            getNewEmployee store
        , route (s "employee" </> Employee.urlParser) <|
            \employeeId -> getEmployee store employeeId
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
