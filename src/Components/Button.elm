module Components.Button exposing (render)

import ComponentSize exposing (Size)
import Css exposing (..)
import Html.Styled exposing (Attribute, Html, button)
import Html.Styled.Attributes exposing (css)


baseStylesBySize : Size -> List Style
baseStylesBySize size =
    case size of
        ComponentSize.Medium ->
            [ padding2 (px 8) (px 12)
            , fontSize (px 16)
            ]


baseInterectiveStyles : List Style
baseInterectiveStyles =
    [ cursor pointer
    , backgroundColor (hex "#111")
    , outline none
    ]


baseStyles : Size -> Attribute action
baseStyles size =
    css <|
        List.concat
            [ baseStylesBySize size
            , [ borderRadius (px 3)
              , border (px 0)
              , backgroundColor (hex "#191919")
              , color (hex "#f3f3f3")
              , focus baseInterectiveStyles
              , hover baseInterectiveStyles
              ]
            ]


baseAttributes : Size -> List (Attribute action) -> List (Attribute action)
baseAttributes size attributes =
    baseStyles size :: attributes


render : Size -> List (Attribute action) -> List (Html action) -> Html action
render size attributes html =
    button (baseAttributes size attributes) html
