class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    self.age += 1
  end
end

# Firstly it is important to note that make_one_year_older is an instance
# method and can only be called on instances of the class Cat. Keeping this
# in mind the use of self here is referencing the instance (object) that
# called the method - the calling object.