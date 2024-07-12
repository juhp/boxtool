module Create (createCmd) where

import Control.Monad (unless)
--import Data.Maybe (fromMaybe, mapMaybe)
import Data.List.Extra (breakOn, dropSuffix, lower, replace)
import System.FilePath (takeFileName)

import Distrobox
import Podman
import Toolbox

data Distro = ArchLinux | Fedora | RHEL | Ubuntu
            | AlmaLinux | Alpine | AmazonLinux | Centos | Debian | OpenSUSE
            | RockyLinux
  deriving (Eq,Show) -- FIXME remove Show

eitherDistro :: String -> Either String Distro
eitherDistro ds =
  case dropSuffix "linux" (lower ds) of
    "arch" -> Right ArchLinux
    "fedora" -> Right Fedora
    "rhel" -> Right RHEL
    "ubuntu" -> Right Ubuntu
    "alma" -> Right AlmaLinux
    "alpine" -> Right Alpine
    "amazon" -> Right AmazonLinux
    "centos" -> Right Centos
    "debian" -> Right Debian
    "suse" -> Right OpenSUSE
    "opensuse" -> Right OpenSUSE
    "rocky" -> Right RockyLinux
    _ -> Left ds

showDistro :: Distro -> String
showDistro = lower . show

-- rhel is UBI
-- supportedDistros :: [Distro]
-- supportedDistros = [ArchLinux, Fedora, RHEL, Ubuntu]

-- https://quay.io/organization/toolbx-images
-- toolbxImageDistros =
--   [Debian, Ubuntu, Alpine, AlmaLinux, OpenSUSE, RockyLinux, RHEL, ArchLinux,
--    Centos, Fedora, AmazonLinux]

defaultImage :: Distro -> String
defaultImage ArchLinux = "quay.io/toolbx/arch-toolbox"
defaultImage Fedora = "registry.fedoraproject.org/fedora-toolbox"
defaultImage RHEL = "registry.access.redhat.com/ubi9/toolbox"
defaultImage Ubuntu = "quay.io/toolbx/ubuntu-toolbox"
defaultImage distro = toolbxImage distro
  where
    toolbxImage :: Distro -> String
    toolbxImage d = "quay.io/toolbx-images/" ++ showDistro d ++ "-toolbox"

-- support distrobox
createCmd :: Maybe String -> Bool -> Bool -> String -> [String] -> IO ()
createCmd mname nopull _verbose req _args = do
  let (os,tag) = breakOn ":" req
  case eitherDistro os of
    Right distro -> do
      let fullname = defaultImage distro
      -- FIXME only pull if not recent image
      unless nopull $
        podman "pull" [fullname ++ tag]
      let name =
            case mname of
              Nothing -> imgContainer ++ "-toolbox"
              Just n -> n
      -- FIXME catch "toolbox enter output"
      toolbox "create" $ ["-i",fullname ++ tag, name]
    Left distro ->
      distrobox "create" ["-i", distro, "-n", imgContainer ++ "-distrobox"]
  where
    imgContainer = replace ":" "-" (takeFileName req)
{-
shortnamesconf :: String
shortnamesconf = "/etc/containers/registries.conf.d/000-shortnames.conf"

shortToLong :: String -> IO String
shortToLong image =
  -- FIXME: check for hostname, ie '.' before '/'
  if '.' `elem` image && '/' `elem` image
  then return image
  else do
    content <- lines <$> readFile shortnamesconf
    let shortnames = mapMaybe readShortName content
    return $ fromMaybe image $ search image shortnames
  where
    readShortName :: String -> Maybe (String,String)
    readShortName cs =
      case words cs of
        ["[aliases]"] -> Nothing
        ("#":_) -> Nothing
        [short,"=",long] -> Just (read short, read long)
        _ -> error $ "malformed 000-shortnames.conf: " ++ cs

    search :: String -> [(String,String)] -> Maybe String
    search img shortnames =
      case lookup img shortnames of
        Just long -> Just long
        Nothing ->
          case find (\(s,_l) -> img `isInfixOf` s) shortnames of
            Just (_s,l) -> Just l
            Nothing -> Just img
-}

-- distrobox create:
-- podman create --hostname "fedora-38.fedora" --name "fedora-38" --privileged --security-opt label=disable --user root:root --ipc host --network host --pid host --label "manager=distrobox" --env "SHELL=/bin/bash" --env "HOME=/var/home/petersen" --volume /:/run/host:rslave --volume /dev:/dev:rslave --volume /sys:/sys:rslave --volume /tmp:/tmp:rslave --volume "/usr/bin/distrobox-init":/usr/bin/entrypoint:ro --volume "/usr/bin/distrobox-export":/usr/bin/distrobox-export:ro --volume "/usr/bin/distrobox-host-exec":/usr/bin/distrobox-host-exec:ro --volume "/var/home/petersen":"/var/home/petersen":rslave --volume /sys/fs/selinux --volume /var/log/journal --volume /run/user/1000:/run/user/1000:rslave --volume /etc/hosts:/etc/hosts:ro --volume /etc/localtime:/etc/localtime:ro --volume /etc/resolv.conf:/etc/resolv.conf:ro --ulimit host --annotation run.oci.keep_original_groups=1 --mount type=devpts,destination=/dev/pts --userns keep-id --entrypoint /usr/bin/entrypoint fedora:38 -v --name "petersen" --user 1000 --group 1000 --home "/var/home/petersen" --init "0" --nvidia "0" --pre-init-hooks "" --additional-packages "" -- ''
