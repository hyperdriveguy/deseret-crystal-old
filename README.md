Optimized Pokémon Crystal
=========================

This is an optimization of pokecrystal, in the sense that all of the unused code and data is removed from the game.  
This means that you have a lot more free space to work with, and don't have to wade through piles of unused mobile features.

The Goals
---------

* Remove as much as possible
* Keep the regular gameplay and logic intact, don't remove working features
* Keep link compatibility with the original games intact
* Don't stray from pokecrystal, don't rename or reorganize things, keep the added line counter as close to 0 as possible

Current status
--------------

Every single labelled but unused code and data has been removed.  
Unused maps have been removed.  
Unused sprite animations have been removed.  
Unused trainers have been removed.  
Remnants of support for non-GBC consoles have been removed.  
Probably more.

There's a few exceptions to some of the rules:
* The battle tower room menu code has been noticeably refactored, to remove the dependency on otherwise unused WRAM addresses, and remove the dependency on an entire jumptable.
* The Celebi event will be kept, despite being inaccessible during normal gameplay, as it's fully functional and used in the VC releases.
* All unused stat-altering move effects will be kept, because they're useful for implementing new moves.

Notes
-----

This project adds a tool, called `tools/unusedsymbols.py`, to scan the built object files for symbols and find unused ones.  
This tool requires `python3` to run, and is most conveniently used through `tools/unusedsymbols.sh`, a wrapper that takes care of (re)building the objects properly, filtering and saving the output.
It is adviseable to run `tools/unusedsymbols.sh` and removing (or ignoring) any unused symbols before commiting.
