# Contributing to this guide

This guide is a living document. If you build a box, run into a problem or
change a procedure, please update it.

## Quick edits

Click the :material-file-edit-outline: **edit** icon at the top of any page. GitHub
opens the Markdown source, and you can propose a change as a pull request.

## Working locally

```bash
git clone https://github.com/RatAcad/ratacademyGuide.git
cd ratacademyGuide
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
mkdocs serve        # preview at http://127.0.0.1:8000
```

The site is rebuilt and published to GitHub Pages automatically on every push to
`main` (`.github/workflows/deploy.yml`).

## Where things live

```text
docs/
├── index.md                  # home page
├── build/ setup/ software/ operate/ data/ reference/
├── files/
│   ├── laser-cut/svg/        # cut files (link from build/enclosure.md)
│   ├── laser-cut/dwg/        # original AutoCAD drawings
│   └── scripts/{ubuntu,windows}/
└── assets/previews/          # thick-line SVG previews used on the enclosure page
mkdocs.yml                    # navigation + theme
```

To add a new cut file, put it in `docs/files/laser-cut/svg/`, add it to the table
in `build/enclosure.md` and state its **units (72 or 96 dpi)**.

## Most wanted

- [ ] Photos of an assembled box and a full academy rack
- [ ] Material/thickness and fasteners for the enclosure
- [ ] A complete bill of materials with part numbers and vendors
- [ ] Wiring photos (Bpod → port interface boards → nose-pokes/valves)
- [ ] Water reservoir and manifold setup

## Never commit

Passwords, database hostnames, IP ranges, personal emails or animal-protocol
numbers. **This site is public.**
