class Person
  def age=(age)
    @age = 2 * age
  end

  def age
    @age * 2
  end
end

person1 = Person.new
person1.age = 20
puts person1.age