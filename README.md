> "It's like a better genius playlist generator because it makes you the genius"

Based on this tweet: https://twitter.com/joshaber/status/175230633033994240

![http://dl.dropbox.com/u/3746322/Snapshot%2011:1:12%2011:13%20AM.png](Joshtweets)

__For realz.__

Created with macruby 0.10. Should work down to 0.5 I believe.

Defaults:
---
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

What to do with it:
---
Listen to good music.
???.
Profit.

License:
---
See LICENSE.md
