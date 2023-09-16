ATB.ver(:state_turn_frame, 1.62)

#==============================================================================
# ■ Game_Battler
#==============================================================================
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # ● ステート情報をクリア
  #--------------------------------------------------------------------------
  alias :atb_clear_states :clear_states
  def clear_states
    atb_clear_states
    @state_frames = {}
  end
  #--------------------------------------------------------------------------
  # ● ステートの消去
  #--------------------------------------------------------------------------
  alias :atb_erase_state :erase_state
  def erase_state(state_id)
    atb_erase_state(state_id)
    @state_frames.delete(state_id)
  end
  #--------------------------------------------------------------------------
  # ● ステートのカウント（ターン数および歩数）をリセット
  #--------------------------------------------------------------------------
  alias :atb_reset_state_counts :reset_state_counts
  def reset_state_counts(state_id)
    atb_reset_state_counts(state_id)
    @state_frames[state_id] = $data_states[state_id].turn_frame
  end
  #--------------------------------------------------------------------------
  # ● ステートのターンカウント更新
  #     timing : タイミング（1:行動終了 2:ターン終了）
  #              (3:ターンフレーム)に対してこのメソッドは実行されない
  #--------------------------------------------------------------------------
  def update_state_turns(timing)
    states.each do |state|
      next if state.auto_removal_timing != timing
      @state_turns[state.id] -= 1 if @state_turns[state.id] > 0
    end
  end
  #--------------------------------------------------------------------------
  # ○ 戦闘行動終了時の処理
  #--------------------------------------------------------------------------
  def atb_state_on_action_end
    @result.clear
    if ATB::CHANT_STATE_TURN_COUNT or not (chanting? and not @act_chant)
      # 詠唱開始時は CHANT_STATE_TURN_COUNT がtrueでなければ
      # ステートの残りターン数を更新しない
      update_state_turns(1)
      remove_states_auto(1)
    end
    if ATB::BUFF_TURN_COUNT == 1
      update_buff_turns
      remove_buffs_auto
    end
  end
  #--------------------------------------------------------------------------
  # ● ターン終了処理
  #--------------------------------------------------------------------------
  def on_turn_end
    @result.clear
    update_state_turns(2)
    remove_states_auto(2)
    if ATB::BUFF_TURN_COUNT == 2
      update_buff_turns
      remove_buffs_auto
    end
  end
  #--------------------------------------------------------------------------
  # ● 行動前に解除
  #--------------------------------------------------------------------------
  def remove_states_before_action
    flag = false
    states.each do |state|
      next unless [1, 2].include?(state.auto_removal_timing)
      if @state_turns[state.id] == 1 and state.note =~ /<次の行動前に解除>/
        remove_state(state.id)
        flag = true
      end
    end
    return flag
  end
  #--------------------------------------------------------------------------
  # ● 全ての再生
  #--------------------------------------------------------------------------
  def regenerate_all
    if alive?
      a = [hp, mp, tp]
      regenerate_hp
      regenerate_mp
      regenerate_tp
      hp_damage = (hp - a[0]).to_i
      mp_damage = (mp - a[1]).to_i
      tp_damage = (tp - a[2]).to_i
      if (hp_damage != 0 or mp_damage != 0 or tp_damage != 0) and
          SceneManager.scene_is?(Scene_Battle)
        SceneManager.scene.refresh_status
        p ["行動ごとの再生", name, "HP再生", hp_damage, "MP再生", mp_damage, "TP再生", tp_damage]
        display_state_regenerate(hp_damage, mp_damage, tp_damage, 0)
        SceneManager.scene.log_wait_and_clear
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ターンフレームステートのターンカウント更新
  #--------------------------------------------------------------------------
  def update_turnframe_state_turns(state, flag)
    if state.auto_remove? and @state_turns[state.id] > 0
      @state_turns[state.id] -= 1
    end
    if flag
      @state_frames[state.id] += state.turn_frame
    else
      @state_frames[state.id]  = state.turn_frame
    end
  end
  #--------------------------------------------------------------------------
  # ● ターンフレームステートのターンカウントによる解除
  #--------------------------------------------------------------------------
  def remove_turnframe_state_by_turn(state)
    if @state_turns[state.id] <= 0
      remove_state(state.id) if state.auto_remove?
    end
  end
  #--------------------------------------------------------------------------
  # ● 再生
  #--------------------------------------------------------------------------
  def frame_state_regenerate(state)
    return if @state_turns[state.id] == nil or @state_turns[state.id] <= 0
    regene = state.frame_regenerate
    return if regene == false
    hp_damage = -(mhp * regene[0] / 100)
    hp_damage = [hp_damage, max_slip_damage].min
    mp_damage = -(mmp * regene[1] / 100)
    tp_damage = -(max_tp * regene[2] / 100)
    self.hp -= hp_damage
    self.mp -= mp_damage
    self.tp -= tp_damage
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新　ステートのフレーム経過
  #--------------------------------------------------------------------------
  def state_frame_update
    @result.clear_status_effects
    a = [hp, mp, tp]
    flag = false
    states.each do |state|
      next if state.auto_removal_timing != 3
      @state_frames[state.id]  ||= state.turn_frame   # nil(未代入)なら代入
      @state_frames[state.id]   -= ATB::REFRESH_FRAME # フレーム更新
      if @state_frames[state.id] <= 0 and @state_turns[state.id] > 0
        update_turnframe_state_turns(state, true)
        remove_turnframe_state_by_turn(state)
        frame_state_regenerate(state)
        flag = true
      end
    end
    if flag == true
      SceneManager.scene.refresh_status
      hp_change = (hp - a[0]).to_i
      mp_change = (mp - a[1]).to_i
      tp_change = (tp - a[2]).to_i
      p ["ターンフレーム再生", name, "HP再生", hp_change, "MP再生", mp_change, "TP再生", tp_change]
      display_state_regenerate(hp_change, mp_change, tp_change, 1)
      SceneManager.scene.log_window.display_affected_status(self, nil)
      SceneManager.scene.log_wait_and_clear
      @result.clear_status_effects
      BattleManager.judge_win_loss  # 再生による全滅判定
    end
  end
  #--------------------------------------------------------------------------
  # ● 再生結果を表示
  #    mode:1なら通常再生 2ならターンフレーム再生
  #--------------------------------------------------------------------------
  def display_state_regenerate(hp_change, mp_change, tp_change, mode)
    return if enemy? and not ATB::ENEMY_REGENERATE_SHOW
    flag = display_state_regenerate_sv_pop(hp_change, mp_change, tp_change, mode)
    return if flag
    display_state_regenerate_message(hp_change, mp_change, tp_change, mode)
  end
  #--------------------------------------------------------------------------
  # ● 再生結果を表示　サイドビューのポップアップ
  #--------------------------------------------------------------------------
  def display_state_regenerate_sv_pop(hp_change, mp_change, tp_change, mode)
    return false
  end
  #--------------------------------------------------------------------------
  # ● 再生結果を表示　デフォルトのバトルログ
  #--------------------------------------------------------------------------
  def display_state_regenerate_message(hp_change, mp_change, tp_change, mode)
    case mode
    when 0; show_setting = ATB::REGENERATE_SHOW_NORMAL
    when 1; show_setting = ATB::REGENERATE_SHOW_FRAME
    end
    flag = false
    if    hp_change > 0 and show_setting[0]
      text = sprintf(state_regenerate_message_set(0), name,  hp_change)
      SceneManager.scene.log_window.add_text(text)
      SceneManager.scene.log_wait
      flag = true
    elsif hp_change < 0 and show_setting[1]
      text = sprintf(state_regenerate_message_set(1), name, -hp_change)
      SceneManager.scene.log_window.add_text(text)
      SceneManager.scene.log_wait
      flag = true
    end
    if    mp_change > 0 and show_setting[2]
      text = sprintf(state_regenerate_message_set(2), name,  mp_change)
      SceneManager.scene.log_window.add_text(text)
      SceneManager.scene.log_wait
      flag = true
    elsif mp_change < 0 and show_setting[3]
      text = sprintf(state_regenerate_message_set(3), name, -mp_change)
      SceneManager.scene.log_window.add_text(text)
      SceneManager.scene.log_wait
      flag = true
    end
    if    tp_change > 0 and show_setting[4]
      text = sprintf(state_regenerate_message_set(4), name,  tp_change)
      SceneManager.scene.log_window.add_text(text)
      SceneManager.scene.log_wait
      flag = true
    elsif tp_change < 0 and show_setting[5]
      text = sprintf(state_regenerate_message_set(5), name, -tp_change)
      SceneManager.scene.log_window.add_text(text)
      SceneManager.scene.log_wait
      flag = true
    end
    SceneManager.scene.log_wait if flag
  end
  #--------------------------------------------------------------------------
  # ● 再生結果メッセージ
  #--------------------------------------------------------------------------
  def state_regenerate_message_set(id)
    case id
    when 0; return  "%s recovered %s HP!"
    when 1; return  "%s took %s damage!"
    when 2; return  "%s recovered %s MP!"
    when 3; return  "%s lost %s MP!"
    when 4; return  "%s recovered %s TP!"
    when 5; return  "%s lost %s TP!"
    end
  end
