arch-tag: Printf type declarations

\begin{code}
module MissingH.Printf.Types where

import System.IO

data Value =
           ValueInt Int
           | ValueString String
             deriving (Eq, Show)

class PFType a where
    toValue :: a -> Value
    fromValue :: Value -> a

instance PFType Int where
    toValue = ValueInt
    fromValue (ValueInt x) = x
    fromValue _ = error "fromValue int"

instance PFType String where
    toValue = ValueString
    fromValue (ValueString x) = x
    fromValue _ = error "fromValue string"

{-
instance PFType Value where
    toValue = id
    fromValue = id
-}
class PFRun a where
    pfrun :: ([Value] -> String) -> a
instance PFRun String where
    pfrun f = f $ []
instance (PFType a, PFRun b) => PFRun (a -> b) where
    pfrun f x = pfrun (\xs -> f (toValue x : xs))

class IOPFRun a where
    iopfrun :: Handle -> ([Value] -> String) -> a
instance IOPFRun (IO ()) where
    iopfrun h f = hPutStr h $ pfrun f
instance (PFType a, IOPFRun b) => IOPFRun (a -> b) where
    iopfrun h f x = iopfrun h (\xs -> f (toValue x : xs))

-------------------------------------------
-- Begin code from Ian Lynagh

type ConversionFunc = Arg
                   -> [Flag]
                   -> Maybe Width
                   -> Maybe Precision
                   -> String



data Format = Literal String
            | Conversion ConversionFunc
            | CharCount

type ArgNum = Integer
type Arg = String
type Width = Integer
type Precision = String
data Flag = AlternateForm       -- "#"
          | ZeroPadded          -- "0"
          | LeftAdjust          -- "-"
          | BlankPlus           -- " "
          | Plus                -- "+"
          | Thousands           -- "'"
          | AlternativeDigits   -- "I" (ignored)
    deriving (Eq, Show)

xvar :: ArgNum -> String
xvar i = 'x':show i

yvar :: ArgNum -> String
yvar i = 'y':show i

nvar :: ArgNum -> String
nvar i = 'n':show i
\end{code}

