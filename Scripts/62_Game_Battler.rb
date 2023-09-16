ATB.ver(:Game_Battler1, 1.62)

#==============================================================================
# ■ Game_Battler
#==============================================================================
class Game_Battler < Game_BattlerBase
  attr_accessor :ap
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias :atb_initialize :initialize
  def initialize
    atb_initialize
    @ap = 0
    clear_chant
    @last_choice_target_index = 0
    @next_ap = 0
  end
  #--------------------------------------------------------------------------
  # ● 戦闘終了処理
  #--------------------------------------------------------------------------
  alias :atb_on_battle_end :on_battle_end
  def on_battle_end
    clear_chant
    atb_on_battle_end
  end
  #--------------------------------------------------------------------------
  # ○ 戦闘開始時のＡＰを算出
  #--------------------------------------------------------------------------
  def make_start_ap(mode)
    case mode
    when 1
      rate = Marshal.load(Marshal.dump(ATB::START_AP_RATE_PREEMPTIVE))
    when -1
      rate = Marshal.load(Marshal.dump(ATB::START_AP_RATE_SURPRISE))
    when 0
      rate = Marshal.load(Marshal.dump(ATB::START_AP_RATE_NORMAL))
    end
    rate = start_ap_plus_rate(mode, rate)
    rate = rate[0] + rand(rate[1] + 1)
    @ap = ATB::MAX_AP * rate / 100
  end
  #--------------------------------------------------------------------------
  # ○ メモ欄から補正
  #--------------------------------------------------------------------------
  def start_ap_plus_rate(mode, rate)
    feature_objects.each do |obj|
      plus = obj.start_ap_plus_rate(mode)
      rate[0] += plus[0]
      rate[1] += plus[1]
    end
    2.times do |time|
      rate[time] = 0 if rate[time] < 0
      rate[time] = 100 if rate[time] > 100
    end
    return rate
  end
  
  #--------------------------------------------------------------------------
  # ○ コマンド入力可能判定
  #--------------------------------------------------------------------------
  alias :atb_inputable? :inputable?
  def inputable?
    atb_inputable? && self == BattleManager.input_battler
  end
  #--------------------------------------------------------------------------
  # ● スキル／アイテムの使用
  #    行動側に対して呼び出され、使用対象以外に対する効果を適用する。
  #--------------------------------------------------------------------------
  alias :atb_use_item :use_item
  def use_item(item)
    next_ap = item.next_ap
    @next_ap = next_ap[0] + rand(next_ap[1] + 1)
    @next_ap = [[0, @next_ap].max, ATB::MAX_AP].min
    atb_use_item(item)
  end
  #--------------------------------------------------------------------------
  # ● 全ての再生
  #--------------------------------------------------------------------------
  def regenerate_all_after_action
    if ATB::REGENERATE_TIMING_AFTER
      #  詠唱中でも再生する    or not　行動直後かつ詠唱途中である
      if ATB::CHANT_REGENERATE or not (chanting? and not @act_chant)
        regenerate_all
        SceneManager.scene.log_window.display_auto_affected_status(self)
        SceneManager.scene.log_window.wait_and_clear
      end
    end
  end
  def regenerate_all_before_action
    if not ATB::REGENERATE_TIMING_AFTER
      #  詠唱中でも再生する    or not　行動直前かつ詠唱完了している
      if ATB::CHANT_REGENERATE or not (chanting? and @chant_count >= @max_chant_count)
        regenerate_all
        SceneManager.scene.log_window.display_auto_affected_status(self)
        SceneManager.scene.log_window.wait_and_clear
      end
    end
  end
  #--------------------------------------------------------------------------
  # ○ 戦闘行動終了時の処理
  #--------------------------------------------------------------------------
  def on_action_end
    atb_state_on_action_end
    if not (chanting? and not @act_chant) # 詠唱開始時はターンカウントしない
      @turn_count += 1 if self.is_a?(Game_Enemy)
    end
    regenerate_all_after_action
    if @act_chant
      chant_not_usable
      clear_chant
    end
    @ap = ATB::MAX_AP * @next_ap / 100
    @next_ap = 0
  end
  #--------------------------------------------------------------------------
  # ○ 詠唱失敗時
  #--------------------------------------------------------------------------
  def chant_not_usable
    if @act_chant.is_a?(String)
      SceneManager.scene.log_window.add_text(name + @act_chant) unless @act_chant.empty?
      SceneManager.scene.log_wait
    end
  end
  #--------------------------------------------------------------------------
  # ○ 逃走失敗時　AP変更
  #--------------------------------------------------------------------------
  def escape_failed_reset_ap
    rate =  Marshal.load(Marshal.dump(ATB::ESCAPE_FAILED_AP_RATE))
    feature_objects.each do |obj|
      plus = obj.escape_ap_plus_rate
      rate[0] += plus[0]
      rate[1] += plus[1]
    end
    2.times do |time|
      rate[time] = [rate[time], 0].max
      rate[time] = [rate[time], 100].min
    end
    rate = rate[0] + rand(rate[1] + 1)
    @ap = ATB::MAX_AP * rate / 100
  end
  #--------------------------------------------------------------------------
  # ○ 逃走失敗時　ステートのターン数減少
  #--------------------------------------------------------------------------
  def escape_failed_state_turn_count
    if ATB::ESCAPE_FAILED_STATE_COUNT_1
      update_state_turns(1)
      remove_states_auto(1)
      if ATB::BUFF_TURN_COUNT == 1
        update_buff_turns
        remove_buffs_auto
      end
    end
    if ATB::ESCAPE_FAILED_STATE_COUNT_2
      update_state_turns(2)
      remove_states_auto(2)
      if ATB::BUFF_TURN_COUNT == 2
        update_buff_turns
        remove_buffs_auto
      end
    end
    if ATB::ESCAPE_FAILED_STATE_COUNT_3
      states.each do |state|
        if state.auto_removal_timing == 3
          update_turnframe_state_turns(state, false)
          remove_turnframe_state_by_turn(state)
        end
      end
    end
    SceneManager.scene.refresh_status
    SceneManager.scene.log_window.display_affected_status(self, nil)
    SceneManager.scene.original_log_wait_and_clear
    @result.clear_status_effects
  end
