ATB.ver(:ap_control_state, 1.71)



module ATB
  
  CONTROL_RESIST_STATE = []   # この行は変更しないでください
  
  # 1:戦闘不能
  #31:なぎ払い
  #32:マジックキャンセル
  #33:突撃の号令
  #34:スタンアタック
  #39:ストーン
  
  # ここに含まれるステートによる増減にのみ、対抗する
  CONTROL_RESIST_STATE[0] = [0,]
  
  CONTROL_RESIST_STATE[1] = [ ]  # 「魔道の真髄」用
    # 31なぎ払い、33突撃の号令、34スタンアタック　の増減キャンセル効果は防ぐが、
    # 32マジックキャンセル、39ストーン　のキャンセル効果は防がず、詠唱終了する
  CONTROL_RESIST_STATE[2] = []  # 「孤高の指輪」用
    # 39突撃の号令　の効果のみを防ぐ
  
  
    
  #詠唱キャンセルが効いた時に解除されるステート
  CHANT_CANCEL_REMOVE_STATE = []  # 44:魔道の真髄
  
  
end



#==============================================================================
# ■ Game_Battler
#==============================================================================
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # ● ステートの付加
  #--------------------------------------------------------------------------
  def add_state(state_id)
    if state_addable?(state_id)
      add_new_state(state_id) unless state?(state_id)
      add_state_ap_control(state_id)
      reset_state_counts(state_id)
      @result.added_states.push(state_id).uniq!
    end
  end
  #--------------------------------------------------------------------------
  # ● ステートの付加
  #--------------------------------------------------------------------------
  def add_state_ap_control(state_id)
    state = $data_states[state_id]
    types = state.chant_control_type
    chant_type_include = (types.empty? or types.include?(@chant_type))
    chant_control = (chanting? and chant_type_include)
    state_chant_cancel(state_id)   if chant_control and state.chant_cancel
    state_chant_control(state_id)  if chant_control and state.chant_control
    state_ap_control(state_id)     if not chanting? and state.ap_control
  end
  #--------------------------------------------------------------------------
  # ● 詠唱キャンセル
  #--------------------------------------------------------------------------
  def state_chant_cancel(state_id)
    state = $data_states[state_id]
    feature_objects.each do |obj|
      resist = obj.state_chant_cancel_resist
      next if ap_control_no_resist?(resist, state_id)
      return if resist[1] > rand(100)
    end
    clear_chant
    message = state.chant_cancel_message
    @result.chant_cancel_state_messages.push(message).uniq! if message
    ATB::CHANT_CANCEL_REMOVE_STATE.each {|state_id| remove_state(state_id)}
  end
  #--------------------------------------------------------------------------
  # ● 詠唱増減
  #--------------------------------------------------------------------------
  def state_chant_control(state_id)
    state = $data_states[state_id]
    control = state.chant_control
    
    resist_rate = ap_control_resist_rate(state_id, control)
    return if resist_rate.zero?
    rate = control[1] + rand(control[2] + 1)
    result = @max_chant_count * (rate * 0.01) * resist_rate
    result = result.to_i
    
    @chant_count = control[0] == "0" ? result : @chant_count + result
    @chant_count = [[0, @chant_count].max, @max_chant_count].min
    message = state.chant_control_message
    @result.chant_control_state_messages.push(message).uniq! if message
  end
  #--------------------------------------------------------------------------
  # ● ＡＰ増減
  #--------------------------------------------------------------------------
  def state_ap_control(state_id)
    state = $data_states[state_id]
    control = state.ap_control
    
    resist_rate = ap_control_resist_rate(state_id, control)
    return if resist_rate.zero?
    rate = control[1] + rand(control[2] + 1)
    result = ATB::MAX_AP * (rate * 0.01) * resist_rate
    result = result.to_i
    
    @ap = control[0] == "0" ? result : @ap + result
    @ap = [[0, @ap].max, ATB::MAX_AP].min
    message = state.ap_control_message
    @result.ap_control_state_messages.push(message).uniq! if message
  end
  
  #--------------------------------------------------------------------------
  # ● 対抗率（増減値に乗算する）
  #--------------------------------------------------------------------------
  def ap_control_resist_rate(state_id, control)
    resist_rate = 1.0
    feature_objects.each do |obj|
      resist = obj.obj_state_ap_control_resist(control[0] == "0", chanting?)
      next if ap_control_no_resist?(resist, state_id)
      if control[0] == "0"
        return 0.0 if resist[1] > rand(100)
      else
        resist_rate *= resist[1]
      end
    end
    return resist_rate
  end
  #--------------------------------------------------------------------------
  # ● 対抗不可能かどうか
  #--------------------------------------------------------------------------
  def ap_control_no_resist?(resist, state_id)
    return true if resist == nil
    p [1, name, resist[0], state_id]
    return true if !ATB::CONTROL_RESIST_STATE[resist[0]].include?(state_id)
    p [2, name, resist[0], state_id]
    return true if chanting? and !resist[2].empty? and !resist[2].include?(@chant_type)
    return false
  end
