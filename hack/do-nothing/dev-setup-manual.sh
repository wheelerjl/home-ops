#!/usr/bin/env bash
set -euo pipefail
# Do nothing script inspired by a blog from Dan Slimmon
# https://blog.danslimmon.com/2019/07/15/do-nothing-scripting-the-key-to-gradual-automation/
# This prints out all the steps necessary to setup my local environment in the way I prefer with
# the intention of automating each step in the future.

echoerr() { echo "$@" 1>&2; }
fatal() { echoerr "$@"; exit 1; }
badopt() { echoerr "$@"; help='true'; }
opt() { if [[ -z ${2-} ]]; then badopt "$1 flag must be followed by an argument"; fi; export $1="$2"; }
required_args() { for arg in $@; do if [[ -z "${!arg-}" ]]; then badopt "$arg is a required argument"; fi; done; }

while [[ $# -gt 0 ]]; do
    arg="$1"
    case $arg in
        --help|-h) opt help true; shift;;
        *) shift;;
    esac
done

if [[ -n ${help-} ]]; then
    echoerr "Usage: $0"
    echoerr "    --help"
    exit 1
fi

echo "  Do-Nothing Script Started"
echo ""
echo "  Running apt update and apt upgrade"
sudo apt -qq update
sudo apt-get update
sudo apt -qq install ca-certificates software-properties-common apt-transport-https
sudo add-apt-repository universe
sudo apt upgrade
echo ""
echo ""

echo "  Checking PS1 Configuration"
if grep -q '\\w\\' ~/.bashrc;
then
    echo "  Update PS1 so it only shows the current directory, not the full path to the directory"
    echo "      From within the ~/.bashrc file, change all instances of \\w\\ to \\W\\"
    read -n 1 -s -r -p "  Press any key to continue"
else
    echo "  [X] PS1 Configured"
fi
echo ""

echo "  Checking FiraCode Installation"
if ! command -v $(dpkg -s fonts-firacode) &> /dev/null
then
    echo "  Install VSCode with the following commands"
    echo "      sudo apt install fonts-firacode"
    read -n 1 -s -r -p "  Press any key to continue"
else
    echo "  [X] FiraCode Installed"
fi
echo ""

echo "  Checking NotepadQQ Installation"
if ! command -v notepadqq &> /dev/null
then
    echo "  Documentation: https://notepadqq.com/wp/download/"
    echo "  Install git with the following commands"
    echo "      sudo apt install notepadqq"
    read -n 1 -s -r -p "  Press any key to continue"
else
    echo "  [X] NotepadQQ Installed"
fi
echo ""

echo "  Checking Git Installation"
if ! command -v git &> /dev/null
then
    echo "  Documentation: https://git-scm.com/download/linux"
    echo "  Install git with the following commands"
    echo "      apt-get install git"
    echo "      git config --global url.ssh://git@github.com/.insteadOf https://github.com/"
    echo "      git config --global user.name \"\$GITHUB_USERNAME\" - Substitue \$GITHUB_USERNAME with actual username"
    echo "      git config --global user.email \"\$GITHUB_EMAIL\" - Substitue \$GITHUB_EMAIL with actual email"
    read -n 1 -s -r -p "  Press any key to continue"
    echo "  Add github SSH Key"
    echo "      Documentation: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account"
    echo "      Create Github SSH Key"
    echo "          ssh-keygen -t ed25519 -C \"\$GITHUB_EMAIL\" - Substitue \$GITHUB_EMAIL with actual email"
    echo "          eval \"\$(ssh-agent -s)\""
    echo "          ssh-add ~/.ssh/id_ed25519"
    echo "      Documentation: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account"
    echo "      Copy SSH Key to Github"
    echo "          cat ~/.ssh/id_ed25519.pub"
    echo "          Follow documentation to copy the key to Github"
    read -n 1 -s -r -p "  Press any key to continue"
    echo "  Add git Helper aliases to ~/.bash_aliases"
    echo "      alias main='git checkout main && git pull'"
    echo "      alias push='git push || eval \$(git push 2>&1 | grep \"set-upstream\")'"
    read -n 1 -s -r -p "  Press any key to continue"
    echo "  Add git helper bash function to ~/.bashrc"
    echo "      # Removes any git branches that exist locally but have been deleted from the remote"
    echo "      function prune() {"
    echo "          git remote prune origin"
    echo "          git branch --v | grep \"\[gone\]\" | awk '{print \$1}' | xargs git branch -D"
    echo "      }"
    read -n 1 -s -r -p "  Press any key to continue"
