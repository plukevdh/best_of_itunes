class PlayCounter
  # @param [Hash <album_title, Array<Track>>] array of albums
  def initialize(albums)
    @albums = albums
  end

  # @param [Integer] the play count threshold
  #
  # @return [Array<Track>] array of songs to add to the playlist
  def calculate(delimit)
    @albums.flat_map do |title, tracks|
      next if tracks.empty?

      # get counts and reject minmax
      counts = tracks.map &:playedCount
      counts -= counts.minmax unless counts.count < 3

      next if counts.empty?

      avg = ( counts.inject(0,&:+) / counts.count )
      tracks.select do |track|
        track.playedCount >= (avg + delimit) ||
          ( counts.size == 1 && track.playedCount >= delimit )
      end
    end.compact
  end
end
