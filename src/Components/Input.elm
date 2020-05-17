module Components.Input exposing (render)

import List
import Css exposing (..)
import Html.Styled exposing (Html, Attribute, input, div)
import Html.Styled.Attributes exposing (css)

addCustomAttributes : List (Attribute msg) -> List (Attribute msg)
addCustomAttributes attributes =
  List.concat [
    attributes,
    [css [
      padding (px 10),
      backgroundColor (rgba 0 0 0 0.6),
      border zero,
      borderRadius (px 3),
      focus [
        outline zero,
        backgroundColor (rgba 0 0 0 0.7)
      ]
    ]]
  ]

render : List (Attribute msg) -> Html msg
render attributes =
  input (addCustomAttributes attributes) []
