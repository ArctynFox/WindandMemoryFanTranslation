#==============================================================================
# ■ RGSS3 アイテム・スキルHPMP回復無効・反転特徴 Ver1.01 by 星潟
#==============================================================================
# アイテム・スキルによるHPやMP回復効果を
# 任意の確率でダメージに反転する特徴を作成できるようになります。
#==============================================================================
# 設定は、共通して特徴を有する項目のメモ欄で行います。
# また、回復無効・反転確率は全ての特徴で加算されます。
# 
# なお、無効・反転が起こるのはアイテムやスキルによる直接的な効果のみです。
# 自動回復やイベントコマンド等による回復には影響を及ぼしません。
#==============================================================================
# ★HP無効設定方法
# <HP回復無効:100>と記入する事で、100％の確率でHP回復が無効になります。
#------------------------------------------------------------------------------
# ★MP無効設定方法
# <MP回復無効:25>と記入する事で、25％の確率でMP回復が無効になります。
#------------------------------------------------------------------------------
# ★HP反転設定方法
# <HP回復反転:50>と記入する事で、50％の確率でHP回復がHPダメージになります。
#------------------------------------------------------------------------------
# ★MP反転設定方法
# <MP回復反転:75>と記入する事で、75％の確率でMP回復がMPダメージになります。
#==============================================================================
# Ver1.01 使用効果にも判定を行うように改修しました。
#==============================================================================
module DMRV
  
  #HP回復無効ステート設定用キーワードを指定。
  
  WORD1 = "HP回復無効"
  
  #MP回復無効ステート設定用キーワードを指定。
  
  WORD2 = "MP回復無効"
  
  #HP回復反転ステート設定用キーワードを指定。
  
  WORD3 = "HP回復反転"
  
  #MP回復反転ステート設定用キーワードを指定。
  
  WORD4 = "MP回復反転"
  
  #HP回復無効時のテキストを表示。
  
  TEXT1 = " can't recover HP!"
  
  #MP回復無効時のテキストを表示。
  
  TEXT2 = " can't recover MP!"
  
end
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # 使用効果［HP 回復］
  #--------------------------------------------------------------------------
  alias item_effect_recover_hp_rv_execute item_effect_recover_hp
  def item_effect_recover_hp(user, item, effect)
    value = (mhp * effect.value1 + effect.value2)
    value = value.to_i
    true_effect = effect.clone
    if value > 0
      
      @result.hp_r_void ||= 1
      
      #HP無効特徴が有効な場合、HPダメージを0にし、無効フラグをONにする。
      
      if @result.hp_r_void == 2 or (@result.hp_r_void == 1 && hm_rv_array[0] > rand(100))
        
        true_effect.value1 = 0
        true_effect.value2 = 0
        @result.hp_r_void = 2
      
      #HP反転特徴が有効な場合、HPダメージを反転する。
      
      elsif @result.hp_r_void == 3 or (@result.hp_r_void == 1 && hm_rv_array[2] > rand(100))
        
        true_effect.value1 = 0
        true_effect.value2 = -value
      
      #どちらも無効な場合は何もしない。
      
      end
    end
    
    #本来の処理を実行。
    
    item_effect_recover_hp_rv_execute(user, item, true_effect)
  end
  #--------------------------------------------------------------------------
  # 使用効果［MP 回復］
  #--------------------------------------------------------------------------
  alias item_effect_recover_mp_rv_execute item_effect_recover_mp
  def item_effect_recover_mp(user, item, effect)
    value = (mmp * effect.value1 + effect.value2)
    value = value.to_i
    true_effect = effect.clone
    if value > 0
      
      @result.mp_r_void ||= 1
      
      #HP無効特徴が有効な場合、HPダメージを0にし、無効フラグをONにする。
      
      if @result.mp_r_void == 2 or (@result.mp_r_void == 1 && hm_rv_array[1] > rand(100))
        
        true_effect.value1 = 0
        true_effect.value2 = 0
        @result.mp_r_void = 2
        @result.success = true
        
      #HP反転特徴が有効な場合、HPダメージを反転する。
      
      elsif @result.mp_r_void == 3 or (@result.mp_r_void == 1 && hm_rv_array[3] > rand(100))
        
        true_effect.value1 = 0
        true_effect.value2 = -value
      
      #どちらも無効な場合は何もしない。
      
      end
    end
    
    #本来の処理を実行。
    
    item_effect_recover_mp_rv_execute(user, item, true_effect)
  end
  #--------------------------------------------------------------------------
  # 無効・反転確率作成
  #--------------------------------------------------------------------------
  def hm_rv_array
    
    return @result.hm_rv_array if @result.hm_rv_array
    
    #初期データの配列を用意。
    
    @result.hm_rv_array = [0,0,0,0]
    
    #特徴別の値を合算し、確率判定。
    
    feature_objects.each {|f| 4.times {|i| @result.hm_rv_array[i] += f.hm_rv_array[i]}}
    
    #データを返す。
    
    @result.hm_rv_array
    
  end
