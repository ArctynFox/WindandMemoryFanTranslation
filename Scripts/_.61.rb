#==============================================================================
# ■ RGSS3 回避時発動スキル特徴 Ver1.00　by 星潟
#------------------------------------------------------------------------------
# 敵からのスキルを回避した際に指定したスキルを
# 発動させる事が出来る特徴を作成する事が出来るようになります。
# 処理が特殊で、競合する可能性が若干高いです。
# 
# 発動時、対象は単体に限定され、味方対象のスキルは使用者を対象とし
# 敵対象のスキルは回避した攻撃の使用者を対象とします。
# 対象の存在しないスキルについては、便宜上使用者を対象としています。
# 使用効果でコモンイベントを発生させるスキルに対してこの効果で
# 同じく使用効果でコモンイベントを発生させるスキルを使用させた場合
# コモンイベントが上書きされるので注意が必要です。
# 使用者が行動出来ない場合や発動コストを払えない場合は発動出来ません。
# 処理の都合上、多くの素材スクリプトの処理は無視されるので
# 複雑な効果を持つスキルをこのスキルで発動させるのは避け
# 単純な効果のスキルのみを発動させた方が良いかと思われます。
#==============================================================================
# 特徴を持つ項目（アクター・職業・エネミー・装備・ステート）のメモ欄に設定します。
#==============================================================================
# <必中回避時スキル:10>
# 
# 命中タイプ:必中のスキル/アイテムを回避した時、スキルID10が発動します。
#------------------------------------------------------------------------------
# <物理回避時スキル:15,50>
# 
# 命中タイプ:物理のスキル/アイテムを回避した時
# 50％の確率でスキルID15が発動します。
#------------------------------------------------------------------------------
# <魔法回避時スキル:rand(3)+16,a.tp>
# 
# 命中タイプ:魔法のスキル/アイテムを回避した時
# 回避した者（これからスキル発動する者）のTPの値の確率で
# スキル16・17・18の3つのどれかが発動します。
#------------------------------------------------------------------------------
# <全回避時スキル:$game_variables[5],b.hp_rate*100>
# 
# スキル/アイテムを回避した時
# 攻撃してきた相手の残りHP割合の値の確率で
# 変数ID5の値のスキルIDのスキルを発動します。
#==============================================================================
module EvadedAction
  
  #命中タイプ:必中を回避した際の発動スキル設定用キーワードを指定。
  
  Word1 = "必中回避時スキル"
  
  #命中タイプ:物理を回避した際の発動スキル設定用キーワードを指定。
  
  Word2 = "物理回避時スキル"
  
  #命中タイプ:魔法を回避した際の発動スキル設定用キーワードを指定。
  
  Word3 = "魔法回避時スキル"
  
  #命中タイプを問わず回避した際の発動スキル設定用キーワードを指定。
  
  Word4 = "全回避時スキル"
  
  #以下変更不要。
  
  Word = []
  Word[0] = Word1
  Word[1] = Word2
  Word[2] = Word3
  Word[3] = Word4
  
end
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # スキル／アイテムの効果を適用
  #--------------------------------------------------------------------------
  alias apply_item_effects_evaded_action apply_item_effects
  def apply_item_effects(target, item)
    a = target
    s = @subject
    apply_item_effects_evaded_action(target, item)
    if target.result.evaded && a.opposite?(s)
      ls = s
      @subject = a
      h = a.evaded_action(item)
      h.each_value {|a1|
      b = s
      skill = $data_skills[eval(a1[0])]
      next unless skill
      next unless a.usable?(skill)
      next unless eval(a1[1]) > rand(100)
      b = skill.for_opponent? ? s : a
      lln = @log_window.line_number
      @log_window.display_use_item(a, skill)
      a.use_item(skill)
      refresh_status
      t = [b]
      show_animation([b], skill.animation_id)
      skill.repeats.times { apply_item_effects(b, skill)}
      @log_window.back_to(lln)}
      @subject = s
    end
  end
end
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # スキル／アイテムの効果適用
  #--------------------------------------------------------------------------
  def evaded_action(item)
    hm = {}
    feature_objects.each {|f|
    f.evaded_data_hash[item.hit_type].each_value {|v| hm[hm.size] = v}
    f.evaded_data_hash[3].each_value {|v| hm[hm.size] = v}}
    hm
  end
end
class RPG::BaseItem
  #--------------------------------------------------------------------------
  # 回避時スキルハッシュ
  #--------------------------------------------------------------------------
  def evaded_data_hash
    @evaded_data_hash ||= evaded_data_hash_make
  end
  #--------------------------------------------------------------------------
  # 回避時スキルハッシュ作成
  #--------------------------------------------------------------------------
  def evaded_data_hash_make
    h = {}
    4.times {|i| h[i] = {}}
    note.each_line {|l|
    4.times {|i|
    a = (/<#{EvadedAction::Word[i]}[:：](\S+)>/ =~ l ? $1.to_s : "").split(/\s*,\s*/)
    case a.size
    when 1;h[i][h[i].size] = [a[0],"100"]
    when 2;h[i][h[i].size] = a
    end}}
    h
  end
end