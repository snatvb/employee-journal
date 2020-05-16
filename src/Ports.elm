port module Ports exposing (saveStore)

import Json.Encode as Encode

port saveStore : Encode.Value -> Cmd action
