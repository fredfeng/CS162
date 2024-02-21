#!/bin/bash

# ChatGPT generated this. Honestly I have no idea how this works.
awk '{ printf "%s \\n\\\n", $0 }' encodings.txt | awk 'BEGIN { print "let raw = \"\\" } { print } END { print "\"" }' | sed 's/} $/}\\/g'