module System.Console.Interface

%default total

public export
Parser : Type -> Type
Parser a = String -> Maybe a 

public export
data Argument : Type where
  Unique   : {a : Type} -> Parser a -> Argument
  Multiple : {a : Type} -> Parser a -> Argument

public export
argument : Argument -> Type
argument (Unique {a} _)   = a
argument (Multiple {a} _) = List a

public export
data Modifier : Type where
  Flag   : Modifier
  Option : Argument -> Modifier

public export
modifier : Modifier -> Type
modifier Flag       = Bool
modifier (Option a) = argument a

public export
record Interface where
  constructor MkInterface
  commands  : List (String, Interface)
  modifiers : List (String, Modifier)
  arguments : Maybe Argument

public export
data All : (a -> Type) -> (List a -> Type) where
  Nil  : All p []
  (::) : p x -> All p xs -> All {a} p (x :: xs)

public export
data Any : (a -> Type) -> (List a -> Type) where
  Here  : p x -> Any {a} p (x :: xs)
  There : Any p xs -> Any p (x :: xs)

public export
data Value : Interface -> Type where
  Call : All (modifier . snd) (modifiers cli) ->
         maybe () argument (arguments cli) ->
         Value cli
  Sub  : Any (Value . snd) (commands cli) ->
         Value cli
