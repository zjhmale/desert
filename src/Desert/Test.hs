module Desert.Test where

import Desert.Plugin (DesertPlugin (..))

import System.Process

plugin :: DesertPlugin
plugin = DesertPlugin $
  \_ -> do
    _ <- rawSystem "./test.native" []
    return ()
