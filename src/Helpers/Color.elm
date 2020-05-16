module Helpers.Color exposing (getById)

import Array
import Css exposing (Color, hex)


colors : Array.Array Color
colors =
    Array.fromList
        [ hex "#333333"
        , hex "#3498db"
        , hex "#22313f"
        , hex "#c0392b"
        , hex "#9b59b6"
        , hex "#f39c12"
        ]


calcColorIndex : Int -> Int
calcColorIndex int =
    remainderBy (Array.length colors) int


getById : Int -> Color
getById int =
    case Array.get (calcColorIndex int) colors of
        Just color ->
            color

        Nothing ->
            hex "ffffff"
