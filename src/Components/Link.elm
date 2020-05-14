module Components.Link exposing (default)

import Css exposing (..)
import Html.Styled exposing (Attribute, Html, a)
import Html.Styled.Attributes exposing (css)
import List


addCustomAttributes : List (Attribute msg) -> List (Attribute msg)
addCustomAttributes attributes =
    List.concat
        [ attributes
        , [ css
                [ color (hex "f3f3f3")
                , visited
                    [ color (hex "f3f3f3")
                    ]
                , hover
                    [ textDecoration none
                    ]
                ]
          ]
        ]


default : List (Attribute msg) -> List (Html msg) -> Html msg
default attributes html =
    a (addCustomAttributes attributes) html
