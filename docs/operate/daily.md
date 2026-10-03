# Daily operation

Animals live in their boxes and train on their own. A daily check takes a few
minutes per rack.

## Start (or restart) the academy

```bash
conda activate bpod
bpodacademy
```

1. **Training → Load** your saved configuration. It fills in the protocol, subject
   and settings for each box.
2. **Bpod → Start All**, or **Start Bpod** box by box.
3. **Run Protocol** on each box.

You can also check from your office or home (on campus/VPN) with
`bpodacademy --remote` and the rig's IP address.

## Daily checklist

- [ ] Every box shows a running protocol in BpodAcademy
- [ ] Animals look healthy; water is flowing (reservoir level dropped, no leaks)
- [ ] Yesterday's performance looks normal (see below)
- [ ] Weigh animals as your animal protocol requires and record the weights:
      `dj-ratacad weight <rat> -d YYYY-MM-DD -w <grams>`

## Check yesterday's performance

```bash
conda activate dj
dj-ratacad summary flashes            # default: yesterday
dj-ratacad summary flashes -d 2026-10-01
```

Replace `flashes` with your task (`flashcount`, `twostep`, `timingtask`,
`probabilities`, `ufi`).

## What happens automatically

| Time | Where | What |
|---|---|---|
| continuous | each box | Protocol runs; trials only start inside the protocol's time-of-day window. A new data file starts every 24 h. |
| 01:00 | each rig computer | [`transferBpodData`](../reference/scripts.md) copies `Bpod Local/Data` to the NAS |
| 02:00 | one designated computer | `dj-ratacad update` loads new NAS data into DataJoint ([Data pipeline](../data/pipeline.md)) |
| 08:00 | each rig computer | [`updateProtocols`](../reference/scripts.md) pulls protocol changes from GitHub. **Restart a protocol to pick up changes.** |

## Starting a new animal

1. Add the animal to the database ([Data pipeline → Adding animals](../data/pipeline.md#adding-animals)).
   **Without this row, its data will never be ingested.**
2. In BpodAcademy: **Subjects → Add Subject** under the protocol, then give it a
   settings file (**Settings → Copy Existing**).
3. Record a baseline weight: `dj-ratacad weight <rat> -d <date> -w <g> -b`.
4. Select the subject for the box and **Run Protocol**.
