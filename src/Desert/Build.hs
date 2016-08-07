module Desert.Build where

import Desert.Plugin (DesertPlugin (..))

import System.Process

plugin :: DesertPlugin
plugin = DesertPlugin $
  \_ -> do
   mapM_ (\n -> rawSystem "ocamlbuild" ["-use-ocamlfind", "-package", "oUnit", "-package", "core", n ++ ".native"]) ["main", "test"]
   return ()