end
class Game_ActionResult
  attr_accessor :hm_rv_array
  attr_accessor :hp_r_void
  attr_accessor :mp_r_void
  #--------------------------------------------------------------------------
  # ダメージの作成
  #--------------------------------------------------------------------------
  alias make_damage_rv_execute make_damage
  def make_damage(value, item)
    
    #本来の処理を実行。
    
    make_damage_rv_execute(value, item)
    
    #HPダメージが0より低い（回復）の場合。
    
    if @hp_damage < 0
      
      @hp_r_void = 0
      
      #HP無効特徴が有効な場合、HPダメージを0にし、無効フラグをONにする。
      
      if @battler.hm_rv_array[0] > rand(100)
        
        @hp_damage = 0
        @hp_r_void = 2
      
      #HP反転特徴が有効な場合、HPダメージを反転する。
      
      elsif @battler.hm_rv_array[2] > rand(100)
        
        @hp_damage = -@hp_damage
        @hp_r_void = 3
      
      #どちらも無効な場合は何もしない。
      
      end
    end
    
    #MPダメージが0より低い（回復）の場合。
    
    if @mp_damage < 0
      
      @mp_r_void = 0
      
      #MP無効特徴が有効な場合、MPダメージを0にし、無効フラグをONにする。
      
      if @battler.hm_rv_array[1] > rand(100)
        
        @mp_damage = 0
        @mp_r_void = 2
      
      #MP反転特徴が有効な場合、MPダメージを反転する。
      
      elsif @battler.hm_rv_array[3] > rand(100)
        
        @mp_damage = -@mp_damage
        @mp_r_void = 3
      
      #どちらも無効な場合は何もしない。
      
      end
    end
  end
  #--------------------------------------------------------------------------
  # ダメージ値のクリア
  #--------------------------------------------------------------------------
  alias clear_damage_values_rv_execute clear_damage_values
  def clear_damage_values
    
    #本来の処理を実行。
    
    clear_damage_values_rv_execute
    
    #HP・MP回復無効発動フラグを初期化。
    
    @hm_rv_array = nil
    @hp_r_void = false
    @mp_r_void = false
    
  end
end
class Window_BattleLog < Window_Selectable
  #--------------------------------------------------------------------------
  # HP ダメージ表示
  #--------------------------------------------------------------------------
  alias display_hp_damage_rv_execute display_hp_damage
  def display_hp_damage(target, item)
    
    #HP回復無効でなければ本来の処理を実行。
    
    return display_hp_damage_rv_execute(target, item) unless target.result.hp_r_void == 2
    
    #指定したメッセージを表示し、ウェイト。
    
    add_text(target.name + DMRV::TEXT1)
    wait
    
  end
  #--------------------------------------------------------------------------
  # MP ダメージ表示
  #--------------------------------------------------------------------------
  alias display_mp_damage_rv_execute display_mp_damage
  def display_mp_damage(target, item)
    
    #MP回復無効でなければ本来の処理を実行。
    
    return display_mp_damage_rv_execute(target, item) unless target.result.mp_r_void == 2
    
    #指定したメッセージを表示し、ウェイト。
    
    add_text(target.name + DMRV::TEXT2)
    wait
    
  end
end
class RPG::BaseItem
  #--------------------------------------------------------------------------
  # 無効・反転確率の配列
  #--------------------------------------------------------------------------
  def hm_rv_array
    
    #配列を作成。
    
    @heal_rev_feature ||= [
    (/<#{DMRV::WORD1}[:：](\S+)>/ =~ @note ? $1.to_i : 0),
    (/<#{DMRV::WORD2}[:：](\S+)>/ =~ @note ? $1.to_i : 0),
    (/<#{DMRV::WORD3}[:：](\S+)>/ =~ @note ? $1.to_i : 0),
    (/<#{DMRV::WORD4}[:：](\S+)>/ =~ @note ? $1.to_i : 0)
    ]
    
  end
end