Based on this tweet: https://twitter.com/joshaber/status/175230633033994240

__For realz.__

Created with macruby 0.10. Should work down to 0.5 I believe.

Defaults:
* Need an empty playlist named "Top Tracks" or create your own and change the PLAYLIST const.
* Adjust the DELIMITER to your liking. Mine plays out nicely at 3-5.

Explanation:
---
The algorithm takes the average play count (disregarding the highest and lowest count for good measure) for each album, and then se​​lects any songs in that album with a play count > DELIMITER

To run:
---
just run `macruby counter.rb`

Problem solving:
---
There shouldn't be any.
If there are, you may need to build the iTunes bridge support files for your machine. Simply run:

`sdef /Applications/iTunes.app | sdp -fh --basename iTunes`
_and_
`gen_bridge_metadata -c '-I.' iTunes.h &gt; iTunes.bridgesupport`


???:
___
Profit.

License:
___
See LICENSE.md
