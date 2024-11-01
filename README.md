# audiobook-notes

This repository is a collection of notes and small programs to explore the creation of audiobooks
from epub or other texts using Text To Speech software. In particular, most successes I have had 
to 2024-11-01
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
https://github.com/nashjc/audiobook-notes/blob/main/AudiobookExperiments.pdf with the corresponding
RMarkdown (.Rmd) file being the source text.

As and when some of the tools and ideas discussed here become established as useful and stable, I
am hopeful that they can be incorporated in Christopher's repository for the convenience of other
workers. I welcome comments and collaboration, as one of my motivations is to provide material for
a friend who is legally blind. My gratitude to all who have contributed to making possible TTS
tools, as my friend has said that the output audio quality and rhythm is, overall, very good.

John Nash, 2024-11-01
