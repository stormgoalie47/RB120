# In the last question we had a module called Speed which contained a go_fast method. 
# We included this module in the Car class as shown below.

# When we called the go_fast method from an instance of the Car class (as shown below)
# you might have noticed that the string printed when we go fast includes the name of
# the type of vehicle we are using. How is this done?

module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed
  def go_slow
    puts "I am safe and driving slow."
  end
end

# We use self.class in the method and this works the following way:

# self refers to the object itself, in this case either a Car or Truck object.
# We ask self to tell us its class with .class. It tells us.
# We don't need to use to_s here because it is inside of a string and is 
# interpolated which means it will take care of the to_s for us.