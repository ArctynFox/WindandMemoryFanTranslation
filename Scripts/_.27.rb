=begin #-----------------------------------------------------------------------

●スキルクールタイム【RGSS3 by Declare War】

スキルにクールタイムをつける

スキルのメモ欄に <クールタイム:n> と書くと
一度使用するとｎターンの間使えなくなる

【イベントコマンド】
$game_temp.loss_cool_time(n)       # 敵味方全体のクールタイムをn減少
$game_temp.actor_loss_cool_time(n) # 味方全体のクールタイムをn減少
$game_temp.enemy_loss_cool_time(n) # 敵全体のクールタイムをn減少

【利用規約】
著作権明記と利用報告は不要、加工自由、転載と配布は禁止

【バージョン情報】
v1.2 - 併用性を向上 
v1.1 - エネミー側にもクールタイムを適応可能にした
v1.0 - 公開

=end #-------------------------------------------------------------------------
class RPG::Skill < RPG::UsableItem
  #--------------------------------------------------------------------------
  # ● 定数
  #--------------------------------------------------------------------------
  COOL_TIME = /<クールタイム:(\d+)>/
  #--------------------------------------------------------------------------
  # ● クールタイムを取得
  #--------------------------------------------------------------------------
  def cool_time
    return @cool_time if @cool_time != nil
    @cool_time = note =~ COOL_TIME ? $1.to_i + 1 : false
  end
end

class << BattleManager
  #--------------------------------------------------------------------------
  # ● 戦闘終了(エイリアス)
  #--------------------------------------------------------------------------
  alias cool_time_battle_end battle_end
  def battle_end(result)
    $game_temp.cool_time_variables_initialize
    cool_time_battle_end(result)
  end
  #--------------------------------------------------------------------------
  # ● ターン終了(エイリアス)
  #--------------------------------------------------------------------------
  alias cool_time_turn_end turn_end
  def turn_end
    $game_temp.loss_cool_time
    cool_time_turn_end
  end
end

class Game_Temp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :cool_time
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化(エイリアス)
  #--------------------------------------------------------------------------
  alias cool_time_initialize initialize
  def initialize
    cool_time_initialize
    cool_time_variables_initialize
  end
  #--------------------------------------------------------------------------
  # ● クールタイムの変数を初期化
  #--------------------------------------------------------------------------
  def cool_time_variables_initialize
    @cool_time = Hash.new{|h, k| h[k] = Hash.new(0)}
  end
  #--------------------------------------------------------------------------
  # ● クールタイム減少
  #--------------------------------------------------------------------------
  def loss_cool_time(n = 1)
    @cool_time.each{|k, v| v.keys.each{|key| v[key] -= n}}  
  end
  #--------------------------------------------------------------------------
  # ● アクターのみクールタイム減少
  #--------------------------------------------------------------------------
  def actor_loss_cool_time(n = 1)
    @cool_time.each{|k, v| v.keys.each{|key| v[key] -= n} if k.actor?}  
  end
  #--------------------------------------------------------------------------
  # ● エネミーのみクールタイム減少
  #--------------------------------------------------------------------------
  def enemy_loss_cool_time(n = 1)
    @cool_time.each{|k, v| v.keys.each{|key| v[key] -= n} if k.enemy?}  
  end
end

class Game_BattlerBase
  #--------------------------------------------------------------------------
  # ● スキルの使用可能条件チェック(エイリアス)
  #--------------------------------------------------------------------------
  alias cool_time_skill_conditions_met? skill_conditions_met?
  def skill_conditions_met?(skill)
    return false if skill_cooling?(skill)
    cool_time_skill_conditions_met?(skill)
  end
end

class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # ● クールタイムを取得
  #--------------------------------------------------------------------------
  def cool_time
    $game_temp.cool_time[self]
  end
  #--------------------------------------------------------------------------
  # ● クールタイム中かどうか
  #--------------------------------------------------------------------------
  def skill_cooling?(skill)
    skill.cool_time && cool_time[skill.id] > 0
  end
  #--------------------------------------------------------------------------
  # ● スキル／アイテムの使用(エイリアス)
  #--------------------------------------------------------------------------
  alias cool_time_use_item use_item
  def use_item(item)
    count_cool_time(item) 
    cool_time_use_item(item)
  end
  #--------------------------------------------------------------------------
  # ● クールタイムの適用
  #--------------------------------------------------------------------------
  def count_cool_time(skill)
    return if !($game_party.in_battle && RPG::Skill === skill)
    return if !skill.cool_time
    $game_temp.cool_time[self][skill.id] = skill.cool_time
  end
end

class Window_BattleSkill < Window_SkillList
  #--------------------------------------------------------------------------
  # ● スキルの使用コストを描画(alias)
  #--------------------------------------------------------------------------
  alias cool_time_draw_skill_cost draw_skill_cost
  def draw_skill_cost(rect, skill)
    return draw_cool_time(rect, skill) if @actor.skill_cooling?(skill)
    cool_time_draw_skill_cost(rect, skill)
  end
  #--------------------------------------------------------------------------
  # ● クールタイムの描画
  #--------------------------------------------------------------------------
  def draw_cool_time(rect, skill)
    change_color(text_color(27), false)
    draw_text(rect, "CD#{@actor.cool_time[skill.id]}", 2)
  end
end
