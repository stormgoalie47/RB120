module Walkable
  def walk
    puts "#{name} #{gait} forward."
  end
end

module Nameable
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

class Person
  include Nameable
  include Walkable

  private

  def gait
    "strolls"
  end
end

class Cat
  include Nameable
  include Walkable

  private

  def gait
    "saunters"
  end
end

class Cheetah
  include Nameable
  include Walkable

  private

  def gait
    "runs"
  end
end

mike = Person.new("Mike")
mike.walk
# => "Mike strolls forward"

kitty = Cat.new("Kitty")
kitty.walk
# => "Kitty saunters forward"

flash = Cheetah.new("Flash")
flash.walk
# => "Flash runs forward"