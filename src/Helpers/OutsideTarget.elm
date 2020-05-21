module Helpers.OutsideTarget exposing (outsideTarget)

import Browser.Events
import Json.Decode as Decode


type DomNode
    = RootNode { id : String }
    | ChildNode { id : String, parentNode : DomNode }

domNode : Decode.Decoder DomNode
domNode =
    Decode.oneOf [ childNode, rootNode ]


rootNode : Decode.Decoder DomNode
rootNode =
    Decode.map (\x -> RootNode { id = x })
        (Decode.field "id" Decode.string)


childNode : Decode.Decoder DomNode
childNode =
    Decode.map2 (\id parentNode -> ChildNode { id = id, parentNode = parentNode })
        (Decode.field "id" Decode.string)
        (Decode.field "parentNode" (Decode.lazy (\_ -> domNode)))

isOutsideDropdown : String -> Decode.Decoder Bool
isOutsideDropdown dropdownId =
    Decode.oneOf
        [ Decode.field "id" Decode.string
            |> Decode.andThen
                (\id ->
                    if dropdownId == id then
                        -- found match by id
                        Decode.succeed False

                    else
                        -- try next decoder
                        Decode.fail "continue"
                )
        , Decode.lazy (\_ -> isOutsideDropdown dropdownId |> Decode.field "parentNode")

        -- fallback if all previous decoders failed
        , Decode.succeed True
        ]

outsideTarget : action -> String -> Decode.Decoder action
outsideTarget action dropdownId =
    Decode.field "target" (isOutsideDropdown dropdownId)
        |> Decode.andThen
            (\isOutside ->
                if isOutside then
                    Decode.succeed action

                else
                    Decode.fail "inside dropdown"
            )