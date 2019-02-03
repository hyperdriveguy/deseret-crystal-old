Optimized Pokémon Crystal
=========================

This is an optimization of pokecrystal, in the sense that all of the unused code and data is removed from the game.  
This means that you have a lot more free space to work with, and don't have to wade through piles of unused mobile features.

The Eye-catcher
---------------

Probably the first thing you want to know when looking at this is "what are the savings?"

```
# Original game:
$ tools/free_space.awk pokecrystal11.map
Free space: 454922/2097152 (21.69%)

# Optimized version:
$ tools/free_space.awk pokecrystal11.map
Free space: 691134/2097152 (32.96%)
```

All of this space saved, without actually modifying the game!

The Goals
---------

* Remove as much as possible
* Keep the regular gameplay and logic intact, don't remove working features
* Keep link compatibility with the original games intact
* Keep save file compatibility with the original games intact
* Don't stray from pokecrystal, don't rename or reorganize things, keep the added line counter as close to 0 as possible

The Current Status
------------------

Every single labelled but unused code and data has been removed.  
Unused maps have been removed.  
Unused sprite animations have been removed.  
Unused trainers have been removed.  
Remnants of support for non-GBC consoles have been removed.  
Probably more.

Future improvements:
* Remove unused text commands and special characters (home/text.asm:CheckDict)
* Use an rgbds parser to actually parse the asm instead of just the objects, so we can find unused macros and constants without the hackiness in tools/unusedsymbols.sh

There's a few exceptions to some of the rules:
* Save file compatibility won't be kept for map IDs and anything else related to maps, as it heavily hinders the cleanup of those.
* The battle tower room menu code has been noticeably refactored, to remove the dependency on otherwise unused WRAM addresses, and remove the dependency on an entire jumptable.
* The Celebi event will be kept, despite being inaccessible during normal gameplay, as it's fully functional and used in the VC releases.
* All unused stat-altering move effects will be kept, because they're useful for implementing new moves.
* Commands used in scripting of any kind that simply point to something that is otherwise used need not be removed. There's little point in doing so.
* Commands used in scripting of any kind that "complete" an otherwise used set of commands may be kept. This is subjective and applied on a case-by-case basis.

The Notes
---------

This project adds a tool, called `tools/unusedsymbols.py`, to scan the built object files for symbols and find unused ones.  
This tool requires `python3` to run, and is most conveniently used through `tools/unusedsymbols.sh`, a wrapper that takes care of (re)building the objects properly, filtering and saving the output. It is adviseable to run `tools/unusedsymbols.sh` and removing (or ignoring) any unused symbols before commiting.

This project is kept up-to-date with all new upstream pokecrystal changes. It is merged with it every once when I feel like it, usually a month or two, or when "big" changes happen. I always make sure the output ROM stays the same before and after the merge. This makes it easy to check if you messed up anything when you merge it with your downstream hack (by comparing your ROM pre-perge and post-merge). As such, the recommended merge process for each new merge commit is as follows:
* Merge the last commit before the merge commit
* Build the ROM and back it up
* Merge the merge commit
* Compare the ROM with your previous ROM, fix what doesn't match.
* Merge up to master, as I usually do a "Post-merge fixes" commit that _may_ alter the contents of the ROM.

The exact commit hashes for these can be found more easily by pressing the "compare" button on the github page, below the green "clone and download" button. I hope this helps keep your hack up-to-date. It definitely helps with mine.