else
    echo "  [X] Git Installed"
fi
echo ""

echo "  Checking VSCode Installation"
if ! command -v code &> /dev/null
then
    echo "  Install VSCode with the following commands"
    echo "      wget -O ~/Downloads/code.deb http://go.microsoft.com/fwlink/?LinkID=760868"
    echo "      sudo apt install ~/Downloads/code.deb"
    echo "      rm -rf ~/Downloads/code.deb"
    read -n 1 -s -r -p "  Press any key to continue"
    echo "  Add VSCode Extensions"
    echo "      Documentation: https://code.visualstudio.com/docs/editor/extension-marketplace#_command-line-extension-management"
    echo "      code --install-extension enkia.tokyo-night"
    echo "      code --install-extension golang.go"
    echo "      code --install-extension PKief.material-icon-theme"
    echo "      code --install-extension eamodio.gitlens"
    read -n 1 -s -r -p "  Press any key to continue"
    echo "  Update VSCode User Settings"
    echo "      Documentation: https://code.visualstudio.com/docs/getstarted/settings#_changing-settingsjson"
    echo "      Update ~/.config/Code/User/settings.json"
    echo "          {"
    echo "             \"workbench.colorTheme\": \"Tokyo Night\","
    echo "             \"workbench.iconTheme\": \"material-icon-theme\","
    echo "             \"workbench.editor.untitled.hint\": \"hidden\","
    echo "             \"editor.fontFamily\": \"Fira Code\","
    echo "             \"editor.fontLigatures\": true,"
    echo "             \"editor.links\": false,"
    echo "             \"redhat.telemetry.enabled\": false,"
    echo "             \"security.workspace.trust.untrustedFiles\": \"open\","
    echo "             \"diffEditor.ignoreTrimWhitespace\": false,"
    echo "          }"
    read -n 1 -s -r -p "  Press any key to continue"
    echo "  Update EDITOR environment variables to use vscode instead of vim (I'm a monster, I know)"
    echo "  Add exports to ~/.bashrc"
    echo "      export EDITOR='code --wait'"
    read -n 1 -s -r -p "  Press any key to continue"
else
    echo "  [X] VSCode Installed"
fi
echo ""

echo "  Checking Terminator Installation"
if ! command -v terminator &> /dev/null
then
    echo "  Install Terminator with the following commands"
    echo "      Documentation: https://github.com/gnome-terminator/terminator/blob/master/INSTALL.md"
    echo "      sudo add-apt-repository ppa:mattrose/terminator"
    echo "      sudo apt-get update"
    echo "      sudo apt install terminator"
    read -n 1 -s -r -p "  Press any key to continue"
    echo "  Update ~/.config/terminator/config"
    echo "      [global_config]"
    echo "        suppress_multiple_term_dialog = True"
    echo "      [keybindings]"
    echo "      [profiles]"
    echo "        [[default]]"
    echo "          cursor_color = \"#aaaaaa\""
    echo "          scrollback_infinite = True"
    echo "          login_shell = True"
    echo "      [layouts]"
    echo "        [[default]]"
    echo "          [[[window0]]]"
    echo "            type = Window"
    echo "            parent = \"\""
    echo "          [[[child1]]]"
    echo "            type = Terminal"
    echo "            parent = window0"
    echo "      [plugins]"
    read -n 1 -s -r -p "  Press any key to continue"
else
    echo "  [X] Terminator Installed"
fi
echo ""

echo "  Checking Github CLI Installation"
if ! command -v gh &> /dev/null
then
    echo "  Documentation: https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
    echo "  Install gh with the following commands"
    echo "      curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg"
    echo "      echo \"deb [arch=\$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main\" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null"
    echo "      sudo apt update"
    echo "      sudo apt install gh"
    read -n 1 -s -r -p "  Press any key to continue"
else
    echo "  [X] Github CLI Installed"
fi
echo ""

