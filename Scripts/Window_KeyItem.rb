#==============================================================================
# ■ Window_KeyItem
#------------------------------------------------------------------------------
# 　イベントコマンド［アイテム選択の処理］に使用するウィンドウです。
#==============================================================================

class Window_KeyItem < Window_ItemList
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(message_window)
    @message_window = message_window
    super(0, 0, Graphics.width, fitting_height(4))
    self.openness = 0
    deactivate
    set_handler(:ok,     method(:on_ok))
    set_handler(:cancel, method(:on_cancel))
  end
  #--------------------------------------------------------------------------
  # ● 入力処理の開始
  #--------------------------------------------------------------------------
  def start
    self.category = :key_item
    update_placement
    refresh
    select(0)
    open
    activate
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ位置の更新
  #--------------------------------------------------------------------------
  def update_placement
    if @message_window.y >= Graphics.height / 2
      self.y = 0
    else
      self.y = Graphics.height - height
    end
  end
  #--------------------------------------------------------------------------
  # ● 決定時の処理
  #--------------------------------------------------------------------------
  def on_ok
    result = item ? item.id : 0
    $game_variables[$game_message.item_choice_variable_id] = result
    close
  end
  #--------------------------------------------------------------------------
  # ● キャンセル時の処理
  #--------------------------------------------------------------------------
  def on_cancel
    $game_variables[$game_message.item_choice_variable_id] = 0
    close
  end
end
