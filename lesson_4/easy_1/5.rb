class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

puts "Pizza: " + Pizza.new("Pep").instance_variables.to_s
puts "Fruit: " + Fruit.new("Apple").instance_variables.to_s