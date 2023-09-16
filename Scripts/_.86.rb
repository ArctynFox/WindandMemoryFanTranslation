#==============================================================================
# ■ Sprite_Battler
#------------------------------------------------------------------------------
# 　バトラー表示用のスプライトです。Game_Battler クラスのインスタンスを監視し、
# スプライトの状態を自動的に変化させます。
#==============================================================================
class Sprite_Battler < Sprite_Base

  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     viewport : ビューポート
  #     battler  : バトラー (Game_Battler)
  #--------------------------------------------------------------------------
  alias initialize_shake2 initialize
  def initialize(viewport, battler = nil)
    initialize_shake2(viewport, battler)
    initialize_shake
  end
  #--------------------------------------------------------------------------
  # ● エフェクトの開始
  #--------------------------------------------------------------------------
  alias start_effect_shake start_effect
  def start_effect(effect_type)
    start_effect_shake(effect_type)
    case @effect_type
    when :blink
      start_shake(3, 30, 15)      
    when :collapse
      start_shake(3, 30, 15)      
    end
  end
  #--------------------------------------------------------------------------
  # ● 点滅エフェクトの更新
  #--------------------------------------------------------------------------
  alias update_blink_shake update_blink
  def update_blink
    update_blink_shake
    update_shake
  end
  #--------------------------------------------------------------------------
  # ● 崩壊エフェクトの更新
  #--------------------------------------------------------------------------
  alias update_collapse_shake update_collapse
  def update_collapse
    update_collapse_shake
    update_shake
  end
  #--------------------------------------------------------------------------
  # ● シェイクの開始
  #     power    : 強さ
  #     speed    : 速さ
  #     duration : 時間
  #--------------------------------------------------------------------------
  def initialize_shake
    @shake_power = [0,0]
    @shake_speed = [0,0]
    @shake_duration = [0,0]
    @shake_direction = [1,1]
    @shake = [0,0]
  end
  #--------------------------------------------------------------------------
  # ● シェイクの開始
  #     power    : 強さ
  #     speed    : 速さ
  #     duration : 時間
  #--------------------------------------------------------------------------
  def start_shake(power, speed, duration)
    @shake_power[0] = power
    @shake_speed[0] = speed
    @shake_duration[0] = duration
    
    #自然に見せるために多少ずらす
    @shake_power[1] = power - rand(power/2)
    @shake_speed[1] = speed - rand(speed/2)
    @shake_duration[1] = duration
  end
  #--------------------------------------------------------------------------
  # ● シェイクの更新
  #--------------------------------------------------------------------------
  def update_shake
    range = 0..1
    range.each do |i|
      if @shake_duration[i] >= 1 or @shake[i] != 0
        delta = (@shake_power[i] * @shake_speed[i] * @shake_direction[i]) / 10.0
        if @shake_duration[i] <= 1 and @shake[i] * (@shake[i] + delta) < 0
          @shake[i] = 0
        else
          @shake[i] += delta
        end
        if @shake[i] > @shake_power[i] * 2
          @shake_direction[i] = -1
        end
        if @shake[i] < - @shake_power[i] * 2
          @shake_direction[i] = 1
        end
        if @shake_duration[i] >= 1
          @shake_duration[i] -= 1
        end
      end
    end    
    self.x += @shake[0]
    self.y += @shake[1]
  end
  
end
