module Main (
  main
) where

import SimpleJSON 
import PrettyJSON (renderJValue)
import Prettify (compact, pretty)
-- import PutJSON

main :: IO ()
-- main = putStrLn $ renderJValue students
main = putStrLn $ pretty 5 $ renderJValue students

xiaoming :: JValue
xiaoming = JObject [("name", JString "小明"), ("age", JNumber 12)]

xiaokai :: JValue
xiaokai  = JObject [("name", JString "小凯"), ("age", JNumber 12)]

students :: JValue
students = JArray [xiaoming, xiaokai]
