module Prettify
  ( 
  Doc,
  string, text, double,
  series, compact,
  (<<)
  ) where

data Doc = Empty
         | Char Char
         | Text String
         | Line
         | Concat Doc Doc
         | Union Doc Doc
  deriving (Show, Eq)

empty :: Doc
empty = Empty

char :: Char -> Doc
char = Char

string :: String -> Doc
string = enclose '"' '"' . hcat . map oneChar

text :: String -> Doc
text "" = Empty
text s = Text s

double :: Double -> Doc
double = Text . show

line :: Doc
line = Line

series :: Char -> Char -> (a -> Doc) -> [a] -> Doc
series open close f = enclose open close . fsep . punctuate (char ',') . map f

compact :: Doc -> String
compact x = transform [x]
  where
    transform [] = ""
    transform (d:ds) = 
      case d of
        Empty -> transform ds
        Char c -> c: transform ds
        Text s -> s ++ transform ds
        Line -> '\n' : transform ds
        a `Concat` b -> transform (a:b:ds)
        _ `Union` b -> transform (b:ds)

-- tool functions
enclose :: Char -> Char -> Doc -> Doc
enclose left right x = char left << x << char right

(<<) :: Doc -> Doc -> Doc
Empty << a = a
a << Empty = a
a << b = a `Concat` b

oneChar :: Char -> Doc
oneChar c = case lookup c simpleEscapes of
              Just r -> text r
              Nothing -> char c

hcat :: [Doc] -> Doc
hcat = foldr (<<) empty

simpleEscapes :: [(Char, String)]
simpleEscapes = zipWith ch "\b\n\f\r\t\\\"/" "bnfrt\\\"/"
  where ch a b = (a, ['\\', b])

punctuate :: Doc -> [Doc] -> [Doc]
punctuate _ [] = []
punctuate _ [a] = [a]
punctuate p (d:ds) = d << p : punctuate p ds

fsep :: [Doc] -> Doc
fsep = foldr (</>) empty 

(</>) :: Doc -> Doc -> Doc
x</>y = x << softline << y

softline :: Doc
softline = group line

group :: Doc -> Doc
group x = flatten x `Union` x

flatten :: Doc -> Doc
flatten (x `Concat` y) = flatten x `Concat` flatten y
flatten Line = Char ' '
flatten (x `Union` _) = flatten x
flatten other = other



