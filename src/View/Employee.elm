module View.Employee exposing (Model, init, render, update)

import Action exposing (Action)
import Action.Views.Home as HomeActions
import Browser exposing (Document)
import Components.Employee as EmployeeComponent
import Components.Link as Link
import Components.NotFound as NotFound
import Css exposing (..)
import Structures.Employee as Employee
import Helpers exposing (packDocument)
import Html.Styled exposing (Attribute, Html, div, text)
import Html.Styled.Attributes exposing (css, href)
import Selectors.Store.Employee as EmployeeSelectors
import Store exposing (Store)


type alias Model =
    { id : Int
    }


init : Int -> ( Model, Cmd Action )
init id =
    ( { id = id
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


backLinkStyles : Attribute Action
backLinkStyles =
    css [ marginTop (px 20) ]


viewEmployee : Employee.Employee -> Html Action
viewEmployee employee =
    div [ baseStyles ]
        [ EmployeeComponent.render employee
        , Link.default [ backLinkStyles, href "/" ] [ text "Назад" ]
        ]


viewNotFound : Html Action
viewNotFound =
    div [ baseStyles ]
        [ NotFound.render []
            [ div [] [ text "Сотрудник не найден" ]
            , Link.default [ backLinkStyles, href "/" ] [ text "Назад" ]
            ]
        ]


view : Store -> Model -> Html Action
view store model =
    case EmployeeSelectors.get model.id store of
        Just employee ->
            viewEmployee employee

        Nothing ->
            viewNotFound


render : Store -> Model -> Document Action
render store model =
    packDocument "Home" (view store model)
