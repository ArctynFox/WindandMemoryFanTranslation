#==============================================================================
# ■ 運/有効度無視ステート/弱体付与アイテム・スキル Ver1.01 by 星潟
#------------------------------------------------------------------------------
# プリセットスクリプトでは、敵との運に1000差があると
# 敵からのステート付与や弱体の効果が無効化されてしまいます。
# このスクリプトを導入する事で
# 特定のスキルに上記仕様を無視する特殊効果を
# 持たせる事ができるようになります。
# また、ステートの有効度や弱体有効度を無視して
# 付与成功率を100％にする設定も可能です。
#------------------------------------------------------------------------------
# ★運を無視したステート付与を行いたい場合
# 
# アイテム/スキルのメモ欄に<運無視ステート付与>と記入する事で
# そのアイテム/スキルはステート付与時に運の影響を受けずにステート付与を行います。
#------------------------------------------------------------------------------
# ★運を無視した弱体付与を行いたい場合
# 
# アイテム/スキルのメモ欄に<運無視弱体付与>と記入する事で
# そのアイテム/スキルは弱体付与時に運の影響を受けずに弱体付与を行います。
#------------------------------------------------------------------------------
# ★有効度を無視したステート付与を行いたい場合
# 
# アイテム/スキルのメモ欄に<有効度無視ステート付与>と記入する事で
# そのアイテム/スキルはステート付与時に有効度の影響を受けずにステート付与を行います。
#------------------------------------------------------------------------------
# ★有効度を無視した弱体付与を行いたい場合
# 
# アイテム/スキルのメモ欄に<有効度無視弱体付与>と記入する事で
# そのアイテム/スキルは弱体付与時に有効度の影響を受けずに弱体付与を行います。
#------------------------------------------------------------------------------
# ★上記4項目をまとめて設定したい場合
# 
# アイテム/スキルのメモ欄に<強制付与>と記入する事で
# そのアイテム/スキルは上記5項目全ての効果を持つようになります。
#==============================================================================
module V_RATE_IS
  
  #運を無視してステート付与を行うアイテム/スキルの設定用ワードを設定します。
  
  WORD1 = "運無視ステート付与"
  
  #運を無視して弱体付与を行うアイテム/スキルの設定用ワードを設定します。
  
  WORD2 = "運無視弱体付与"
  
  #有効度を無視してステート付与を行うアイテム/スキルの設定用ワードを設定します。
  
  WORD3 = "有効度無視ステート付与"
  
  #有効度を無視して弱体付与を行うアイテム/スキルの設定用ワードを設定します。
  
  WORD4 = "有効度無視弱体付与"
  
  #上記5つを全て含めたステート/弱体付与のアイテム/スキルの設定用ワードを設定します。
  
  WORD5 = "強制付与"
  
end
class Game_Temp
  #一時データの無視判定を外部から変更可能にしておく。
  attr_accessor:luk_effect_rate_100
  attr_accessor:state_rate_100
  attr_accessor:debuff_rate_100
end
class Game_BattlerBase
  #--------------------------------------------------------------------------
  # ステート有効度の取得
  #--------------------------------------------------------------------------
  alias state_rate_100 state_rate
  def state_rate(state_id)
    $game_temp.state_rate_100 ? 1.0 : state_rate_100(state_id)
  end
  #--------------------------------------------------------------------------
  # 弱体有効度の取得
  #--------------------------------------------------------------------------
  alias debuff_rate_100 debuff_rate
  def debuff_rate(param_id)
    $game_temp.debuff_rate_100 ? 1.0 : debuff_rate_100(param_id)
  end
end
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # 運有効度判定を分岐させる
  #--------------------------------------------------------------------------
  alias luk_effect_rate_100fixed luk_effect_rate
  def luk_effect_rate(user)
    
    #一時データを参照し、状態次第で確率を1.0に固定させる。
    
    $game_temp.luk_effect_rate_100 ? 1.0 : luk_effect_rate_100fixed(user)
  end
  #--------------------------------------------------------------------------
  # 使用効果［ステート付加］
  #--------------------------------------------------------------------------
  alias item_effect_add_state_100fixed item_effect_add_state
  def item_effect_add_state(user, item, effect)
    
    #アイテムに応じて一時データを変更する。
    
    $game_temp.luk_effect_rate_100 = item.luk_effect_rate_100[0]
    $game_temp.state_rate_100 = item.is_void_rate[0]
    
    #本来の処理を実行。
    
    item_effect_add_state_100fixed(user, item, effect)
    
    #一時データをfalseに戻す。
    
    $game_temp.luk_effect_rate_100 = nil
    $game_temp.state_rate_100 = nil
    
  end
  #--------------------------------------------------------------------------
  # アイテム/スキルによる弱体付与
  #--------------------------------------------------------------------------
  alias item_effect_add_debuff_100fixed item_effect_add_debuff
  def item_effect_add_debuff(user, item, effect)
    
    #アイテムに応じて一時データを変更する。
    
    $game_temp.luk_effect_rate_100 = item.luk_effect_rate_100[1]
    $game_temp.debuff_rate_100 = item.is_void_rate[1]
    
    #本来の処理を実行。
    
    item_effect_add_debuff_100fixed(user, item, effect)
    
    #一時データをfalseに戻す。
    
    $game_temp.luk_effect_rate_100 = nil
    $game_temp.state_rate_100 = nil
    
  end
end
class RPG::UsableItem < RPG::BaseItem
  #--------------------------------------------------------------------------
  # 運無視
  #--------------------------------------------------------------------------
  def luk_effect_rate_100
    
    #キャッシュがある場合はキャッシュを返す。
    
    @luk_effect_rate_100 ||= /<#{V_RATE_IS::WORD5}>/ =~ note ? [true, true] : [
    (/<#{V_RATE_IS::WORD1}>/ =~ note ? true : false),
    (/<#{V_RATE_IS::WORD2}>/ =~ note ? true : false)]
    
  end
  #--------------------------------------------------------------------------
  # 有効度無視
  #--------------------------------------------------------------------------
  def is_void_rate
    
    #キャッシュがある場合はキャッシュを返す。
    
    @is_void_rate ||= /<#{V_RATE_IS::WORD5}>/ =~ note ? [true, true] : [
    (/<#{V_RATE_IS::WORD3}>/ =~ note ? true : false),
    (/<#{V_RATE_IS::WORD4}>/ =~ note ? true : false)]
    
  end
end