echo "  Checking Golang Installation"
if ! command -v go &> /dev/null
then
    echo "  Documentation: https://go.dev/doc/install"
    echo "  Install Golang with the following commands"
    echo "      wget -O ~/Downloads/go1.18.2.linux-amd64.tar.gz https://go.dev/dl/go1.18.2.linux-amd64.tar.gz"
    echo "      sudo rm -rf /usr/local/go"
    echo "      sudo tar -C /usr/local -xzf ~/Downloads/go1.18.2.linux-amd64.tar.gz"
    echo "      rm -rf ~/Downloads/go1.18.2.linux-amd64.tar.gz"
    read -n 1 -s -r -p "  Press any key to continue"
    echo "  Add the following lines to the end of ~/.bashrc"
    echo "      # Golang Environment Variables"
    echo "      export PATH=\$PATH:/usr/local/go/bin"
    echo "      export GOBIN=/home/$USER/workspace/go/bin"
    echo "      export GOPATH=/home/$USER/workspace/go"
    read -n 1 -s -r -p "  Press any key to continue"
    echo "  Add go helper aliases to ~/.bash_aliases"
    echo "      # Ensures no caching set when running tests"
    echo "      alias gotest='go test ./... -count=1'"
    read -n 1 -s -r -p "  Press any key to continue"
else
    echo "  [X] Golang Installed"
fi
echo ""

echo "  Checking Kubectl installation"
if ! command -v kubectl &> /dev/null
then
    echo "  Documentation: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management"
    echo "  Install Kubectl with the following commands"
    echo "      sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg"
    echo "      echo \"deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main\" | sudo tee /etc/apt/sources.list.d/kubernetes.list"
    echo "      sudo apt-get update"
    echo "      sudo apt-get install -y kubectl"
    read -n 1 -s -r -p "  Press any key to continue"
    echo "  Update kubectl config settings"
    echo "  Add the following lines to the end of ~/.bashrc"
    echo "      # Use vscode when editing resources with kubectl"
    echo "      export KUBE_EDITOR='code --wait'"
    read -n 1 -s -r -p "  Press any key to continue"
else
    echo "  [X] Kubectl Installed"
fi
echo ""

echo "  Checking Terraform Installation"
if ! command -v terraform &> /dev/null
then
    echo "  Install Terraform with the following commands"
    echo "      Documentation: https://learn.hashicorp.com/tutorials/terraform/install-cli"
    echo "      curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -"
                # Note focal is hardcoded here instead of the command in the instructions since my linux version is mint and not base ubuntu
    echo "      sudo apt-add-repository \"deb [arch=amd64] https://apt.releases.hashicorp.com focal main"\"
    echo "      sudo apt-get update && sudo apt-get install terraform"
    read -n 1 -s -r -p "  Press any key to continue"
else
    echo "  [X] Terraform Installed"
fi
echo ""

echo "  Checking Helm installation"
if ! command -v helm &> /dev/null
then
    echo "  Documentation: https://helm.sh/docs/intro/install/#from-script"
    echo "  Install Helm with the following commands"
    echo "      curl -Lo ~/Downloads/helm-v3.8.2-linux-amd64.tar.gz https://get.helm.sh/helm-v3.8.2-linux-amd64.tar.gz"
    echo "      tar -zxvf ~/Downloads/helm-v3.8.2-linux-amd64.tar.gz --directory ~/Downloads"
    echo "      sudo mv ~/Downloads/linux-amd64/helm /usr/local/bin/helm"
    echo "      sudo chmod +x /usr/local/bin/helm"
    echo "      rm -rf ~/Downloads/helm-v3.8.2-linux-amd64.tar.gz"
    echo "      rm -rf ~/Downloads/linux-amd64"
    read -n 1 -s -r -p "  Press any key to continue"
else
    echo "  [X] Helm Installed"
fi
echo ""

echo "  Checking Talos installation"
if ! command -v talosctl &> /dev/null
then
    echo "  Documentation: https://www.talos.dev/v1.0/introduction/getting-started/"
    echo "  Install Talos with the following commands"
    echo "      curl -Lo /usr/local/bin/talosctl https://github.com/siderolabs/talos/releases/download/v1.0.4/talosctl-\$(uname -s | tr \"[:upper:]\" \"[:lower:]\")-amd64"
    echo "      chmod +x /usr/local/bin/talosctl"
    read -n 1 -s -r -p "  Press any key to continue"
else
    echo "  [X] Talos Installed"
fi
echo ""

