#!/usr/bin/env bash

export LD_LIBRARY_PATH="/run/opengl-driver/lib:/run/current-system/sw/share/nix-ld/lib:${LD_LIBRARY_PATH:-}"

exec /run/media/hawk/D-drive/Fox/ML/Project_Blue/.venv/bin/python \
    -m ipykernel_launcher -f "$1"
