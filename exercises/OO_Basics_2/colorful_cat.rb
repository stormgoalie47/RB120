class Cat
  COLOR = "purple"
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def greet
    puts "Hello. I am #{name} and I am #{COLOR}."
  end
end

kitty = Cat.new('Sophie')
kitty.greet