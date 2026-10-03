# Troubleshooting

**First place to look:** `$BPOD_DIR/Academy/logs/<box_id>.log` (that box's MATLAB
output) and `$BPOD_DIR/Academy/logs/BpodAcademy.log`.

??? question "\"Protocol did not start!\""
    - Read the box log. A MATLAB error in the protocol is the usual cause.
    - Check that you're running **Bpod_Gen2_Legacy**. The newer `RatAcad/Bpod_Gen2`
      fork has no `RunProtocol('StartSafe')` ([details](../software/bpod.md#which-repository)).
    - Check that the subject folder exists: `Data/<subject>/<protocol>/`.

??? question "\"Failed to start matlab process\""
    - Check that the Bpod is plugged in, then use **Bpod → Refresh Ports**.
    - If the USB serial number changed (e.g. a replacement Bpod), update the box
      in BpodAcademy and **add a new row** to `bpod.Bpod` in DataJoint.
    - Check that the MATLAB Engine for Python is installed in the `bpod` environment.
    - If none of that works, restart the computer.

??? question "A new Bpod won't connect (firmware version mismatch)"
    New Bpods ship with firmware newer than Bpod_Gen2_Legacy (v1.63) supports. For now,
    flash the firmware bundled with Legacy using `UpdateBpodFirmware` in MATLAB
    (Arduino/Teensyduino needed; see [setup](../setup/computer-ubuntu.md#5-optional-arduino-teensyduino-for-firmware-updates)).
    The long-term fix is to merge upstream Sanworks into the NoGUI fork:
    [development to-do](../software/bpod.md#development-to-do-merge-upstream-sanworks-into-the-nogui-fork).

??? question "A Bpod doesn't appear in the port list"
    On Linux/macOS, BpodAcademy only lists serial devices whose manufacturer
    contains "duino" (Arduino/Teensy). Check with `ls /dev/ttyACM*`, and make sure the
    user is in the `dialout` group: `sudo usermod -aG dialout ratacad1`.

??? question "\"Make sure to calibrate valves before running a protocol\""
    There is no `Calibration Files/LiquidCalibration_<box_id>.mat` for this box yet.
    [Calibrate it](../operate/calibration.md).

??? question "Show GUI / Calibrate do nothing"
    These only work **on the rig computer**, not from `bpodacademy --remote`, and
    not while a protocol is running.

??? question "Can't connect remotely"
    Check that TCP **5555 and 5556** are open to your network on the rig
    ([firewall](../setup/computer-ubuntu.md#9-firewall)) and that you're on campus or VPN.

??? question "Sessions are missing from DataJoint"
    - Is the animal in `animal.Animal`, and not marked euthanized?
    - Is the protocol in `bpod.Protocol`?
    - Do the subject or protocol names contain an `_`? (They must not.)
    - Did the 01:00 transfer copy the file to the NAS? Check `RATACAD_DATA/<animal>/`.
    - Read `~/dj_ratacad.log` on the ingest computer.
    - Box shows as "Unknown"? The file has no `Info.BpodName` (it wasn't recorded with the
      NoGUI Bpod), or no `bpod.Bpod` row is dated before the session.

??? question "A protocol change didn't take effect"
    Protocols sync at **08:00** from the `master` branch only. Restart the protocol in
    BpodAcademy after the sync. Edits made directly on the rig are
    **overwritten**, so commit them to GitHub.

??? question "Python errors about `distutils`"
    BpodAcademy needs **Python ≤ 3.11**. Recreate the env:
    `conda create -n bpod python=3.10`.

??? question "Rewards look too big or too small"
    Recalibrate. Calibration drifts after tubing changes, after a change in reservoir
    height, and from air bubbles. Flush with
    [`FlushValves`](../software/protocols.md#utility-protocols-every-academy-needs) first.
