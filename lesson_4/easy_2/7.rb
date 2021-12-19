class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

# @@cats_count is a class variable. In this environment, it acts to keep track
#   of the number of instantiations of the Cat class, as it is incremented by 1
#   at each instantiation

cat1 = Cat.new(:cat)
cat2 = Cat.new(:cat)
cat3 = Cat.new(:cat)

puts Cat.cats_count