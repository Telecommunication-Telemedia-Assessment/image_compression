#!/bin/bash

echo "var previews = [" > previews.js
for x in previews/*; do
    echo "  \"$x\", " >> previews.js
done
echo "]"  >> previews.js