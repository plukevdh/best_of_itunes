#!/usr/local/bin/macruby
framework 'Foundation'
framework 'ScriptingBridge'

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

tracks  = itunes.sources["Library"].userPlaylists["Music"].fileTracks
albums = {}

tracks.each do |track|
  albums[track.album] ||= []
  albums[track.album] << track if track.album.strip != ""
end

top_tracks = albums.flat_map do |title, tracks|
  next if tracks.empty?

  # get counts and reject minmax
  counts = tracks.map &:playedCount
  counts -= counts.minmax unless counts.count < 2

  next if counts.empty? || counts == 0

  avg = ( counts.inject(0,&:+) / counts.count )
  tracks.select { |track| track.playedCount > (avg + DELIMITER) }
end

itunes.add top_tracks.compact.map(&:location), to: itunes.sources["Library"].playlists[PLAYLIST]
