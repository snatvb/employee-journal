module Components.Employees exposing (onItemClick, onItemHover, render)

import Components.Employee as EmployeeItem
import Components.Event as Events exposing (Event)
import Css exposing (..)
import Html.Styled exposing (Attribute, Html, div)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick, onMouseEnter)
import List
import Structures.Employee exposing (Employee)


type Control action
    = Item (Event (Employee -> action))
    | None


type alias Controls action =
    List (Control action)


onItemClick : (Employee -> action) -> Control action
onItemClick handler =
    Item (Events.OnClick handler)


onItemHover : (Employee -> action) -> Control action
onItemHover handler =
    Item (Events.OnHover handler)


baseStyles : Attribute action
baseStyles =
    css
        [ displayFlex
        , justifyContent center
        , alignItems center
        , flexWrap wrap
        ]


getItemHoverStyles : Bool -> List Style
getItemHoverStyles needHover =
    if needHover then
        [ backgroundColor (rgba 0 0 0 0.2)
        , cursor pointer
        ]

    else
        []


itemStyles : Bool -> Attribute action
itemStyles needHover =
    css
        [ margin2 (px 0) (px 10)
        , padding (px 10)
        , borderRadius (px 3)
        , hover <| getItemHoverStyles needHover
        ]


clickInControl : Control action -> Bool
clickInControl control =
    case control of
        Item event ->
            Events.isClick event

        _ ->
            False


hasClick : Controls action -> Bool
hasClick controls =
    List.any clickInControl controls


itemControlAsAttribute : Employee -> Control action -> Maybe (Attribute action)
itemControlAsAttribute employee control =
    case control of
        Item event ->
            Events.eventToAttribute employee event

        _ ->
            Nothing


controlsAsAttributes : (Control action -> Maybe (Attribute action)) -> Controls action -> List (Attribute action)
controlsAsAttributes converter =
    List.filterMap identity
        << List.map converter


renderItem : Controls action -> Employee -> Html action
renderItem controls employee =
    div (itemStyles (hasClick controls) :: controlsAsAttributes (itemControlAsAttribute employee) controls)
        [ EmployeeItem.render employee
        ]


renderItems : Controls action -> List Employee -> List (Html action)
renderItems controls =
    List.map (renderItem controls)


render : Controls action -> List Employee -> Html action
render controls employees =
    div [ baseStyles ] <|
        renderItems controls employees
