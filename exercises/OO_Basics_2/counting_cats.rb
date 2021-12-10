class Cat
  @@total_cats = 0
  attr_accessor :name

  def initialize(name)
    @name = name
    @@total_cats += 1
  end

  def self.total
    puts @@total_cats
  end
end

kitty1 = Cat.new("kitty1")
kitty2 = Cat.new("kitty2")

Cat.total