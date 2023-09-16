ATB.ver(:enemy_gauge, 1.61)


# 「敵ＡＰゲージ描画」から移行
#==============================================================================
# ■ Sprite_Battler
#==============================================================================
class Sprite_Battler < Sprite_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias :atb_initialize :initialize
  def initialize(viewport, battler = nil)
    atb_initialize(viewport, battler)
    @gauge_sprite = Spriteset_Enemy_Gauge.new(self) if battler and battler.enemy?
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  alias :atb_dispose :dispose
  def dispose
    @gauge_sprite.dispose if @gauge_sprite
    atb_dispose
  end
  #--------------------------------------------------------------------------
  # ● 位置の更新
  #--------------------------------------------------------------------------
  alias :atb_update_position :update_position
  def update_position
    atb_update_position
    @gauge_sprite.update_rect(self.x, self.y, self.z) if @gauge_sprite
  end
end

#==============================================================================
# ■ Spriteset_Enemy_Gauge
#==============================================================================
class Spriteset_Enemy_Gauge
  def initialize(battler_sprite)
    @sprites = Array.new(4) {|i| Sprite_Enemy_Gauge.new(battler_sprite, i)}
  end
  def refresh_status
    @sprites.each {|sprite| sprite.refresh}
  end
  def refresh_ap
    @sprites[3].refresh
  end
  def dispose
    @sprites.each {|sprite| sprite.dispose}
  end
  def update_rect(x, y, z)
    @sprites.each {|sprite| sprite.update_rect(x, y, z)}
  end
end

#==============================================================================
# ■ Sprite_Enemy_Gauge
#==============================================================================
class Sprite_Enemy_Gauge < Sprite_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(battler_sprite, gauge_number = nil)
    @battler_sprite = battler_sprite
    @battler        = battler_sprite.battler
    super(@battler_sprite.viewport)
    @front_flag = ATB::ENEMY_GAUGE_FRONT
    @front_flag =  true if @battler.gauge_front
    @front_flag = false if @battler.gauge_back
    self.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @gauge_number = gauge_number
    if @battler.is_a?(Game_Enemy)
      @gauge_width = @battler.gauge_width(@gauge_number)
      @gauge_high  = @battler.gauge_high
    else
      @gauge_width = 100
      @gauge_high  = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● ＡＰゲージ表示位置を更新
  #--------------------------------------------------------------------------
  def update_rect(x, y, z)
    self.x = x - @gauge_width / 2
    self.y = y - @gauge_high
    self.y += ATB::ENEMY_GAUGE_POS_DATA[@gauge_number]
    self.z = @battler_sprite.z + (@front_flag ? 1 : -1)
  end
  #--------------------------------------------------------------------------
  # ● ＡＰゲージ消去
  #--------------------------------------------------------------------------
  def clear
    self.bitmap.clear
  end
  #--------------------------------------------------------------------------
  # ● ゲージの描画
  #--------------------------------------------------------------------------
  def refresh
    if @battler.draw_gauge?(@gauge_number)
      draw_gauge
    else
      clear
    end
  end
  #--------------------------------------------------------------------------
  # ● ＡＰゲージの描画
  #--------------------------------------------------------------------------
  def draw_gauge
    clear
    data = gauge_data
    rate = data[0]
    color = data[1]
    rate = 0.0 if rate < 0.0 or rate.nan?
    rate = 1.0 if rate > 1.0
    fill_w = (@gauge_width * rate).to_i
    color[0].alpha = ATB::ENEMY_AP_GAUGE_ALPHA
    color[1].alpha = ATB::ENEMY_AP_GAUGE_ALPHA
    self.bitmap.fill_rect(0, 0, @gauge_width, 6, color[0])
    self.bitmap.gradient_fill_rect(0, 0, fill_w, 6,color[1], color[2])
  end
  #--------------------------------------------------------------------------
  # ● ゲージの内容
  #--------------------------------------------------------------------------
  def gauge_data
    case @gauge_number
    when 0; rate = @battler.hp / @battler.mhp.to_f
    when 1; rate = @battler.mp / @battler.mmp.to_f
    when 2; rate = @battler.tp / @battler.max_tp.to_f
    when 3; return [@battler.ap_rate, @battler.ap_gauge_color]
    end
    return [rate, ATB::ENEMY_GAUGE_COLOR_DATA[@gauge_number]]
  end
end