end
#==============================================================================
# ■ Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ● マップ画面上でのターン終了処理
  #--------------------------------------------------------------------------
  def turn_end_on_map
    if $game_party.steps % steps_for_turn == 0
      @result.clear
      regenerate_all
      update_state_turns(1) # 行動終了時
      update_state_turns(2) # ターン終了時
      flag = state_frame_update_on_map
      perform_map_damage_effect if @result.hp_damage > 0 or flag
      remove_states_auto(1)
      remove_states_auto(2)
      remove_states_auto(3)
    end
  end
  #--------------------------------------------------------------------------
  # ● マップ画面上でのターン経過処理　フレーム経過ステート
  #--------------------------------------------------------------------------
  def state_frame_update_on_map
    a = hp
    states.each do |state|
      if state.auto_removal_timing == 3
        update_turnframe_state_turns(state, false)
        remove_turnframe_state_by_turn(state)
        frame_state_regenerate(state)
      end
    end
    return hp < a # ＨＰが減ったかどうか
  end
end

class RPG::State
  def regenerate_timing_before
    return true if @note =~ /<行動前に再生>/
  end
  def regenerate_timing_after
    return true if @note =~ /<行動後に再生>/
  end
  def auto_removal_timing
    unless @atb_auto_removal_timing
      if @note =~ /<ターンフレーム=(\d+)>/
        @atb_auto_removal_timing = 3
      else
        @atb_auto_removal_timing = @auto_removal_timing
      end
    end
    return @atb_auto_removal_timing
  end
  def auto_remove?
    return false if @auto_removal_timing == 0
    return true
  end
  def turn_frame
    return @note =~ /<ターンフレーム=(\d+)>/ ? $1.to_i : 360000
  end
  def frame_regenerate
    return @note =~ /<フレーム再生=(\-*\d+),(\-*\d+),(\-*\d+)>/ ?
                    [$1.to_i, $2.to_i, $3.to_i] : false
  end
