module Desert.Run where

import Desert.Plugin (DesertPlugin (..))

import System.Process

plugin :: DesertPlugin
plugin = DesertPlugin $
  \args -> do
    _ <- rawSystem "./main.native" args
    return ()
