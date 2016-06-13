module Main where

import New
import Build
import           Data.List                   (intercalate, stripPrefix)
import           Data.Char
import System.Environment (getArgs)

newtype Command = Command { unCommand :: String }
newtype CommandArgs = CommandArgs { unCommandArgs :: [String] }

openKeg :: Command -> CommandArgs -> IO ()
openKeg c a = do

  let command  = unCommand c
      args     = unCommandArgs a

  let plugin = case toLower `fmap` command of
        "new" -> new

  putStrLn $ "Calling " ++ command ++ " with [" ++ intercalate " " args ++ "]."

  run plugin args

main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> build
    ["clean"] -> build
    ["run"] -> build
    ["test"] -> build
    (command:otherargs) -> openKeg
                            (Command command)
                            (CommandArgs otherargs)

