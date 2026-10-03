# Hardware & parts list

!!! warning "Work in progress"
    This list was put together from the software and the lab notes. **No complete
    bill of materials with part numbers exists yet.** Rows marked *TBD* need a builder
    to fill them in. See [Contributing](../reference/contributing.md).

## Per box

| Qty | Item | Notes |
|---:|---|---|
| 1 | Laser-cut enclosure, **1/4 in (6 mm) acrylic** | ~6 ft² of sheet per box. [Cut list](enclosure.md#cut-list-for-one-box) |
| 1 | **Bpod State Machine** (r2 recommended) | [Sanworks](https://sanworks.io/). The code supports r0.5, r0.7–0.9 and r2.0. **New units currently need a firmware downgrade**; [see why](../software/bpod.md#known-limitation-new-bpods-need-old-firmware) |
| 3 | **Nose-pokes** with IR beam, cue LED and water spout | Sanworks port + port interface board, or your own. They mount in the 2.00 in openings |
| 3 | **Solenoid valves** (one per port) | Driven by the Bpod port interface boards. *TBD: model* |
| 3 | Bpod port interface boards + cables | Sanworks |
| 1 | USB cable to the control computer | Each Bpod is identified by its **USB serial number** |
| — | Mounting screws for the nose-pokes | The 0.177 in holes fit #8 / M4. *TBD: length* |
| — | Fasteners for the corner holes | The 0.265 in holes fit 1/4 in / M6. *TBD: rods or standoffs, length* |
| opt. | USB camera (UVC) | Any OpenCV-compatible camera. Recorded by BpodAcademy |

## Water system (per rack)

| Item | Notes |
|---|---|
| Reservoir, ≥ 4 L | Filled weekly with **10 % sucrose** ([Weekly maintenance](../operate/weekly-maintenance.md)) |
| Tubing + Y-connectors | Reservoir → valves. Keep a spare set so you can swap in clean tubing each week. *TBD: tubing ID* |
| Tubing clamps | For changing lines without spills |
| Syringe | For priming the lines |

## Per rack / academy

| Qty | Item | Notes |
|---:|---|---|
| 1 per ~8 boxes | **Control computer** | ≥ 8 cores/16 threads, ≥ 32 GB RAM, 2 × 1 TB SSD RAID 1. [Details](../setup/computer-ubuntu.md#hardware) |
| — | Powered USB hubs | If the computer has fewer USB ports than boxes |
| 1 | Rack / shelving | *TBD* |
| opt. 1 | Teensy 3.2 camera-sync board | Takes TTL from up to 13 Bpods. [BpodAcademy → Cameras](../software/bpodacademy.md#cameras-optional) |
| 1 | Lab network storage (NAS) | Nightly data copy |
| 1 | MySQL / DataJoint server | We use AWS RDS. [Data pipeline](../data/pipeline.md) |

## Box designs in use

The database (`bpod.BoxDesign`) knows three layouts:

| Design | Layout | Used by |
|---|---|---|
| `3-port` | Left, center and right nose-pokes on one wall | Flashes, FlashCount, Probabilities, … *(this is the design in the cut files)* |
| `6-port` | Two rows of 3 nose-pokes | TwoStep |
| `lever-port` | A lever on the left and a nose-poke on the right | TimingTask |

## Software licenses you need

- **MATLAB** (one license per control computer). Add the **Parallel Computing
  Toolbox** if your protocols use asynchronous saving.
- Everything else is free and open source (Bpod GPL-3.0, Python, DataJoint, Ubuntu).
