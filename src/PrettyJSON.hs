module PrettyJSON
  ( renderJValue
  ) where

import Prettify (Doc, (<<), double, series, string, text)
import SimpleJSON

renderJValue :: JValue -> Doc
renderJValue (JBool True) = text "true"
renderJValue (JBool False) = text "false"
renderJValue (JString s) = string s
renderJValue (JNumber n) = double n
renderJValue JNull = text "null"
renderJValue (JObject o) = series '{' '}' field o
  where
    field (name, val) = string name << text ": " << renderJValue val
renderJValue (JArray arr) = series '[' ']' renderJValue arr
