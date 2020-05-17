module View.NewFeature exposing (Model, init, render, update)

import Action exposing (Action)
import Action.Store
import Action.Store.Features
import Action.Views as ViewsActions
import Action.Views.NewFeature as NewFeatureActions
import Browser exposing (Document)
import Components.Button as Button
import Components.Date as DateComponent
import Components.Input as Input
import Components.Link as Link
import Components.MonthChooser as MonthChooser
import Css exposing (..)
import Date
import Helpers exposing (packDocument, prepareInternalUrlRequest)
import Html.Styled exposing (Attribute, Html, div, text)
import Html.Styled.Attributes exposing (css, href, placeholder, value)
import Html.Styled.Events exposing (onClick, onInput)
import Store exposing (Store)
import Structures.Feature exposing (Feature)
import Time exposing (Month(..))


type alias Model =
    { feautre : Feature
    }


initFeature : Feature
initFeature =
    { title = ""
    , description = ""
    , dateStart = Date.fromCalendarDate 1970 Jan -1
    , dateEnd = Date.fromCalendarDate 1970 Jan 1
    , pm = ""
    , fo = ""
    }


init : ( Model, Cmd Action )
init =
    ( { feautre = initFeature }
    , Cmd.none
    )


updateForm : NewFeatureActions.Form -> Feature -> Feature
updateForm action feature =
    case action of
        NewFeatureActions.UpdateTitle title ->
            { feature | title = title }

        NewFeatureActions.UpdateDescription description ->
            { feature | description = description }

        NewFeatureActions.UpdatePM pm ->
            { feature | pm = pm }

        NewFeatureActions.UpdateFO fo ->
            { feature | fo = fo }


update : NewFeatureActions.Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        NewFeatureActions.Form formAction ->
            ( { model | feautre = updateForm formAction model.feautre }, Cmd.none )


formStyles : Attribute Action
formStyles =
    css
        [ marginRight (px 30)
        ]


row : List (Html Action) -> Html Action
row =
    div [ css [ marginTop (px 10) ] ]


form : Store -> Model -> Html Action
form store model =
    div [ formStyles ]
        [ row [ div [] [ text "Добавление новой фичи" ] ]
        , row [ Input.render [ value model.feautre.title, onInput titleChangeAction, placeholder "Название" ] ]
        , row [ Input.render [ value model.feautre.pm, onInput pmChangeAction, placeholder "Проектный менедржер" ] ]
        , row [ Input.render [ value model.feautre.fo, onInput foChangeAction, placeholder "Фич-овнер" ] ]
        , row
            [ DateComponent.render [] model.feautre.dateStart
            , text " - "
            , DateComponent.render [] model.feautre.dateStart
            ]
        , row
            [ MonthChooser.render [] model.feautre.dateStart
            ]
        , row [ Button.render [] [ text "Сохранить" ] ]
        , row
            [ div []
                [ Link.default [ href "/" ] [ text "Назад" ]
                ]
            ]
        ]


baseStyles : Attribute Action
baseStyles =
    css
        [ displayFlex
        , justifyContent center
        , alignItems center
        , width (pct 100)
        , height (pct 100)
        , paddingTop (px 20)
        ]


view : Store -> Model -> Html Action
view store model =
    div [ baseStyles ]
        [ form store model
        ]


render : Store -> Model -> Document Action
render store model =
    packDocument "Добавление новой фичи" (view store model)



-- actions


titleChangeAction : String -> Action
titleChangeAction =
    Action.Views
        << ViewsActions.NewFeature
        << NewFeatureActions.Form
        << NewFeatureActions.UpdateTitle


descriptionChangeAction : String -> Action
descriptionChangeAction =
    Action.Views
        << ViewsActions.NewFeature
        << NewFeatureActions.Form
        << NewFeatureActions.UpdateDescription


pmChangeAction : String -> Action
pmChangeAction =
    Action.Views
        << ViewsActions.NewFeature
        << NewFeatureActions.Form
        << NewFeatureActions.UpdatePM


foChangeAction : String -> Action
foChangeAction =
    Action.Views
        << ViewsActions.NewFeature
        << NewFeatureActions.Form
        << NewFeatureActions.UpdateFO
