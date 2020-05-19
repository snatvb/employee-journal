module Action.Views.NewFeature exposing (Action(..), Form(..))

import Date exposing (Date)
import Enum.DayChooseFor exposing (DayChooseFor)


type Action
    = Form Form


type Form
    = UpdateTitle String
    | UpdateDescription String
    | UpdateStartDate Date
    | UpdateEndDate Date
    | UpdatePM String
    | UpdateFO String
    | UpdateDayChooseFor DayChooseFor Date
