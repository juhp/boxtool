{-# LANGUAGE CPP, OverloadedStrings #-}

-- SPDX-License-Identifier: MIT

-- module Main (main) where

-- import SimpleCmd (cmd_)
-- import SimpleCmdArgs ( some, simpleCmdArgs, strArg )
-- import System.Linux.Capabilities ()


-- base library
import Control.Applicative (
#if !MIN_VERSION_simple_cmd_args(0,1,4)
  many,
#endif
-- remove with newer simple-cmd-args
#if !MIN_VERSION_base(4,8,0)
  (<$>), (<*>)
#endif
  )
--import Control.Monad (unless, when)
--import Data.Aeson
-- #if MIN_VERSION_aeson(2,0,0)
--import Data.Aeson.Key (fromText)
-- #endif
--import Data.Aeson.Types
--import qualified Data.ByteString.Lazy.Char8 as B
--import Data.Maybe
--import qualified Data.Text as T
import SimpleCmd (cmd_, {-cmd, cmdBool, error',-} needProgram)
import SimpleCmdArgs

import Paths_boxtool (version)

import Create
import Enter

-- FIXME ephemeral vs kept
-- FIXME bind home
-- "https://raw.githubusercontent.com/89luca89/distrobox/${version}/docs/compatibility.md"

main :: IO ()
main = do
  needProgram "podman"
  cmd_ "echo" ["-ne", "\ESC[22;0t"] -- save term title to title stack
  simpleCmdArgs' (Just version) "Interactive container tool" "TBD" $
    subcommands
    [ Subcommand "new"
      "create a new interactive container" $
      createCmd
      <$> optional (strOptionWith 'n' "name" "NAME" "Container name")
      <*> switchWith 'p' "no-pull" "Pull latest image"
      <*> switchWith 'V' "verbose" "output more details"
      <*> strArg "DIST/IMAGE/CONTAINER"
      <*> many (strArg "CMD+ARGs...")
    , Subcommand "run"
      "enter an interactive container" $
      enterCmd
      <$> switchWith 'V' "verbose" "output more details"
      <*> strArg "DIST/IMAGE/CONTAINER"
      <*> many (strArg "CMD+ARGs...")
    -- , Subcommand "temporary"
    --   "start a temporary one-time container" $
    --   temporaryCmd
    ]
  cmd_ "echo" ["-ne", "\ESC[23;0t"] -- restore term title from stack

-- -- TODO exec --privileged ?
-- -- TODO exec --user ?
-- runContainer :: Maybe String -> Bool -> Bool -> String -> [String] -> IO ()
-- runContainer mname pull verbose request args = do
--   needProgram "podman"
--   let givenName = isJust mname
--   mcid <- containerID request
--   case mcid of
--     Just cid -> do
--       when givenName $
--         error' "Cannot specify name for existing container"
--       podman_ verbose "start" ["-ai", cid]
--       let (copts, cargs) = splitCtrArgs args
--       let com = if null cargs then "attach" else "exec"
--       podman_ verbose com $ copts ++ cid : cargs
--       podman_ verbose "stop" [cid]
--     Nothing -> do
--       let image = request
--       putStr image
--       if pull
--         then podman_ verbose "pull" [image]
--         else do
--         haveImage <- imageExists image
--         unless haveImage $
--           podman_ verbose "pull" [image]
--       imageId <- fromMaybe image <$> latestImage image
--       when (imageId /= image) $
--         putStrLn $ " " ++ imageId
--       let (copts, cargs) = splitCtrArgs args
--       case mname of
--         Nothing ->
--           podman_ verbose "run" $ ["--rm", "-it"] ++ copts ++ imageId:cargs
--         Just name -> do
--           com <- if null cargs then imageShell imageId else return args
--           -- TODO create --network --privileged --pull(?)
--           podman_ verbose "create" $
--             ["-it",
--              "--hostname=" ++ name,
--              "--name=" ++ name ++ "-bxtl",
--              "--tz=local",
--              imageId] ++ com
--   where
--     splitCtrArgs :: [String] -> ([String], [String])
--     splitCtrArgs =
--       span (\ a -> a /= "" && head a == '-')

-- podman_ :: Bool -> String -> [String] -> IO ()
-- podman_ verbose c as = do
--   when verbose $
--     putStrLn $! unwords ("podman" : c : as)
--   cmd_ "podman" (c:as)

-- podman :: String -> [String] -> IO String
-- podman c as = cmd "podman" (c:as)

-- -- imageOfContainer :: String -> IO String
-- -- imageOfContainer name =
-- --   podman "ps" ["-a", "--filter", "name=" ++ name, "--format", "{{.Image}}"]

-- imageExists :: String -> IO Bool
-- imageExists name =
--   cmdBool "podman" ["image", "exists", name]

-- -- containerExists :: String -> IO Bool
-- -- containerExists name =
-- --   cmdBool "podman" ["container", "exists", name]

-- containerID ::
--   String ->
--   -- ^ name
--   IO (Maybe String)
--   -- ^ id
-- containerID name =
--   listToMaybe . map head . filter ((== name) . (!! 1)) . filter ((== 2) . length) . map words . lines <$> podman "ps" ["-a", "--format", "{{.ID}}  {{.Names}}", "--filter", "name=" ++ name]

-- imageShell :: String -> IO [String]
-- imageShell name = do
--   cfg <- podman "inspect" [name]
--   -- podman inspect outputs an Array of Object's
--   -- was ContainerConfig
--   let mccmd =
--         case decode (B.pack cfg) of
--           Just [obj] -> lookupKey "Config" obj >>= lookupKey "Cmd"
--           _ -> Nothing
--   return $ fromMaybe ["/usr/bin/bash"] mccmd

-- latestImage :: String -> IO (Maybe String)
-- latestImage name =
--     listToMaybe . lines <$> podman "images" ["--format", "{{.ID}}", name]

-- -- from http-query
-- -- | Look up key in object
-- lookupKey :: FromJSON a => T.Text -> Object -> Maybe a
-- lookupKey k = parseMaybe (.: fromText k)
-- #if !MIN_VERSION_aeson(2,0,0)
--   where
--     fromText :: T.Text -> T.Text
--     fromText = id
-- #endif
