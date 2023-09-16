#==============================================================================
# ■ RGSS3 効果遅延アイテム・スキル Ver2.00 by 星潟
#------------------------------------------------------------------------------
# 使用後に遅れて効果が発動するアイテム・スキルを作成できます。
# 指定ターン後のターン終了時に発動するタイプと
# 指定行動回数後に発動するタイプの2種類をそれぞれ設定できます。
# 記入する数字はどちらの形式も共通して以下の通りです。
#==============================================================================
# 1つ目が遅延効果発生時の使用者の名前として表示されるのが
# 使用者自身か対象の名前にするかを決める数字。(0で使用者。1で対象)、
# 2つ目が遅延効果として実際に発動するアイテム・スキルID、
# （アイテムはアイテム、スキルはスキルのみ指定できます）
# 3つ目が何ターン、もしくは何回行動後に遅延効果が発動するか、
# 4つ目が3つ目で設定した発動タイミングの数字にランダムで延長する範囲、
# 5つ目が遅延アイテム・スキルが正常に発動する確率となっています。
# （4つ目と5つ目の数字は省略できますが、4つ目を省略して5つ目を入力は出来ません）
# 1アイテム・スキルに対し、どちらの種類でもいくつでも設定できます。
#==============================================================================
# アイテム・スキルのメモ欄に指定。
#==============================================================================
# <遅延発動:0,20,0>
# 遅延効果発動時の使用者名の表記は使用者となる。
# このターンの終了時にアイテム・スキルID20が発動。
#------------------------------------------------------------------------------
# <遅延発動:1,25,1,0,50>
# 遅延効果発動時の使用者名の表記は対象自身となる。
# 更に、50％の確率で次のターンの終了時にアイテム・スキルID25が発動。
#------------------------------------------------------------------------------
# <行動後遅延発動:0,30,2>
# 遅延効果発動時の使用者名の表記は使用者となる。
# 相手が2回行動した後の次の行動後（3回目の行動後）にアイテム・スキルID30が発動。
#------------------------------------------------------------------------------
# <行動後遅延発動:1,35,3,2,25>
# 遅延効果発動時の使用者名の表記は対象自身となる。
# 更に、相手が3～5回行動した後の次の行動後（4～6回目の行動後）に
# 25％の確率でアイテム・スキルID35が発動。
#==============================================================================
# 使用者対象のスキルで遅延発動させ
# 遅延発動させるスキルとして敵をランダム攻撃する物や敵全体攻撃の物を指定すれば
# 一度の遅延効果で複数の敵を攻撃する遅延スキルも作成出来ます。
#==============================================================================
module DelayAct
  
  #ターン終了時に発動する場合のキーワード設定
  
  WORD1 = "遅延発動"
  
  #行動後に発動する場合のキーワード設定
  
  WORD2 = "行動後遅延発動"
  
end
class RPG::UsableItem < RPG::BaseItem
  #--------------------------------------------------------------------------
  # 遅延発動
  #--------------------------------------------------------------------------
  def delay_skill_data
    @delay_skill_data ||= create_delay_skill_data
  end
  #--------------------------------------------------------------------------
  # 遅延発動データ作成
  #--------------------------------------------------------------------------
  def create_delay_skill_data
    h = {}
    self.note.each_line {|l|
    if /<#{DelayAct::WORD1}[：:](\S+)>/ =~ l
      a = $1.to_s.split(/\s*,\s*/).inject([]) {|r,i| r.push(i.to_i)} 
      if a.size > 2
        a.push(0) if a.size == 3
        a.push(100) if a.size == 4
        a.push(0)
        h[h.size] = a
      end
    end
    if /<#{DelayAct::WORD2}[：:](\S+)>/ =~ l
      a = $1.to_s.split(/\s*,\s*/).inject([]) {|r,i| r.push(i.to_i)} 
      if a.size > 2
        a.push(0) if a.size == 3
        a.push(100) if a.size == 4
        a.push(1)
        h[h.size] = a
      end
    end}
    h
  end
