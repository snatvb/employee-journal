module Selectors.Store.Employee exposing (get)

import Dict
import Store exposing (Store)
import Structures.Employee exposing (Employee)

get : Int -> Store -> Maybe Employee
get id store =
  Dict.get id store.employees.items
