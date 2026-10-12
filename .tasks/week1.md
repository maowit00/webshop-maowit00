# ToDos Week-1

## VPN

- [ ] Setup VPN on HOST machine
  - NOT inside the VM
  - VPN might be useful for stuff other than SWA :\

## GitLab Access

- [ ] Access Request on <https://gitlab.hs-esslingen.de/swa-lab-wise26>

## Virtual Machine

- [ ] Set Up VM

- [ ] Get `.iso` image
  - From Moodle `x86` [Ubuntu2604x86 (other)](https://bwsyncandshare.kit.edu/s/c9Nnr9zmygzRroR)
  - Or from directly from <https://ubuntu.com/download/desktop>
  - arm version already available there!
  - No additional spyware in the Moodle VM, other than whats already installed by Canonical.

- [ ] Get Hypervisor Software
  - [ ] [VMware Workstation Pro](https://www.vmware.com/info/workstation-pro/evaluation)
    - Requires an account. Not for commercial use but very good on windows
    - [Something similar for Mac vmware Fusion and Workstation](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion)
  - [ ] [Microsoft Hyper-V on Windows](https://learn.microsoft.com/windows-server/virtualization/hyper-v/overview)
    - Windows *native hypervisor solution
    - Requires Windows Pro/Education version.
    - Won't work on Home Edition, I think!
  - [ ] [UTM on macos](https://mac.getutm.app/)
    - Recommended
    - [Install UTM via brew](https://formulae.brew.sh/cask/utm)
    - [Install brew if you haven't already :/](https://brew.sh/)
  - [ ] [Qemu for Linux](https://www.qemu.org/)
    - [Support Linux KVM: Kernel Virtual Machine](https://linux-kvm.org/page/Main_Page) pretty much best there is on linux

- [ ] Install OS from `.iso` file
  - Pretty much just clicking next
  - [ ] Setup the keyboard correctly though!!
  - [ ] Remove the iso from the virtual CD/DVD if the virtual machine manager hasn't done that

## Install Some Dev Tools

- [ ] Install some GUIs
  - [ ] vscode

- [ ] Install CLI Tools
  - [ ] git

## Start Bashing Automation

- [ ] [Start Scripting](/.scripts/readme.md)

- [ ] Decide where to put stuff `~/lab` is good place as any.
  - As long as you remember where

## Connection to GitLab (SSH)

- [ ] Setup SSH keys
  - BE COOL! Always use SSH!!
  - [ ] [Create ssh key](/.docs/tutorials/ssh/create-key.md)
  - [ ] [Upload ssh key to gitlab server](https://gitlab.hs-esslingen.de/-/user_settings/ssh_keys)
- [ ] OR use token based authentication
  - WAY LESS COOL! But whatevs :/
  - [ ] [Setup GitLab CLI (glab)](/.docs/tutorials/glab/setup.md)

## Start Cloning

- [ ] clone repo

```console
git clone git@gitlab.hs-esslingen.de:swa-lab-wise26/webshop-maowit00.git
```

## Config Git

- [ ] Config git username/email
  - Check [.scripts/setup/git/config.sh](/.scripts/setup/git/config.sh)

## Testing Commit

- [ ] Create `week1` branch with some commit message

```console
git switch -c week1
```

Use vscode command menu with `Ctrl + Shift + P` and look for create branch.

## Testing Push and Merge

- [ ] Push branch and create merge request
