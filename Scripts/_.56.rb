#==============================================================================
# ■ RGSS3 アイテムコマンド封印/スキルのアイテム化 Ver2.00 by 星潟
#------------------------------------------------------------------------------
# アイテムコマンドを封印する特徴の作成が可能になります。
# また、指定したスキルをアイテム扱いとすることで
# 敵のスキルでポーション等を作成し
# 「敵がアイテムを使っている戦闘演出」等をする場合に
# アイテムコマンド封印特徴が付与されていれば
# 該当スキルをアイテムとみなし、使用不可能にする事も出来ます。
#==============================================================================
# 特徴を有する項目(アクター・職業・装備・ステート等)のメモ欄に指定。
#------------------------------------------------------------------------------
# <アイテム封印>
#
# アイテムコマンドが使用できなくなります。
#==============================================================================
# スキルのメモ欄に指定。
#------------------------------------------------------------------------------
# <アイテム扱い>
# 
# このスキルはアイテム封印効果を受けている状態では使用できなくなります。
#==============================================================================
# Ver1.01 スキルのアイテム化機能を追加しました。
# Ver2.00 アイテムコマンド封印判定をキャッシュ化しました。
#==============================================================================
module ITEM_COMMAND_SEAL
  
  #アイテムコマンド封印特徴に指定する際に
  #特徴を有する項目のメモ欄に記入するキーワードを指定します。
  
  WORD1 = "アイテム封印"
  
  #アイテム扱いのスキルに指定する際に
  #スキルのメモ欄に記入するキーワードを指定します。
  
  WORD2 = "アイテム扱い"
  
end
class Window_ActorCommand < Window_Command
  #--------------------------------------------------------------------------
  # アイテムコマンドをリストに追加
  #--------------------------------------------------------------------------
  alias add_item_command_ics add_item_command
  def add_item_command
    @actor.item_command_seal? ? add_command([Vocab::item, nil], :item, false) : add_item_command_ics
  end
end
class Game_BattlerBase
  #--------------------------------------------------------------------------
  # アイテムコマンド封印
  #--------------------------------------------------------------------------
  def item_command_seal?
    feature_objects.any? {|f| f.item_command_seal}
  end
  #--------------------------------------------------------------------------
  # スキル使用条件判定
  #--------------------------------------------------------------------------
  alias skill_conditions_met_ics? skill_conditions_met?
  def skill_conditions_met?(skill)
    return false if !skill_conditions_met_ics?(skill)
    return false if skill.item_skill? && item_command_seal?
    return true
  end
end
class RPG::BaseItem
  #--------------------------------------------------------------------------
  # アイテムコマンド封印
  #--------------------------------------------------------------------------
  def item_command_seal
    (@item_command_seal = /<#{ITEM_COMMAND_SEAL::WORD1}>/ =~ note ? 1 : 0) == 1
  end
end
class RPG::Skill < RPG::UsableItem
  #--------------------------------------------------------------------------
  # アイテム扱いのスキルか？
  #--------------------------------------------------------------------------
  def item_skill?
    (@item_skill = /<#{ITEM_COMMAND_SEAL::WORD2}>/ =~ note ? 1 : 0) == 1
  end
end