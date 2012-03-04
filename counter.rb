#!/usr/local/bin/macruby
framework 'Foundation'
framework 'ScriptingBridge'

require './objects/play_counter'

itunes = SBApplication.applicationWithBundleIdentifier("com.apple.itunes")
load_bridge_support_file 'iTunes.bridgesupport'
itunes.run

class SBElementArray
  def [](value)
    self.objectWithName(value)
  end
end

DELIMITER = 5
PLAYLIST = "Top Tracks"

albums = {}

itunes.sources["Library"].userPlaylists["Music"].fileTracks.each do |track|
  albums[track.album] ||= []
  albums[track.album] << track
end


awesome_tracks = []
awesome_tracks = PlayCounter.new(albums).calculate(DELIMITER)

itunes.add awesome_tracks.map(&:location), to: itunes.sources["Library"].playlists[PLAYLIST]
