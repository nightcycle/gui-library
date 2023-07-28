#!/usr/bin/env bash
source .env/Scripts/Activate
pseudo-enum build dev.project.json
style-guide build out/StyleGuide.luau -dark
py scripts/edit_style_guide.py
rojo sourcemap dev.project.json --output sourcemap.json
stylua out