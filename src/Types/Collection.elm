module Types.Collection exposing
    ( Collection
    , empty
    , getId
    , insert
    , remove
    , toItem
    , unwrap
    , update
    , encode
    )

import Dict
import Json.Encode as Encoder


type CollectionItem v
    = CollectionItem Int v


type alias CollectionItems v =
    Dict.Dict Int (CollectionItem v)


type alias CollectionStructure v =
    { nextId : Int
    , items : CollectionItems v
    }


type Collection v
    = Collection (CollectionStructure v)


toItem : Int -> v -> CollectionItem v
toItem id v =
    CollectionItem id v


insertInItems : Int -> v -> CollectionItems v -> CollectionItems v
insertInItems id value items =
    Dict.insert id (toItem id value) items


insert : v -> Collection v -> Collection v
insert newValue (Collection collection) =
    Collection
        { nextId = collection.nextId + 1
        , items = insertInItems collection.nextId newValue collection.items
        }


update : Int -> v -> Collection v -> Collection v
update id newValue (Collection collection) =
    Collection
        { collection
            | items = Dict.insert id (toItem id newValue) collection.items
        }


remove : Int -> Collection v -> Collection v
remove id (Collection collection) =
    Collection
        { collection
            | items = Dict.remove id collection.items
        }


unwrap : CollectionItem v -> v
unwrap (CollectionItem _ value) =
    value


empty : Collection v
empty =
    Collection
        { nextId = 0
        , items = Dict.empty
        }


getId : CollectionItem v -> Int
getId (CollectionItem id _) =
    id


encodeItem : (v -> Encoder.Value) -> (Int, CollectionItem v) -> ( String, Encoder.Value )
encodeItem encoder (_, (CollectionItem id value)) =
    ( String.fromInt id, encoder value )


encodeItems : (v -> Encoder.Value) -> CollectionItems v -> Encoder.Value
encodeItems encoder items =
    Encoder.object
        << List.map (encodeItem encoder)
        << Dict.toList
    <|
        items


encode : (v -> Encoder.Value) -> Collection v -> Encoder.Value
encode encoder (Collection collection) =
    Encoder.object
        [ ( "nextId", Encoder.int collection.nextId )
        , ( "items", encodeItems encoder collection.items )
        ]
