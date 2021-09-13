module Idrall.Parser.Rule

import Data.List
import Data.List1

import Text.Parser
import Text.Quantity
import Text.Token
import Text.Lexer
import Text.Bounded

import Idrall.Parser.Lexer

public export
Rule : {state : Type} -> Type -> Type
Rule ty = Grammar state RawToken True ty

public export
EmptyRule : {state : Type} -> Type -> Type
EmptyRule ty = Grammar state RawToken False ty

export
whitespace : Rule ()
whitespace =
  terminal ("Expected whitespace") $
    \case
      White => Just ()
      _ => Nothing

export
tokenW : Grammar state (TokenRawToken) True a -> Grammar state (TokenRawToken) True a
tokenW p = do
  x <- p
  _ <- optional whitespace
  pure x

export
keyword : String -> Rule ()
keyword req =
  terminal ("Expected '" ++ req ++ "'") $
    \case
      Keyword s => if s == req then Just () else Nothing
      _ => Nothing

export
symbol : String -> Rule ()
symbol req =
  terminal ("Expected '" ++ req ++ "'") $
    \case
      Symbol s => if s == req then Just () else Nothing
      _ => Nothing

export
textBoundary : Rule ()
textBoundary =
  terminal "expected \" or ''" $
    \case
      StringBegin _ => Just ()
      StringEnd => Just ()
      _ => Nothing

export
textLit : Rule String
textLit =
  terminal "expected valid Text" $
    \case
      StringLit x => Just x
      _ => Nothing

export
interpBegin : Rule ()
interpBegin =
  terminal "expected ${" $
    \case
      InterpBegin => Just ()
      _ => Nothing

export
interpEnd : Rule ()
interpEnd =
  terminal "expected }" $
    \case
      InterpEnd => Just ()
      _ => Nothing

export
identPart : Rule String
identPart =
  terminal "expected name" $
    \case
      Ident x => Just x
      _ => Nothing

export
embedPath : Rule String
embedPath =
  terminal "expected import path" $
    \case
      FilePath x => Just x
      _ => Nothing

export
naturalLit : Rule Nat
naturalLit =
  terminal "expected natural" $
    \case
      TNatural x => Just x
      _ => Nothing

export
integerLit : Rule Integer
integerLit =
  terminal "expected integer" $
    \case
      TInteger x => Just x
      _ => Nothing

export
doubleLit : Rule Double
doubleLit =
  terminal "expected double" $
    \case
      TDouble x => Just x
      _ => Nothing

export
dottedList : Rule (List1 String)
dottedList = do
  _ <- optional whitespace
  x <- sepBy1 (tokenW $ symbol ".") (identPart)
  pure x

export
builtin : Rule String
builtin =
  terminal "expected builtin" $
    \case
      Builtin x => Just x
      _ => Nothing

export
someBuiltin : Rule ()
someBuiltin =
  terminal "expected builtin" $
    \case
      Builtin "Some" => Just ()
      _ => Nothing

export
endOfInput : Rule ()
endOfInput =
  terminal "expected builtin" $
    \case
      EndInput => Just ()
      _ => Nothing