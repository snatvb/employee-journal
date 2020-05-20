module Helpers.DateTime exposing
    ( clampYear
    , getDaysInDate
    , getDaysInMonth
    , monthAsString
    , monthAsStringFromDate
    , toString
    , updateDay
    , updateMonth
    , updateMonthNumber
    , updateYear
    )

import Date
import Time exposing (Month(..))


asTextWithPad : (Date.Date -> Int) -> Date.Date -> String
asTextWithPad converter date =
    String.pad 2 '0'
        << String.fromInt
    <|
        converter date


toString : Date.Date -> String
toString date =
    asTextWithPad Date.day date
        ++ "."
        ++ asTextWithPad Date.monthNumber date
        ++ "."
        ++ asTextWithPad Date.year date


getDaysInFeb : Int -> Int
getDaysInFeb year =
    if year // 4 == 0 then
        29

    else
        28


getDaysInMonth : Month -> Int -> Int
getDaysInMonth month year =
    case month of
        Jan ->
            31

        Feb ->
            getDaysInFeb year

        Mar ->
            31

        Apr ->
            30

        May ->
            31

        Jun ->
            30

        Jul ->
            31

        Aug ->
            31

        Sep ->
            30

        Oct ->
            31

        Nov ->
            30

        Dec ->
            31


monthAsString : Month -> String
monthAsString month =
    case month of
        Jan ->
            "январь"

        Feb ->
            "февраль"

        Mar ->
            "март"

        Apr ->
            "апрель"

        May ->
            "май"

        Jun ->
            "июнь"

        Jul ->
            "июль"

        Aug ->
            "август"

        Sep ->
            "сентябрь"

        Oct ->
            "октябрь"

        Nov ->
            "ноябрь"

        Dec ->
            "декабрь"


monthAsStringFromDate : Date.Date -> String
monthAsStringFromDate =
    monthAsString << Date.month


getDaysInDate : Date.Date -> Int
getDaysInDate date =
    getDaysInMonth
        (Date.month date)
        (Date.year date)


updateDay : Int -> Date.Date -> Date.Date
updateDay day date =
    Date.fromCalendarDate
        (Date.year date)
        (Date.month date)
        day


updateMonth : Month -> Date.Date -> Date.Date
updateMonth month date =
    Date.fromCalendarDate
        (Date.year date)
        month
        (Date.day date)


updateMonthNumber : Int -> Date.Date -> Date.Date
updateMonthNumber month date =
    Date.fromCalendarDate
        (Date.year date)
        (Date.numberToMonth month)
        (Date.day date)


updateYear : Int -> Date.Date -> Date.Date
updateYear year date =
    Date.fromCalendarDate
        year
        (Date.month date)
        (Date.day date)


clampYear : Int -> Int -> Date.Date -> Date.Date
clampYear min max date =
    updateYear (clamp min max <| Date.year date) date
