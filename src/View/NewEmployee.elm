module View.NewEmployee exposing (Model, init, render, update)

import Action exposing (Action)
import Action.Store
import Action.Store.Employees
import Action.Views as ViewsActions
import Action.Views.NewEmployee as NewEmployeeActions
import Browser exposing (Document)
import Components.Button as Button
import Components.Employee
import Components.Input as Input
import Components.Link as Link
import Css exposing (..)
import Employee exposing (Employee)
import Helpers exposing (packDocument, prepareInternalUrlRequest)
import Html.Styled exposing (Attribute, Html, div, text)
import Html.Styled.Attributes exposing (css, href, value)
import Html.Styled.Events exposing (onClick, onInput)
import Store exposing (Store)


type alias Model =
    { name : String
    , surname : String
    }


init : ( Model, Cmd Action )
init =
    ( { name = "Name"
      , surname = "Surname"
      }
    , Cmd.none
    )


update : NewEmployeeActions.Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        NewEmployeeActions.UpdateName name ->
            ( { model | name = name }, Cmd.none )

        NewEmployeeActions.UpdateSurname surname ->
            ( { model | surname = surname }, Cmd.none )


buildEmployee : Model -> Employee
buildEmployee model =
    { id = 0
    , name = model.name
    , surname = model.surname
    }


actionChangeName : String -> Action
actionChangeName =
    Action.Views << ViewsActions.NewEmployee << NewEmployeeActions.UpdateName


actionChangeSurname : String -> Action
actionChangeSurname =
    Action.Views << ViewsActions.NewEmployee << NewEmployeeActions.UpdateSurname


exmapleStyles : List (Attribute Action)
exmapleStyles =
    [ css
        [ width (px 300)
        ]
    ]


exmaple : Model -> Html Action
exmaple model =
    div exmapleStyles
        [ Components.Employee.render <| buildEmployee model
        ]


formStyles : Attribute Action
formStyles =
    css
        [ marginRight (px 30)
        ]


row : Html Action -> Html Action
row html =
    div [ css [ marginTop (px 10) ] ] [ html ]


form : Store -> Model -> Html Action
form store model =
    div [ formStyles ]
        [ row <| div [] [ text "Новый сотрудник" ]
        , row <| Input.render [ value model.name, onInput actionChangeName ]
        , row <| Input.render [ value model.surname, onInput actionChangeSurname ]
        , row <| Button.render [ onClick <| save store model ] [ text "Сохранить" ]
        , row <|
            div []
                [ Link.default [ href "/" ] [ text "Назад" ]
                ]
        ]


baseStyles : Attribute Action
baseStyles =
    css
        [ displayFlex
        , justifyContent center
        , alignItems center
        , paddingTop (px 20)
        ]


view : Store -> Model -> Html Action
view store model =
    div [ baseStyles ]
        [ form store model
        , exmaple model
        ]


render : Store -> Model -> Document Action
render store model =
    packDocument "Новый сотрудник" (view store model)


save : Store -> Model -> Action
save store model =
    Action.RedirectAfterAction (prepareInternalUrlRequest "/" store.url)
        << Action.Store
        << Action.Store.Employees
        << Action.Store.Employees.Insert
    <|
        buildEmployee model
