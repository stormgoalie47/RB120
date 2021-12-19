class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    template
  end
end

class Computer
  attr_accessor :template

  def create_template
    self.template = "template 14231"
  end

  def show_template
    self.template
  end
end

# the second class is using the setter and getter methods explicitly within instance methods
# the first modifies the instance variable @template directly and calls the getter method
    # within the show_template method