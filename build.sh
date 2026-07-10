#!/bin/bash
lua web.lua
cp -r css/ www/
cp -r img/ www/
cp -r js/ www/
mkdir -p fonts
cp -r fonts/ www/
