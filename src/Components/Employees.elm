module Components.Employees exposing (render)

import Components.Employee as EmployeeItem
import Css exposing (..)
import Employee exposing (Employee)
import Html.Styled exposing (Attribute, Html, div, text)
import Html.Styled.Attributes exposing (css)
import List


baseStyles : Attribute action
baseStyles =
    css
        [ displayFlex
        , justifyContent center
        , alignItems center
        , flexWrap wrap
        ]


itemStyles : Attribute action
itemStyles =
    css
        [ margin2 (px 0) (px 10)
        ]


renderItem : Employee -> Html action
renderItem employee =
    div [ itemStyles ]
        [ EmployeeItem.render employee
        ]


render : List Employee -> Html action
render employees =
    div [ baseStyles ] <|
        List.map renderItem employees
