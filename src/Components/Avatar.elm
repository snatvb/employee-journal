module Components.Avatar exposing (Avatar, baseStyles, render)

import Array
import Css exposing (..)
import Helpers.Color
import Helpers.String
import Html.Styled exposing (Attribute, Html, div, img, text)
import Html.Styled.Attributes exposing (css, src)

type alias Avatar =
    { name : String
    , url : Maybe String
    , id : Int
    }


getBackgroundColor : Avatar -> Color
getBackgroundColor avatar =
    case avatar.url of
        Just _ ->
            hex "00000000"

        Nothing ->
            Helpers.Color.getById avatar.id


baseStyles : Avatar -> List (Attribute action)
baseStyles avatar =
    [ css
        [ borderRadius (px 9999)
        , backgroundColor (getBackgroundColor avatar)
        ]
    ]


render : Avatar -> Html action
render avatar =
    div (baseStyles avatar)
        [ photo avatar
        ]


photoEmptyStyles : List (Attribute action)
photoEmptyStyles =
    [ css
        [ displayFlex
        , justifyContent center
        , alignItems center
        ]
    ]


photo : Avatar -> Html action
photo avatar =
    case avatar.url of
        Just url ->
            img [ src url ] []

        Nothing ->
            div photoEmptyStyles
                [ text <| Helpers.String.getFirstToAvatar avatar.name ]
