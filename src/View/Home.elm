module View.Home exposing (Model, init, render, update)

import Action exposing (Action)
import Action.Views.Home as HomeActions
import Browser exposing (Document)
import Components.Employees as EmployeesComponent
import Components.Link as Link
import Css exposing (..)
import Dict
import Helpers exposing (packDocument, prepareInternalUrlRequest)
import Html.Styled exposing (Attribute, Html, div, text)
import Html.Styled.Attributes exposing (css, href)
import Store exposing (Store)
import Structures.Employee as Employee


type alias Model =
    { counter : Int
    }


init : ( Model, Cmd Action )
init =
    ( { counter = 0
      }
    , Cmd.none
    )


update : HomeActions.Action -> Model -> ( Model, Cmd Action )
update _ model =
    ( model, Cmd.none )


baseStyles : Attribute Action
baseStyles =
    css
        [ displayFlex
        , flexDirection column
        , justifyContent center
        , alignItems center
        , width (pct 100)
        , height (pct 100)
        ]


headerStyles : Attribute Action
headerStyles =
    css
        [ fontSize (px 24)
        ]


employeesStyles : Attribute Action
employeesStyles =
    css
        [ margin2 (px 40) (px 0)
        ]


linkRowStyles : Attribute Action
linkRowStyles =
    css
        [ margin2 (px 10) (px 0)
        , textAlign center
        ]


makePathFromEmployee : Employee.Employee -> String
makePathFromEmployee employee =
    "/employee/" ++ String.fromInt employee.id


handleEmployeeClick : Store -> Employee.Employee -> Action
handleEmployeeClick store employee =
    Action.Redirect
        << prepareInternalUrlRequest (makePathFromEmployee employee)
    <|
        store.url


viewEmployees : Store -> Html Action
viewEmployees store =
    EmployeesComponent.render
        [ EmployeesComponent.onItemClick <| handleEmployeeClick store ]
    <|
        getLastThreeEmployees store.employees.items


view : Store -> Model -> Html Action
view store _ =
    div [ baseStyles ]
        [ div [ headerStyles ] [ text "Журнал сотрудников" ]
        , div [ employeesStyles ] [ viewEmployees store ]
        , div []
            [ linkRow [ Link.default [ href "add-employee" ] [ text "Новый сотрудник" ] ]
            , linkRow [ Link.default [ href "add-feature" ] [ text "Добавить фичу" ] ]
            ]
        ]


render : Store -> Model -> Document Action
render store model =
    packDocument "Home" (view store model)


linkRow : List (Html Action) -> Html Action
linkRow =
    div [ linkRowStyles ]


getLastThreeEmployees : Employee.Employees -> List Employee.Employee
getLastThreeEmployees employees =
    List.take 3
        << List.reverse
        << Dict.values
    <|
        employees
