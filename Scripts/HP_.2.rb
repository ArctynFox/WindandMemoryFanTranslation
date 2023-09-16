#==============================================================================
# ■ RGSS3 HP/MP/TP変換攻撃特徴・アイテム・スキル Ver1.01 by 星潟
#------------------------------------------------------------------------------
# 特定のスキルで攻撃した際に
# 指定した確率でダメージの指定％分HP、MP、TPを回復する特徴を作成します。
# もしくは、指定した確率でダメージの指定％分HP、MP、TPを回復する
# アイテム・スキルを作成します。
#==============================================================================
# スキルのメモ欄に記述。
#------------------------------------------------------------------------------
# <変換攻撃判定:100>
# 
# このスキルでダメージを与えた際、100％の確率で変換特徴の効果を発動する。
#------------------------------------------------------------------------------
# <変換攻撃判定:50>
# 
# このスキルでダメージを与えた際、50％の確率で変換特徴の効果を発動する。
#------------------------------------------------------------------------------
# <変換攻撃判定:a.luk-b.luk>
# 
# このスキルでダメージを与えた際、使用者の運から相手の運を引いた確率で
# 変換特徴の効果を発動する。
#------------------------------------------------------------------------------
# <変換攻撃判定:v[50]>
# 
# このスキルでダメージを与えた際、変数ID50の確率で変換特徴の効果を発動する。
#==============================================================================
# 特徴を有する項目、もしくはアイテム・スキルのメモ欄に記述。
#------------------------------------------------------------------------------
# <HP変換攻撃:50,75>
# 
# 変換特徴の効果が発動する際、75％の確率で
# ダメージの50％を自らのHPに変換。
#------------------------------------------------------------------------------
# <MP変換攻撃:10,a.luk/10>
# 
# 変換特徴の効果が発動する際、使用者の運の1/10の確率で
# ダメージの10％を自らのMPに変換。
#------------------------------------------------------------------------------
# <TP変換攻撃:5>
# 
# 変換特徴の効果が発動する際、100％の確率でダメージの5％を自らのTPに変換。
#==============================================================================
module ConvertAttack
  
  #変換攻撃判定設定用キーワードを指定。
  
  Word = "変換攻撃判定"
  
  #変換攻撃特徴設定用キーワードを指定。
  
  Words = ["HP変換攻撃","MP変換攻撃","TP変換攻撃"]
  
  #空のハッシュを2つ用意。
  
  MA = {}
  ME = {}
  
  #アクターHP/MP/TPダメージ時メッセージ
  
  MA[0] = {
  :hp => "%s lost %s %s!",
  :mp => "%s lost %s %s!",
  :tp => "%s lost %s %s!"}
  
  #アクターHP/MP/TP回復時メッセージ
  
  MA[1] = {
  :hp => "%s gained %s %s!",
  :mp => "%s gained %s %s!",
  :tp => "%s gained %s %s!"}
  
  #エネミーHP/MP/TPダメージ時メッセージ
  
  ME[0] = {
  :hp => "%s lost %s %s!",
  :mp => "%s lost %s %s!",
  :tp => "%s lost %s %s!"}
  
  #エネミーHP/MP/TP回復時メッセージ
  
  ME[1] = {
  :hp => "%s gained %s %s!",
  :mp => "%s gained %s %s!",
  :tp => "%s gained %s %s!"}
  
  #--------------------------------------------------------------------------
  # メッセージ取得
  #--------------------------------------------------------------------------
  def self.mt(a,d,data)
    (a ? MA : ME)[d > 0 ? 1 : 0][data]
  end
  
end
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # スキル／アイテムの使用者側への効果
  #--------------------------------------------------------------------------
  alias item_user_effect_hmtp_convert item_user_effect
  def item_user_effect(user, item)
    a = user
    b = self
    v = $game_variables
    @result.convert_user = user
    if eval(item.convert_attack_rate) > rand(100)
      a = create_convert_attack_rate(user,item)
      hd = @result.hp_damage
      @result.exhp_convert += hd * a[0] / 100
      @result.exmp_convert += hd * a[1] / 100
      @result.extp_convert += hd * a[2] / 100
      user.hp += @result.exhp_convert
      user.mp += @result.exmp_convert
      user.tp += @result.extp_convert
    end
    item_user_effect_hmtp_convert(user, item)
  end
  #--------------------------------------------------------------------------
  # 変換攻撃割合
  #--------------------------------------------------------------------------
  def create_convert_attack_rate(user,item)
    a = user
    b = self
    v = $game_variables
    r = [0,0,0]
    fa = (user.feature_objects + [item])
    fa.each {|f| 3.times {|i| d = f.convert_attack_data[i]
    r[i] += eval(d[0]) if (!d.empty? && !(eval(d[1]) <= rand(100)))}}
    r
  end
