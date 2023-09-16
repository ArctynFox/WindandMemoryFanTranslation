class Game_Interpreter
  def set_number_range(min, max)
    Window_NumberInput.set_range(min, max)
  end
end

class Window_NumberInput
  alias refresh_unmodified refresh
  def refresh
    @number = @@min if @@min && @number < @@min
    @number = @@max if @@max && @number > @@max
    refresh_unmodified
  end

  alias process_ok_unmodified process_ok
  def process_ok
    @@min = nil
    @@max = nil
    process_ok_unmodified
  end

  def self.set_range(min, max)
    min = 0 if min < 0
    max = 0 if max < 0
    max = min if min > max
    @@min = min
    @@max = max
  end
end