module PutJSON (
  renderJValue
) where


import SimpleJSON
import           Data.List

renderJValue :: JValue -> String
renderJValue (JString s) = surround '"' '"' s
renderJValue (JNumber n) = show n
renderJValue (JBool True) = show "true"
renderJValue (JBool False) = show "false"
renderJValue JNull = show "null"

renderJValue (JObject o) = "{" ++ pairs o  ++ "}"
  where pairs [] = ""
        pairs ps  = intercalate ", " (map renderPair ps)
        renderPair (k, v)  = show k ++ ":" ++ renderJValue v

renderJValue (JArray a) = "[" ++ pairs a  ++ "]"
  where pairs [] = ""
        pairs ps = intercalate ", " (map renderJValue ps)

surround :: a -> a -> [a] -> [a]
surround left right s = left:s ++ [right]
