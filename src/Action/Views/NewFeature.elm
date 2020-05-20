module Action.Views.NewFeature exposing (Action(..), Form(..))

import Date exposing (Date)
import Components.DaySelector as DaySelector exposing (ScaleIn)
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
    | UpdateDaySelectorScale DaySelector.Scale
    | UpdateDaySelectorScaleIn ScaleIn
    | UpdateDayChooseFor DayChooseFor Date
