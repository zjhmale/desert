module Desert.Clean where

import Desert.Plugin (DesertPlugin (..))

import System.Directory
import Data.String.Utils

plugin :: DesertPlugin
plugin = DesertPlugin $
  \_ -> do
    files <- getDirectoryContents "."
    let compiledFiles = filter (endswith ".o") files
    mapM_ removeFile compiledFiles
    mapM_ removeFile ["main.native", "test.native"]
    removeDirectoryRecursive "_build"
