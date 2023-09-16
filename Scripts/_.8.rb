#==============================================================================
#                   「セルフスイッチ操作ぷらす」(ACE) ver1.1  by奈々
#
#   ◇使用規約
#   使用される場合はスクリプト作成者として「奈々」を明記して下さい。
#   このスクリプトを改変したり、改変したものを配布するなどは自由ですが
#   その場合も元のスクリプトの作成者として名前は載せて下さい。
#
#------------------------------------------------------------------------------
#
#   イベントでセルフスイッチを自在に切り替えるスクリプトです。
#   他のマップ、好きなイベントのセルフスイッチを操作可能なだけでなく
#   全てのマップ、全てのイベントといった指定も行えます。
#   
#   また、おまけとして
#   指定したスイッチ/変数を一括で変えるコマンド
#   指定したスイッチ/変数以外を一括で変えるコマンドが追加されます。
#   
#   
#   ◇使用方法
#   イベントコマンドの「スクリプト」から呼び出す。
#   
#   ・セルフスイッチの操作
#   adv_self_switches(マップID, イベントID, "スイッチ名", true / false)
#   
#   例１：
#   adv_self_switches(1, 1, "A", true)
#   マップ1番のイベント1番のセルフスイッチAをonにする。
#   
#   例２：[]で指定することで、複数のIDを指定できる。
#   adv_self_switches([1,2,3], 1, "A", true)
#   マップ1番と2番と3番のイベント1番のセルフスイッチAをonにする。
#   adv_self_switches(1, [2,5], ["A","C"], true)
#   マップ1番のイベント2番と5番のセルフスイッチACをonにする。
#
#   例３："all"を指定することで、全てのIDを指定できる。
#   adv_self_switches("all", 1, "A", true)
#   全てのマップのイベント1番のセルフスイッチAをonにする。
#   adv_self_switches(1, "all", "all", true)
#   マップ1番の全てのイベントのセルフスイッチABCDをonにする。
#   adv_self_switches("all", "all", "all", false)
#   全てのセルフスイッチをoffにする。
#   
#   ・スイッチ/変数の一括操作
#   adv_switches(スイッチID, true / false)
#   adv_switches_rev(スイッチID, true / false)
#   adv_variables(変数ID, 数値)
#   adv_variables_rev(変数ID, 数値)
#   
#   IDは[]で複数指定可能。指定したIDを一括操作する。
#   revの方は指定したID「以外」を一括操作する。
#
#==============================================================================


#==============================================================================
# ■ Game_Interpreter
#------------------------------------------------------------------------------
# 　イベントコマンドを実行するインタプリタです。このクラスは Game_Map クラス、
# Game_Troop クラス、Game_Event クラスの内部で使用されます。
#==============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● スイッチの上級操作
  #--------------------------------------------------------------------------
  def adv_switches(list, value)
    if list.is_a?(Numeric)
      list = [list]
    end
    $data_system.switches.each_index {|index|
    next if index == 0
    next if !list.include?(index)
    $game_switches[index] = value
    }
  end
  def adv_switches_rev(list, value)
    if list.is_a?(Numeric)
      list = [list]
    end
    $data_system.switches.each_index {|index|
    next if index == 0
    next if list.include?(index)
    $game_switches[index] = value
    }
  end
  #--------------------------------------------------------------------------
  # ● 変数の上級操作
  #--------------------------------------------------------------------------
  def adv_variables(list, value)
    if list.is_a?(Numeric)
      list = [list]
    end
    $data_system.variables.each_index {|index|
    next if index == 0
    next if !list.include?(index)
    $game_variables[index] = value
    }
  end
  def adv_variables_rev(list, value)
    if list.is_a?(Numeric)
      list = [list]
    end
    $data_system.variables.each_index {|index|
    next if index == 0
    next if list.include?(index)
    $game_variables[index] = value
    }
  end
  #--------------------------------------------------------------------------
  # ● セルフスイッチの上級操作
  #--------------------------------------------------------------------------
  def adv_self_switches(map_id, event_id, channel, value)
    #チャンネルのセット
    if channel == "all"
      channel = ["A","B","C","D"]
    elsif channel.is_a?(String)
      channel = [channel]
    end
    #マップIDのセット
    if map_id == "all"
      map_id = []
      $data_mapinfos.each_key{|key|
      map_id += [key]
      }
    elsif map_id.is_a?(Numeric)
      map_id = [map_id]
    end
    map_id.each{|mi|
    #イベントIDのセット（マップ毎）
    if event_id == "all"
      event_id2 = []
      map = load_data(sprintf("Data/Map%03d.rvdata2", mi))
      map.events.each_key{|key|
      event_id2 += [key]
      }
    elsif event_id.is_a?(Numeric)
      event_id2 = [event_id]
    else
      event_id2 = event_id
    end
    event_id2.each{|ei|
    channel.each{|ch|
    $game_self_switches[[mi, ei, ch]] = value
    }
    }
    }
  end
end