end
#==============================================================================
# ■ Window_BattleLog
#==============================================================================
class Window_BattleLog < Window_Selectable
  #--------------------------------------------------------------------------
  # ● 影響を受けたステータスの表示
  #--------------------------------------------------------------------------
  def display_affected_status(target, item)
    if target.result.status_affected?
      add_text("") if line_number < max_line_number
      display_changed_states(target)
      display_changed_buffs(target)
      display_added_ap_control_states(target)
    end
  end
  #--------------------------------------------------------------------------
  # ● ＡＰ・詠唱増減が適用されたなら増減時メッセージを表示
  #--------------------------------------------------------------------------
  def display_added_ap_control_states(target)
    messages  = target.result.chant_cancel_state_messages
    messages += target.result.chant_control_state_messages
    messages += target.result.ap_control_state_messages
    
    if messages[0] == nil
      back_one if last_text == nil or last_text.empty?
      return
    end
    wait if (last_text != nil and not last_text.empty?)
    back_one
    last_number = line_number
    messages.each do |message|
      back_to(last_number) if line_number == max_line_number
      add_text(target.name + message)
      wait
    end
    wait
  end
end
#==============================================================================
# ■ Game_ActionResult
#==============================================================================
class Game_ActionResult
  attr_accessor :chant_cancel_state_messages
  attr_accessor :chant_control_state_messages
  attr_accessor :ap_control_state_messages
  #--------------------------------------------------------------------------
  # ● ステータス効果のクリア
  #--------------------------------------------------------------------------
  alias :atb_clear_status_effects :clear_status_effects
  def clear_status_effects
    atb_clear_status_effects
    clear_ap_control_state_messages
  end
  def clear_ap_control_state_messages
    @chant_cancel_state_messages = []
    @chant_control_state_messages = []
    @ap_control_state_messages = []
  end
end

class RPG::State
  def ap_control
    return @note =~ /<ＡＰ増減=(\d+),\[(\-*\d+),(\d+)\]>/ ? [$1, $2.to_i, $3.to_i] : nil
  end
  def chant_control
    return @note =~ /<詠唱増減=(\d+),\[(\-*\d+),(\d+)\]>/ ? [$1, $2.to_i, $3.to_i] : nil
  end
  def chant_cancel
    return @note =~ /<詠唱キャンセル>/ ? true : nil
  end
  def chant_control_type
    return @note =~ /<詠唱増減タイプ=(\[[\d,]+\])>/ ? eval($1) : []
  end
  
  def ap_control_message
    return @note =~ /<ＡＰ増減文=(\S+)>/ ? $1 : nil
  end
  def chant_control_message
    return @note =~ /<詠唱増減文=(\S+)>/ ? $1 : nil
  end
  def chant_cancel_message
    return @note =~ /<詠唱中止文=(\S+)>/ ? $1 : nil
  end
end


class RPG::BaseItem
  def state_ap_control_resist_0
    return @note =~ /<ＡＰ増減0対抗=(\d+),(\d+)>/ ?
                      [$1.to_i, $2.to_i] : nil
  end
  def state_ap_control_resist_1
    return @note =~ /<ＡＰ増減1対抗=(\d+),(\-*\d+)>/ ?
                      [$1.to_i, $2.to_i * 0.01] : nil
  end
  def state_chant_control_resist_0
    return @note =~ /<詠唱増減0対抗=(\d+),(\d+),(\[[\d,]*\])>/ ?
                      [$1.to_i, $2.to_i, eval($3)] : nil
  end
  def state_chant_control_resist_1
    return @note =~ /<詠唱増減1対抗=(\d+),(\-*\d+),(\[[\d,]*\])>/ ?
                      [$1.to_i, $2.to_i * 0.01, eval($3)] : nil
  end
  def state_chant_cancel_resist
    return @note =~ /<詠唱中止対抗=(\d+),(\d+),(\[[\d,]*\])>/ ?
                      [$1.to_i, $2.to_i, eval($3)] : nil
  end
  
  def obj_state_ap_control_resist(control_0, chanting)
    if control_0
      return chanting ? state_chant_control_resist_0 : state_ap_control_resist_0
    else
      return chanting ? state_chant_control_resist_1 : state_ap_control_resist_1
    end
  end
end