end
#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  attr_accessor :log_window
end

#==============================================================================
# ■ Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ● ＡＴＢ不使用あるいはＡＴＢ過去版からのセーブデータ引継ぎ時のデータ修正
  #--------------------------------------------------------------------------
  def reset_variable_state_frames
    if @state_frames == nil
      if @state_flames  # 過去版　表記揺れ
        @state_frames = @state_flames
        @state_flames = nil
      else  # 不使用
        @state_frames = {}
      end
    end
  end
end
#==============================================================================
# ■ Game_Actors
#==============================================================================
class Game_Actors
  #--------------------------------------------------------------------------
  # ● ＡＴＢ不使用あるいはＡＴＢ過去版からのセーブデータ引継ぎ時のデータ修正
  #--------------------------------------------------------------------------
  def reset_variable_state_frames
    @data.each do |actor|
      next if actor == nil
      actor.reset_variable_state_frames
    end
  end
end
#==============================================================================
# ■ Scene_Load
#==============================================================================
class Scene_Load < Scene_File
  #--------------------------------------------------------------------------
  # ● ロード成功時の処理
  #--------------------------------------------------------------------------
  alias :atb_on_load_success :on_load_success
  def on_load_success
    $game_actors.reset_variable_state_frames
    atb_on_load_success
  end
end