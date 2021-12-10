module Walkable
  def walk
    "#{self} #{gait} forward."
  end
end

module Nameable
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    name
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

class Noble
  include Nameable
  include Walkable
  attr_reader :title

  def initialize(name, title)
    super(name)
    @title = title
  end

  def to_s
    "#{title} #{name}"
  end

  private

  def gait
    "struts"
  end
end

byron = Noble.new("Byron", "Lord")
puts byron.walk
# # => "Lord Byron struts forward"
puts byron.name
#=> "Byron"
puts byron.title
#=> "Lord"