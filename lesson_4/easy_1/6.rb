class Cube
  attr_reader :volume

  def initialize(volume)
    @volume = volume
  end
end

new_cube = Cube.new(1000)
puts new_cube.volume