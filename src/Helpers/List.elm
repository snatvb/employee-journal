module Helpers.List exposing (aperture)

import List


aperture : Int -> List a -> List (List a)
aperture chunkSize list =
    if List.length list <= chunkSize then
        [ list ]

    else
      List.take chunkSize list :: aperture chunkSize (List.drop chunkSize list)
