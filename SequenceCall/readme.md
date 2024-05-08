# Sequence Call WIDGET  
If you fly F3A or any sequnce of maneuvers, this tool let your radio be your caller.


## Credits



## Setup
The Zip files comes already organized in the same directory structure as the radio.

In your radio SDCard, it should look like this:

    \WIDGETS\SeqCall
    \WIDGETS\SeqCall\seq        -- sequences directory  (text files with extension .txt)
    \WIDGETS\SeqCall\sounds     -- sounds/wav directory  (wav files for each maneuver)
    \WIDGETS\SeqCall\main.lua   -- Lua script for the WIDGET


## How to use it

1. Enter your radio Widget Page Editor, and Setup the place where you want to add the WIDGET

![image](https://github.com/frankiearzu/EdgeTX-LUA/assets/32604366/f0967d2c-03b8-440b-bd5f-84c62ea00b47)

2. Setup the Widget
   File: name of the sequence file (without the .txt extnsion)
   Next: what switch do you want to use to go to the next manuver (SH is good since is a temp switch)

![image](https://github.com/frankiearzu/EdgeTX-LUA/assets/32604366/3d7aeade-d76f-4bf1-a987-6f3097453734)

3. Go back to your main screen, and your should see the sequence of maneuvers

![image](https://github.com/frankiearzu/EdgeTX-LUA/assets/32604366/56278f88-80f1-456c-8e26-0753f139bdfc)


4. If you flip (ON-OFF Up/Down cycle) it shoud move to the next maneouver and play the wav.

5. Full Scren allows you to navigate and reset the sequence, also if you tap the screen, should play the current maneuver

![image](https://github.com/frankiearzu/EdgeTX-LUA/assets/32604366/8ef182cb-2b1c-465a-b3ac-907b812c6c0a)
![image](https://github.com/frankiearzu/EdgeTX-LUA/assets/32604366/f05e7e1f-c5dc-4914-8de5-978e4e8b1758)

## How to create your own Sequence

To create your own, create a sequence file with your favorite text editor.
Each line has the text to be displayed on the screen, a comma (,) and optionally the wav file to use.
The very first line is the name of your sequence, and can have a .wav file associated (optional).
The wav file needs to exist in the \WIDGETS\SeqCall\sounds folder

![image](https://github.com/frankiearzu/EdgeTX-LUA/assets/32604366/add937b9-46fd-4a0f-9567-b15f71949025)
![image](https://github.com/frankiearzu/EdgeTX-LUA/assets/32604366/c4c61f98-f6fa-420b-bb45-f00d5eac9838)

## How to create your own WAV files

To create wav files, you can use many tools available online. Just make sure tha the name is not too long (max 15 characters) and has to be placed in the \WIDGETS\SeqCall\sounds folder.

OpenTX Speaker
![image](https://github.com/frankiearzu/EdgeTX-LUA/assets/32604366/632b8c6e-6227-44a1-9c36-6817cae503bd)






