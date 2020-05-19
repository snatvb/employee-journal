module Components.DayChooser exposing
    ( State
    , initState
    , onDayChoosed
    , render
    )

import Components.Event as Events exposing (Event)
import Css exposing (..)
import Date
import Enum.DayChooserScale as DayChooserScale exposing (Scale)
import Helpers.DateTime as DateTime exposing (monthAsStringFromDate)
import Helpers.List
import Html.Styled exposing (Attribute, Html, div, text)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import List
import Time exposing (Month(..))


type alias State =
    { currentDate : Date.Date
    , scale : Scale
    }


initState : Date.Date -> State
initState date =
    { currentDate = date
    , scale = DayChooserScale.Day
    }


type alias CallBack action =
    Event (State -> action)


type Control action
    = Day (CallBack action)
    | Month (CallBack action)
    | Year (CallBack action)
    | OnChangeState (Event (State -> action))


type alias Controls action =
    List (Control action)


updateDate : State -> Date.Date -> State
updateDate state date =
    { state | currentDate = date }


controlsAsAttributes : (Control action -> Maybe (Attribute action)) -> Controls action -> List (Attribute action)
controlsAsAttributes converter =
    List.filterMap identity
        << List.map converter


dayControlAsAttribute : State -> Control action -> Maybe (Attribute action)
dayControlAsAttribute state control =
    case control of
        Day event ->
            Events.eventToAttribute state event

        _ ->
            Nothing



-- scallerControlAsAttribute : State -> Control action -> Maybe (Attribute action)
-- scallerControlAsAttribute state control =
--     case control of
--         Day event ->
--             Events.eventToAttribute date event
--         _ ->
--             Nothing


dayControlsAsAttributes : State -> Controls action -> List (Attribute action)
dayControlsAsAttributes =
    controlsAsAttributes << dayControlAsAttribute


onDayChoosed : (State -> action) -> Control action
onDayChoosed handler =
    Day <| Events.OnClick handler


dayAsString : Int -> String
dayAsString =
    String.pad 2 '0'
        << String.fromInt


isChoosedDay : Date.Date -> Int -> Bool
isChoosedDay date day =
    Date.day date == day


getDayStyles : Date.Date -> Int -> List (Attribute action)
getDayStyles date day =
    if isChoosedDay date day then
        [ dayStyles, activeDayStyles ]

    else
        [ dayStyles ]


dateAttributes : Controls action -> State -> Int -> List (Attribute action)
dateAttributes controls state day =
    List.concat
        [ getDayStyles state.currentDate day
        , dayControlsAsAttributes (updateDate state <| DateTime.updateDay day state.currentDate) controls
        ]


renderMonth : Controls action -> Date.Date -> Html action
renderMonth controls date =
    div [ scalingStyles ] [ text <| monthAsStringFromDate date ]


renderYear : Controls action -> Date.Date -> Html action
renderYear controls date =
    div [ scalingStyles ] [ text <| String.fromInt <| Date.year date ]


renderDay : Controls action -> State -> Int -> Html action
renderDay controls state day =
    div (dateAttributes controls state day) [ text <| dayAsString day ]


renderRow : Controls action -> State -> List Int -> Html action
renderRow controls state days =
    div [ rowStyles ] <| List.map (renderDay controls state) days


renderDays : Controls action -> State -> List (Html action)
renderDays controls state =
    List.map (renderRow controls state)
        << Helpers.List.aperture 7
        << List.range 1
    <|
        DateTime.getDaysInDate state.currentDate


renderMonthes : Controls action -> State -> List (Html action)
renderMonthes controls state =
    List.map (renderRow controls state)
        << Helpers.List.aperture 4
        << List.range 1
    <|
        12


renderByScale : Controls action -> State -> List (Html action)
renderByScale controls state =
    case state.scale of
        DayChooserScale.Day ->
            [ renderMonth controls state.currentDate
            , div [] <| renderDays controls state
            ]

        DayChooserScale.Month ->
            [ renderYear controls state.currentDate
            , div [] <| renderMonthes controls state
            ]

        DayChooserScale.Year ->
            [ renderMonth controls state.currentDate
            , div [] <| renderDays controls state
            ]


render : Controls action -> State -> Html action
render controls state =
    div [ baseStyles ] <| renderByScale controls state



-- Styles


baseStyles : Attribute action
baseStyles =
    css
        [ display inlineFlex
        , flexDirection column
        , padding2 (px 5) (px 6)
        , fontSize (em 0.8)
        , backgroundColor (rgba 0 0 0 0.5)
        , borderRadius (px 4)
        , cursor default
        ]


scalingStyles : Attribute action
scalingStyles =
    css
        [ displayFlex
        , justifyContent spaceAround
        , backgroundColor (rgba 255 255 255 0.1)
        , marginBottom (px 4)
        , padding (px 4)
        , borderRadius (px 4)
        , cursor pointer
        , textTransform uppercase
        , hover [ backgroundColor (rgba 255 255 255 0.15) ]
        ]


rowStyles : Attribute action
rowStyles =
    css
        [ displayFlex
        ]


dayStyles : Attribute action
dayStyles =
    css
        [ padding (px 5)
        , borderRadius (px 4)
        , cursor pointer
        , hover
            [ backgroundColor (rgba 255 255 255 0.1)
            ]
        ]


activeDayStyles : Attribute action
activeDayStyles =
    css
        [ backgroundColor (hex "#2c3e5090")
        ]
