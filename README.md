# audiobook-notes

This repository is a collection of notes and small programs to explore the creation of audiobooks
from epub or other texts using Text To Speech software. In particular, most success to 2024-11-01
have come with Christopher Aedo's epub2tts-edge software (https://github.com/aedocw/epub2tts-edge).

No TTS is perfect. Nor are human readers. Hence words like "read" can be pronounced more than one
way, like "reed" or "red". Phrases or sentences in other languages will trip up both software and
people. Some of the tools and discussion in this collection are directed to working around such
issues.

Other concerns relate to workflow and dealing with corrections, adjustments, text features, etc.
For example, we might like to have characters in a novel speak in voices associated with the
particular speaker. I haven't found how to do that yet.

Some of my explorations have led to modest software tools. I've written them mainly in R, simply
because I use R and RStudio a lot and it was fairly easy for me to repurpose some other code. I
suspect Python might be more widely practiced for these sorts of exercises, but the R scripts
allow me to experiment quickly and interactively. 

I've a work-in-progress write-up of my explorations as 
