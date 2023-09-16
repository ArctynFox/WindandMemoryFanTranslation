#==============================================================================
# ■ RGSS3 使用後追加行動効果　Ver1.01　by 星潟
#==============================================================================
# アイテム・スキルに対し、戦闘中に使用した後に
# 更に別のスキルを使用する行動を追加する効果が設定できるようになります。
# 
# また、行動中に行動不能になった場合は追加行動は発生しません。
# 設定次第では永久に行動し続ける為注意が必要です。
#==============================================================================
# アイテム/スキルのメモ欄に指定。行を分けて記入する事でいくつでも指定可能。
# 最初にスキルID(0以下の場合は使用できる物を自動行動扱いで使用)、
# 次にターゲットインデックス、
# (-2で最終ターゲット、-1でランダムターゲット、0～はそのまま対象のインデックス)
# 最後に任意で発動確率を指定。
#------------------------------------------------------------------------------
# <使用後追加行動:0,-1,50>
# 
# 50％の確率でランダムターゲットで自動行動。
#------------------------------------------------------------------------------
# <使用後追加行動:1,-2>
# 
# 100％の確率でラストターゲットに対してスキルID1を使用。
#------------------------------------------------------------------------------
# <使用後追加行動:1,0>
# 
# 100％の確率でIndex0の対象に対してスキルID1を使用。
#------------------------------------------------------------------------------
# <使用後追加行動:attack_skill_id,-2>
# 
# 100％の確率でラストターゲットに対して通常攻撃を使用。
# （通常攻撃IDが変更されるタイプのスクリプト等を使用している場合向け）
#------------------------------------------------------------------------------
# <使用後追加行動:guard_skill_id,0>
# 
# 100％の確率でIndex0の対象に対して防御を使用。
# （防御IDが変更されるタイプのスクリプト等を使用している場合向け。
#   通常、防御は自分が対象なので、ターゲットは常に自分になる）
#==============================================================================
module AddAfterAction
  
  #設定用キーワードを指定。
  
  Word = "使用後追加行動"
  
end
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # 使用後追加行動
  #--------------------------------------------------------------------------
  def add_after_action(item)
    item.add_after_action.each {|a| 
    next if eval(a[2]) < rand(100)
    a0 = eval(a[0])
    s = a0 < 1 ? decide_add_random_after_action_id : a0
    next unless s
    add_after_action_main(s,eval(a[1]))}
  end
  #--------------------------------------------------------------------------
  # 使用後追加行動メイン
  #--------------------------------------------------------------------------
  def add_after_action_main(sid,ti)
    return unless movable?
    action = Game_Action.new(self)
    action.set_skill(sid)
    if ti == -2
      action.target_index = last_target_index
    elsif ti == -1
      action.decide_random_target
    else
      action.target_index = ti
    end
    @actions = [@actions[0]] + [action] + @actions[1,@actions.size]
  end
end
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # 次のランダム行動を決定
  #--------------------------------------------------------------------------
  def decide_add_random_after_action_id
    (make_action_list.max_by {|action| action.value }).item.id
  end
end
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # 次のランダム行動を決定
  #--------------------------------------------------------------------------
  def decide_add_random_after_action_id
    action_list = enemy.actions.select {|a| action_valid?(a) }
    return nil if action_list.empty?
    rating_max = action_list.collect {|a| a.rating }.max
    rating_zero = rating_max - 3
    action_list.reject! {|a| a.rating <= rating_zero }
    b = select_enemy_action(action_list, rating_zero)
    b.skill_id
  end
end
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # スキル／アイテムの使用
  #--------------------------------------------------------------------------
  alias use_item_ex_item_add_action use_item
  def use_item
    item = @subject.current_action.item
    use_item_ex_item_add_action
    @subject.add_after_action(item)
  end
end
class RPG::UsableItem < RPG::BaseItem
  #--------------------------------------------------------------------------
  # 使用後追加行動
  #--------------------------------------------------------------------------
  def add_after_action
    @add_after_action ||= create_add_after_action
  end
  #--------------------------------------------------------------------------
  # 使用後追加行動データ作成
  #--------------------------------------------------------------------------
  def create_add_after_action
    a = []
    note.each_line {|l|
    b = /<#{AddAfterAction::Word}[:：](\S+)>/ =~ l ? $1.to_s : nil
    if b
      c = b.split(/\s*,\s*/).inject([]) {|r,i| r.push(i)}
      case c.size
      when 2;c.push("100")
      when 3;
      else;next
      end
      a.push(c)
    end}
    a
  end
end