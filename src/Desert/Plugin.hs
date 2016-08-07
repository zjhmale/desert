module Desert.Plugin where

data DesertPlugin = DesertPlugin { run :: [String] -> IO () }
