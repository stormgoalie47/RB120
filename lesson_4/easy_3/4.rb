class Cat
  def initialize(type)
    @type = type
  end

  def to_s
    "I am a #{@type} cat."
  end
end

munchie = Cat.new("tabby")

puts munchie