#!/bin/bash
# Hover your mouse over a point, press Enter to capture its coordinates.
# Run this to find the start and end positions for your scrub.

echo "=== Coordinate Finder ==="
echo "Hover your mouse, then press Enter to capture the position."
echo ""

while true; do
  read -r -p "Press Enter to capture (or type 'q' + Enter to quit): " input
  [[ "$input" == "q" ]] && break
  POS=$(cliclick p)
  echo "  → $POS"
  echo ""
done
