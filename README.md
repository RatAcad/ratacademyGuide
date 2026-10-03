# Rat Academy Build Guide

Source for the Rat Academy (RatAcad) build-and-operate guide, published at
**https://ratacad.github.io/ratacademyGuide/**.

It covers laser-cut enclosure files, hardware, control-computer setup, Bpod (NoGUI fork),
BpodAcademy, protocols, daily/weekly operation, valve calibration and the DataJoint data pipeline.

## Preview locally

```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
mkdocs serve      # http://127.0.0.1:8000
```

Pushing to `main` builds the site and deploys it to GitHub Pages
(`.github/workflows/deploy.yml`).

## Layout

- `docs/`: Markdown pages (navigation in `mkdocs.yml`)
- `docs/files/laser-cut/`: SVG and DWG cut files
- `docs/files/scripts/`: rig automation scripts (Ubuntu, Windows)

This site is **public**. Do not commit passwords, database hostnames or internal IP ranges.
