module View.NewFeature exposing (Model, init, render, update)

import Action exposing (Action)
import Action.Store
import Action.Store.Features
import Action.Views as ViewsActions
import Action.Views.NewFeature as NewFeatureActions
import Browser exposing (Document)
import Components.Button as Button
import Components.Date as DateComponent
import Components.DayChooser as DayChooser exposing (onDayChoosed)
import Components.Input as Input
import Components.Link as Link
import Css exposing (..)
import Date
import Enum.DayChooseFor exposing (DayChooseFor)
import Helpers exposing (packDocument, prepareInternalUrlRequest)
import Html.Styled exposing (Attribute, Html, div, text)
import Html.Styled.Attributes exposing (css, href, placeholder, value)
import Html.Styled.Events exposing (onClick, onInput)
import Store exposing (Store)
import Structures.Feature exposing (Feature)
import Time exposing (Month(..))


type alias FormModel =
    { feautre : Feature
    , dayChooserState : DayChooser.State
    , dayChooserDisplay : DayChooseFor
    }


type alias Model =
    { form : FormModel
    }


initDate : Date.Date
initDate =
    Date.fromCalendarDate 1970 Jan 1


initFeature : Feature
initFeature =
    { title = ""
    , description = ""
    , dateStart = initDate
    , dateEnd = initDate
    , pm = ""
    , fo = ""
    }


init : ( Model, Cmd Action )
init =
    ( { form =
            { feautre = initFeature
            , dayChooserState = DayChooser.initState initFeature.dateStart
            , dayChooserDisplay = Enum.DayChooseFor.None
            }
      }
    , Cmd.none
    )


updateDateInDayCooser : Date.Date -> DayChooser.State -> DayChooser.State
updateDateInDayCooser date state =
    { state | currentDate = date }


updateForm : NewFeatureActions.Form -> FormModel -> FormModel
updateForm action ({ feautre } as formModel) =
    case action of
        NewFeatureActions.UpdateTitle title ->
            { formModel | feautre = { feautre | title = title } }

        NewFeatureActions.UpdateDescription description ->
            { formModel | feautre = { feautre | description = description } }

        NewFeatureActions.UpdatePM pm ->
            { formModel | feautre = { feautre | pm = pm } }

        NewFeatureActions.UpdateFO fo ->
            { formModel | feautre = { feautre | fo = fo } }

        NewFeatureActions.UpdateStartDate dateStart ->
            { formModel
                | feautre = { feautre | dateStart = dateStart }
                , dayChooserState = updateDateInDayCooser dateStart formModel.dayChooserState
            }

        NewFeatureActions.UpdateEndDate dateEnd ->
            { formModel
                | feautre = { feautre | dateEnd = dateEnd }
                , dayChooserState = updateDateInDayCooser dateEnd formModel.dayChooserState
            }

        NewFeatureActions.UpdateDayChooseFor chooseFor date ->
            { formModel
                | dayChooserDisplay = chooseFor
                , dayChooserState = updateDateInDayCooser date formModel.dayChooserState
            }


update : NewFeatureActions.Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        NewFeatureActions.Form formAction ->
            ( { model | form = updateForm formAction model.form }, Cmd.none )


formStyles : Attribute Action
formStyles =
    css
        [ marginRight (px 30)
        ]


row : List (Html Action) -> Html Action
row =
    div [ css [ marginTop (px 10) ] ]


renderChooser : FormModel -> Html Action
renderChooser { dayChooserDisplay, dayChooserState } =
    case dayChooserDisplay of
        Enum.DayChooseFor.StartDate ->
            row
                [ DayChooser.render [ onDayChoosed updateStartDate ] dayChooserState
                ]

        Enum.DayChooseFor.EndDate ->
            row
                [ DayChooser.render [ onDayChoosed updateEndDate ] dayChooserState
                ]

        Enum.DayChooseFor.None ->
            text ""


form : Store -> FormModel -> Html Action
form _ ({ feautre } as formModel) =
    div [ formStyles ]
        [ row [ div [] [ text "Добавление новой фичи" ] ]
        , row [ Input.render [ value feautre.title, onInput titleChangeAction, placeholder "Название" ] ]
        , row [ Input.render [ value feautre.description, onInput descriptionChangeAction, placeholder "Описание" ] ]
        , row [ Input.render [ value feautre.pm, onInput pmChangeAction, placeholder "Проектный менедржер" ] ]
        , row [ Input.render [ value feautre.fo, onInput foChangeAction, placeholder "Фич-овнер" ] ]
        , row
            [ div [ dateStyles ] [ DateComponent.render [ onClick <| openChooserStarDate formModel ] feautre.dateStart ]
            , text " - "
            , div [ dateStyles ] [ DateComponent.render [ onClick <| openChooserEndDate formModel ] feautre.dateEnd ]
            ]
        , renderChooser formModel
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
        [ form store model.form
        ]


render : Store -> Model -> Document Action
render store model =
    packDocument "Добавление новой фичи" (view store model)



-- styles


dateStyles : Attribute Action
dateStyles =
    css
        [ display inlineFlex
        , cursor pointer
        , hover
            [ opacity (num 80)
            ]
        ]



-- actions


makeAction : NewFeatureActions.Form -> Action
makeAction =
    Action.Views
        << ViewsActions.NewFeature
        << NewFeatureActions.Form


makeUpdateChooseDayForAction : DayChooseFor -> Date.Date -> Action
makeUpdateChooseDayForAction dayChooseFor date =
    makeAction (NewFeatureActions.UpdateDayChooseFor dayChooseFor date)


titleChangeAction : String -> Action
titleChangeAction =
    makeAction
        << NewFeatureActions.UpdateTitle


descriptionChangeAction : String -> Action
descriptionChangeAction =
    makeAction
        << NewFeatureActions.UpdateDescription


pmChangeAction : String -> Action
pmChangeAction =
    makeAction
        << NewFeatureActions.UpdatePM


foChangeAction : String -> Action
foChangeAction =
    makeAction
        << NewFeatureActions.UpdateFO


hideDayChooserAction : Action
hideDayChooserAction =
    makeUpdateChooseDayForAction Enum.DayChooseFor.None initDate


updateStartDate : Date.Date -> Action
updateStartDate date =
    Action.Batch
        [ makeAction
            << NewFeatureActions.UpdateStartDate <| date
        , hideDayChooserAction
        ]


updateEndDate : Date.Date -> Action
updateEndDate date =
    Action.Batch
        [ makeAction
            << NewFeatureActions.UpdateEndDate <| date
        , hideDayChooserAction
        ]


openChooserStarDate : FormModel -> Action
openChooserStarDate formModel =
    case formModel.dayChooserDisplay of
        Enum.DayChooseFor.StartDate ->
            hideDayChooserAction

        _ ->
            makeUpdateChooseDayForAction Enum.DayChooseFor.StartDate formModel.feautre.dateStart


openChooserEndDate : FormModel -> Action
openChooserEndDate formModel =
    case formModel.dayChooserDisplay of
        Enum.DayChooseFor.EndDate ->
            hideDayChooserAction

        _ ->
            makeUpdateChooseDayForAction Enum.DayChooseFor.EndDate formModel.feautre.dateEnd
