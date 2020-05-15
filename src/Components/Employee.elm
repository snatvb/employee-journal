module Components.Employee exposing (render)

import Array
import ComponentSize exposing (Size)
import Components.Avatar as Avatar
import Css exposing (..)
import Employee exposing (Employee)
import Helpers.Color
import Helpers.String
import Html.Styled exposing (Attribute, Html, div, text)
import Html.Styled.Attributes exposing (css)


getBaseStylesBySize : Size -> List (Attribute action)
getBaseStylesBySize size =
    case size of
        ComponentSize.Medium ->
            [ css
                [ fontSize (px 14) ]
            ]


baseStyles : Size -> List (Attribute action)
baseStyles size =
    List.concat
        [ getBaseStylesBySize size
        , [ css
                [ color (hex "f3f3f3")
                ]
          ]
        ]


employeeToAvatar : Employee -> Avatar.Avatar
employeeToAvatar employee =
    { url = Nothing
    , name = employee.name
    , id = employee.id
    }


render : Size -> Employee -> Html action
render size employee =
    div (baseStyles size)
        [ Avatar.render <| employeeToAvatar employee
        ]
