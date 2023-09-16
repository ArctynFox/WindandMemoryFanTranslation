#==============================================================================
# ■ RGSS3 通常攻撃ID変化特徴 Ver1.00 by 星潟
#------------------------------------------------------------------------------
# 本来はスキルID1番に指定されている通常攻撃のスキルIDを
# 変更する特徴を作成する事が可能になります。
# 
# これにより、通常攻撃のランダム攻撃化や全体攻撃化の効果を持つ
# ステートや装備品を作成する事が可能になります。
# 
# なお、RPGツクールVXAceプリセットスクリプトの不具合により
# 攻撃追加回数が反映されませんが
# 配布中の『通常攻撃時の追加攻撃回数強制適用』スクリプトを併用する事で
# 攻撃追加回数が反映されるようになります。
#------------------------------------------------------------------------------
# 使用方法
# 
# ★通常攻撃IDを変更する特徴を作成したい場合
#
# 特徴を有する項目（アクター・職業・装備・ステート等）のメモ欄に
# <攻撃ID変更:130>と記入する事で機能します。
# （この場合は、通常攻撃のスキルIDが130に変化します）
# 
# ★通常攻撃IDを変更する特徴が複数付与されている場合に
#   スキル間においてどのスキルが通常攻撃として扱われるか優先度を付けたい場合
#
# 通常攻撃として扱う予定のスキルのメモ欄に
# <攻撃ID優先度変更:1>と記入する事で機能します。
# 書き込まれた数値が優先度として機能し、数値が高ければ高いほど優先されます。
# （なお、優先度が指定されていない場合、自動的に優先度0となります）
#
# ※優先度が同じ攻撃スキルが存在する場合は
#   スキルIDの値が高いスキルが優先されます。
#==============================================================================
module ATTACK_CHANGE
  
  #攻撃ID変更用のキーワードを設定します。
  
  WORD1 = "攻撃ID変更"
  
  #攻撃ID優先度変更用のキーワードを設定します。
  
  WORD2 = "攻撃ID優先度変更"
  
end
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● コマンド［攻撃］
  #--------------------------------------------------------------------------
  alias command_attack_attack_change command_attack
  def command_attack
    
    #通常攻撃時、対象を選択する必要がある場合は通常の処理を行う。
    
    return command_attack_attack_change if $data_skills[BattleManager.actor.attack_skill_id].need_selection?
    
    #通常攻撃時、対象を選択する必要が無い場合は
    #攻撃をセットした後、次のアクターへ移す。
    
    BattleManager.actor.input.set_attack
    next_command
  end
end
class Game_BattlerBase
  #--------------------------------------------------------------------------
  # ● 通常攻撃のスキル ID を取得
  #--------------------------------------------------------------------------
  alias attack_skill_id_attack_change attack_skill_id
  def attack_skill_id
    
    #空の配列を用意。
    
    data = []
    
    #特徴に通常攻撃IDが指定されている場合、そのIDを配列に加える。
    
    feature_objects.each do |f|
      data.push(f.new_attack_skill_id) if f.new_attack_skill_id != 0
    end
    
    #配列が空の場合は通常の処理を行う。
    
    return attack_skill_id_attack_change if data.empty?
    
    #配列内の同じ物を消去し、並び変える。
    
    data.uniq!
    data.sort!
    
    #スキルの優先度の最高値を取得する。
    
    number = 0
    data.each do |d|
      number = $data_skills[d].attack_skill_priority if number <= $data_skills[d].attack_skill_priority
    end
    
    #配列から、スキル優先度が最高値でない物を削除する。
    
    data.reject! {|d| $data_skills[d].attack_skill_priority != number}
    
    #配列の末尾の値を取りだす。
    
    return data.pop
  end
end
class RPG::BaseItem
  def new_attack_skill_id
    
    #キャッシュがある場合はキャッシュを返す。
    
    return @new_attack_skill_id if @new_attack_skill_id != nil
    
    #メモ欄からデータを取得する。
    
    memo = self.note.scan(/<#{ATTACK_CHANGE::WORD1}[：:](\S+)>/).flatten
    
    #データを取得出来無かった場合は0を返す。
    
    @new_attack_skill_id = (memo != nil && !memo.empty?) ? memo[0].to_i : 0
    
    #データを返す。
    
    return @new_attack_skill_id
  end
end
class RPG::Skill < RPG::UsableItem
  def attack_skill_priority
    
    #キャッシュがある場合はキャッシュを返す。
    
    return @attack_skill_priority if @attack_skill_priority != nil
    
    #メモ欄からデータを取得する。
    
    memo = self.note.scan(/<#{ATTACK_CHANGE::WORD2}[：:](\S+)>/).flatten
    
    #データを取得出来無かった場合は0を返す。
    
    @attack_skill_priority = (memo != nil && !memo.empty?) ? memo[0].to_i : 0
    
    #データを返す。
    
    return @attack_skill_priority
  end
end