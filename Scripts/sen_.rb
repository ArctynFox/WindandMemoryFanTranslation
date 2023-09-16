
class Game_Interpreter
  alias operate_variable_unmodified operate_variable
  def operate_variable(variable_id, operation_type, value)
    flag = variable_id == 38 && !(operation_type == 0 && value == 100)
    if flag
      sen = $game_variables[38]
    end
    operate_variable_unmodified(variable_id, operation_type, value)
    if flag
      sen = $game_variables[38] - sen
      $game_temp.streffect.push(Window_Getinfo.new(0, 7, nil, sen)) if sen != 0
    end
    if variable_id == 38
      $game_switches[14] = $game_variables[38] <= 0
      $game_switches[15] = $game_variables[38] <= 30
      $game_switches[16] = $game_variables[38] <= 70
    end
  end
end

class Window_Getinfo < Window_Base
  alias initialize_unmodified initialize
  def initialize(id, type, text = "", value)
    initialize_unmodified(id, type, text, value)
    if type == 7
      if @value >= 1
        Audio.se_play('Audio/SE/Heal7', 80)
      elsif @value <= -1
        Audio.se_play('Audio/SE/Down2', 80)
      end
    end
  end

  alias refresh_unmodified refresh
  def refresh(id, type, text = "", value)
    if type == 7
      c = B_COLOR
      self.contents.fill_rect(0, 14, 644, 24, c)
      color = $game_variables[38] > 70 ? 3 :
              $game_variables[38] > 30 ? 6 :
              $game_variables[38] > 1 ? 14 : 2
      text = value > 0 ? "SEN increased." : "SEN decreased!"
      note = "Current value: #{$game_variables[38]} (" +
             (value > 0 ? "+" : "") +
             "#{value})"
      draw_icon(103, 4, 14)
      change_color(text_color(color))
      self.contents.draw_text(28, 14, 612, line_height, note)
      change_color(normal_color)
      self.contents.font.size = 14
      w = self.contents.text_size(text).width
      self.contents.fill_rect(0, 0, w + 4, 14, c)
      self.contents.draw_text_f(4, 0, 340, 14, text)
      Graphics.frame_reset
    else
      refresh_unmodified(id, type, text, value)
    end
  end
end