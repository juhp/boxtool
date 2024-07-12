module Podman (podman)
where

import SimpleCmd (cmd_)

podman :: String -> [String] -> IO ()
podman c args =
  cmd_ "podman" $ c : args
