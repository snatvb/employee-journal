module Components.DaySelector exposing
    ( Handlers
    , Props
    , Scale(..)
    , ScaleIn
    , State
    , initProps
    , initScale
    , initState
    , render
    , updateDate
    , updateScale
    , updateScaleIn
    )

import Css exposing (..)
import Date
import Helpers.DateTime as DateTime exposing (monthAsStringFromDate)
import Helpers.List exposing (aperture, listWrap)
import Html.Styled exposing (Attribute, Html, div, input, text)
import Html.Styled.Attributes exposing (css, value)
import Html.Styled.Events exposing (onClick, onInput)
import List
import Time exposing (Month(..))


type alias ScaleIn =
    ( Scale, Date.Date )


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
    , onScaleIn : Maybe (ScaleIn -> action)
    , onChangeDate : Maybe (Date.Date -> action)
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
    , onScaleIn = Nothing
    , onChangeDate = Nothing
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


updateScaleIn : State -> ScaleIn -> State
updateScaleIn state ( scale, date ) =
    { state | scale = scale, currentDate = date }


updateDate : State -> Date.Date -> State
updateDate state date =
    { state | currentDate = date }


numAsString : Int -> String
numAsString =
    String.pad 2 '0'
        << String.fromInt


isChoosedDay : Date.Date -> Int -> Bool
isChoosedDay date day =
    Date.day date == day


isChoosedMonth : Date.Date -> Int -> Bool
isChoosedMonth date month =
    Date.monthNumber date == month


getDayStyles : Date.Date -> Int -> List (Attribute action)
getDayStyles date day =
    if isChoosedDay date day then
        [ cellStyles, activeCellStyles ]

    else
        [ cellStyles ]


getMonthStyles : Date.Date -> Int -> List (Attribute action)
getMonthStyles date month =
    if isChoosedMonth date month then
        [ cellStyles, activeCellStyles ]

    else
        [ cellStyles ]


unwrapHandler : Maybe (Attribute action) -> List (Attribute action)
unwrapHandler maybeAttributes =
    Maybe.withDefault []
        << Maybe.map listWrap
    <|
        maybeAttributes


dayHandlers : Props action -> Date.Date -> List (Attribute action)
dayHandlers props date =
    unwrapHandler
        << Maybe.map (\x -> onClick (x <| DateTime.clampYear 1970 9999 date))
    <|
        props.handlers.onDateChoosed


monthHandlers : Props action -> Date.Date -> List (Attribute action)
monthHandlers props date =
    unwrapHandler
        << Maybe.map (\x -> onClick (x ( Day, date )))
    <|
        props.handlers.onScaleIn


scaleHandlers : Props action -> Scale -> List (Attribute action)
scaleHandlers props scale =
    unwrapHandler
        << Maybe.map (\x -> onClick (x scale))
    <|
        props.handlers.onScale


inputHandler : (Date.Date -> action) -> Date.Date -> String -> action
inputHandler handler date =
    handler
        << Maybe.withDefault date
        << Maybe.map (\y -> DateTime.updateYear y date)
        << String.toInt
        << String.trim


addInputHandler : Props action -> List (Attribute action) -> List (Attribute action)
addInputHandler props attributes =
    case props.handlers.onChangeDate of
        Just handler ->
            onInput (inputHandler handler props.state.currentDate) :: attributes

        Nothing ->
            attributes


renderMonth : Props action -> Html action
renderMonth props =
    div (scalingStyles :: scaleHandlers props Month) [ text <| monthAsStringFromDate props.state.currentDate ]


renderYear : Props action -> Html action
renderYear ({ state } as props) =
    input
        (addInputHandler props
            [ yearInputStyles
            , value <| String.fromInt <| Date.year state.currentDate
            ]
        )
        []



-- _ ->
--     div (scalingStyles :: scaleHandlers props Year) [ text <| String.fromInt <| Date.year state.currentDate ]


dayAttributes : Props action -> Int -> List (Attribute action)
dayAttributes ({ state } as props) day =
    List.concat
        [ getDayStyles state.currentDate day
        , dayHandlers props <| DateTime.updateDay day state.currentDate
        ]


monthAttributes : Props action -> Int -> List (Attribute action)
monthAttributes ({ state } as props) month =
    List.concat
        [ getMonthStyles state.currentDate month
        , monthHandlers props <| DateTime.updateMonthNumber month state.currentDate
        ]


renderCell : Props action -> Int -> Html action
renderCell props n =
    case props.state.scale of
        Day ->
            div (dayAttributes props n) [ text <| numAsString n ]

        _ ->
            div (monthAttributes props n) [ text <| numAsString n ]


renderRow : Props action -> List Int -> Html action
renderRow props days =
    div [ rowStyles ] <| List.map (renderCell props) days


renderDays : Props action -> List (Html action)
renderDays props =
    List.map (renderRow props)
        << aperture 7
        << List.range 1
    <|
        DateTime.getDaysInDate props.state.currentDate


renderMonthes : Props action -> List (Html action)
renderMonthes props =
    List.map (renderRow props)
        << Helpers.List.aperture 4
        << List.range 1
    <|
        12


renderByScale : Props action -> List (Html action)
renderByScale props =
    case props.state.scale of
        Day ->
            [ renderMonth props
            , div [ gridStyles ] <| renderDays props
            ]

        _ ->
            [ renderYear props
            , div [ gridStyles ] <| renderMonthes props
            ]


render : Props action -> Html action
render props =
    div [ baseStyles ] (renderByScale props)



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


gridStyles : Attribute action
gridStyles =
    css
        [ displayFlex
        , flexDirection column
        , justifyContent center
        , alignItems center
        , minHeight (px 120)
        , minWidth (px 170)
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


cellStyles : Attribute action
cellStyles =
    css
        [ padding (px 5)
        , borderRadius (px 4)
        , cursor pointer
        , hover
            [ backgroundColor (rgba 255 255 255 0.1)
            ]
        ]


activeCellStyles : Attribute action
activeCellStyles =
    css
        [ backgroundColor (hex "#2c3e5090")
        ]


yearInputStyles : Attribute action
yearInputStyles =
    css
        [ backgroundColor (rgba 255 255 255 0.1)
        , border (px 0)
        , outline zero
        , borderRadius (px 4)
        , textAlign center
        , marginBottom (px 4)
        , padding (px 4)
        , focus
            [ backgroundImage <| linearGradient (stop <| rgba 0 0 0 0.15) (stop <| rgba 0 0 0 0) []
            ]
        ]



-- #endregion Styles
