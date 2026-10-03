# Valve calibration

Each box's water valves must be calibrated so that a requested reward
(e.g. 20 µL) actually delivers that volume. Calibrate **every week after changing
tubing** ([Weekly maintenance](weekly-maintenance.md)), and whenever a valve, tube or
reservoir height changes.

The calibration is stored **per box** in
`Bpod Local/Calibration Files/LiquidCalibration_<box_id>.mat`.

## Procedure

1. In BpodAcademy, **Start Bpod** for the box and then click **Calibrate**. This only
   works on the rig computer, and only while no protocol is running.
2. In the Bpod liquid calibration window:
    1. Pick the valves to calibrate. On a 3-port box these are valves **1–3**
       (left, center, right).
    2. Add the pulse durations (ms) to measure, or use **Suggest Points** to
       get durations for a target range (default 2–10 µL per pulse).
    3. Set **pulses per measurement**. The default is **100**, and pulses are 0.2 s apart.
3. Put a pre-weighed cup under each port and click **Measure Pending**. Refill
   the reservoir when prompted.
4. Weigh each cup and enter the **total grams** delivered. Bpod converts this to
   µL per pulse (1 g = 1000 µL).
5. Bpod fits a curve of volume vs. pulse duration. Click **Test Curve**
   to deliver a target amount, and check it on the scale.
6. Save and close the window. The file is written as `LiquidCalibration_<box_id>.mat`.

!!! tip
    Run [`FlushValves`](../software/protocols.md#utility-protocols-every-academy-needs)
    first so the lines are full and free of bubbles. Air in the line ruins a
    calibration.
