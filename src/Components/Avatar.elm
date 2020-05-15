module Components.Avatar exposing (Avatar, baseStyles, render)

import Array
import ComponentSize exposing (Size)
import Css exposing (..)
import Helpers.Color
import Helpers.String
import Html.Styled exposing (Attribute, Html, div, img, text)
import Html.Styled.Attributes exposing (css, src)


type alias Avatar =
    { name : String
    , url : Maybe String
    , id : Int
    , size : Size
    }


getBackgroundColor : Avatar -> Color
getBackgroundColor avatar =
    case avatar.url of
        Just _ ->
            hex "00000000"

        Nothing ->
            Helpers.Color.getById avatar.id


getBaseStylesBySize : Avatar -> List (Attribute action)
getBaseStylesBySize avatar =
    case avatar.size of
        ComponentSize.Medium ->
            [ css
                [ width (px 100)
                , height (px 100)
                , fontSize (px 32)
                ]
            ]


baseStyles : Avatar -> List (Attribute action)
baseStyles avatar =
    List.concat
        [ getBaseStylesBySize avatar
        , [ css
                [ borderRadius (px 9999)
                , backgroundColor (getBackgroundColor avatar)
                ]
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
        , width (pct 100)
        , height (pct 100)
        ]
    ]


photoAttrs : String -> List (Attribute action)
photoAttrs url =
    [ src url
    , css
        [ width (pct 100)
        , height (pct 100)
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
