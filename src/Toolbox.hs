module Toolbox (toolbox)
where

import SimpleCmd (cmd_)

toolbox :: String -> [String] -> IO ()
toolbox c args =
  cmd_ "toolbox" $ c : args
