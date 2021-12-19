class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

tv = Television.new       # new Television object assigned to tv
tv.manufacturer           # undefined method
tv.model                  # call model

# Television.manufacturer # call self.manufacturer
# Television.model        # undefined method