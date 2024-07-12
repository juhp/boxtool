module Distrobox (distrobox)
where

import SimpleCmd (cmd_)

distrobox :: String -> [String] -> IO ()
distrobox c args =
  cmd_ "distrobox" $ c : args
