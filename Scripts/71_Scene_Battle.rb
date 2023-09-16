ATB.ver(:Scene_Battle, 1.71)

#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias :atb_initialize :initialize
  def initialize
    atb_initialize
    @atb_wait_flag = false
    $game_temp.last_battler_identifier = nil
  end
  #--------------------------------------------------------------------------
  # ○ ウェイト
  #--------------------------------------------------------------------------
  def log_wait
    @log_window.wait
  end
  #--------------------------------------------------------------------------
  # ○ ウェイト
  #--------------------------------------------------------------------------
  def log_wait_and_clear
    @log_window.wait_and_clear
  end
  #--------------------------------------------------------------------------
  # ○ ウェイトとクリア
  #    サイドビューでは Window_BattleLog の wait_and_clear が再定義されるので
  #    サイドビューに対応しやすいように同じ処理のメソッドを作ってそれを使う
  #--------------------------------------------------------------------------
  def original_log_wait_and_clear(time = @log_window.message_speed)
    wait(time * 2) if @log_window.line_number > 0
    @log_window.clear
  end
  #--------------------------------------------------------------------------
  # ● 前のコマンド入力へ
  #--------------------------------------------------------------------------
  def prior_command
    BattleManager.actor.prior_command
    start_actor_command_selection
  end
  #--------------------------------------------------------------------------
  # ● パーティコマンド選択の開始
  #--------------------------------------------------------------------------
  def start_party_command_selection
    unless scene_changing?
      refresh_status
      @status_window.unselect
      @status_window.open
      wait(@atb_wait_flag ? ATB::GAUGE_START_WAIT : ATB::BATTLE_START_WAIT)
      @atb_wait_flag = true
      
      battlers_ap_cancel_reduce
      while BattleManager.make_action_orders == []
        refresh_ap
        ATB::REFRESH_FRAME.times { update_for_wait }
        battlers_frame_update
      end
      battlers_ap_reduce
      refresh_ap
      
      process_before_action
      
      return if process_forced_action
      if BattleManager.input_start
        BattleManager.next_command
        start_actor_command_selection
      else
        turn_start
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 行動直前の処理
  #--------------------------------------------------------------------------
  def process_before_action
    battler = BattleManager.make_action_orders[0]
    return if $game_temp.last_battler_identifier == battler.atb_identifier(0)
    $game_temp.last_battler_identifier = battler.atb_identifier(0)
    # 行動直前に再生 REGENERATE_TIMING_AFTER
    battler.regenerate_all_before_action
    if !battler.chanting?
      # ステート<次の行動前に解除>
      if battler.remove_states_before_action
        @log_window.display_affected_status(BattleManager.input_battler, nil)
        refresh_status
        log_wait_and_clear
        BattleManager.input_battler.result.clear_status_effects
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ターン開始
  #--------------------------------------------------------------------------
  def turn_start
    @party_command_window.close
    @actor_command_window.close
    @status_window.unselect
    @subject =  nil
    
    @chant_battler = BattleManager.input_battler
    if @chant_battler and @chant_battler.current_action and 
       @chant_battler.current_action.item and
       @chant_battler.current_action.item.chant
      
      object = @chant_battler.current_action.item
      @chant_battler.set_chant(object)
      
      abs_wait_short unless @chant_battler.enemy?
      @chant_battler.sprite_effect_type = :whiten
      display_chant_message(object)
      
      animation_id = @chant_battler.chant_object.chant_animation
      if animation_id == nil
        animation_id = ATB::CHANT_START_ANIMATION_DEFAULT[@chant_battler.chant_type]
      end
      if animation_id != nil
        SceneManager.scene.show_animation([@chant_battler], animation_id)
      end
      @log_window.display_affected_status(@chant_battler, nil)
      log_wait if @chant_battler.result.status_affected?
      @chant_battler.actions.clear
      chant_display_end_item
    end
    @chant_battler = nil
    BattleManager.turn_start
  end
  #--------------------------------------------------------------------------
  # ○ 敵味方合わせた全バトルメンバーの取得
  #--------------------------------------------------------------------------
  def all_movable_members
    $game_party.movable_members + $game_troop.movable_members
  end
  #--------------------------------------------------------------------------
  # ○ 敵味方合わせた全生存メンバーの取得
  #--------------------------------------------------------------------------
  def all_alive_members
    $game_party.alive_members + $game_troop.alive_members
  end
  #--------------------------------------------------------------------------
  # ○ AP増加
  #--------------------------------------------------------------------------
  def battlers_frame_update
    all_alive_members.each do |member|
      member.frame_update
    end
  end
  #--------------------------------------------------------------------------
  # ● コマンド［逃げる］
  #--------------------------------------------------------------------------
  def command_escape
    if ATB.xp_style?
      @party_command_window.close
      @party_command_window.openness = 0 if LNX11::MESSAGE_TYPE == 2
      @status_window.unselect
    end
    return if BattleManager.process_escape
    @escaped = true
    turn_start
    $game_party.members.each do |member|
      member.escape_failed_state_turn_count
    end
    $game_party.members.each do |member|
      member.escape_failed_reset_ap
    end
    refresh_status
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動終了時の処理
  #--------------------------------------------------------------------------
  alias :atb_process_action_end :process_action_end
  def process_action_end
    if @escaped
      @escaped = nil
      return
    end
    return if $game_temp.last_battler_identifier == @subject.atb_identifier(1)
    $game_temp.last_battler_identifier = @subject.atb_identifier(1)
    atb_process_action_end
  end
  #--------------------------------------------------------------------------
  # ○ ＡＰを削る
  #--------------------------------------------------------------------------
  def battlers_ap_reduce
    all_alive_members.each do |battler|
      battler.ap_reduce if battler != BattleManager.action_battler
    end
  end
  def battlers_ap_cancel_reduce
    all_alive_members.each do |battler|
      battler.ap_cancel_reduce
    end
  end