#==============================================================================
# ■ Game_Enemy
#==============================================================================
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # ● ゲージを描画するか
  #--------------------------------------------------------------------------
  def draw_gauge?(gauge_number)
    return false if not alive?
    return false if $game_switches[ATB::ENEMY_AP_GAUGE_HIDE_SWITCH] == true
    return false if ATB::ENEMY_AP_GAUGE_HIDE_IN_TURN and BattleManager.in_turn?
    return false if $game_temp.ap_gauge_hide_by_anime != []
    feature_objects.each do |obj|
      return !ATB::ENEMY_GAUGE_DRAW_DATA[gauge_number] if obj.no_draw_gauge(gauge_number)
    end
    return ATB::ENEMY_GAUGE_DRAW_DATA[gauge_number]
  end
  #--------------------------------------------------------------------------
  # ● ゲージの長さ
  #--------------------------------------------------------------------------
  def gauge_width(gauge_number)
    case gauge_number
    when 0; return $1.to_i if enemy.note =~ /<ＨＰゲージ長さ=(\d+)>/
    when 1; return $1.to_i if enemy.note =~ /<ＭＰゲージ長さ=(\d+)>/
    when 2; return $1.to_i if enemy.note =~ /<ＴＰゲージ長さ=(\d+)>/
    when 3; return $1.to_i if enemy.note =~ /<ＡＰゲージ長さ=(\d+)>/
    end
    return ATB::ENEMY_GAUGE_WIDTH_DATA[gauge_number]
  end
  #--------------------------------------------------------------------------
  # ● ゲージのy座標(縦の位置)
  #--------------------------------------------------------------------------
  def gauge_high
    return enemy.note =~ /<ゲージ高さ=(\-*\d+)>/ ? $1.to_i : 0
  end
  #--------------------------------------------------------------------------
  # ● ゲージが手前か奥か
  #--------------------------------------------------------------------------
  def gauge_front
    return enemy.note =~ /<ゲージ手前>/
  end
  def gauge_back
    return enemy.note =~ /<ゲージ奥>/
  end
end

class RPG::BaseItem
  def no_draw_gauge(gauge_number)
    unless @no_draw_gauge
      @no_draw_gauge = []
      for i in 0..3
        case i
        when 0; match = /<ＨＰゲージ表示>/
        when 1; match = /<ＭＰゲージ表示>/
        when 2; match = /<ＴＰゲージ表示>/
        when 3; match = /<ＡＰゲージ表示>/
        end
        @no_draw_gauge[i] = @note =~ match ? true : false
      end
    end
    return @no_draw_gauge[gauge_number]
  end
end

# 「敵ＡＰゲージ描画２」から移行
module ATB
  ENEMY_GAUGE_COLOR_DATA  = [ENEMY_HP_GAUGE_COLOR, ENEMY_MP_GAUGE_COLOR,
                             ENEMY_TP_GAUGE_COLOR]
  def text_color(n)
    Cache.text_color(n)
  end
end
#==============================================================================
# ■ Sprite_Base
#==============================================================================
class Sprite_Base < Sprite
  #--------------------------------------------------------------------------
  # ● アニメーションの開始
  #--------------------------------------------------------------------------
  alias :atb_start_animation :start_animation
  def start_animation(animation, mirror = false)
    atb_start_animation(animation, mirror)
    if @animation and SceneManager.scene_is?(Scene_Battle) and
       ATB::ENEMY_AP_GAUGE_HIDE_ANIMATION.include?(@animation.id)
      $game_temp.ap_gauge_hide_by_anime.push(object_id)
    end
  end
  #--------------------------------------------------------------------------
  # ● アニメーションの終了
  #--------------------------------------------------------------------------
  alias :atb_dispose_animation :dispose_animation
  def dispose_animation
    $game_temp.ap_gauge_hide_by_anime.delete(object_id)
    atb_dispose_animation
  end
end
#==============================================================================
# ■ Game_Temp
#==============================================================================
class Game_Temp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :ap_gauge_hide_by_anime
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias :atb_initialize :initialize
  def initialize
    atb_initialize
    @ap_gauge_hide_by_anime = []
  end
end
#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  alias :atb_start :start
  def start
    $game_temp.ap_gauge_hide_by_anime = []
    atb_start
  end
  #--------------------------------------------------------------------------
  # ● ステータスウィンドウの情報を更新
  #--------------------------------------------------------------------------
  def refresh_status
    @status_window.refresh
    @spriteset.refresh_enemy_status
  end
  #--------------------------------------------------------------------------
  # ● ステータスウィンドウの情報を更新
  #--------------------------------------------------------------------------
  def refresh_ap
    @status_window.refresh_ap
    @spriteset.refresh_enemy_ap
  end
end
#==============================================================================
# ■ Spriteset_Battle
#==============================================================================
class Spriteset_Battle
  def refresh_enemy_status
    return unless @enemy_sprites
    @enemy_sprites.each {|sprite| sprite.refresh_status}
  end
  def refresh_enemy_ap
    return unless @enemy_sprites
    @enemy_sprites.each {|sprite| sprite.refresh_ap}
  end
end
#==============================================================================
# ■ Sprite_Battler
#==============================================================================
class Sprite_Battler < Sprite_Base
  def refresh_status
    @gauge_sprite.refresh_status
  end
  def refresh_ap
    @gauge_sprite.refresh_ap
  end
end