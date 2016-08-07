module Desert where

import Data.Char

import qualified Desert.New as New
import qualified Desert.Build as Build
import qualified Desert.Test as Test
import qualified Desert.Run as Run
import qualified Desert.Clean as Clean
import Desert.Plugin

newtype Command = Command { unCommand :: String }
newtype CommandArgs = CommandArgs { unCommandArgs :: [String] }

openKeg :: Command -> CommandArgs -> IO ()
openKeg c a = do
  let command = unCommand c
      args = unCommandArgs a
      plugin = case toLower `fmap` command of
                 "new" -> New.plugin
                 "build" -> Build.plugin
                 "test" -> Test.plugin
                 "run" -> Run.plugin
                 "clean" -> Clean.plugin
                 subc -> error $ "not support subcmd " ++ subc ++ " yet"
  run plugin args
