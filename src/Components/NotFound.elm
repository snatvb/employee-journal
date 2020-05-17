module Components.NotFound exposing (render, renderPageNotFound)

import Css exposing (..)
import Html.Styled exposing (Attribute, Html, div, text)
import Html.Styled.Attributes exposing (css)


baseStyles : Attribute action
baseStyles =
    css
        [ displayFlex
        , flexDirection column
        , alignItems center
        , justifyContent center
        , width (pct 100)
        , height (pct 100)
        ]


title404Styles : Attribute acion
title404Styles =
    css
        [ fontSize (px 48)
        , fontWeight bold
        ]


descriptionStyles : Attribute acion
descriptionStyles =
    css
        [ fontSize (px 24)
        , textAlign center
        ]


addBaseStyles : List (Attribute action) -> List (Attribute action)
addBaseStyles attributes =
    baseStyles :: attributes


render : List (Attribute action) -> List (Html action) -> Html action
render attributes html =
    div (addBaseStyles attributes)
        [ div [ title404Styles ] [ text "404" ]
        , div [ descriptionStyles ] html
        ]


renderPageNotFound : List (Attribute action) -> Html action
renderPageNotFound attributes =
    div (addBaseStyles attributes)
        [ div [ title404Styles ] [ text "404" ]
        , div [ descriptionStyles ] [ text "Page not found" ]
        ]
