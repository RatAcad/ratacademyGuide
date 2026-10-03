# Build roadmap

These are the steps for building a Ratacademy from nothing. Each step links to
the detailed page.

## Phase 1: Plan and order

- [ ] Decide how many boxes and racks you need (~8 boxes per control computer is a good start)
- [ ] Get approval for continuous home-cage training and water regulation under your animal protocol
- [ ] Order Bpods, nose-pokes and valves ([Hardware](../build/hardware.md))
- [ ] Order the control computer(s) and ask IT for setup ([Ubuntu](../setup/computer-ubuntu.md))
- [ ] Arrange lab network storage and a MySQL/DataJoint database ([Data pipeline](../data/pipeline.md))
- [ ] Get 1/4 in (6 mm) acrylic sheet (~6 ft² per box) and laser-cutter time

## Phase 2: Build boxes

- [ ] Cut the enclosure parts, **checking the scale first** ([Enclosure](../build/enclosure.md#before-you-cut-check-the-scale))
- [ ] Assemble the boxes and mount the nose-pokes
- [ ] Wire the ports to the Bpods; plumb the reservoir → valves → spouts
- [ ] Label every box `RATACAD_<rack>_<position>`

## Phase 3: Set up software

- [ ] Set up the control computer ([Ubuntu](../setup/computer-ubuntu.md) / [Windows](../setup/computer-windows.md))
- [ ] Install Bpod_Gen2_Legacy ([Bpod](../software/bpod.md))
- [ ] Install BpodAcademy and add every box ([BpodAcademy](../software/bpodacademy.md))
- [ ] Set up your protocol repo and the 08:00 sync ([Protocols](../software/protocols.md))
- [ ] Enable the 01:00 data transfer and 02:00 DataJoint ingest ([Scripts](../reference/scripts.md))

## Phase 4: Commission each box

- [ ] **TestPokes**: every IR beam, LED and valve responds
- [ ] **FlushValves**: lines are primed with no bubbles or leaks
- [ ] **Calibrate** the valves ([Valve calibration](../operate/calibration.md))
- [ ] Run a test subject for a day and check that it shows up in DataJoint

## Phase 5: Run

- [ ] Add animals to the database and to BpodAcademy ([Daily operation](../operate/daily.md#starting-a-new-animal))
- [ ] Daily checks ([Daily operation](../operate/daily.md))
- [ ] Weekly water change and recalibration ([Weekly maintenance](../operate/weekly-maintenance.md))
