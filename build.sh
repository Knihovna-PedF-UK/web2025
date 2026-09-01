#!/bin/bash
WWW_DIR="${WWW_DIR:-www}"

lua web.lua
cp -r css/ "$WWW_DIR/"
cp -r img/ "$WWW_DIR/"
cp -r js/ "$WWW_DIR/"
mkdir -p fonts
cp -r fonts/ "$WWW_DIR/"
