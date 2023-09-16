#==============================================================================
# ■ RGSS3 戦闘時使用不可アイテム・スキルオート非表示 Ver1.00 by 星潟
#------------------------------------------------------------------------------
# 戦闘時、使用可能時が『メニューのみ』と『使用不可』の
# アイテム及びスキルを全て非表示にします。
#==============================================================================
class Window_SkillList < Window_Selectable
  alias include_battle_jogai? include?
  def include?(item)
    #元の処理の判定を引き継ぎます。
    data = include_battle_jogai?(item)
    #元の処理結果がfalse、もしくは戦闘中でなければ元のデータを返します。
    return data if !data or !$game_party.in_battle
    #使用可能時がメニューのみ、もしくは使用不可の場合は非表示化します。
    return false if item.occasion == 2 or item.occasion == 3
    return true
  end
end
class Window_ItemList < Window_Selectable
  alias include_battle_jogai? include?
  def include?(item)
    #元の処理の判定を引き継ぎます。
    data = include_battle_jogai?(item)
    #元の処理結果がfalse、もしくは戦闘中でなければ元のデータを返します。
    return data if !data or !$game_party.in_battle
    #使用可能時がメニューのみ、もしくは使用不可の場合は非表示化します。
    return false if item.occasion == 2 or item.occasion == 3
    return true
  end
end