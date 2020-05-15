module Helpers.Color exposing (getById)

import Css exposing (Color, hex)
import Array

colors : Array.Array Color
colors =
    Array.fromList
        [ hex "333333"
        , hex "333333"
        , hex "333333"
        , hex "333333"
        , hex "333333"
        , hex "333333"
        , hex "333333"
        , hex "333333"
        , hex "333333"
        , hex "333333"
        ]


calcColorIndex : Int -> Int
calcColorIndex int =
    int // Array.length colors


getById : Int -> Color
getById int =
    case Array.get (calcColorIndex int) colors of
        Just color ->
            color

        Nothing ->
            hex "ffffff"