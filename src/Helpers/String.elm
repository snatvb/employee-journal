module Helpers.String exposing (getFirstToAvatar)

import List


getFirstToAvatar : String -> String
getFirstToAvatar str =
    let
        first =
            List.head <|
                String.toList <|
                    String.trim str
    in
    case first of
        Just value ->
            String.toUpper <| String.fromChar value

        Nothing ->
            "#"
