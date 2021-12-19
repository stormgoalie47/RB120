class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def positive_balance?
    balance >= 0
  end
end

# Ben is right. Because, getter method for @balance instance variable exists and no need to
#   include '@' when referencing the instance variable within an instance method