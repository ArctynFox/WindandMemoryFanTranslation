#==============================================================================
# ■ 碧の軌跡っぽいステータス表示
#   @version 0.13 12/01/07
#   @author さば缶
#------------------------------------------------------------------------------
# 　マップ画面下にステータスが表示されます
#
#  ■用意するもの
#    Graphics\System の下に Actor_bg1 ～ Actor_bg3
#    Graphics\Faces の下に 顔グラを50%に縮小したファイル "通常のファイル名_s"
#    例 Actor1.png → Actor1_s.png
#    ※このファイルが存在しない場合、プログラムで縮小するため非常に荒くなります
#
#==============================================================================
module Saba
  module KisekiStatus
    # このスイッチがONの場合、ステータスを表示します
    INVISIBLE_SWITCH = 18
    
    # TPを表示する場合、true に設定します。
    SHOW_TP = false
  end
end

class Window_KisekiStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, Graphics.height-window_height+18, Graphics.width, window_height)
    self.opacity = 0
    self.visible = $game_switches[Saba::KisekiStatus::INVISIBLE_SWITCH]
  
    refresh
  end
  def refresh
    @last_hps = []
    @last_mps = []
    @last_tps = []
    super
  end
  #--------------------------------------------------------------------------
  # ● 項目数の取得
  #--------------------------------------------------------------------------
  def item_max
    $game_party.battle_members.size
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウの高さを取得
  #--------------------------------------------------------------------------
  def window_height
    item_height+32
  end
  #--------------------------------------------------------------------------
  # ● 項目の高さを取得
  #--------------------------------------------------------------------------
  def item_height
    52
  end
  #--------------------------------------------------------------------------
  # ● 項目の幅を取得
  #--------------------------------------------------------------------------
  def item_width
    return 70
  end
  #--------------------------------------------------------------------------
  # ● 桁数の取得
  #--------------------------------------------------------------------------
  def col_max
    return $game_party.battle_members.size
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #--------------------------------------------------------------------------
  def draw_item(index)
    actor = $game_party.battle_members[index]
    rect = item_rect(index)
    
    bg_bitmap = Cache.system("Actor_bg1")
    contents.blt(rect.x, rect.y, bg_bitmap, bg_bitmap.rect)
    
    small_bitmap = Bitmap.new(48, 48)
    begin
      bitmap = Cache.face(actor.face_name + "_s")
    rescue
    end
    if bitmap == nil
      bitmap = Cache.face(actor.face_name)
      face_rect = Rect.new(actor.face_index % 4 * 96, actor.face_index / 4 * 96, 96, 96)
      small_bitmap.stretch_blt(Rect.new(0, 0, 48, 48), bitmap, face_rect)
    else
      small_bitmap.blt(0, 0, bitmap, Rect.new(actor.face_index % 4 * 48,  actor.face_index / 4 * 48, 48, 48))
    end
    bitmap.dispose
    clear_edge(small_bitmap)
    
    contents.blt(rect.x+2, 2, small_bitmap, Rect.new(0, 0, 48, 48))
    small_bitmap.dispose
    
    if actor.dead?
      bg_bitmap = Cache.system("Actor_bg1")
      contents.blt(rect.x, rect.y, bg_bitmap, bg_bitmap.rect)
      bg_bitmap = Cache.system("Actor_bg3")
    else
      bg_bitmap = Cache.system("Actor_bg2")
    end
    contents.blt(rect.x, rect.y, bg_bitmap, bg_bitmap.rect)
    
    draw_gauge(rect.x + 47, rect.y+20, 50, actor.hp_rate, hp_gauge_color1, hp_gauge_color2)
    draw_gauge(rect.x + 42, rect.y+24, 50, actor.mp_rate, mp_gauge_color1, mp_gauge_color2)
    if Saba::KisekiStatus::SHOW_TP
      draw_gauge(rect.x + 37, rect.y+28, 50, actor.tp_rate, tp_gauge_color1, tp_gauge_color2)
    end
    @last_hps.push(actor.hp_rate)
    @last_mps.push(actor.mp_rate)
    @last_tps.push(actor.tp_rate)
  end
  #--------------------------------------------------------------------------
  # ● 顔画像の端を消します
  #--------------------------------------------------------------------------
  def clear_edge(bitmap)
    22.times  { |i|
      bitmap.clear_rect(0, i, 22 - i, 1)
      bitmap.clear_rect(26 + i, i, 22 - i, 1)
      bitmap.clear_rect(0, i + 26, i, 1)
      bitmap.clear_rect(48 - i, i + 26, i, 1)
    }
  end
  #--------------------------------------------------------------------------
  # ● ゲージの描画
  #     rate   : 割合（1.0 で満タン）
  #     color1 : グラデーション 左端
  #     color2 : グラデーション 右端
  #--------------------------------------------------------------------------
  def draw_gauge(x, y, width, rate, color1, color2)
    fill_w = (width * rate).to_i
    gauge_y = y + line_height - 8
    
    contents.fill_rect(x-2, gauge_y-1, width+4, 4, text_color(15))
    contents.fill_rect(x-1, gauge_y-2, width+2, 6, text_color(15))
    contents.fill_rect(x, gauge_y, width, 2, gauge_back_color)
    contents.gradient_fill_rect(x, gauge_y, fill_w, 2, color1, color2)
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    if $game_switches[Saba::KisekiStatus::INVISIBLE_SWITCH] == true &&
      ! $game_message.busy? && ! $game_message.visible
      self.visible = true
    else
      self.visible = false
      return
    end
    hps = []
    mps = []
    tps = []
    for actor in $game_party.battle_members
      hps.push(actor.hp_rate)
      mps.push(actor.mp_rate)
      tps.push(actor.tp_rate)
    end

    if @last_hps != hps || @last_mps != mps || @last_tps != tps
      refresh
    end
  end
end

class Scene_Map
  #--------------------------------------------------------------------------
  # ● 全ウィンドウの作成
  #--------------------------------------------------------------------------
  alias saba_kiseki_status_create_all_windows create_all_windows
  def create_all_windows
    saba_kiseki_status_create_all_windows
    @kiseki_status_window = Window_KisekiStatus.new
  end
end