# Sequence Call WIDGET  
If you fly F3A or any sequnce of maneuvers, this tool let your radio be your caller.


# Credits



## Setup
The Zip files comes already organized in the same directory structure as the radio.

In your radio SDCard, it should look like this:

    \WIDGETS\SeqCall
    \WIDGETS\SeqCall\seq        -- sequences directory  (text files with extension .txt)
    \WIDGETS\SeqCall\sounds     -- sounds/wav directory  (wav files for each maneuver)
    \WIDGETS\SeqCall\main.lua   -- Lua script for the WIDGET


# How to use it

1. Go to your telemetry
2. Setup the Widget
        name of the sequence file (without the .txt extnsion)
        what switch do you want to use to go to the next manuver (SH is good since is a temp switch)



# How to create your own Sequence

To create your own, create a sequence file with your favorite text editor.
Each line has the text to be displayed on the screen, a comma (,) and optionally the wav file to use.
The very first line is the name of your sequence, and can have a .wav file associated (optional).
The wav file needs to exist in the \WIDGETS\SeqCall\sounds folder



# How to create your own WAV files

To create wav files, you can use many tools available online. Just make sure tha the name is not too long (max 15 characters) and has to be placed in the \WIDGETS\SeqCall\sounds folder.

