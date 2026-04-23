#!/bin/bash
# Replays a click-drag scrub on whatever is currently on screen.
# Edit the four variables below with your coordinates (use find-coords.sh to find them).

START_X=3100     # X coordinate where the playhead starts (where to click down)
START_Y=1009      # Y coordinate of the timeline
END_X=2900      # X coordinate to scrub to
END_Y=1009        # Y coordinate at end (usually same as START_Y)

STEPS=200         # Number of intermediate moves per pass (more = smoother)
PASSES=3          # Number of back-and-forth sweeps before releasing

# ── do not edit below this line ──────────────────────────────────────────────

TMPFILE=$(mktemp)

echo "Scrubbing in 3 seconds — switch to Chrome now..."
sleep 3

{
  echo "m:$START_X,$START_Y"
  echo "w:100"
  echo "dd:$START_X,$START_Y"

  PASS_STEPS=$STEPS
  for pass in $(seq 1 $PASSES); do
    # Odd passes go START → END, even passes go END → START
    if (( pass % 2 == 1 )); then
      FROM_X=$START_X; FROM_Y=$START_Y
      TO_X=$END_X;   TO_Y=$END_Y
    else
      FROM_X=$END_X; FROM_Y=$END_Y
      TO_X=$START_X; TO_Y=$START_Y
    fi

    for i in $(seq 1 $PASS_STEPS); do
      X=$(( FROM_X + (TO_X - FROM_X) * i / PASS_STEPS ))
      Y=$(( FROM_Y + (TO_Y - FROM_Y) * i / PASS_STEPS ))
      echo "dm:$X,$Y"
    done

    # Reduce steps by 25% for the next pass (minimum 1)
    PASS_STEPS=$(( PASS_STEPS * 75 / 100 ))
    (( PASS_STEPS < 1 )) && PASS_STEPS=1
  done

  # Release at wherever the last pass ended
  if (( PASSES % 2 == 1 )); then
    echo "du:$END_X,$END_Y"
  else
    echo "du:$START_X,$START_Y"
  fi
} > "$TMPFILE"

cliclick -f "$TMPFILE"
rm "$TMPFILE"
echo "Done."
