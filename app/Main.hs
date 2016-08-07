module Main where

import System.Environment (getArgs)
import Desert

main :: IO ()
main = do
  args <- getArgs
  case args of
   (command:otherargs) -> openKeg (Command command) (CommandArgs otherargs)
   _ -> putStrLn "usage: desert <cmd> <args*>"
