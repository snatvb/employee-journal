module View.NewFeature exposing (Model, init, render, update, subscriptions)

import Action exposing (Action)
import Action.Store
import Action.Store.Features
import Action.Views as ViewsActions
import Action.Views.NewFeature as NewFeatureActions
import Browser exposing (Document)
import Browser.Events
import Components.Button as Button
import Components.Date as DateComponent
import Components.DaySelector as DaySelector
import Components.Input as Input
import Components.Link as Link
import Css exposing (..)
import Date exposing (Date)
import Enum.DayChooseFor exposing (DayChooseFor)
import Helpers exposing (applyTo, packDocument, prepareInternalUrlRequest)
import Helpers.OutsideTarget exposing (outsideTarget)
import Html.Styled exposing (Attribute, Html, div, text)
import Html.Styled.Attributes exposing (css, href, placeholder, value, id)
import Html.Styled.Events exposing (onClick, onInput)
import Store exposing (Store)
import Structures.Feature exposing (Feature)
import Task
import Time exposing (Month(..))


type alias FormModel =
    { feautre : Feature
    , daySelectorState : DaySelector.State
    , dayChooserDisplay : DayChooseFor
    }


type alias Model =
    { form : FormModel
    }


initDate : Date
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
            , dayChooserDisplay = Enum.DayChooseFor.None
            , daySelectorState = DaySelector.initState initFeature.dateStart
            }
      }
    , Task.perform updateDates Date.today
    )

subscriptions : Model -> Sub Action
subscriptions model =
    if model.form.dayChooserDisplay /= Enum.DayChooseFor.None then
        Browser.Events.onMouseDown (outsideTarget hideDaySelectorAction "day-selector")

    else
        Sub.none

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
                , daySelectorState = DaySelector.updateDate formModel.daySelectorState dateStart
            }

        NewFeatureActions.UpdateEndDate dateEnd ->
            { formModel
                | feautre = { feautre | dateEnd = dateEnd }
                , daySelectorState = DaySelector.updateDate formModel.daySelectorState dateEnd
            }

        NewFeatureActions.UpdateDayChooseFor chooseFor date ->
            { formModel
                | dayChooserDisplay = chooseFor
                , daySelectorState = DaySelector.updateDate formModel.daySelectorState date
            }

        NewFeatureActions.UpdateDaySelectorScale scale ->
            { formModel
                | daySelectorState = DaySelector.updateScale formModel.daySelectorState scale
            }

        NewFeatureActions.UpdateDaySelectorScaleIn scaleIn ->
            { formModel
                | daySelectorState = DaySelector.updateScaleIn formModel.daySelectorState scaleIn
            }

        NewFeatureActions.UpdateDaySelectorDate date ->
            { formModel
                | daySelectorState = DaySelector.updateDate formModel.daySelectorState date
            }


update : NewFeatureActions.Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        NewFeatureActions.Form formAction ->
            ( { model | form = updateForm formAction model.form }, Cmd.none )


formStyles : Attribute Action
formStyles =
    css []


rowWithAttrs : List (Attribute Action) -> List (Html Action) -> Html Action
rowWithAttrs attributes =
    div (css [ marginTop (px 10) ] :: attributes)

row : List (Html Action) -> Html Action
row =
    rowWithAttrs []

rowDaySelector : List (Html Action) -> Html Action
rowDaySelector =
    rowWithAttrs [id "day-selector"]


daySelectorProps : DaySelector.State -> (Date -> Action) -> DaySelector.Props Action
daySelectorProps state onDateChoosed =
    { state = state
    , handlers =
        { onScale = Just handleDaySelectorScale
        , onScaleIn = Just handleDaySelectorScaleIn
        , onDateChoosed = Just onDateChoosed
        , onChangeDate = Just handleChangeDate
        }
    }


renderDaySelector : FormModel -> Html Action
renderDaySelector { dayChooserDisplay, daySelectorState } =
    case dayChooserDisplay of
        Enum.DayChooseFor.StartDate ->
            rowDaySelector
                [ DaySelector.render <| daySelectorProps daySelectorState updateStartDate ]

        Enum.DayChooseFor.EndDate ->
            rowDaySelector
                [ DaySelector.render <| daySelectorProps daySelectorState updateEndDate ]

        Enum.DayChooseFor.None ->
            text ""


onSaveAttribute : Store -> Feature -> Attribute Action
onSaveAttribute store feature =
    if String.length feature.title > 2 then
        onClick <| saveAction store feature

    else
        css
            [ opacity (num 0.8)
            , important <| cursor notAllowed
            ]


form : Store -> FormModel -> Html Action
form store ({ feautre } as formModel) =
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
        , renderDaySelector formModel
        , row [ Button.render [ onSaveAttribute store feautre ] [ text "Сохранить" ] ]
        , row
            [ div []
                [ Link.default [ href "/" ] [ text "Назад" ]
                ]
            ]
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


dateStyles : Attribute Action
dateStyles =
    css
        [ display inlineFlex
        , cursor pointer
        , hover
            [ opacity (num 0.8)
            ]
        ]



-- actions


makeAction : NewFeatureActions.Form -> Action
makeAction =
    Action.Views
        << ViewsActions.NewFeature
        << NewFeatureActions.Form


makeUpdateSelectorDayForAction : DayChooseFor -> Date -> Action
makeUpdateSelectorDayForAction dayChooseFor date =
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


saveAction : Store -> Feature -> Action
saveAction store =
    Action.RedirectAfterAction (prepareInternalUrlRequest "/" store.url)
        << Action.Store
        << Action.Store.Features
        << Action.Store.Features.Add


hideDaySelectorAction : Action
hideDaySelectorAction =
    makeUpdateSelectorDayForAction Enum.DayChooseFor.None initDate


handleDaySelectorScale : DaySelector.Scale -> Action
handleDaySelectorScale =
    makeAction
        << NewFeatureActions.UpdateDaySelectorScale


handleDaySelectorScaleIn : DaySelector.ScaleIn -> Action
handleDaySelectorScaleIn =
    makeAction
        << NewFeatureActions.UpdateDaySelectorScaleIn


handleChangeDate : Date -> Action
handleChangeDate =
    makeAction
        << NewFeatureActions.UpdateDaySelectorDate


updateStartDate : Date -> Action
updateStartDate date =
    Action.Batch
        [ makeAction
            << NewFeatureActions.UpdateStartDate
          <|
            date
        , hideDaySelectorAction
        ]


updateDates : Date -> Action
updateDates date =
    Action.Batch <|
        List.map
            (applyTo date)
            [ makeAction << NewFeatureActions.UpdateStartDate
            , makeAction << NewFeatureActions.UpdateEndDate
            ]


updateEndDate : Date -> Action
updateEndDate date =
    Action.Batch
        [ makeAction
            << NewFeatureActions.UpdateEndDate
          <|
            date
        , hideDaySelectorAction
        ]


openChooserStarDate : FormModel -> Action
openChooserStarDate formModel =
    case formModel.dayChooserDisplay of
        Enum.DayChooseFor.StartDate ->
            hideDaySelectorAction

        _ ->
            makeUpdateSelectorDayForAction Enum.DayChooseFor.StartDate formModel.feautre.dateStart


openChooserEndDate : FormModel -> Action
openChooserEndDate formModel =
    case formModel.dayChooserDisplay of
        Enum.DayChooseFor.EndDate ->
            hideDaySelectorAction

        _ ->
            makeUpdateSelectorDayForAction Enum.DayChooseFor.EndDate formModel.feautre.dateEnd
