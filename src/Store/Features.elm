module Store.Features exposing (Model, init, update)

import Action exposing (Action)
import Action.Store.Features as FeatureActions
import Structures.Feature exposing (Feature)
import Types.Collection exposing (Collection, empty, insert, remove)


type alias Model =
    Collection Feature


init : Model
init =
    empty


update : FeatureActions.Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        FeatureActions.Add feature ->
            ( insert feature model, Cmd.none )

        FeatureActions.Update id feature ->
            ( Types.Collection.update id feature model, Cmd.none )

        FeatureActions.Remove id ->
            ( remove id model, Cmd.none )
