#==============================================================================
# ■ RGSS3 絶対命中/絶対回避特徴＆アイテム/スキル Ver1.00　by 星潟
#------------------------------------------------------------------------------
# 命中タイプ別、もしくは全てのアイテムについて
# 絶対命中/絶対回避化させる特徴を作成する事ができるようになります。
# また、絶対命中するアイテム/スキルの作成も可能になります。
# 命中/回避関連の全てのスクリプトよりも下に配置される事をお勧めします。
#==============================================================================
# ★設定例（アクター・エネミー・ステート・装備品のメモ欄に設定）
#------------------------------------------------------------------------------
# <全絶対命中>
# 
# このキャラクターによる全てのスキル/アイテムが絶対に命中します。
#------------------------------------------------------------------------------
# <必中絶対命中>
# 
# このキャラクターによる命中タイプ:必中のスキル/アイテムが絶対に命中します。
#------------------------------------------------------------------------------
# <物理絶対命中>
# 
# このキャラクターによる命中タイプ:物理のスキル/アイテムが絶対に命中します。
#------------------------------------------------------------------------------
# <魔法絶対命中>
# 
# このキャラクターによる命中タイプ:魔法のスキル/アイテムが絶対に命中します。
#------------------------------------------------------------------------------
# <全絶対回避>
# 
# このキャラクターが受ける全てのスキル/アイテムを絶対に回避します。
#------------------------------------------------------------------------------
# <必中絶対回避>
# 
# このキャラクターが受ける命中タイプ:必中のスキル/アイテムを絶対に回避します。
#------------------------------------------------------------------------------
# <物理絶対回避>
# 
# このキャラクターが受ける命中タイプ:物理のスキル/アイテムを絶対に回避します。
#------------------------------------------------------------------------------
# <魔法絶対回避>
# 
# このキャラクターが受ける命中タイプ:魔法のスキル/アイテムを絶対に回避します。
#==============================================================================
# ★設定例（アイテム・スキルのメモ欄に設定）
#------------------------------------------------------------------------------
# <絶対命中>
# 
# このスキル/アイテムは絶対に命中します。
#==============================================================================
module CertaintyHit
  
  #絶対命中と絶対回避が同時に計算される場合
  #絶対命中と絶対回避のどちらを優先するかを決定します。
  #0の場合は命中を優先します。
  #1の場合は回避を優先します。
  #2の場合は絶対命中も絶対回避もなかったことにして本来の処理を行います。
  
  Type  = 0
  
  #特徴用の絶対命中化用キーワードを指定します。
  
  Words1 = ["必中絶対命中","物理絶対命中","魔法絶対命中","全絶対命中"]
  
  #特徴用の絶対回避化用キーワードを指定します。
  
  Words2 = ["必中絶対回避","物理絶対回避","魔法絶対回避","全絶対回避"]
  
  #スキル/アイテム用の絶対命中化用キーワードを指定します。
  
  Word = "絶対命中"
  
  #絶対命中時/絶対回避処理用の命中率及び回避率を設定します。
  #絶対命中の場合は、命中に前者、回避に後者、
  #絶対回避の場合は、命中に後者、回避に前者を使用します。
  
  Value = [9.99, -9.99]
  
  #--------------------------------------------------------------------------
  # キーワード配列
  #--------------------------------------------------------------------------
  def self.words(type)
    type ? Words1 : Words2
  end
