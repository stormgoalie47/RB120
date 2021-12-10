class Banner
  def initialize(message)
    @message = message
    @message_length = message.length
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private
  def horizontal_rule
    "+#{'-' * (@message_length + 2)}+"
  end

  def empty_line
    "|#{' ' * (@message_length + 2)}|"
  end

  def message_line
    "| #{@message} |"
  end
end

banner = Banner.new('To boldly go where no one has gone before.')
puts banner

banner = Banner.new('')
puts banner