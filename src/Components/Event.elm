module Components.Event exposing
    ( Event(..)
    , eventToAttribute
    , isClick
    )

import Html.Styled exposing (Attribute)
import Html.Styled.Events exposing (onClick, onMouseEnter)


type Event action
    = OnClick action
    | OnHover action
    | None


isClick : Event action -> Bool
isClick event =
    case event of
        OnClick _ ->
            True

        _ ->
            False


eventToAttribute : a -> Event (a -> action) -> Maybe (Attribute action)
eventToAttribute employee event =
    case event of
        OnClick handler ->
            Just <| onClick <| handler employee

        OnHover handler ->
            Just <| onMouseEnter <| handler employee

        _ ->
            Nothing
