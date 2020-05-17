module View.Employee exposing (Model, init, render, update)

import Action exposing (Action)
import Action.Views.Home as HomeActions
import Browser exposing (Document)
import Components.Employees as EmployeesComponent
import Components.Link as Link
import Css exposing (..)
import Dict
import Employee
import Helpers exposing (packDocument, prepareInternalUrlRequest)
import Html.Styled exposing (Attribute, Html, div, text)
import Html.Styled.Attributes exposing (css, href)
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


view : Store -> Model -> Html Action
view store _ =
    div [ baseStyles ]
        [ text "here will be employee"
        , Link.default [ href "/" ] [ text "Назад" ]
        ]


render : Store -> Model -> Document Action
render store model =
    packDocument "Home" (view store model)
