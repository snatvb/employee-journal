module Helpers.Color exposing (getById)

import Array
import Css exposing (Color, hex)

defaultColor : Color
defaultColor = hex "#333333"

colors : Array.Array Color
colors =
    Array.fromList
        [ defaultColor
        , hex "#3498db"
        , hex "#2c3e50"
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
            defaultColor
