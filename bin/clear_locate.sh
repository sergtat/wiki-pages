#!/bin/bash

find ../pages -name '*.md' -print0 | xargs -0 grep '\./images'
