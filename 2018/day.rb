class Day
  def initialize(input)
    @input = input
  end

  def call
    raise NotImplementedError
  end

  def self.call(*args)
    new(*args).call
  end

  private

  attr_reader :input
end
