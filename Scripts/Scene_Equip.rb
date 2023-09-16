#==============================================================================
# ■ Scene_Equip
#------------------------------------------------------------------------------
# 　装備画面の処理を行うクラスです。
#==============================================================================

class Scene_Equip < Scene_MenuBase
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_status_window
    create_command_window
    create_slot_window
    create_item_window
  end
  #--------------------------------------------------------------------------
  # ● ステータスウィンドウの作成
  #--------------------------------------------------------------------------
  def create_status_window
    @status_window = Window_EquipStatus.new(0, @help_window.height)
    @status_window.viewport = @viewport
    @status_window.actor = @actor
  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウの作成
  #--------------------------------------------------------------------------
  def create_command_window
    wx = @status_window.width
    wy = @help_window.height
    ww = Graphics.width - @status_window.width
    @command_window = Window_EquipCommand.new(wx, wy, ww)
    @command_window.viewport = @viewport
    @command_window.help_window = @help_window
    @command_window.set_handler(:equip,    method(:command_equip))
    @command_window.set_handler(:optimize, method(:command_optimize))
    @command_window.set_handler(:clear,    method(:command_clear))
    @command_window.set_handler(:cancel,   method(:return_scene))
    @command_window.set_handler(:pagedown, method(:next_actor))
    @command_window.set_handler(:pageup,   method(:prev_actor))
  end
  #--------------------------------------------------------------------------
  # ● スロットウィンドウの作成
  #--------------------------------------------------------------------------
  def create_slot_window
    wx = @status_window.width
    wy = @command_window.y + @command_window.height
    ww = Graphics.width - @status_window.width
    @slot_window = Window_EquipSlot.new(wx, wy, ww)
    @slot_window.viewport = @viewport
    @slot_window.help_window = @help_window
    @slot_window.status_window = @status_window
    @slot_window.actor = @actor
    @slot_window.set_handler(:ok,       method(:on_slot_ok))
    @slot_window.set_handler(:cancel,   method(:on_slot_cancel))
  end
  #--------------------------------------------------------------------------
  # ● アイテムウィンドウの作成
  #--------------------------------------------------------------------------
  def create_item_window
    wx = 0
    wy = @slot_window.y + @slot_window.height
    ww = Graphics.width
    wh = Graphics.height - wy
    @item_window = Window_EquipItem.new(wx, wy, ww, wh)
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.status_window = @status_window
    @item_window.actor = @actor
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @slot_window.item_window = @item_window
  end
  #--------------------------------------------------------------------------
  # ● コマンド［装備変更］
  #--------------------------------------------------------------------------
  def command_equip
    @slot_window.activate
    @slot_window.select(0)
  end
  #--------------------------------------------------------------------------
  # ● コマンド［最強装備］
  #--------------------------------------------------------------------------
  def command_optimize
    Sound.play_equip
    @actor.optimize_equipments
    @status_window.refresh
    @slot_window.refresh
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # ● コマンド［全て外す］
  #--------------------------------------------------------------------------
  def command_clear
    Sound.play_equip
    @actor.clear_equipments
    @status_window.refresh
    @slot_window.refresh
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # ● スロット［決定］
  #--------------------------------------------------------------------------
  def on_slot_ok
    @item_window.activate
    @item_window.select(0)
  end
  #--------------------------------------------------------------------------
  # ● スロット［キャンセル］
  #--------------------------------------------------------------------------
  def on_slot_cancel
    @slot_window.unselect
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # ● アイテム［決定］
  #--------------------------------------------------------------------------
  def on_item_ok
    Sound.play_equip
    @actor.change_equip(@slot_window.index, @item_window.item)
    @slot_window.activate
    @slot_window.refresh
    @item_window.unselect
    @item_window.refresh
  end
  #--------------------------------------------------------------------------
  # ● アイテム［キャンセル］
  #--------------------------------------------------------------------------
  def on_item_cancel
    @slot_window.activate
    @item_window.unselect
  end
  #--------------------------------------------------------------------------
  # ● アクターの切り替え
  #--------------------------------------------------------------------------
  def on_actor_change
    @status_window.actor = @actor
    @slot_window.actor = @actor
    @item_window.actor = @actor
    @command_window.activate
  end
end
