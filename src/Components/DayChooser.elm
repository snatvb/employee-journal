module Components.DayChooser exposing
    ( State
    , initState
    , onDayChoosed
    , render
    )

import Components.Event as Events exposing (Event)
import Css exposing (..)
import Date
import Helpers.DateTime as DateTime
import Helpers.List
import Html.Styled exposing (Attribute, Html, div, text)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import List
import Time exposing (Month(..))


type alias State =
    { currentDate : Date.Date
    , showMonth : Month
    }


initState : Date.Date -> State
initState date =
    { currentDate = date
    , showMonth = Date.month date
    }


type Control action
    = Day (Event (Date.Date -> action))
    | MonthPick (Event (Month -> action))
    | None


type alias Controls action =
    List (Control action)


controlsAsAttributes : (Control action -> Maybe (Attribute action)) -> Controls action -> List (Attribute action)
controlsAsAttributes converter =
    List.filterMap identity
        << List.map converter


dayControlAsAttribute : Date.Date -> Control action -> Maybe (Attribute action)
dayControlAsAttribute date control =
    case control of
        Day event ->
            Events.eventToAttribute date event

        _ ->
            Nothing


dayControlsAsAttributes : Date.Date -> Controls action -> List (Attribute action)
dayControlsAsAttributes date =
    controlsAsAttributes <| dayControlAsAttribute date


onDayChoosed : (Date.Date -> action) -> Control action
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


dateAttributes : Controls action -> Date.Date -> Int -> List (Attribute action)
dateAttributes controls date day =
    List.concat
        [ getDayStyles date day
        , dayControlsAsAttributes (DateTime.updateDay day date) controls
        ]


renderDay : Controls action -> Date.Date -> Int -> Html action
renderDay controls date day =
    div (dateAttributes controls date day) [ text <| dayAsString day ]


renderRow : Controls action -> Date.Date -> List Int -> Html action
renderRow controls date days =
    div [ rowStyles ] <| List.map (renderDay controls date) days


renderDays : Controls action -> Date.Date -> List (Html action)
renderDays controls date =
    List.map (renderRow controls date)
        << Helpers.List.aperture 7
        << List.range 1
    <|
        DateTime.getDaysInDate date


render : Controls action -> State -> Html action
render controls state =
    div [ baseStyles ] <| renderDays controls state.currentDate



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
