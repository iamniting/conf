#### Enable rpmfusion repo
```console
sudo dnf install -y \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
```

#### Install packages
```console
sudo dnf install -y \
    awscli \
    curl \
    docker \
    dconf-editor \
    ffmpeg \
    ffmpegthumbnailer \
    git \
    golang \
    google-chrome-stable \
    grpcurl \
    gstreamer1-plugin-openh264 \
    ImageMagick \
    jq \
    libavcodec-freeworld \
    make \
    mkvtoolnix-gui \
    neovim \
    nethogs \
    openh264 \
    podman \
    python3-mutagen \
    qbittorrent \
    qpdf \
    screen \
    ShellCheck \
    sshpass \
    terminator \
    tig \
    tmate \
    tmux \
    tree \
    uget \
    vim \
    vlc \
    wget \
    youtube-dl \
    yq
```

#### Install extensions
```console
sudo dnf install -y \
    gnome-tweaks \
    gnome-icon-theme \
    gnome-extensions-app \
    gnome-shell-extension-gpaste \
    gnome-shell-extension-window-list \
    gnome-shell-extension-frippery-move-clock \
    gnome-shell-extension-frippery-panel-favorites \
    gnome-shell-extension-frippery-applications-menu
```

#### Update packages
```console
sudo dnf update -y
```

#### Install bashrc and vimrc
```console
curl -s -o ~/.bashrc https://raw.githubusercontent.com/iamniting/conf/master/bashrc
curl -s -o ~/.vimrc https://raw.githubusercontent.com/iamniting/conf/master/vimrc
```

#### Install fuzzy finder
```console
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

#### Create and copy key to the github
```console
ssh-keygen
cat ~/.ssh/id_rsa.pub
```

#### Setup git
```console
git config --global core.editor vim
git config --global user.name "Nitin Goyal"
git config --global user.email nigoyal@redhat.com
```

#### Clone and copy executables to local bin
```console
mkdir -p ~/code
cd ~/code && git clone git@github.com:iamniting/conf.git

cd ~/code/conf/
mkdir -p ~/.local/bin
find . -type f -exec grep -l '#!/bin/bash' {} \; -exec cp -i {} ~/.local/bin/ \;
```

#### Setup go env
```console
go env -w GOPROXY="https://proxy.golang.org,direct"
```

#### Turn off recent files in file manager
```console
gsettings set org.gnome.desktop.privacy remember-recent-files false
```

#### Few other tweaks
* [Run docker as a non-root user](https://docs.docker.com/engine/install/linux-postinstall/)
* [Setup wayland to xorg](https://docs.fedoraproject.org/en-US/quick-docs/configuring-xorg-as-default-gnome-session/)
