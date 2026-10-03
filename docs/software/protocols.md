# Protocols

A **protocol** is the MATLAB code that defines a behavioral task: its states,
cue lights, rewards and training stages. Bpod runs it on each box.

!!! info "Our protocols are private"
    The Scott Lab protocols are in a **private** repository
    (`RatAcad/ScottLabBpodProtocols`) and aren't shared on this site. If you're
    building your own academy, either create your own protocol repository in the
    structure below or contact the RatAcad maintainers about collaborating.

## Repository layout

Your protocol repository must follow Bpod's folder rules, so that the
[`updateProtocols` script](../reference/scripts.md) can copy it straight into
`Bpod Local/Protocols`:

```text
<YourLabBpodProtocols>/
├── README.md
└── Protocols/
    ├── MyTask/
    │   ├── MyTask.m                 # entry point; MUST have the same name as the folder
    │   ├── MyTaskCheckSettings.m    # fills in default settings
    │   ├── MyTaskStateMat.m         # builds the state machine for one trial
    │   ├── MyTaskUpdateTraining.m   # automated stage progression
    │   ├── MyTaskCleanup.m          # (optional) turns everything off at the end
    │   └── README.md                # what the task does and its training stages
    ├── FlushValves/                 # utility: flush water lines
    └── TestPokes/                   # utility: check every port/LED/valve
```

Only `Protocols/` is synced to the rigs. Anything else in the repo, such as old
or personal protocols, stays on GitHub only.

## Anatomy of an academy protocol

Academy protocols run **unattended for days**, so they differ from a typical
interactive Bpod protocol in a few ways:

- **Settings come from BpodAcademy.** The protocol reads
  `BpodSystem.ProtocolSettings` and fills in any missing fields with defaults
  (`<Task>CheckSettings.m`). Per-animal settings, like the current training stage,
  carry over from one session to the next.
- **Time-of-day windows.** The main loop runs for `SessionDuration`, but only starts
  trials inside the allowed hours (e.g. a `CheckTimeOfDay(S.Hours(1), S.Hours(2))`
  check). Outside those hours it just waits.
- **Automated training.** After every trial, `<Task>UpdateTraining.m` checks
  performance and moves the animal to the next stage when it meets the criterion.
  No human has to step in.
- **Saving during the session.** Data is saved every *N* trials or by a background
  saver (`StartBpodSaveAsync`), so a crash loses very little.
- **Cleanup on exit.** An `onCleanup` handler turns off valves and lights if the
  protocol is stopped.

The main loop of a typical academy protocol looks like this:

```matlab
function MyTask
    global BpodSystem
    S = MyTaskCheckSettings(BpodSystem.ProtocolSettings);   % defaults + saved settings
    tic
    while toc < S.SessionDuration
        if CheckTimeOfDay(S.Hours(1), S.Hours(2))
            [sma, S] = MyTaskStateMat(S);      % build this trial's state machine
            SendStateMatrix(sma);
            RawEvents = RunStateMatrix;        % run the trial
            BpodSystem.Data = AddTrialEvents(BpodSystem.Data, RawEvents);
            BpodSystem.Data.TrialSettings(BpodSystem.Data.nTrials) = S;
            S = MyTaskUpdateTraining(S);       % advance training stage if criterion met
            if mod(BpodSystem.Data.nTrials, S.SaveInterval) == 0
                SaveBpodSessionData(true);
            end
        else
            pause(1);
        end
    end
end
```

## Utility protocols every academy needs

| Protocol | Use it for | Key settings (defaults) |
|---|---|---|
| **FlushValves** | Pulses each valve in turn to flush/prime water lines | `Ports` ([1 2 3]), `ValveTime` (0.1 s), `Pulses` (10000) |
| **InteractiveFlushValves** | Opens valves continuously, or only while the center port is poked (`TriggerImmediately = 0`), for checking flow by hand | `Ports`, `TriggerImmediately` (1) |
| **TestPokes** | Runs once through every port, lighting each LED and opening each valve, to check that a box works | `Ports` ([1 2 3]), `ValveTime` (0.1 s), `Repetitions` (1) |

Note that **Bpod valve *n* = `ValveState` bit 2^(n-1)**, and ports are numbered 1–3
from left to right on the [port wall](../build/enclosure.md).

## Tasks that have run in the academy

For context only; the code is private. All of these use the three-port wall
(left, center, right) unless noted.

- **Flashes / FlashCount**: Poisson flash counting / accumulation of evidence
  ([Scott et al., 2015](https://elifesciences.org/articles/11308)), with a fully
  automated, multi-stage training pipeline.
- **UncertainFlashInference**: flash-sequence inference with flashes of two
  intensities.
- **Probabilities**: two-armed bandit with block reversals
  ([Beron et al., 2022](https://github.com/bernardosabatinilab/two-armed-bandit-task)).
- **TwoStep**: two-step task ([Miller et al., 2017](https://www.nature.com/articles/nn.4613);
  [Akam et al., 2020](https://doi.org/10.1016/j.neuron.2020.10.013)). Uses **six**
  ports (two rows of three).
- **Transitive**, **TimingTask**, **LightChasing** (shaping).

## Workflow for changing a protocol

1. Create a branch for the protocol: `git checkout -b MyTask`.
2. Edit it and test it on a spare box.
3. Commit, push and open a pull request into `master`.
4. Once it's merged, every rig picks up the change at **~08:00 the next morning**
   (`updateProtocols` cron job). Restart the protocol in BpodAcademy to load it.

!!! warning
    `updateProtocols` mirrors the repository with `rsync --delete-after`, so **any
    protocol that exists only on the rig computer will be deleted**. Always commit
    protocols to the repository.
