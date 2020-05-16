module Components.Event exposing (Event(..), isClick)


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
