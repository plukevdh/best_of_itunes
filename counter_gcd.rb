#!/usr/local/bin/macruby
framework 'Foundation'
framework 'ScriptingBridge'

include Dispatch
require './objects/play_counter'

# init itunes bridge
itunes = SBApplication.applicationWithBundleIdentifier("com.apple.itunes")
load_bridge_support_file 'iTunes.bridgesupport'
itunes.run

# access helper
class SBElementArray
  def [](value)
    self.objectWithName(value)
  end
end

DELIMITER = 5
PLAYLIST = "Top Tracks"

WORKERS = 5

# block calculation macros
BLOCK_LOW  = ->(index, size) { ((index * size) / WORKERS) * 2 }
BLOCK_HIGH = ->(index, size) { BLOCK_LOW.call(index + 1, size) - 2 }
BLOCK_SIZE = ->(index, size) { ((BLOCK_HIGH.call(index, size) - BLOCK_LOW.call(index, size)) / 2) + 1 }

# cache itunes data
albums = {}
itunes.sources["Library"].userPlaylists["Music"].fileTracks.each do |track|
  albums[track.album] ||= []
  albums[track.album] << track
end

album_blocks = []
total = 0

0.upto(WORKERS-1) do |i|
  block_size = BLOCK_SIZE.call(i, albums.count)
  group = albums.to_a[total, block_size]

  album_blocks << group
  total += block_size
end

# Creating a group to synchronize block execution.
awesome_tracks = []
group = Dispatch::Group.new
result_queue = Dispatch::Queue.new('access-queue.#{awesome_tracks.object_id}')

# Dispatch a task to the default concurrent queue.
album_blocks.each do |block|
  Dispatch::Queue.concurrent.async(group) do
    tracks = PlayCounter.new(Hash[block]).calculate(DELIMITER)

    result_queue.async(group) do
      awesome_tracks.concat tracks
    end
  end
end

group.wait
itunes.add awesome_tracks.map(&:location), to: itunes.sources["Library"].playlists[PLAYLIST]
