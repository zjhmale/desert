module Build where

import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util

build :: IO ()
build = shakeArgs shakeOptions{shakeFiles="_build"} $ do
    want ["_build/bin/main"]
    want ["_build/bin/test"]

    phony "clean" $ do
        putNormal "Cleaning files in _build"
        removeFilesAfter "_build" ["//*"]

    phony "run" $ do
        cmd "_build/bin/main"

    phony "test" $ do
        cmd "_build/bin/test"

    "_build/bin/main" %> \_ -> do
        cs <- getDirectoryFiles "" ["//*.ml", "//*.mli", "//*.mll", "//*.mly"]
        need cs
        () <- cmd "ocamlbuild -use-ocamlfind main.native"
        () <- cmd "mkdir -p _build/bin"
        cmd "mv main.native _build/bin/main"

    "_build/bin/test" %> \_ -> do
        cs <- getDirectoryFiles "" ["//*.ml", "//*.mli", "//*.mll", "//*.mly"]
        need cs
        () <- cmd "ocamlbuild -use-ocamlfind -package oUnit test.native"
        () <- cmd "mkdir -p _build/bin"
        cmd "mv test.native _build/bin/test"
