ATB.ver(:Game_Battler3_chant, 1.71)

#==============================================================================
# ■ Game_Battler
#==============================================================================
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :chant_object
  attr_reader   :chant_type
  attr_accessor :last_choice_target_index
  #--------------------------------------------------------------------------
  # ○ 詠唱用パラメータをクリア
  #--------------------------------------------------------------------------
  def clear_chant
    @chant_states.each {|id| remove_state(id) } if @chant_states
    @chant_object = nil
    @chant_type   = nil
    @chant_count  = nil
    @max_chant_count      = nil
    @chant_action_forced  = false
    @chant_target_index   = nil
    @act_chant = false
    @chant_states = nil
  end
  #--------------------------------------------------------------------------
  # ○ 詠唱中判定
  #--------------------------------------------------------------------------
  def chanting?
    @chant_type
  end
  #--------------------------------------------------------------------------
  # ○ 詠唱開始
  #--------------------------------------------------------------------------
  def set_chant(object)
    chant_param   = object.chant
    @chant_object = object
    @chant_type   = chant_param[0]
    @chant_count  = 0
    @max_chant_count      = chant_param[1] + rand(chant_param[2] + 1)
    @chant_action_forced  = true if current_action.forcing
    @chant_target_index   = current_action.target_index
    @chant_states = []
    feature_objects.unshift(@chant_object).each do |object|
      object.chant_states(@chant_type).each {|id| @chant_states.push(id) }
    end
    @chant_states.uniq!
    @chant_states.each {|id| add_state(id) }
  end
  #--------------------------------------------------------------------------
  # ○ 詠唱完了判定
  #--------------------------------------------------------------------------
  def act_chant?
    return false if !chanting? or @chant_count < @max_chant_count
    chant_force_action if BattleManager.in_turn?
    return true
  end
  #--------------------------------------------------------------------------
  # ○ 詠唱完了：戦闘行動の強制
  #--------------------------------------------------------------------------
  def chant_force_action
    clear_actions
    action = Game_Action.new(self, @chant_action_forced ? true : "chant")
    if @chant_object.is_a?(RPG::Skill)
      action.set_skill(@chant_object.id)
    elsif @chant_object.is_a?(RPG::Item)
      action.set_item(@chant_object.id)
    end
    action.target_index = @chant_target_index
    @act_chant = true
    if not usable?(action.item)
      @act_chant = action.item.chant_not_valid_message
      action.clear
    end
    @actions.push(action)
  end
  #--------------------------------------------------------------------------
  # ● 行動が有効か否かの判定
  #    イベントコマンドによる [戦闘行動の強制] ではないとき、ステートの制限
  #    やアイテム切れなどで予定の行動ができなければ false を返す。
  #--------------------------------------------------------------------------
  def valid?
    (forcing && item) || subject.usable?(item)
  end
  #--------------------------------------------------------------------------
  # ○ ＡＰの割合を取得
  #--------------------------------------------------------------------------
  def ap_rate
    if chanting?
      rate = @chant_count.to_f / @max_chant_count
    else
      rate = @ap.to_f / ATB::MAX_AP
    end
    rate = 1.0 if rate > 1
    return rate
  end
  #--------------------------------------------------------------------------
  # ○ ＡＰの割合を取得
  #--------------------------------------------------------------------------
  def ap_rate_100
    return (ap_rate * 100).to_i
  end
end

class RPG::UsableItem
  def chant
    return @note =~ /<詠唱=(\d+),\[(\-*\d+),(\d+)\]>/ ? [$1.to_i, $2.to_i, $3.to_i] : nil
  end
  def chant_message
    return @note =~ /<詠唱文=(\S+?)>/ ? $1 : nil
  end
  def chant_animation
    return @note =~ /<詠唱アニメ=(\d+)>/ ? $1.to_i : nil
  end
  def chant_not_valid_message
    return @note =~ /<詠唱失敗文=(\S+?)>/ ? $1 : ""
  end
end
class RPG::BaseItem
  def chant_states(type)
    result = []
    result += [$1.to_i] if @note =~ /<詠唱ステート=(\d+)>/
    result += eval($1)  if @note =~ /<詠唱ステート=(\[[\d,]+\])>/
    result += [$1.to_i] if @note =~ /<詠唱ステート#{type}=(\d+)>/
    result += eval($1)  if @note =~ /<詠唱ステート#{type}=(\[[\d,]+\])>/
    return result
  end
end

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================
class Game_BattlerBase
  #--------------------------------------------------------------------------
  # ● スキル／アイテムの共通使用可能条件チェック
  #--------------------------------------------------------------------------
  def usable_item_conditions_met?(item)
    return false if item.chant and chant_sealed?
    movable? && occasion_ok?(item)
  end
  #--------------------------------------------------------------------------
  # ○ 詠唱禁止かどうか
  #--------------------------------------------------------------------------
  def chant_sealed?
    return true if SceneManager.scene_is?(Scene_Battle) and @actions.size > 1
    feature_objects.each do |obj|
      return true if obj.note =~ /<詠唱禁止>/
    end
    return false
  end
end
#==============================================================================
# ■ Game_Action
#==============================================================================
class Game_Action
  #--------------------------------------------------------------------------
  # ● ターゲットの配列作成
  #--------------------------------------------------------------------------
  def make_targets
    if forcing != true && subject.confusion?
      [confusion_target]
    elsif item.for_opponent?
      targets_for_opponents
    elsif item.for_friend?
      targets_for_friends
    else
      []
    end
  end
end
#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ○ 詠唱開始メッセージの表示
  #--------------------------------------------------------------------------
  def display_chant_message(object)
    text = object.chant_message
    @log_window.add_text(@chant_battler.name + text) if text
  end
  #--------------------------------------------------------------------------
  # ○ スキル／アイテム名の表示終了
  #--------------------------------------------------------------------------
  def chant_display_end_item
    log_wait_and_clear
  end
end
#==============================================================================
# ■ Window_BattleItem
#==============================================================================
class Window_BattleItem < Window_ItemList
  #--------------------------------------------------------------------------
  # ● アイテムを許可状態で表示するかどうか
  #--------------------------------------------------------------------------
  def enable?(item)
    BattleManager.action_battler.usable?(item)
  end
end