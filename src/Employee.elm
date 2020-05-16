module Employee exposing
    ( Employee
    , Employees
    , Id
    , encode
    , encodeEmployees
    , insert
    , remove
    , updateId
    )

import Dict
import Json.Encode as Encoder


type alias Id =
    Int


type alias Employee =
    { id : Id
    , name : String
    , surname : String
    }


type alias Employees =
    Dict.Dict Id Employee


insert : Employees -> Id -> Employee -> Employees
insert employees id employee =
    Dict.insert id employee employees


remove : Employees -> Id -> Employees
remove employees id =
    Dict.remove id employees


updateId : Id -> Employee -> Employee
updateId id employee =
    { employee | id = id }


encode : Employee -> Encoder.Value
encode employee =
    Encoder.object
        [ ( "id", Encoder.int employee.id )
        , ( "name", Encoder.string employee.name )
        , ( "surname", Encoder.string employee.surname )
        ]


encodeDictItem : ( Id, Employee ) -> ( String, Encoder.Value )
encodeDictItem ( id, employee ) =
    ( String.fromInt id, encode employee )


encodeEmployees : Employees -> Encoder.Value
encodeEmployees employees =
    Encoder.object <|
        List.map encodeDictItem <|
            Dict.toList employees
