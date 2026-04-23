# video-scrub-tool

A lightweight Mac utility for consistently repeating mouse-based video timeline scrubbing interactions — useful for capturing and comparing visual behavior across different video players.

## Why

Testing how a video player responds to scrubbing (grabbing the playhead and dragging) is hard to do consistently by hand. This tool replays the exact same mouse-down → drag → release sequence every time, so you can isolate and compare player behavior across different implementations.

## Requirements

- macOS
- [cliclick](https://github.com/BlueM/cliclick) — install via Homebrew:
  ```bash
  brew install cliclick
  ```
- Terminal must have **Accessibility** permission:
  System Settings → Privacy & Security → Accessibility → add Terminal ✓

## Setup

1. Clone the repo:
   ```bash
   git clone https://github.com/vanlane/video-scrub-tool.git
   cd video-scrub-tool
   ```

2. Find your coordinates using the helper script. Hover your mouse over the playhead start position and press Enter, then hover over the end scrub position and press Enter:
   ```bash
   ./find-coords.sh
   ```

3. Open `scrub.sh` and plug in your coordinates at the top:
   ```bash
   START_X=3100     # where the playhead is (click down here)
   START_Y=920
   END_X=2900       # where to scrub to
   END_Y=920
   ```

## Usage

Navigate Chrome to the page you want to test, then run:
```bash
./scrub.sh
```

You have 3 seconds to switch to Chrome before the scrub fires. Press **Ctrl+C** in Terminal to stop early.

## Configuration

| Variable | Description |
|----------|-------------|
| `START_X / START_Y` | Coordinates of the playhead (where to click down) |
| `END_X / END_Y` | Coordinates to scrub to |
| `STEPS` | Number of intermediate moves per pass — more = smoother (default: 200) |
| `PASSES` | Number of back-and-forth sweeps before releasing (default: 3) |

Each additional pass automatically reduces steps by 25%, making successive sweeps progressively faster — mimicking natural scrubbing behavior.

## Files

- `scrub.sh` — main scrub replay script
- `find-coords.sh` — helper to capture screen coordinates
