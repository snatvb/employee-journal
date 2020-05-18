module Helpers.DateTime exposing
    ( getDaysInDate
    , getDaysInMonth
    , toString
    , updateDay
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
