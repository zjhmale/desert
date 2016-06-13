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
             testDir = "test"
             mainFilePath = sourceDir </> "main.ml"
             libHeaderFilePath = sourceDir </> "lib.mli"
             libFilePath = sourceDir </> "lib.ml"
             testFilePath = testDir </> "test.ml"
             readmeFilePath = "README.md" --File path is filename in current dir
             tagFilePath = "_tags"

         createDirectoryIfMissing True sourceDir
         createDirectoryIfMissing True testDir

         writeFile mainFilePath $ intercalate "\n"
           ["open Lib",
            "",
            "let _ = Printf.printf \"hello, we get: %s\\n\" (str_of_t (succ (succ one_t)));"
           ]

         writeFile libHeaderFilePath $ intercalate "\n"
           ["type t",
            "",
            "val one_t : t",
            "val succ : t -> t",
            "val str_of_t : t -> string"
           ]

         writeFile libFilePath $ intercalate "\n"
           ["type t = int",
            "",
            "let one_t = 1",
            "let succ i = i+1",
            "let str_of_t = string_of_int"
           ]

         writeFile testFilePath $ intercalate "\n"
           ["open OUnit",
            "open Lib",
            "",
            "let suite = \"OUnit tests...\" >:::  [\"Fix me\" >:: (fun () -> assert_equal \"1\" (str_of_t (succ (succ one_t))))]",
            "",
            "let _ = run_test_tt_main suite"
           ]

         writeFile tagFilePath $ intercalate "\n"
           ["<src/**>: include",
            "<test/**>: include",
            "<test/**>: package(oUnit)"
           ]

         writeFile readmeFilePath $ intercalate "\n"
           ["#" ++ packageName ++ "!"]

         _ <- rawSystem "git" ["init"]

         simpleHttp "https://raw.githubusercontent.com/github/gitignore/master/OCaml.gitignore" >>= L.writeFile ".gitignore"

         return ()
