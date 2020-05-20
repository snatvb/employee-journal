module Components.DaySelector exposing
    ( Props
    , Scale(..)
    , State
    , Handlers
    , initProps
    , initState
    , initScale
    , render
    , updateDate
    , updateScale
    )

import Css exposing (..)
import Date
import Enum.DayChooserScale as DayChooserScale exposing (Scale)
import Helpers.DateTime as DateTime exposing (monthAsStringFromDate)
import Helpers.List exposing (aperture, listWrap)
import Html.Styled exposing (Attribute, Html, div, text)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import List
import Time exposing (Month(..))


type Scale
    = Day
    | Month
    | Year


type alias State =
    { currentDate : Date.Date
    , scale : Scale
    }


type alias Handlers action =
    { onScale : Maybe (Scale -> action)
    , onDateChoosed : Maybe (Date.Date -> action)
    }


type alias Props action =
    { handlers : Handlers action
    , state : State
    }


initScale : Scale
initScale =
    Day


initHandlers : Handlers action
initHandlers =
    { onScale = Nothing
    , onDateChoosed = Nothing
    }


initState : Date.Date -> State
initState date =
    { currentDate = date
    , scale = initScale
    }


initProps : Date.Date -> Props action
initProps date =
    { state = initState date
    , handlers = initHandlers
    }


updateScale : State -> Scale -> State
updateScale state scale =
    { state | scale = scale }


updateDate : State -> Date.Date -> State
updateDate state date =
    { state | currentDate = date }


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


dayHandlers : Props action -> Date.Date -> List (Attribute action)
dayHandlers props date =
    Maybe.withDefault []
        << Maybe.map listWrap
        << Maybe.map (\x -> onClick (x date))
    <|
        props.handlers.onDateChoosed


dayAttributes : Props action -> Int -> List (Attribute action)
dayAttributes ({ state } as props) day =
    List.concat
        [ getDayStyles state.currentDate day
        , dayHandlers props <| DateTime.updateDay day state.currentDate
        ]


renderMonth : Date.Date -> Html action
renderMonth date =
    div [ scalingStyles ] [ text <| monthAsStringFromDate date ]


renderYear : Date.Date -> Html action
renderYear date =
    div [ scalingStyles ] [ text <| String.fromInt <| Date.year date ]


renderDay : Props action -> Int -> Html action
renderDay props day =
    div (dayAttributes props day) [ text <| dayAsString day ]


renderRow : Props action -> List Int -> Html action
renderRow props days =
    div [ rowStyles ] <| List.map (renderDay props) days


renderDays : Props action -> List (Html action)
renderDays props =
    List.map (renderRow props)
        << aperture 7
        << List.range 1
    <|
        DateTime.getDaysInDate props.state.currentDate



-- renderMonthes : Props action -> List (Html action)
-- renderMonthes props =
--     List.map (renderRow props)
--         << Helpers.List.aperture 4
--         << List.range 1
--     <|
--         12
-- renderByScale : Props action -> List (Html action)
-- renderByScale props =
--     case props.scale of
--         Day ->
--             [ renderMonth props.currentDate
--             , div [] <| renderDays props
--             ]
--         Month ->
--             [ renderYear props.currentDate
--             , div [] <| renderMonthes props
--             ]
--         Year ->
--             [ renderMonth props.currentDate
--             , div [] <| renderDays props
--             ]


render : Props action -> Html action
render props =
    div [ baseStyles ]
        [ renderMonth props.state.currentDate
        , div [] <| renderDays props
        ]



-- #region Styles


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



-- #endregion Styles
