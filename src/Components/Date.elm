module Components.Date exposing (render)

import Css exposing (..)
import Date
import Html.Styled exposing (Attribute, Html, div, text)
import Html.Styled.Attributes exposing (css)
import Helpers.DateTime as DateTime


baseStyles : Attribute action
baseStyles =
    css
        [ display inlineFlex
        , padding2 (px 5) (px 6)
        , fontSize (em 0.8)
        , backgroundColor (rgba 0 0 0 0.5)
        , borderRadius (px 3)
        ]


render : List (Attribute action) -> Date.Date -> Html action
render attributes date =
    div (baseStyles :: attributes)
        [ text <| DateTime.toString date
        ]
