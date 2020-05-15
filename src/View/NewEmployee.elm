module View.NewEmployee exposing (Model, init, render, update)

import Action exposing (Action)
import Action.Views as ViewsActions
import Action.Views.NewEmployee as NewEmployeeActions
import Browser exposing (Document)
import ComponentSize
import Components.Employee
import Components.Input as Input
import Components.Link as Link
import Employee exposing (Employee)
import Helpers exposing (packDocument)
import Html.Styled exposing (Html, div, text)
import Html.Styled.Attributes exposing (href, value)
import Html.Styled.Events exposing (onInput)
import Store exposing (Store)


type alias Model =
    { name : String
    , surname : String
    }


init : ( Model, Cmd Action )
init =
    ( { name = "Example name"
      , surname = "Example surname"
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


view : Store -> Model -> Html Action
view _ model =
    div []
        [ div [] [ text model.name ]
        , Input.render [ value model.name, onInput actionChangeName ]
        , Input.render [ value model.surname, onInput actionChangeSurname ]
        , div []
            [ Link.default [ href "/" ] [ text "Назад" ]
            ]
        , Components.Employee.render ComponentSize.Medium <| buildEmployee model
        ]


render : Store -> Model -> Document Action
render store model =
    packDocument "Home" (view store model)