end
#==============================================================================
# ■ Game_Battler
#==============================================================================
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # ○ ＡＰを削る
  #--------------------------------------------------------------------------
  def ap_reduce
    if chanting?
      @chant_count = @max_chant_count - 1 if @chant_count >= @max_chant_count
    else
      @ap          = ATB::MAX_AP      - 1 if @ap          >= ATB::MAX_AP
    end
  end
  def ap_cancel_reduce
    if chanting?
      @chant_count = @max_chant_count     if @chant_count == @max_chant_count - 1
    else
      @ap          = ATB::MAX_AP          if @ap          == ATB::MAX_AP      - 1
    end
  end
  #--------------------------------------------------------------------------
  # ○ 「最後に行動開始・終了したバトラー」の識別子
  #--------------------------------------------------------------------------
  def atb_identifier(n)
    return [n, !enemy?, (enemy? ? @index : @actor_id)]
  end
end

#==============================================================================
# ■ BattleManager
#==============================================================================
module BattleManager
  #--------------------------------------------------------------------------
  # ● 戦闘開始
  #--------------------------------------------------------------------------
  class << self
    alias :atb_battle_start :battle_start
  end
  def self.battle_start
    make_battlers_ap
    atb_battle_start
    @preemptive = false
    @surprise = false
  end
  #--------------------------------------------------------------------------
  # ○ ＡＰ作成
  #--------------------------------------------------------------------------
  def self.make_battlers_ap
    mode = (@preemptive ? 1 : (@surprise ? -1 : 0))
    $game_party.members.each {|member| member.make_start_ap(mode)}
    $game_troop.members.each {|member| member.make_start_ap(mode * -1)}
  end
  #--------------------------------------------------------------------------
  # ○ 判定するバトラーを取得
  #--------------------------------------------------------------------------
  def self.check_members
    return $game_party.alive_members + $game_troop.alive_members
  end
  #--------------------------------------------------------------------------
  # ○ 行動選択可能なバトラーを取得
  #--------------------------------------------------------------------------
  def self.input_battler
    return check_members.find {|battler| battler.ap >= ATB::MAX_AP }
  end
  #--------------------------------------------------------------------------
  # ○ 詠唱完了したバトラーを取得
  #--------------------------------------------------------------------------
  def self.act_chant_battler
    return check_members.find {|battler| battler.act_chant? }
  end
  #--------------------------------------------------------------------------
  # ○ 行動順序の作成
  #--------------------------------------------------------------------------
  def self.act_forced_battler
    return @action_forced if @action_forced and @action_forced.ap >= ATB::MAX_AP
    return nil
  end
  #--------------------------------------------------------------------------
  # ○ 行動順序の作成
  #--------------------------------------------------------------------------
  def self.action_battler
    return [act_forced_battler, act_chant_battler, input_battler].compact[0]
  end
  #--------------------------------------------------------------------------
  # ○ 行動順序の作成
  #--------------------------------------------------------------------------
  def self.make_action_orders
    @action_battlers = [action_battler].compact
    return @action_battlers
  end
end
#==============================================================================
# ■ Game_Temp
#==============================================================================
class Game_Temp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :last_battler_identifier
end