class Person
  def name=(name)
    name = name.split
    @first_name = name.first
    @last_name = name.last
  end

  def name
    "#{@first_name} #{@last_name}"
  end
end

person1 = Person.new
person1.name = 'John Doe'
puts person1.name