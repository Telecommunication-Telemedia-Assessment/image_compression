#!/bin/bash

rm -rf html_

git clone -b gh-pages git@github.com:Telecommunication-Telemedia-Assessment/image_compression.git html_

cp -r html/* html_

cd html_

git add .
git commit -m "update of github.io page @ $(date)"
git push origin gh-pages

cd ..
rm -rf html_