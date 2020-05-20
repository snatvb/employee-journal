module Helpers exposing
    ( fixPathInUrl
    , packDocument
    , packModelWithCmd
    , prepareInternalUrlRequest
    )

import Action exposing (Action)
import Browser exposing (Document)
import Html.Styled exposing (Html, toUnstyled)
import Url exposing (Url)


packDocument : String -> Html Action -> Document Action
packDocument title html =
    { title = title
    , body = [ toUnstyled html ]
    }


packModelWithCmd : (m -> pm) -> (a -> m -> ( m, Cmd Action )) -> a -> m -> ( pm, Cmd Action )
packModelWithCmd packer updateFn action model =
    let
        ( updatedModel, cmd ) =
            updateFn action model
    in
    ( packer updatedModel, cmd )


prepareInternalUrlRequest : String -> Url -> Browser.UrlRequest
prepareInternalUrlRequest path url =
    Browser.Internal { url | path = path }


fixPathInUrl : Url -> Url
fixPathInUrl url =
    if String.startsWith "/" url.path then
        url

    else
        { url | path = "/" ++ url.path }