end
class << BattleManager
  attr_accessor :delay_actions_turnend
  attr_accessor :delay_actions_actend
  attr_accessor :display_name_delayact
  #--------------------------------------------------------------------------
  # メンバ変数の初期化
  #--------------------------------------------------------------------------
  alias init_members_delay_actions init_members
  def init_members
    init_members_delay_actions
    @delay_actions_turnend = []
    @delay_actions_actend = []
    @display_name_delayact = nil
  end
  #--------------------------------------------------------------------------
  # ターン終了時遅延発動の配列内データを更新
  #--------------------------------------------------------------------------
  def delay_actions_turnend_update
    ar = []
    @delay_actions_turnend.each {|a|
    if a[:count] <= 0
      ar.push(a.clone)
    else
      a[:count] -= 1
    end}
    ar.each {|a| @delay_actions_turnend.delete(a)}
    ar
  end
  #--------------------------------------------------------------------------
  # 行動終了時遅延発動の配列内データを更新
  #--------------------------------------------------------------------------
  def delay_actions_actend_update(target)
    ar = []
    @delay_actions_actend.each {|a|
    next if target != a[:target]
    if a[:count] <= 0
      ar.push(a.clone)
    else
      a[:count] -= 1
    end}
    ar.each {|a| @delay_actions_actend.delete(a)}
    ar
  end
end
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # スキル／アイテムの使用者側への効果
  #--------------------------------------------------------------------------
  alias item_user_effect_delayact item_user_effect
  def item_user_effect(user, item)
    if $game_party.in_battle
      item.delay_skill_data.each_value {|data|
      if data[4].to_i > rand(100)
        count = data[2].to_i + rand(data[3].to_i + 1)
        sid = data[1].to_i
        item2 = item.is_a?(RPG::Skill) ? $data_skills[sid] : $data_items[sid]
        hash = {:user => user,:target => self,:item => item2,:count => count,:name_type => data[0] == 1 ? true : false}
        if data[5].to_i == 0
          BattleManager.delay_actions_turnend.push(hash)
        else
          BattleManager.delay_actions_actend.push(hash)
        end
        @result.success = true
      end}
    end
    item_user_effect_delayact(user, item)
  end
  #--------------------------------------------------------------------------
  # スキル／アイテムの使用者側への効果
  #--------------------------------------------------------------------------
  def set_deley_act(target,item)
    @pre_delay_actions = @actions.clone
    @actions.clear
    action = Game_Action.new(self,true)
    action.target_index = target.index
    if item.is_a?(RPG::Skill)
      action.set_skill(item.id)
    else
      action.set_item(item.id)
    end
    @actions.push(action)
  end
  #--------------------------------------------------------------------------
  # 遅延行動後のデータ復帰
  #--------------------------------------------------------------------------
  def after_delay_act
    @actions = @pre_delay_actions.clone if movable?
    @pre_delay_actions = nil
  end
end
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # 行動終了の処理
  #--------------------------------------------------------------------------
  alias process_action_end_delayact process_action_end
  def process_action_end
    a = BattleManager.delay_actions_actend_update(@subject)
    a.each {|hash| delay_act_execute(hash);@log_window.clear} if !a.empty?
    process_action_end_delayact
  end
  #--------------------------------------------------------------------------
  # 遅延行動の実行
  #--------------------------------------------------------------------------
  def delay_act_execute(hash)
    last_subject = @subject
    user = hash[:user]
    target = hash[:target]
    item = hash[:item]
    return unless target.exist?
    return if target.dead?
    @subject = user
    user.set_deley_act(target,item)
    BattleManager.display_name_delayact = target if hash[:name_type]
    use_item
    user.after_delay_act
    @subject = last_subject
  end
  #--------------------------------------------------------------------------
  # ターン終了
  #--------------------------------------------------------------------------
  alias turn_end_delayact turn_end
  def turn_end
    return if @turn_ending_delay_act
    @turn_ending_delay_act = true
    a = BattleManager.delay_actions_turnend_update
    a.each {|hash| delay_act_execute(hash);@log_window.clear} if !a.empty?
    turn_end_delayact
    @turn_ending_delay_act = nil
  end
end
class Window_BattleLog < Window_Selectable
  #--------------------------------------------------------------------------
  # スキル／アイテム使用の表示
  #--------------------------------------------------------------------------
  alias display_use_item_delayact display_use_item
  def display_use_item(subject, item)
    s = BattleManager.display_name_delayact
    BattleManager.display_name_delayact = nil
    display_use_item_delayact(s ? s : subject, item)
  end
end