module View.NewEmployee exposing (Model, init, render)

import Action exposing (Action)
import Browser exposing (Document)
import Components.Input as Input
import Components.Link as Link
import Helpers exposing (packDocument)
import Html.Styled exposing (Html, a, div, text)
import Html.Styled.Attributes exposing (href)
import Store exposing (Store)


type alias Model =
    { name : String
    , surname: String
    }


init : ( Model, Cmd Action )
init =
    ( { name = "Example name"
    , surname = "Example surname"
      }
    , Cmd.none
    )



-- update : Action -> Model -> ( Model, Cmd Action )
-- update action model =
--     case action of
--         Action.Store storeAction ->
--             let
--                 ( store, cmd ) =
--                     St.update storeAction model.store
--             in
--             ( { model | store = store }, cmd )


view : Store -> Model -> Html Action
view _ model =
    div []
        [ div [] [ text model.name ]
        -- , Input.render [ text model.name ]
        , div []
            [ Link.default [ href "/" ] [ text "Назад" ]
            ]
        ]


render : Store -> Model -> Document Action
render store model =
    packDocument "Home" (view store model)
