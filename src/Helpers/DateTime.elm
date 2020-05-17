module Helpers.DateTime exposing (toString)

import Date


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
