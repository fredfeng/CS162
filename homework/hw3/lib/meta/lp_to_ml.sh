#!/bin/bash

# ChatGPT generated this. Honestly I have no idea how this works.
awk '{ printf "%s \\n\\\n", $0 }' meta.lp | awk 'BEGIN { print "let lp = \"\\" } { print } END { print "\"" }' | sed 's/} $/}\\/g'