class AngryCat
  def initialize(age, name)
    @age  = age
    @name = name
  end

  def age
    puts @age
  end

  def name
    puts @name
  end

  def hiss
    puts "Hisssss!!!"
  end
end

garfield = AngryCat.new(100 ,"Garfield")
munchie = AngryCat.new(9, "Munchie")

garfield.name

munchie.name