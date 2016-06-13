module New where

import qualified Data.ByteString.Lazy as L
import Data.List (intercalate)
import Network.HTTP.Conduit (simpleHttp)
import System.Directory
import System.FilePath
import System.Process

data DesertPlugin = DesertPlugin { run :: [String] -> IO () }

new :: DesertPlugin
new = DesertPlugin
       $ \args -> do
         let packageName = head args

         putStrLn $ "Creating new project named " ++ packageName

         alreadyExists <- doesDirectoryExist packageName
         if (not alreadyExists) then createDirectory packageName else return ()

         setCurrentDirectory packageName

         let sourceDir = "src"
             mainFile = "main.ml"
             mainFilePath = sourceDir </> mainFile
             readmeFilePath = "README.md" --File path is filename in current dir

         putStrLn "Creating initial main file"
         createDirectoryIfMissing True sourceDir

         writeFile mainFilePath $ intercalate "\n"
           [ "let _ = Printf.printf \"hello\""
           ]

         putStrLn "Creating README.md file"
         writeFile readmeFilePath $ intercalate "\n"
           ["#" ++ packageName ++ "!"]

         putStrLn "Initialising a git repo"
         _ <- rawSystem "git" ["init"]

         putStrLn "Add git ignore"
         simpleHttp "https://raw.githubusercontent.com/github/gitignore/master/OCaml.gitignore" >>= L.writeFile ".gitignore"

         return ()
