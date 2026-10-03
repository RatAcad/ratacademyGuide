# Weekly maintenance

Rats live in their boxes and earn water by doing the task, so the water lines and
reservoirs have to be refreshed every week. Plan about an hour for a full academy.

## Supplies

- [ ] Saccharin powder and clean reservoirs
- [ ] Clean tubing and Y-connectors
- [ ] Syringe (to prime the lines)
- [ ] 70 % ethanol and paper towels
- [ ] Scale for weighing rats
- [ ] Screwdrivers (to fix loose nose-pokes)

## Start the control software

On the control computer:

```bash
conda activate bpod
bpodacademy
```

## Procedure

1. **Stop all protocols** in BpodAcademy.
2. **Remove the tubing from every box.** Clamp each line before you pull it so it
   doesn't spill.
3. **Clean the old tubing:** flush it with water 2×, then air 3×, and hang it to dry.
4. **Replace the reservoirs.** Empty them, rinse them and refill each one with
   **4 L of 0.2 % saccharin**, i.e. 4 × (2 g saccharin + 1 L water).
5. **For each box:**
    1. Weigh the rat and record the weight. Put the rat in a holding cage.
    2. Wipe down the nose-poke wall with ethanol.
    3. Connect clean tubing.
    4. Draw saccharin into the tubing with a syringe so there are no air bubbles.
    5. **[Calibrate the valves](calibration.md).**
    6. Put the rat back in its box.
6. Restart each box's protocol in BpodAcademy
   ([Daily operation](daily.md)).

!!! tip "Track body weight"
    Rats on water restriction must stay above your IACUC weight threshold. Keep
    weekly weights in your lab's records and follow your animal protocol. This guide
    doesn't replace it.
