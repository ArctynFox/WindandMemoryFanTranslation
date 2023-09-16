#==============================================================================
# ■ Window_BattleEnemy
#------------------------------------------------------------------------------
# 　バトル画面で、行動対象の敵キャラを選択するウィンドウです。
#==============================================================================

class Window_BattleEnemy < Window_Selectable

  #--------------------------------------------------------------------------
  # ● ウィンドウの表示
  #--------------------------------------------------------------------------
  alias show2 show
  def show
    @target_anim_on = true
    @old_index = nil
    show2
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウの非表示
  #--------------------------------------------------------------------------
  alias hide2 hide
  def hide
    old_enemy.sprite_effect_type = :whiten_loop_stop if @old_index != nil
    enemy.sprite_effect_type = :whiten_loop_stop
    @target_anim_on = false
    @old_index = nil
    hide2
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウの更新
  #--------------------------------------------------------------------------
  def update
    super
    update_target_anim
  end
  #--------------------------------------------------------------------------
  # ● ターゲットアニメの更新
  #--------------------------------------------------------------------------
  def update_target_anim
    return if @target_anim_on == nil
    if @target_anim_on && @index != @old_index
      old_enemy.sprite_effect_type = :whiten_loop_stop if @old_index != nil
      enemy.sprite_effect_type = :whiten_loop
    end
    @old_index = @index    
  end
  #--------------------------------------------------------------------------
  # ● 前の敵キャラオブジェクト取得
  #--------------------------------------------------------------------------
  def old_enemy
    $game_troop.alive_members[@old_index]
  end

end

#==============================================================================
# ■ Sprite_Battler
#------------------------------------------------------------------------------
# 　バトラー表示用のスプライトです。Game_Battler クラスのインスタンスを監視し、
# スプライトの状態を自動的に変化させます。
#==============================================================================
class Sprite_Battler < Sprite_Base

  #--------------------------------------------------------------------------
  # ● エフェクトの開始
  #--------------------------------------------------------------------------
  def start_effect(effect_type)
    @effect_type = effect_type
    case @effect_type
    when :appear
      @effect_duration = 16
      @battler_visible = true
    when :disappear
      @effect_duration = 32
      @battler_visible = false
    when :whiten
      @effect_duration = 16
      @battler_visible = true
    when :blink
      @effect_duration = 20
      @battler_visible = true
    when :collapse
      @effect_duration = 48
      @battler_visible = false
    when :boss_collapse
      @effect_duration = bitmap.height
      @battler_visible = false
    when :instant_collapse
      @effect_duration = 16
      @battler_visible = false
    when :whiten_loop
      @whiten_cnt = 0.0
      @effect_duration = -1
      @battler_visible = true
    when :whiten_loop_stop
      @effect_duration = -1
    end
    revert_to_normal
  end
  #--------------------------------------------------------------------------
  # ● エフェクトの更新
  #--------------------------------------------------------------------------
  alias update_effect2 update_effect
  def update_effect
    update_effect2
    if @effect_duration < 0
      case @effect_type
      when :whiten_loop
        update_whiten_loop
      when :whiten_loop_stop
        update_whiten_loop_stop
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 選択時のエフェクト
  #--------------------------------------------------------------------------
  def update_whiten_loop
    d=(-90+@whiten_cnt/180)*Math::PI
    col = 255 * Math.sin(d)
    @whiten_cnt += 6
    @whiten_cnt %= 180        
    self.color.set(col, col, col, col)
  end
  #--------------------------------------------------------------------------
  # ● 選択時のエフェクト終了
  #--------------------------------------------------------------------------
  def update_whiten_loop_stop
    @whiten_cnt = 0.0
    self.color.set(0, 0, 0, 0)
    @effect_duration = 0
    @effect_type = nil
  end

end
