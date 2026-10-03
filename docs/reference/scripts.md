# Automation scripts

These small scripts keep each control computer in sync. They pull the latest protocols
from GitHub every morning, push behavior data to the lab NAS every night, and update
BpodAcademy and the DataJoint database.

All paths assume the user `ratacad1` with everything under `~/ratacad/`. Edit them to
match your machine.

## Schedule

| Time | Script | What it does |
|---|---|---|
| 01:00 | `transferBpodData` | rsync `Bpod Local/Data` → NAS `RATACAD_DATA`; (Ubuntu) delete local files older than 30 days |
| 08:00 | `updateProtocols` | `git pull` the protocols repo, then mirror `Protocols/` into `Bpod Local/Protocols` |
| as needed | `updateBpodAcademy` | reinstall BpodAcademy from GitHub into the `bpod` conda env |
| as needed / cron on the DB host | `updateDJ` | reinstall `dj_ratacad` and run `dj-ratacad update` to ingest new sessions |

## Ubuntu

| File | Download |
|---|---|
| `updateProtocols.sh` | [download](../files/scripts/ubuntu/updateProtocols.sh) |
| `transferBpodData.sh` | [download](../files/scripts/ubuntu/transferBpodData.sh) |
| `updateBpodAcademy.sh` | [download](../files/scripts/ubuntu/updateBpodAcademy.sh) |
| `updateDJ.sh` | [download](../files/scripts/ubuntu/updateDJ.sh) |

=== "updateProtocols.sh"

    ```bash
    --8<-- "docs/files/scripts/ubuntu/updateProtocols.sh"
    ```

=== "transferBpodData.sh"

    ```bash
    --8<-- "docs/files/scripts/ubuntu/transferBpodData.sh"
    ```

=== "updateBpodAcademy.sh"

    ```bash
    --8<-- "docs/files/scripts/ubuntu/updateBpodAcademy.sh"
    ```

=== "updateDJ.sh"

    ```bash
    --8<-- "docs/files/scripts/ubuntu/updateDJ.sh"
    ```

!!! warning "`transferBpodData.sh` deletes local data"
    After copying, it **deletes local data files older than 30 days**
    (`find ... -mtime +30 -delete`). Check that the NAS copy is working
    before you enable it. The `find` path is relative, so it relies on cron running
    from the home directory (cron's default).

## Windows

On Windows each `.sh` file is run by Cygwin through a matching `.bat` launcher,
which is what Task Scheduler calls.

| Script | `.sh` | `.bat` |
|---|---|---|
| updateProtocols | [download](../files/scripts/windows/updateProtocols.sh) | [download](../files/scripts/windows/updateProtocols.bat) |
| transferBpodData | [download](../files/scripts/windows/transferBpodData.sh) | [download](../files/scripts/windows/transferBpodData.bat) |
| transferMiniscopeData *(optional, for miniscope rigs)* | [download](../files/scripts/windows/transferMiniscopeData.sh) | [download](../files/scripts/windows/transferMiniscopeData.bat) |

=== "updateProtocols.sh"

    ```bash
    --8<-- "docs/files/scripts/windows/updateProtocols.sh"
    ```

=== "transferBpodData.sh"

    ```bash
    --8<-- "docs/files/scripts/windows/transferBpodData.sh"
    ```

=== "transferMiniscopeData.sh"

    ```bash
    --8<-- "docs/files/scripts/windows/transferMiniscopeData.sh"
    ```

=== "launcher (.bat)"

    ```bat
    --8<-- "docs/files/scripts/windows/transferBpodData.bat"
    ```
