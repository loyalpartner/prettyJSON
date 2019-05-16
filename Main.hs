module Main (
  main
) where

import SimpleJSON 
import PutJSON

main :: IO ()
main = putStrLn $ renderJValue students

xiaoming :: JValue
xiaoming = JObject [("name", JString "小明"), ("age", JNumber 12)]

xiaokai :: JValue
xiaokai  = JObject [("name", JString "小凯"), ("age", JNumber 12)]

students :: JValue
students = JArray [xiaoming, xiaokai]
