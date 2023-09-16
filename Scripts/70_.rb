ATB.ver(:status_window, 1.70)

=begin

「戦闘コマンドカスタム1.05」の設定項目の内、以下の項目は推奨設定があります
推奨設定以外で発生した不具合はサポートしません
  
  ACTOR_MODE = 2
  PARTY_USE_MODE = 2 もしくは 3
  STATUS_MODE = 1
  STATUS_X = [128, 128, 128]
  
=end

module ATB_STATUS
  #--------------------------------------------------------------------------
  # ● ＡＰゲージ横幅
  #--------------------------------------------------------------------------
  def self.atbs_ap_gauge_width
    return ($data_system.opt_display_tp ? 90 : 120) + ATBS[:apw]
  end
end

# 「ウインドウ　味方ステータス」から移行
unless ATB.xp_style?
#==============================================================================
# ■ Window_BattleStatus
#==============================================================================
class Window_BattleStatus < Window_Selectable
  include ATB_STATUS
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #--------------------------------------------------------------------------
  def draw_item(index)
    actor = $game_party.battle_members[index]
    draw_gauge_area(gauge_area_rect(index), actor)
    draw_basic_area(basic_area_rect(index), actor)
    draw_actor_ap_index(index)
  end
  #--------------------------------------------------------------------------
  # ● 基本エリアの描画
  #--------------------------------------------------------------------------
  def draw_basic_area(rect, actor)
    icon_w = rect.width - 104 + ATBS[:stw] * 24
    draw_actor_icons(actor, rect.x + 104 + ATBS[:stx], rect.y, icon_w)
    draw_actor_name(actor,  rect.x +   0 + ATBS[:nax], rect.y, 100 + ATBS[:naw])
  end
  #--------------------------------------------------------------------------
  # ● ゲージエリアの描画（TP あり）
  #--------------------------------------------------------------------------
  def draw_gauge_area_with_tp(rect, actor)
    draw_actor_tp(actor, rect.x + 180 + ATBS[:tpx], rect.y,  70 + ATBS[:tpw])
    draw_actor_mp(actor, rect.x + 100 + ATBS[:mpx], rect.y,  70 + ATBS[:mpw])
    draw_actor_hp(actor, rect.x +   0 + ATBS[:hpx], rect.y,  90 + ATBS[:hpw])
  end
  #--------------------------------------------------------------------------
  # ● ゲージエリアの描画（TP なし）
  #--------------------------------------------------------------------------
  def draw_gauge_area_without_tp(rect, actor)
    draw_actor_hp(actor, rect.x +   0 + ATBS[:hpx], rect.y, 134 + ATBS[:hpw])
    draw_actor_mp(actor, rect.x + 144 + ATBS[:mpx], rect.y,  76 + ATBS[:mpw])
  end
end
end

# 「ウインドウ　味方ＡＰゲージ」から移行
#==============================================================================
# ■ Window_Base
#==============================================================================
class Window_Base < Window
  #--------------------------------------------------------------------------
  # ● アクターのＡＰの描画
  #--------------------------------------------------------------------------
  def draw_actor_ap(actor, x, y, width, use_cache = true)
    rate     = actor.ap_rate
    rate100  = actor.ap_rate_100
    color    = actor.ap_gauge_color
    draw_ap_gauge(x, y, width, rate, color)
    if use_cache
      src_bitmap = Cache.ap_number(rate100)
    else
      src_bitmap = APNumberBitmap.number_bitmap(rate100, width, contents.font.size)
    end
    contents.blt(x, y, src_bitmap, src_bitmap.rect)
  end
  #--------------------------------------------------------------------------
  # ● ＡＰゲージの描画
  #--------------------------------------------------------------------------
  def draw_ap_gauge(x, y, width, rate, color)
    fill_w = (width * rate).to_i
    gauge_y = y + line_height - 8
    contents.fill_rect(x, gauge_y, width, 6, color[0])
    contents.gradient_fill_rect(x, gauge_y, fill_w, 6, color[1], color[2])
  end
end
#==============================================================================
# ■ Window_BattleStatus
#==============================================================================
class Window_BattleStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # ● アクターのＡＰの描画
  #--------------------------------------------------------------------------
  def draw_actor_ap_index(index)
    rect  = gauge_area_rect(index)
    actor = $game_party.battle_members[index]
    dtp   = $data_system.opt_display_tp
    x     = rect.x + (dtp ? 260 : 230) + ATBS[:apx]
    y     = rect.y
    width = ATB_STATUS.atbs_ap_gauge_width
    contents.clear_rect(x, y, width, line_height)
    
    draw_actor_ap(actor, x, y, width)
  end
  #--------------------------------------------------------------------------
  # ● 全項目のＡＰのみ描画
  #--------------------------------------------------------------------------
  def refresh_ap
    item_max.times {|i| draw_actor_ap_index(i) }
  end
