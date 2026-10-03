# System architecture

A Rat Academy is a set of **racks of behavior boxes**. Animals live in their
boxes, earn water by doing a task, and move through training stages automatically.
Everything is controlled from a few computers and logged to a central database.

```mermaid
flowchart TB
    subgraph rack["Rack (e.g. RATACAD_1, ~8–9 boxes)"]
        direction LR
        bx1["Box RATACAD_1_1<br/>laser-cut enclosure<br/>3 nose-pokes + valves"] --- bp1[Bpod State Machine]
        bx2["Box RATACAD_1_2"] --- bp2[Bpod State Machine]
        bxn["…"] --- bpn[Bpod …]
    end
    W[("Water reservoir<br/>10 % sucrose")] -. tubing .-> bx1 & bx2 & bxn
    bp1 & bp2 & bpn -- USB --> PC

    subgraph PC["Control computer (Ubuntu or Windows)"]
        BA["BpodAcademy<br/>(Python GUI + ZMQ server)"] --> ML["MATLAB engines<br/>Bpod NoGUI fork, one per box"]
        ML --> PR["Protocols<br/>(from private GitHub repo)"]
        ML --> DATA["Bpod Local/Data"]
    end

    GH[(GitHub: protocols)] -- "08:00 git pull" --> PR
    DATA -- "01:00 rsync" --> NAS[(Lab NAS)]
    NAS -- "02:00 dj-ratacad update" --> DB[("DataJoint<br/>MySQL on AWS")]
    DB --> AN[Analysis]
    REM[Remote laptop<br/>bpodacademy --remote] -. "TCP 5555/5556" .-> BA
```

## Components

| Layer | What | Where to read more |
|---|---|---|
| Enclosure | Laser-cut box: port wall with 3 nose-pokes, ventilated lid | [Enclosure](../build/enclosure.md) |
| Hardware | Bpod State Machine, port interface boards, nose-pokes, solenoid valves, water system | [Hardware](../build/hardware.md) |
| Real-time control | Bpod (Sanworks) with the RatAcad **NoGUI** changes, running in MATLAB | [Bpod](../software/bpod.md) |
| Orchestration | **BpodAcademy**: one GUI and server for all boxes, cameras and remote access | [BpodAcademy](../software/bpodacademy.md) |
| Tasks | MATLAB protocols with automated training stages | [Protocols](../software/protocols.md) |
| Storage | rsync to the lab NAS each night | [Scripts](../reference/scripts.md) |
| Database | **dj_ratacad** DataJoint pipeline on MySQL (AWS RDS) | [Data pipeline](../data/pipeline.md) |

## Repositories

| Repo | Purpose | Visibility |
|---|---|---|
| [RatAcad/Bpod_Gen2_Legacy](https://github.com/RatAcad/Bpod_Gen2_Legacy) | Bpod with NoGUI changes (**use this one**) | public, GPL-3.0 |
| [RatAcad/Bpod_Gen2](https://github.com/RatAcad/Bpod_Gen2) | newer Bpod port of NoGUI (not yet BpodAcademy-compatible) | public, GPL-3.0 |
| [RatAcad/BpodAcademy](https://github.com/RatAcad/BpodAcademy) | multi-Bpod GUI and server | public, GPL-3.0 |
| [RatAcad/dj_ratacad](https://github.com/RatAcad/dj_ratacad) | DataJoint pipeline | public |
| RatAcad/ScottLabBpodProtocols | lab MATLAB protocols | **private** |

## Naming conventions

- **Boxes:** `RATACAD_<rack>_<position>`, e.g. `RATACAD_2_4`. The same name is used as
  the BpodAcademy box ID, the Bpod `Name` and the calibration file name, and
  it appears in the database.
- **Subjects and protocols:** no underscores (file names are split on `_`).
- **Data files:** `<Subject>_<Protocol>_<YYYYMMDD>_<HHMMSS>.mat`.