echo "  Checking Docker installation"
if ! command -v docker &> /dev/null
then
    echo "  Documentation: https://docs.docker.com/engine/install/debian/#install-docker-engine"
    echo "  Install Docker with the following commands"
    echo "      sudo apt remove docker docker-engine docker.io containerd runc"
    echo "      sudo apt update"
    echo "      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -"
    echo "      sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable\""
    echo "      sudo apt update"
    echo "      sudo apt install docker-ce docker-ce-cli containerd.io"
    read -n 1 -s -r -p "  Press any key to continue"
    echo "  Enable docker as non-root user"
    echo "      sudo groupadd docker"
    echo "      sudo usermod -aG docker $USER"
    echo "      Note: To run docker as non-root, you must restart machine"
    read -n 1 -s -r -p "  Press any key to continue"
else
    echo "  [X] Docker Installed"
fi
echo ""

echo "  Checking Kind installation"
if ! command -v kind &> /dev/null
then
    echo "  Documentation: https://kind.sigs.k8s.io/docs/user/quick-start/#installing-from-release-binaries"
    echo "  Install Kind with the following commands"
    echo "      curl -Lo /usr/local/bin/kind https://kind.sigs.k8s.io/dl/v0.13.0/kind-linux-amd64"
    echo "      chmod +x /usr/local/bin/kind"
    read -n 1 -s -r -p "  Press any key to continue"
else
    echo "  [X] Kind Installed"
fi
echo ""

echo "  Checking SOPS installation"
if ! command -v sops &> /dev/null
then
    echo "  Documentation: https://github.com/mozilla/sops#11stable-release"
    echo "  Install SOPS with the following commands"
    echo "      sudo curl -Lo /usr/local/bin/sops https://github.com/mozilla/sops/releases/download/v3.7.3/sops-v3.7.3.linux.amd64"
    echo "      sudo chmod +x /usr/local/bin/sops"
    read -n 1 -s -r -p "  Press any key to continue"
else
    echo "  [X] SOPS Installed"
fi
echo ""

echo "  Checking Flux installation"
if ! command -v flux &> /dev/null
then
    echo "  Documentation: https://fluxcd.io/docs/installation/#install-the-flux-cli"
    echo "  Install Flux with the following commands"
    echo "      curl -Lo ~/Downloads/flux_0.30.2_linux_amd64.tar.gz https://github.com/fluxcd/flux2/releases/download/v0.30.2/flux_0.30.2_linux_amd64.tar.gz"
    echo "      tar -zxvf ~/Downloads/flux_0.30.2_linux_amd64.tar.gz --directory ~/Downloads"
    echo "      rm -rf ~/Downloads/flux_0.30.2_linux_amd64.tar.gz"
    echo "      sudo mv ~/Downloads/flux /usr/local/bin/flux"
    echo "      sudo chmod +x /usr/local/bin/flux"
    read -n 1 -s -r -p "  Press any key to continue"
    echo "  Documentation: https://fluxcd.io/docs/cmd/flux_completion_bash/"
    echo "  Setup bash completion by adding the following line to your ~/.bashrc"
    echo "      command -v flux >/dev/null && . <(flux completion bash)"
    read -n 1 -s -r -p "  Press any key to continue"
else
    echo "  [X] Flux Installed"
fi
echo ""

echo "  Checking Age installation"
if ! command -v age &> /dev/null
then
    echo "  Documentation: https://github.com/FiloSottile/age#installation"
    echo "  Install Age with the following commands"
    echo "      curl -Lo ~/Downloads/age-v1.0.0-linux-amd64.tar.gz https://github.com/FiloSottile/age/releases/download/v1.0.0/age-v1.0.0-linux-amd64.tar.gz"
    echo "      tar -zxvf ~/Downloads/age-v1.0.0-linux-amd64.tar.gz --directory ~/Downloads"
    echo "      sudo mv ~/Downloads/age/age /usr/local/bin/age"
    echo "      sudo mv ~/Downloads/age/age-keygen /usr/local/bin/age-keygen"
    echo "      sudo chmod +x /usr/local/bin/age"
    echo "      sudo chmod +x /usr/local/bin/age-keygen"
    echo "      rm -rf ~/Downloads/age"
    echo "      rm -rf ~/Downloads/age-v1.0.0-linux-amd64.tar.gz"
    read -n 1 -s -r -p "  Press any key to continue"
else
    echo "  [X] Age Installed"
fi
echo ""

echo "  Do-Nothing Script Finished"
echo ""