end

class RPG::UsableItem
  def next_ap
    return @note =~ /<行動後ＡＰ=\[(\d+),(\d+)\]>/ ? [$1.to_i, $2.to_i] : [0, 0]
  end
end
class RPG::BaseItem
  def start_ap_plus_rate(mode)
    case mode
    when 1
      return @note =~ /<開始ＡＰ=1,\[(\-*\d+),(\-*\d+)\]>/ ? [$1.to_i, $2.to_i] : [0, 0]
    when -1
      return @note =~ /<開始ＡＰ=-1,\[(\-*\d+),(\-*\d+)\]>/ ? [$1.to_i, $2.to_i] : [0, 0]
    when 0
      return @note =~ /<開始ＡＰ=0,\[(\-*\d+),(\-*\d+)\]>/ ? [$1.to_i, $2.to_i] : [0, 0]
    end
  end
  def escape_ap_plus_rate
    return @note =~ /<逃走ＡＰ=\[(\-*\d+),(\-*\d+)\]>/ ? [$1.to_i, $2.to_i] : [0, 0]
  end
end

#==============================================================================
# ■ Game_Interpreter
#==============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● 戦闘行動の強制
  #--------------------------------------------------------------------------
  def command_339
    iterate_battler(@params[0], @params[1]) do |battler|
      next if battler.death_state?
      battler.force_action(@params[2], @params[3])
      BattleManager.force_action(battler)
    end
  end
end
#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● 強制された戦闘行動の処理
  #--------------------------------------------------------------------------
  def process_forced_action
    if BattleManager.act_forced_battler
      BattleManager.clear_action_force
      turn_start
      return true
    end
    return false
  end
end
#==============================================================================
# ■ Game_Unit
#==============================================================================
class Game_Unit
  #--------------------------------------------------------------------------
  # ● 戦闘行動の作成
  #--------------------------------------------------------------------------
  def make_actions
    members.each do |member|
      next if member.current_action and member.current_action.forcing
      member.make_actions
    end
  end
end

#==============================================================================
# ■ Game_Battler
#==============================================================================
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :turn_count
  #--------------------------------------------------------------------------
  # ● 戦闘開始処理
  #--------------------------------------------------------------------------
  alias :atb_on_battle_start :on_battle_start
  def on_battle_start
    atb_on_battle_start
    @turn_count = 1
  end
end
#==============================================================================
# ■ Game_Enemy
#==============================================================================
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # ● 行動条件合致判定［ターン数］
  #--------------------------------------------------------------------------
  def conditions_met_turns?(param1, param2)
    n = @turn_count
    if param2 == 0
      n == param1
    else
      n > 0 && n >= param1 && n % param2 == param1 % param2
    end
  end
end