class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

# hello = Hello.new
# hello.hi          # "Hello" output

# hello = Hello.new
# hello.bye         # Error: undefined method bye

# hello = Hello.new
# hello.greet       # Argument Error

# hello = Hello.new
# hello.greet("Goodbye")  #Output "Goodbye"

Hello.hi            # Undefined method