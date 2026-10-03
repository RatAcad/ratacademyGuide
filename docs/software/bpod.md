# Bpod (RatAcad fork)

[Bpod](https://sanworks.github.io/Bpod_Wiki/) (Sanworks) is the real-time state
machine that runs each box: it reads nose-pokes, drives cue lights and opens
water valves. Each box has its own **Bpod State Machine**, connected to the control
computer by USB.

Ratacademy runs a modified Bpod that works **headless**, i.e. without the
Bpod console window. This lets one computer run many Bpods unattended, all
controlled by [BpodAcademy](bpodacademy.md).

## Which repository?

| Repository | Bpod version | Use it? |
|---|---|---|
| [**RatAcad/Bpod_Gen2_Legacy**](https://github.com/RatAcad/Bpod_Gen2_Legacy) (branch `feature/NoGUI`) | 1.63 + NoGUI | **Yes. This is what the academy runs.** |
| [RatAcad/Bpod_Gen2](https://github.com/RatAcad/Bpod_Gen2) (branch `feature/NoGUI`) | 1.77 + NoGUI port | Not with BpodAcademy yet (see below) |
| [sanworks/Bpod_Gen2](https://github.com/sanworks/Bpod_Gen2) | upstream | No; it lacks the headless features |

!!! danger "Use Bpod_Gen2_Legacy with BpodAcademy"
    BpodAcademy starts protocols with `RunProtocol('StartSafe', ...)`. That mode
    exists **only in Bpod_Gen2_Legacy**. The newer `RatAcad/Bpod_Gen2` fork has no
    `StartSafe`, so **Run Protocol fails with "Protocol did not start!"**.

!!! note "Rename the folder to `Bpod_Gen2`"
    Both the Legacy README and BpodAcademy say to name the cloned folder
    `Bpod_Gen2`:

    ```bash
    git clone git@github.com:RatAcad/Bpod_Gen2_Legacy.git ~/ratacad/Bpod_Gen2
    cd ~/ratacad/Bpod_Gen2 && git checkout feature/NoGUI
    ```

## Known limitation: new Bpods need old firmware

!!! failure "Bpod_Gen2_Legacy is based on Bpod 1.63 (2021)"
    New Bpod State Machines from Sanworks ship with newer firmware than Bpod
    software 1.63 supports. **Today, using a new Bpod in the academy means
    downgrading its firmware** to the version bundled with Legacy
    (`UpdateBpodFirmware`). That's not a good long-term solution: you lose firmware fixes
    and features, and newer hardware revisions and modules may not be supported at all.

### Development to-do: merge upstream Sanworks into the NoGUI fork

The fix is to bring the NoGUI changes onto the **current Sanworks Bpod_Gen2**, so
the headless starter works with current firmware. The 2023 attempt
([RatAcad/Bpod_Gen2](https://github.com/RatAcad/Bpod_Gen2), v1.77) is a starting
point, but it is already well behind Sanworks and is missing `StartSafe`.

When the merge is done, the result must still have:

- [ ] `Bpod(SerialPort, ForceJava, ShowGUI, Name)`, including the silent `'EMU'` start
- [ ] `BpodSystem.SwitchGUI()` and the `ShowGUI`/`Name` properties on `BpodObject`
- [ ] `RunProtocol('StartSafe', protocol, subject, settings)` with `onCleanup(@() StopProtocol(true))`
- [ ] `StopProtocol(save)`, and an `EndBpod` that is safe without a GUI
- [ ] Per-box calibration file `LiquidCalibration_<Name>.mat`
- [ ] `SessionData.Info.BpodName` written in `AddTrialEvents`
- [ ] 24-hour file split (`SaveBpodSessionData(checkDay)`, `SplitBpodSessionData`, `Info.FileDate`, `Info.FileStartTime_UTC`)
- [ ] Async saving (`StartBpodSaveAsync`, `SaveBpodSessionDataAsync`, `CloseBpodSaveAsync`, `GatherTrialData`)
- [ ] `CheckTimeOfDay`

How to test it:

- [ ] A **new Bpod on its factory firmware** connects headless
- [ ] BpodAcademy can Start, Calibrate, Run, Stop and End it
- [ ] Data files still load in `dj-ratacad update` (box name and 24 h split are recognized)
- [ ] The existing protocols run unchanged

After the merge, this page, the setup pages and the BpodAcademy README should be updated to
point at the new branch. Until then, keep using Legacy.

## What the NoGUI fork adds

| Change | Why it matters for the academy |
|---|---|
| `Bpod(SerialPort, ForceJava, ShowGUI, Name)` | Start a Bpod by its serial port with **no GUI** and a **box name**, e.g. `Bpod('/dev/ttyACM0', 0, 0, 'RATACAD_1_1')` |
| `BpodSystem.SwitchGUI()` | Show or hide the Bpod console on demand |
| `RunProtocol('Start' \| 'StartSafe', protocol, subject, settings)` | Run a protocol headless. `StartSafe` **saves data and stops cleanly** on Ctrl-C or when BpodAcademy stops it |
| `StopProtocol(save)` | Save → stop the state machine → close protocol figures |
| Per-box calibration file | `Bpod Local/Calibration Files/LiquidCalibration_<Name>.mat`, so each box keeps its own valve calibration |
| `SessionData.Info.BpodName` | Records which box ran the session. [dj_ratacad](../data/pipeline.md) needs this field |
| **24-hour file splitting** | Sessions can run for days; a new data file starts every 24 h (`Info.FileDate`, `Info.FileStartTime_UTC`) |
| Async saving (`StartBpodSaveAsync`, …) | Saves data in a background worker. **Needs the Parallel Computing Toolbox** (only if a protocol uses it) |
| `CheckTimeOfDay(start, stop)` | Lets protocols train only during set hours (handles windows that cross midnight) |

## Running Bpod by hand (no BpodAcademy)

This is useful for testing a single box from MATLAB:

```matlab
Bpod('/dev/ttyACM0', 0, 0, 'TestBox');   % or 'EMU' for the emulator; 'COM3' on Windows
BpodLiquidCalibration('Calibrate');       % calibrate valves for this box
RunProtocol('Start', 'TestPokes', 'FakeSubject');   % blocks; Ctrl-C to stop
BpodSystem.SwitchGUI();                   % show the console if needed
EndBpod;
```

## Hardware & firmware

The fork ships the standard Bpod firmware (`UpdateBpodFirmware.m`) and module
code. It supports state machine **r0.5, 0.7–0.9 and 2.0**. For hardware and
assembly, see the [Sanworks Bpod wiki](https://sanworks.github.io/Bpod_Wiki/) and
[Bpod-CAD](https://github.com/sanworks/Bpod-CAD).

License: GPL-3.0 (inherited from Sanworks).
