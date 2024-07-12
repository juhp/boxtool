module Enter (enterCmd) where

import Data.List (isSuffixOf)

import Toolbox

enterCmd :: Bool -> String -> [String] -> IO ()
enterCmd _verbose req _args = do
  -- FIXME insert stream for centos
  let name =
        if "-toolbox" `isSuffixOf` req
        then req
        else req ++ "-toolbox"
  toolbox "enter" [name]

-- distrobox enter:
-- podman exec
-- --interactive
-- --detach-keys=""
-- --user="petersen"
-- --tty
-- --workdir="/var/home/petersen"
-- [<see below for --env's>]
-- fedora-38-distrobox
-- sh -c "\$(getent passwd petersen | cut -f 7 -d :) -l"

-- --env "CONTAINER_ID=fedora-38-distrobox"
-- --env "DISTROBOX_ENTER_PATH=/var/home/petersen/bin/distrobox-enter"
-- --env "SESSION_MANAGER=local/unix:@/tmp/.ICE-unix/2164,unix/unix:/tmp/.ICE-unix/2164" --env "COLORTERM=truecolor" --env "VIRSH_DEFAULT_CONNECT_URI=qemu:///system" --env "HISTCONTROL=ignoredups"
-- --env "XDG_MENU_PREFIX=gnome-"
-- --env "HISTSIZE=1000"
-- --env "SSH_AUTH_SOCK=/run/user/1000/keyring/ssh"
-- --env "XMODIFIERS=@im=ibus"
-- --env "DESKTOP_SESSION=gnome"
-- --env "EDITOR=vi"
-- --env "PWD=/var/home/petersen"
-- --env "XDG_SESSION_DESKTOP=gnome"
-- --env "LOGNAME=petersen"
-- --env "XDG_SESSION_TYPE=wayland"
-- --env "SYSTEMD_EXEC_PID=2222"
-- --env "XAUTHORITY=/run/user/1000/.mutter-Xwaylandauth.C1VA51"
-- --env "GDM_LANG=en_SG.UTF-8"
-- --env "USERNAME=petersen"
-- --env "LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;37;41:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:*.m4a=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.oga=01;36:*.opus=01;36:*.spx=01;36:*.xspf=01;36:*~=00;90:*#=00;90:*.bak=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.swp=00;90:*.tmp=00;90:*.dpkg-dist=00;90:*.dpkg-old=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:"
-- --env "XDG_CURRENT_DESKTOP=GNOME"
-- --env "VTE_VERSION=7201"
-- --env "WAYLAND_DISPLAY=wayland-0"
-- --env "TMPDIR=/var/home/petersen/tmp"
-- --env "GNOME_TERMINAL_SCREEN=/org/gnome/Terminal/screen/5c2d4aee_7ae7_40f6_b0ba_5aa603b51969"
-- --env "MOZ_GMP_PATH=/usr/lib64/mozilla/plugins/gmp-gmpopenh264/system-installed"
-- --env "GNOME_SETUP_DISPLAY=:1"
-- --env "NPM_CONFIG_PREFIX=/var/home/petersen/.npm-global"
-- --env "XDG_SESSION_CLASS=user"
-- --env "TERM=xterm-256color"
-- --env "USER=petersen"
-- --env "GIT_PAGER=cat"
-- --env "GNOME_TERMINAL_SERVICE=:1.92"
-- --env "DISPLAY=:0"
-- --env "SHLVL=2"
-- --env "QT_IM_MODULE=ibus"
-- --env "DARCS_PAGER=cat"
-- --env "XDG_RUNTIME_DIR=/run/user/1000"
-- --env "GDMSESSION=gnome"
-- --env "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus"
-- --env "MAIL=/var/spool/mail/petersen"
-- --env "PANGO_LANGUAGE=ja"
-- --env "PATH=/var/home/petersen/bin:/var/home/petersen/.local/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/var/home/petersen/.cabal/bin:/var/home/petersen/.cargo/bin:/var/home/petersen/.local/share/coursier/bin:/sbin:/bin:/var/home/petersen/bin"
-- --env "XDG_DATA_DIRS=/var/home/petersen/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share/:/usr/share/"
-- --env "XDG_CONFIG_DIRS="
