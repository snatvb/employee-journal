module Components.Employee exposing (render)

import ComponentSize exposing (Size)
import Components.Avatar as Avatar
import Css exposing (..)
import Employee exposing (Employee)
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
                [ displayFlex
                , flexDirection column
                , alignItems center
                , color (hex "f3f3f3")
                ]
          ]
        ]


employeeToAvatar : Size -> Employee -> Avatar.Avatar
employeeToAvatar size employee =
    { url = Nothing
    , name = employee.name
    , id = employee.id
    , size = size
    }


fontSizeFullName : Size -> Style
fontSizeFullName size =
    case size of
        ComponentSize.Medium ->
            fontSize (px 18)


fullName : Size -> Employee -> Html action
fullName size employee =
    div
        [ css
            [ fontSizeFullName size
            , marginTop (px 10)
            ]
        ]
        [ text <| employee.name ++ " " ++ employee.surname ]


view : Size -> Employee -> Html action
view size employee =
    div (baseStyles size)
        [ Avatar.render <| employeeToAvatar size employee
        , fullName size employee
        ]

render : Employee -> Html action
render employee =
    view ComponentSize.Medium employee
