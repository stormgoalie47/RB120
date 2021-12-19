class Bag
  def initialize(color, material)
    @color = color
    @material = material
  end
end

new_bag = Bag.new("color", "material")
puts new_bag.instance_variables