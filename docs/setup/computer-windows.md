# Control computer: Windows

Windows works too. The main differences from [Ubuntu](computer-ubuntu.md):
automation scripts run through **Cygwin** + **Windows Task Scheduler** instead
of cron, and the network drive is mapped as a drive letter (we use `Z:`).

Hardware requirements are the same as for
[Ubuntu](computer-ubuntu.md#hardware).

## Ask your IT department for

- [ ] **MATLAB** (campus license)
- [ ] Join the machine to Active Directory
- [ ] **Map the lab NAS as `Z:`**
- [ ] **Admin rights** for the local user `ratacad1`
- [ ] Firewall: we restrict SSH/rsync/5555–5556 to campus ranges on Ubuntu
      ([see here](computer-ubuntu.md#9-firewall)); ask IT whether Windows Firewall
      should do the same.

## 1. SSH server

Enable the built-in **OpenSSH Server**
([Microsoft instructions](https://learn.microsoft.com/windows-server/administration/openssh/openssh_install_firstuse)).

## 2. Cygwin

Install [Cygwin](https://www.cygwin.com/) to `C:\tools\cygwin` and include the
**rsync** and **git** packages. The scheduled-task `.bat` files launch
`C:\tools\cygwin\bin\mintty.exe`.

## 3. Git and GitHub

Install [Git for Windows](https://git-scm.com/downloads) (includes **Git Bash**),
then create an SSH key and add it to the lab's GitHub machine account. Follow
[GitHub's instructions](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
and choose **Windows**.

## 4. Install Bpod (RatAcad fork)

In **Git Bash**:

```bash
mkdir -p ~/ratacad && cd ~/ratacad
git clone git@github.com:RatAcad/Bpod_Gen2_Legacy.git Bpod_Gen2
cd Bpod_Gen2
git checkout feature/NoGUI
```

1. Right-click MATLAB → **Run as administrator**. **Set Path → Add Folder** →
   `C:\Users\ratacad1\ratacad\Bpod_Gen2`. **Save** and close MATLAB.
2. Open MATLAB normally, run `Bpod` to create the `Bpod Local` folders, then close MATLAB.

## 5. (Optional) Arduino + Teensyduino

Only for firmware updates. Same as on [Ubuntu](computer-ubuntu.md#5-optional-arduino-teensyduino-for-firmware-updates),
but with the Windows installers.

## 6. Anaconda + BpodAcademy

Install [Anaconda](https://www.anaconda.com/download), then see
[BpodAcademy → Install](../software/bpodacademy.md#install).

## 7. Protocols repository

```bash
cd ~/ratacad
git clone git@github.com:RatAcad/ScottLabBpodProtocols.git   # private; use your lab's own repo
```

## 8. Scheduled protocol updates and data transfer

1. Copy the [Windows scripts](../reference/scripts.md#windows) to
   `C:\Users\ratacad1\ratacad\scripts\`: each `.sh` file together with its `.bat` launcher
   (`updateProtocols`, `transferBpodData`, and optionally `transferMiniscopeData`).
2. Open **Task Scheduler → Create Basic Task**.
3. Trigger: **Daily**. Use the same times as on Ubuntu: 08:00 for `updateProtocols.bat`
   and 01:00 for `transferBpodData.bat`.
4. Action: **Start a program** → choose the `.bat` file.
5. Repeat for each script.

!!! note
    The original notes said to copy these scripts from the `ubuntu` folder. On Windows,
    use the files in the **`windows`** folder. They use Cygwin paths
    (`/cygdrive/c/...`, `/cygdrive/z/...`).
