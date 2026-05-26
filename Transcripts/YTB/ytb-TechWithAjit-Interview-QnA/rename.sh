#!/bin/bash
for file in *.vtt; do
    newname=$(echo "$file" | tr -d '"' | sed 's/[^a-zA-Z0-9.-]/-/g' | sed 's/--*/-/g')
    if [ "$file" != "$newname" ]; then
        mv "$file" "$newname"
    fi
done
