module Store.Features exposing (Model, update, init)

import Action.Store.Features as FeatureActions
import Structures.Feature exposing (Feature)
import Types.Collection exposing (Collection, insert, remove, empty)


type alias Model =
    Collection Feature

init : Model
init =
  empty

update : FeatureActions.Action -> Model -> Model
update action model =
    case action of
        FeatureActions.Add feature ->
            insert feature model

        FeatureActions.Update id feature ->
            Types.Collection.update id feature model

        FeatureActions.Remove id ->
            remove id model
