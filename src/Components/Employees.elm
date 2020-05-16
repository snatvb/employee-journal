module Components.Employees exposing (onItemClick, onItemHover, render)

import Components.Employee as EmployeeItem
import Components.Event as Events exposing (Event)
import Css exposing (..)
import Employee exposing (Employee)
import Html.Styled exposing (Attribute, Html, div)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick, onMouseEnter)
import List


type Control action
    = Item (Event action)
    | None


type alias Controls action =
    List (Control action)


onItemClick : action -> Control action
onItemClick action =
    Item (Events.OnClick action)


onItemHover : action -> Control action
onItemHover action =
    Item (Events.OnHover action)


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


eventToAttribute : Event action -> Maybe (Attribute action)
eventToAttribute event =
    case event of
        Events.OnClick action ->
            Just <| onClick action

        Events.OnHover action ->
            Just <| onMouseEnter action

        _ ->
            Nothing


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


itemControlAsAttribute : Control action -> Maybe (Attribute action)
itemControlAsAttribute control =
    case control of
        Item event ->
            eventToAttribute event

        _ ->
            Nothing


controlsAsAttributes : (Control action -> Maybe (Attribute action)) -> Controls action -> List (Attribute action)
controlsAsAttributes converter controls =
    List.filterMap identity
        << List.map converter
    <|
        controls


renderItem : Controls action -> Employee -> Html action
renderItem controls employee =
    div (itemStyles (hasClick controls) :: controlsAsAttributes itemControlAsAttribute controls)
        [ EmployeeItem.render employee
        ]


renderItems : Controls action -> List Employee -> List (Html action)
renderItems controls =
    List.map (renderItem controls)


render : Controls action -> List Employee -> Html action
render controls employees =
    div [ baseStyles ] <|
        renderItems controls employees
