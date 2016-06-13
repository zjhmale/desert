module Main where

import New
import Build
import Data.List (intercalate)
import Data.Char
import System.Environment (getArgs)

newtype Command = Command { unCommand :: String }
newtype CommandArgs = CommandArgs { unCommandArgs :: [String] }

runPlugin :: Command -> CommandArgs -> IO ()
runPlugin c a = do
  let command = unCommand c
      args = unCommandArgs a
      plugin = case toLower `fmap` command of
        "new" -> new
        p -> error $ "not support plugin: " ++ p

  putStrLn $ "Calling " ++ command ++ " with [" ++ intercalate " " args ++ "]."
  run plugin args

main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> build
    [cmd] | cmd `elem` ["clean", "run", "test"] -> build
    (command:otherargs) -> runPlugin (Command command)
                                    (CommandArgs otherargs)