end

#==============================================================================
# ■ Game_Battler
#==============================================================================
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # ● ウインドウスキンから色を取得
  #--------------------------------------------------------------------------
  def text_color(n)
    Cache.text_color(n)
  end
  #--------------------------------------------------------------------------
  # ● ＡＰゲージ色の取得
  #--------------------------------------------------------------------------
  if $atb_ap_gauge_color_new
    def ap_gauge_color; return ap_gauge_color_new; end
  else
    def ap_gauge_color; return ap_gauge_color_old; end
  end
  #--------------------------------------------------------------------------
  # ● ＡＰゲージ色の取得　旧設定
  #--------------------------------------------------------------------------
  def ap_gauge_color_old
    if not chanting?
      color = ap_color_base
      states.reverse.each do |state|
        color = ap_color_change(color, state.id)
      end
      return color
    else
      color = chant_color_base
      states.reverse.each do |state|
        color = chant_color_change(color, state.id)
      end
      return color
    end
  end
  #--------------------------------------------------------------------------
  # ● ＡＰゲージ色の取得　新設定
  #--------------------------------------------------------------------------
  def ap_gauge_color_new
    if @chant_type == nil
      method_name = "ap_gauge_color_nil"
    else
      method_name = "ap_gauge_color_#{@chant_type}"
    end
    begin
      send(method_name)
    rescue
      $atb_ap_gauge_method_error_check ||= {}
      unless $atb_ap_gauge_method_error_check[method_name]
        $atb_ap_gauge_method_error_check[method_name] = true
        msgbox sprintf("エラー：ＡＴＢゲージ色設定")
        msgbox sprintf("メソッド %s が存在しません", method_name)
      end
      send("ap_gauge_color_nil")
    end
  end
  #--------------------------------------------------------------------------
  # ● ステート判定
  #--------------------------------------------------------------------------
  def cst(*args)
    [*args].each do |state_id|
      return true if state?(state_id)
    end
    return false
  end
end

#==============================================================================
# ■ APNumberBitmap
#==============================================================================
module APNumberBitmap
  #--------------------------------------------------------------------------
  # ● 横幅
  #--------------------------------------------------------------------------
  def self.bitmap_width
    ATB_STATUS.atbs_ap_gauge_width
  end
  #--------------------------------------------------------------------------
  # ● 文字サイズ
  #--------------------------------------------------------------------------
  def self.font_size
    24
  end
  #--------------------------------------------------------------------------
  # ● ビットマップ作成
  #--------------------------------------------------------------------------
  def self.number_bitmap(n, width = bitmap_width, size = font_size)
    bitmap = Bitmap.new(width, size)
    bitmap.font.size = size
    if ATB::AP_GAUGE_NAME
      bitmap.font.color = ATB::AP_GAUGE_NAME_TEXT_COLOR
      bitmap.draw_text(bitmap.rect, "AP")
    end
    if ATB::AP_GAUGE_PERCENT
      bitmap.font.size = size
      bitmap.font.color = ATB::AP_GAUGE_MAIN_TEXT_COLOR
      text = n.to_s
      text += "%" if ATB::AP_GAUGE_SIGN
      bitmap.draw_text(bitmap.rect, text, 2)
    end
    return bitmap
  end
end

#==============================================================================
# ■ Cache
#==============================================================================
module Cache
  #--------------------------------------------------------------------------
  # ● ＡＰ表示ビットマップのキャッシュ作成
  #--------------------------------------------------------------------------
  def self.create_ap_number
    @ap_number = []
    for i in 0..100
      @ap_number[i] = APNumberBitmap.number_bitmap(i)
    end
  end
  #--------------------------------------------------------------------------
  # ● ＡＰ表示ビットマップのキャッシュ読み込み
  #--------------------------------------------------------------------------
  def self.ap_number(number)
    @ap_number[number]
  end
  #--------------------------------------------------------------------------
  # ● ウインドウスキンから文字色取得
  #--------------------------------------------------------------------------
  def self.text_color(n)
    @text_color ||= []
    unless @text_color[n]
      @text_color[n] = 
        self.system("Window").get_pixel(64 + (n % 8) * 8, 96 + (n / 8) * 8)
    end
    return @text_color[n]
  end
end
#==============================================================================
# ■ DataManager
#==============================================================================
module DataManager
  #--------------------------------------------------------------------------
  # ● データベースのロード
  #--------------------------------------------------------------------------
  def self.load_database
    if $BTEST
      load_battle_test_database
    else
      load_normal_database
      check_player_location
    end
    Cache.create_ap_number
  end
end
#==============================================================================
# ■ Window_ActorCommand
#==============================================================================
class Window_ActorCommand < Window_Command
  #--------------------------------------------------------------------------
  # ● キャンセル処理の有効状態を取得
  #--------------------------------------------------------------------------
  def cancel_enabled?
    false
  end
end