end
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # スキル／アイテムの命中率計算
  #--------------------------------------------------------------------------
  alias item_hit_certainty item_hit
  def item_hit(user, item)
    
    #設定別に処理。
    
    case CertaintyHit::Type
    
    #絶対命中を優先する場合。
    
    when 0
      
      #絶対命中の場合は絶対命中用の値を返す。
      
      return CertaintyHit::Value[0] if certainty_hit_execute(user, item)
      
      #絶対回避の場合は絶対回避用の値を返す。
      
      return CertaintyHit::Value[1] if certainty_eva_execute(user, item)
    
    #絶対回避を優先する場合。
    
    when 1
      
      #絶対回避の場合は絶対回避用の値を返す。
      
      return CertaintyHit::Value[1] if certainty_eva_execute(user, item)
      
      #絶対命中の場合は絶対命中用の値を返す。
      
      return CertaintyHit::Value[0] if certainty_hit_execute(user, item)
    
    #絶対命中と絶対回避が打ち消し合う場合。
    
    when 2
      
      #絶対命中かつ絶対回避ではない場合は絶対命中用の値を返す。
      
      return CertaintyHit::Value[0] if certainty_hit_execute(user, item) && !certainty_eva_execute(user, item)
      
      #絶対回避かつ絶対命中ではない場合は絶対回避用の値を返す。
      
      return CertaintyHit::Value[1] if certainty_eva_execute(user, item) && !certainty_hit_execute(user, item)
      
    end
    
    #本来の処理を実行。
    
    item_hit_certainty(user, item)
    
  end
  #--------------------------------------------------------------------------
  # スキル／アイテムの回避率計算
  #--------------------------------------------------------------------------
  alias item_eva_certainty item_eva
  def item_eva(user, item)
    
    #設定別に処理。
    
    case CertaintyHit::Type
    
    #絶対命中を優先する場合。
    
    when 0
      
      #絶対命中の場合は絶対命中用の値を返す。
      
      return CertaintyHit::Value[1] if certainty_hit_execute(user, item)
      
      #絶対回避の場合は絶対回避用の値を返す。
      
      return CertaintyHit::Value[0] if certainty_eva_execute(user, item)
    
    #絶対回避を優先する場合。
    
    when 1
      
      #絶対回避の場合は絶対回避用の値を返す。
      
      return CertaintyHit::Value[0] if certainty_eva_execute(user, item)
      
      #絶対命中の場合は絶対命中用の値を返す。
      
      return CertaintyHit::Value[1] if certainty_hit_execute(user, item)
    
    #絶対命中と絶対回避が打ち消し合う場合。
    
    when 2
      
      #絶対命中かつ絶対回避ではない場合は絶対命中用の値を返す。
      
      return CertaintyHit::Value[1] if certainty_hit_execute(user, item) && !certainty_eva_execute(user, item)
      
      #絶対回避かつ絶対命中ではない場合は絶対回避用の値を返す。
      
      return CertaintyHit::Value[0] if certainty_eva_execute(user, item) && !certainty_hit_execute(user, item)
      
    end
    
    #本来の処理を実行。
    
    item_eva_certainty(user, item)
    
  end
  #--------------------------------------------------------------------------
  # 絶対命中
  #--------------------------------------------------------------------------
  def certainty_hit_execute(user, item)
    
    #絶対命中スキル/アイテムの場合はtrueを返す。
    
    return true if item.certainty_hit_item
    
    #全絶対命中の場合はtrueを返す。
    
    return true if user.certainty_hit(3) or user.certainty_hit(item.hit_type)
    
    #falseを返す。
    
    false
    
  end
  #--------------------------------------------------------------------------
  # 絶対回避
  #--------------------------------------------------------------------------
  def certainty_eva_execute(user, item)
    
    #味方へのスキルの場合は絶対回避は行わない。
    #スキルが味方対象かつ敵対象ではなく
    #使用者がアクターであり対象がアクターであるか
    #使用者がエネミーであり対象がエネミーである場合はfalseとする。
    #（無意味な処理に見えるかもしれませんが、主に競合対策の処理です）
    
    return false if item.for_friend? && !item.for_opponent? && user.actor? == self.actor?
    
    #全絶対回避の場合はtrueを返す。
    
    return true if certainty_eva(3) or certainty_eva(item.hit_type)
    
    #falseを返す。
    
    false
    
  end
  #--------------------------------------------------------------------------
  # 絶対命中データを取得
  #--------------------------------------------------------------------------
  def certainty_hit(type)
    feature_objects.any? {|f| f.certainty_hit_array[type]}
  end
  #--------------------------------------------------------------------------
  # 絶対回避データを取得
  #--------------------------------------------------------------------------
  def certainty_eva(type)
    feature_objects.any? {|f| f.certainty_eva_array[type]}
  end
end
class RPG::BaseItem
  #--------------------------------------------------------------------------
  # 絶対命中配列を取得
  #--------------------------------------------------------------------------
  def certainty_hit_array
    @certainty_hit_array ||= create_certainty_hit_eva_array(true)
  end
  #--------------------------------------------------------------------------
  # 絶対回避配列を取得
  #--------------------------------------------------------------------------
  def certainty_eva_array
    @certainty_eva_array ||= create_certainty_hit_eva_array(false)
  end
  #--------------------------------------------------------------------------
  # 絶対命中/回避配列を作成
  #--------------------------------------------------------------------------
  def create_certainty_hit_eva_array(type)
    CertaintyHit.words(type).inject([]) {|r,t| r.push(/<#{t}>/ =~ note)}
  end
end
class RPG::UsableItem < RPG::BaseItem
  #--------------------------------------------------------------------------
  # 絶対命中アイテム
  #--------------------------------------------------------------------------
  def certainty_hit_item
    (@certainty_hit_item ||= /<#{CertaintyHit::Word}>/ =~ note ? 1 : 0) == 1
  end
end