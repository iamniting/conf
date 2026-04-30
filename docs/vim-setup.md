#### Install required packages
```console
sudo dnf install -y vim git go
sudo curl -s -o /etc/yum.repos.d/yarn.repo https://dl.yarnpkg.com/rpm/yarn.repo
sudo dnf install -y yarn
sudo rm -rf /etc/yum.repos.d/yarn.repo
```

#### Download .vimrc
```console
curl -s -o ~/.vimrc https://raw.githubusercontent.com/iamniting/conf/master/vimrc
```

#### Download vim and neovim plug
```console
curl --create-dirs -s -o ~/.vim/autoload/plug.vim \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

curl --create-dirs -s -o ~/.local/share/nvim/site/autoload/plug.vim \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

#### Install plugins and go binaries
```console
vim +PlugInstall
vim +GoInstallBinaries
ls -la $GOPATH/bin
```

#### Install coc plugins inside vim
```console
:CocInfo
:CocInstall coc-python coc-json coc-go
:CocConfig
```

#### Add below config for go in CocConfig
```console
vim ~/.vim/coc-settings.json

{
  "languageserver": {
    "golang": {
      "command": "/root/code/go/bin/gopls",
      "rootPatterns": ["go.mod", ".vim/", ".git/", ".hg/"],
      "filetypes": ["go"]
    }
  }
}
```

#### Setup vim to work with python
```console
pip install jedi -U
sudo dnf install python3-jedi
:CocCommand python.setInterpreter
:CocCommand python.setLinter
```