end
class Game_ActionResult
  attr_accessor :convert_user
  attr_accessor :exhp_convert
  attr_accessor :exmp_convert
  attr_accessor :extp_convert
  #--------------------------------------------------------------------------
  # ダメージ値のクリア
  #--------------------------------------------------------------------------
  alias clear_damage_values_convert clear_damage_values
  def clear_damage_values
    clear_damage_values_convert
    @convert_user = ""
    @exhp_convert = 0
    @exmp_convert = 0
    @extp_convert = 0
  end
  #--------------------------------------------------------------------------
  # HP 変換の文章を取得
  #--------------------------------------------------------------------------
  def hp_damage_exconvert_text
    d = @exhp_convert
    u = @convert_user
    sprintf(ConvertAttack.mt(u.actor?,d,:hp),u.name, Vocab::hp, d.abs)
  end
  #--------------------------------------------------------------------------
  # MP 変換の文章を取得
  #--------------------------------------------------------------------------
  def mp_damage_exconvert_text
    d = @exmp_convert
    u = @convert_user
    sprintf(ConvertAttack.mt(u.actor?,d,:mp),u.name, Vocab::mp, d.abs)
  end
  #--------------------------------------------------------------------------
  # TP 変換の文章を取得
  #--------------------------------------------------------------------------
  def tp_damage_exconvert_text
    d = @extp_convert
    u = @convert_user
    sprintf(ConvertAttack.mt(u.actor?,d,:tp),u.name, Vocab::tp, d.abs)
  end
end
class Window_BattleLog < Window_Selectable
  #--------------------------------------------------------------------------
  # HP ダメージ表示
  #--------------------------------------------------------------------------
  alias display_hp_damage_convert display_hp_damage
  def display_hp_damage(target, item)
    display_hp_damage_convert(target, item)
    if target.result.exhp_convert != 0
      t = target.result.hp_damage_exconvert_text
      add_text(t)
      wait
      @convert_back_one = true
    end
    if target.result.exmp_convert != 0
      t = target.result.mp_damage_exconvert_text
      f ? replace_text(t) : add_text(t)
      wait
      @convert_back_one = true
    end
    if target.result.extp_convert != 0
      t = target.result.tp_damage_exconvert_text
      f ? replace_text(t) : add_text(t)
      wait
      @convert_back_one = true
    end
  end
  #--------------------------------------------------------------------------
  # ダメージの表示
  #--------------------------------------------------------------------------
  alias display_damage_convert display_damage
  def display_damage(target, item)
    display_damage_convert(target, item)
    @convert_back_one = nil
  end
  #--------------------------------------------------------------------------
  # 文章の追加
  #--------------------------------------------------------------------------
  alias add_text_convert add_text
  def add_text(text)
    if @convert_back_one
      back_one
      @convert_back_one = nil
    end
    add_text_convert(text)
  end
end
class RPG::BaseItem
  #--------------------------------------------------------------------------
  # 変換攻撃特徴
  #--------------------------------------------------------------------------
  def convert_attack_data
    @convert_attack_data ||= create_convert_attack_data
  end
  #--------------------------------------------------------------------------
  # 変換攻撃特徴データ作成
  #--------------------------------------------------------------------------
  def create_convert_attack_data
    ConvertAttack::Words.inject([]) {|r,w|
    a = /<#{w}[:：](\S+)>/ =~ note ? $1.to_s.split(/\s*,\s*/).inject([]) {|r,i| r.push(i)} : []
    a.push("100") if a.size == 1
    r.push(a)}
  end
  #--------------------------------------------------------------------------
  # 変換攻撃フラグ
  #--------------------------------------------------------------------------
  def convert_attack_rate
    @convert_attack_rate ||= /<#{ConvertAttack::Word}[:：](\S+)>/ =~ note ? $1.to_s : "0"
  end
end