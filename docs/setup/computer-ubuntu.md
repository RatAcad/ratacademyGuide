# Control computer: Ubuntu (recommended)

One control computer runs many boxes. It runs MATLAB plus one headless Bpod
instance per box, all managed by [BpodAcademy](../software/bpodacademy.md). Each night
it copies the data to network storage.

## Hardware

Plan per Bpod/box and size up from there:

| Resource | Rule of thumb | Our first machine |
|---|---|---|
| CPU | ~2 cores per Bpod | ≥ 8 cores / 16 threads |
| RAM | ~2–3 GB per Bpod | ≥ 32 GB |
| System disk | | 2 × 1 TB SSD, RAID 1 (mirrored) |
| GPU | minimal | on-board graphics or an entry-level card (e.g. NVIDIA Quadro P400) |
| USB | 1 port per Bpod (+ cameras) | use powered USB hubs if needed |

## Ask your IT department for

- [ ] **Ubuntu 22.04 LTS**
- [ ] **MATLAB** (a campus license is fine; check the
      [MATLAB version supported by Bpod](https://sanworks.github.io/Bpod_Wiki/))
- [ ] Join the machine to your directory service (Active Directory/LDAP) if
      your institution requires it
- [ ] **Mount the lab network drive (NAS) at login** through `/etc/fstab`. Nightly data
      transfer goes there. (At BU this is mounted at `/ad/eng/research/eng_research_scottlab`.)
- [ ] A local **`ratacad1`** user (or similar) in the `sudo` group. This guide
      assumes the username `ratacad1` and the home directory `/home/ratacad1`.
- [ ] Keep the machine **off the public internet**. A host firewall (`ufw`)
      should allow these from campus IP ranges only:
    - SSH (port 22)
    - rsync (port 873)
    - TCP **5555 and 5556** (BpodAcademy remote connections)

## 1. Update and switch to a low-latency kernel

```bash
sudo apt update
sudo apt upgrade
sudo apt install linux-lowlatency-hwe-22.04
sudo reboot
```

!!! note
    The original lab notes used `linux-lowlatency-hwe-18.04`, from when the machines
    ran Ubuntu 18.04. Use the package that matches your Ubuntu release
    (`apt search linux-lowlatency`).

## 2. Enable SSH

```bash
sudo apt update
sudo apt install openssh-server
sudo systemctl status ssh   # should say "active (running)"
```

## 3. Git and GitHub access

```bash
sudo apt install git
```

Create an SSH key for the machine and add it to a GitHub account that can read
the RatAcad repositories (and your private protocol repository). Follow
[GitHub: Generating a new SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
and choose the **Linux** instructions.

!!! warning "Use a lab machine account and SSH keys"
    Use a shared lab GitHub account for the rig computers (ours is `ratacad1`). Keep
    its password in your lab's password manager. **Never write it in this guide or in
    lab docs.** Day-to-day access should use SSH keys only.

## 4. Install Bpod (RatAcad fork)

```bash
mkdir -p ~/ratacad && cd ~/ratacad
git clone git@github.com:RatAcad/Bpod_Gen2_Legacy.git Bpod_Gen2
cd Bpod_Gen2
git checkout feature/NoGUI
```

1. Open MATLAB **as admin** (`sudo matlab`), then **Set Path → Add Folder** and select
   `~/ratacad/Bpod_Gen2`. **Save** and close MATLAB without running anything.
2. Open MATLAB **normally** (`matlab`, no sudo) and run `Bpod`. This creates
   the `Bpod Local` folders (Calibration, Data, Protocols, Settings …) inside `~/ratacad/`.
   Then close MATLAB.

See [Bpod (RatAcad fork)](../software/bpod.md) for which fork to use and how it
differs from upstream Sanworks Bpod.

## 5. (Optional) Arduino + Teensyduino for firmware updates

Only needed to reflash Bpod firmware.

```bash
cd ~/Downloads
tar -xvf arduino-x.x.x-linux64.tar.xz
mv ~/Downloads/arduino-x.x.x ~
cd ~/arduino-x.x.x && sudo ./install.sh

cd ~/Downloads
chmod +x TeensyduinoInstall.linux64
./TeensyduinoInstall.linux64      # install into ~/arduino-x.x.x
```

Use an Arduino version that Teensyduino supports, and apply any Bpod-specific
library changes described on the
[Bpod wiki](https://sanworks.github.io/Bpod_Wiki/).

## 6. Install Anaconda and BpodAcademy

Install [Anaconda or Miniconda](https://www.anaconda.com/download), then follow
[BpodAcademy → Install](../software/bpodacademy.md#install).

## 7. Clone your protocols repository

```bash
cd ~/ratacad
git clone git@github.com:RatAcad/ScottLabBpodProtocols.git   # private; use your lab's own repo
```

See [Protocols](../software/protocols.md).

## 8. Automate protocol updates and data transfer

Copy the [Ubuntu scripts](../reference/scripts.md#ubuntu) to `~/ratacad/scripts/`,
make them executable and register them with `cron`:

```bash
mkdir -p ~/ratacad/scripts
# copy updateProtocols.sh, transferBpodData.sh, updateBpodAcademy.sh here
chmod +x ~/ratacad/scripts/*.sh
crontab -e
```

Add the following to the end of the crontab:

```cron
0 8 * * * ~/ratacad/scripts/updateProtocols.sh     # 08:00 pull protocols from GitHub
0 1 * * * ~/ratacad/scripts/transferBpodData.sh    # 01:00 copy data to the NAS
```

## 9. Firewall

Replace the CIDR ranges with your campus networks. At BU these are four campus
ranges plus `10.0.0.0/8`; ask your IT department for yours.

```bash
for NET in <CAMPUS_CIDR_1> <CAMPUS_CIDR_2> 10.0.0.0/8; do
  sudo ufw allow from $NET to any port 22                    # SSH
  sudo ufw allow from $NET to any port 873                   # rsync
  sudo ufw allow from $NET to any port 5555,5556 proto tcp   # BpodAcademy remote
done
sudo ufw enable
sudo ufw status numbered
```

## Done? Check:

- [ ] `matlab` opens and `Bpod` starts without errors (with a Bpod plugged in)
- [ ] `conda activate bpod && bpodacademy` opens the GUI
- [ ] `crontab -l` shows both jobs
- [ ] `ls <NAS mount>/RATACAD_DATA` works as `ratacad1`
- [ ] You can `ssh ratacad1@<machine>` from another campus computer
