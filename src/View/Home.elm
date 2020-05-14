module View.Home exposing (Model, init, render, updateStore)

import Action exposing (Action)
import Action.Store
import Browser exposing (Document)
import Components.Input as Input
import Components.Link as Link
import Helpers exposing (packDocument)
import Html.Styled exposing (Html, a, div, text)
import Html.Styled.Attributes exposing (href)
import Store as St exposing (Store)


type alias Model =
    { store : Store
    , counter : Int
    }


init : Store -> ( Model, Cmd Action )
init store =
    ( { store = store
      , counter = 0
      }
    , Cmd.none
    )


updateStore : Action.Store.Action -> Model -> ( Model, Cmd Action )
updateStore storeAction model =
    let
        ( store, cmd ) =
            St.update storeAction model.store
    in
    ( { model | store = store }, cmd )



-- update : Action -> Model -> ( Model, Cmd Action )
-- update action model =
--     case action of
--         Action.Store storeAction ->
--             let
--                 ( store, cmd ) =
--                     St.update storeAction model.store
--             in
--             ( { model | store = store }, cmd )


view : Model -> Html Action
view model =
    div []
        [ div [] [ text "Hello world" ]
        , Input.render []
        , div [] [ text <| String.fromInt model.counter ]
        , div []
            [ Link.default [ href "add-employee" ] [ text "Новый сотрудник" ]
            ]
        ]


render : Model -> Document Action
render model =
    packDocument "Home" (view model)
