class Game_Event
  attr_accessor :soul_retrieval_event_active

  def is_soul_retrieval_event?
    if @is_soul_retrieval_event == nil
      begin
        command = @event.pages[0].list[0]
        @is_soul_retrieval_event =
          command.code == 117 &&        # コモンイベント
          command.parameters[0] == 32   # ソウルの回収
      rescue
        @is_soul_retrieval_event = false
      end
    end
    return @is_soul_retrieval_event
  end

  alias conditions_met_unmodified conditions_met?
  def conditions_met?(page)
    if is_soul_retrieval_event?
      if page == @event.pages[0]
        return @soul_retrieval_event_active && $game_switches[69]
      else
        return false
      end
    else
      return conditions_met_unmodified(page)
    end
  end
end

class Game_Player
  alias perform_transfer_unmodified perform_transfer
  def perform_transfer
    perform_transfer_unmodified
    # ソウルが出現しているか？
    if $game_switches[69]
      event = $game_map.events[1]
      # EV001 がソウル回収イベントなのか？
      if event && event.is_soul_retrieval_event?
        # 入ったマップがソウルが回収可能なマップだったのか？
        if $game_map.map_id == $game_variables[21]
          # イベントを出現させて、記録した場所へ移動する
          event.soul_retrieval_event_active = true
          event.moveto($game_variables[22], $game_variables[23])
        else
          # それ以外の場合にイベントを隠す
          event.soul_retrieval_event_active = nil
        end
      end
    end
  end
end