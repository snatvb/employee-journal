module Employee exposing (Employee, Employees, insert, remove, updateId, Id)

import Dict

type alias Id = Int

type alias Employee =
  { id: Id
  ,  name: String
  ,  surname: String
  }

type alias Employees = Dict.Dict Id Employee

insert : Employees -> Id -> Employee -> Employees
insert employees id employee =
  Dict.insert id employee employees

remove : Employees -> Id -> Employees
remove employees id =
  Dict.remove id employees

updateId : Id -> Employee -> Employee
updateId id employee =
  { employee | id = id }
