module Structures.Feature exposing (Feature)

import Date exposing (Date)

type alias Feature =
    { title : String
    , description : String
    , dateStart : Date
    , dateEnd : Date
    , pm : String
    , fo : String
    }
