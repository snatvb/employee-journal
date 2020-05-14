module Employee exposing (..)

import Dict

type alias Id = Int

type alias Employee =
  { id: Id
  ,  name: String
  ,  surname: String
  }

type alias Employees = Dict.Dict Id Employee

add : Employees -> Id -> Employee -> Employees
add employees id employee =
  Dict.insert id employee employees

remove : Employees -> Id -> Employees
remove employees id =
  Dict.remove id employees