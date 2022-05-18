## Install packages

```console
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
```

```console
sudo dnf install -y\
    tmux screen tmate terminator sshpass tree wget curl make jq nethogs\
    vim git golang tig awscli docker podman ShellCheck dconf-editor\
    google-chrome-stable uget qbittorrent youtube-dl vlc\
    ffmpeg mkvtoolnix-gui qpdf ImageMagick\
    gstreamer1-plugin-openh264 krb5-workstation krb5-auth-dialog
```

```console
sudo dnf install -y\
    gnome-tweaks\
    gnome-extensions-app\
    gnome-shell-extension-frippery-applications-menu\
    gnome-shell-extension-frippery-panel-favorites\
    gnome-shell-extension-frippery-move-clock\
    gnome-shell-extension-gpaste\
    gnome-shell-extension-netspeed\
    gnome-icon-theme
```

## Update and reboot

```console
dnf update -y
reboot
```

## Install bashrc and vimrc

```console
curl -s -o ~/.bashrc https://raw.githubusercontent.com/iamniting/conf/master/bashrc
curl -s -o ~/.vimrc https://raw.githubusercontent.com/iamniting/conf/master/vimrc
```

## Install fuzzy finder

```console
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

## Create and copy key to the github

```console
ssh-keygen
cat ~/.ssh/id_rsa.pub
```

## Setup git

```console
git config --global core.editor vim
git config --global user.name "Nitin Goyal"
git config --global user.email nigoyal@redhat.com
```

## Setup go env

```console
go env -w GOPROXY="https://proxy.golang.org,direct"
```

## Turn off recent file tracking

```console
gsettings set org.gnome.desktop.privacy remember-recent-files false
```

## Few other tweaks

* [Run docker as a non-root user](https://docs.docker.com/engine/install/linux-postinstall/)

* [Setup Wayland to xorg](https://docs.fedoraproject.org/en-US/quick-docs/configuring-xorg-as-default-gnome-session/)
