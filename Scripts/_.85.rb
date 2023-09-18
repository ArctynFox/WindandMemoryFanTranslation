#==============================================================================
# ■ RGSS3 最大レベル限界突破特徴 Ver1.03　by 星潟
#------------------------------------------------------------------------------
# このスクリプトを導入することで
# レベル100以上へのレベルアップを可能にする特徴を作成できます。
# また、レベル100以上でのレベルアップでのスキル習得設定も可能です。
#------------------------------------------------------------------------------
# ★特徴を有する項目のメモ欄設定例
#------------------------------------------------------------------------------
# <レベル限界増加:10>
# 
# 限界レベルが+10されます。
# 
# <限界突破後補正:110>
# 
# レベル100以上のレベルアップ時の能力増加値の割合は
# レベル98→99の際の増加値にP_RATEで設定した％をかけたものの
# 110％の値となります。
# 
# <限界突破後補正:level>
# 
# レベル100以上のレベルアップ時の能力増加値の割合は
# レベル98→99の際の増加値にP_RATEで設定した％をかけたものの
# 現在レベル％の値となります。（レベル250の場合、250％）
#------------------------------------------------------------------------------
# ★職業の覚えるスキルのメモ欄（小さいメモ欄）設定例
#------------------------------------------------------------------------------
# <LV:120>
# 
# このスキルは本来の指定レベルで覚えず、レベル120で覚えます。
#------------------------------------------------------------------------------
# ★必要経験値補正（職業のメモ欄）設定例
#   この項目は、1つの職業のメモ欄に対し、行を分けて記述する事で複数指定できます。
#   1つ目の引数としてレベル、2つ目の引数としてEXP増加量を指定します。
#   2つ目の引数には、levelという変数を用いる事が出来ます。
#   （levelの値は、次のレベルの数値となります）
#------------------------------------------------------------------------------
# <必要経験値補正:100,10000>
# 
# この場合、レベル100からの必要経験値が10000増加します。
#------------------------------------------------------------------------------
# <必要経験値補正:150,level*level>
# 
# この場合、レベル150からの必要経験値がそのレベルの二乗の値分増加します。
#------------------------------------------------------------------------------
# Ver1.01 テストプレイ以外でのレベル100以上でのスキル習得設定に
#         致命的な不具合があった問題を修正しました。
#         また、キャッシュ化による全体的な軽量化を施しました。
#         追加機能として、レベル描写領域の変更機能を追加しました。
# Ver1.02 必要経験値に補正をかけられるようになりました。
#         限界突破後補正のかかり方に異常があった不具合を修正しました。
#         能力増加割合を計算式で求める方式に変更しました。
#==============================================================================
module MLV_CHANGE
  
  #レベル100以上のレベルアップ時の能力増加値の基本割合を設定します。
  #計算式の文字列となっているので、任意の数値を文字列として記入して下さい。
  #基本割合での増減を行いたくない場合は、"100"として下さい。
  
  #なお、能力増加値は、レベル98→99の際の能力を100％として計算します。
  #レベルに応じて変動させたい場合は"level"等とする事で
  #レベル依存になります。
  
  P_RATE = "105"
  
  #レベル限界がどれだけ増加するかを設定する特徴メモ欄用キーワードを設定します。
  
  WORD1  = "レベル限界増加"
  
  #R_RATEにさらに追加する特徴メモ欄用キーワードを設定します。
  
  WORD2  = "限界突破後補正"
  
  #そのスキルを覚えるレベルを設定する職業スキルメモ欄用キーワードを設定します。
  
  WORD3  = "LV"
  
  #必要経験値補正用の職業メモ欄用キーワードを設定します。
  
  WORD4  = "必要経験値補正"
  
  #レベル描写領域調整値（0以上でWindow_Baseのレベル描写を上書きして調整する）
  #デフォルトでは3桁の表示に適した値である8を入れています。
  
  LVDRW  = 8
  
end
class RPG::BaseItem
  #--------------------------------------------------------------------------
  # 最大レベル増加値
  #--------------------------------------------------------------------------
  def mlv_plus
    
    #キャッシュがあればキャッシュを返す。
    
    return @mlv_plus if @mlv_plus != nil
    
    #メモ欄からデータを取得
    
    memo = self.note.scan(/<#{MLV_CHANGE::WORD1}[：:](\S+)>/).flatten
    
    #最大レベル増加値を取得する。
    
    @mlv_plus = (memo != nil && !memo.empty?) ? memo[0].to_i : 0
    
    #データを返す。
    
    return @mlv_plus
    
  end
  #--------------------------------------------------------------------------
  # Lv99以降の能力補正値
  #--------------------------------------------------------------------------
  def olv_extend
    
    #キャッシュがあればキャッシュを返す。
    
    return @olv_extend if @olv_extend != nil
    
    #メモ欄からデータを取得
    
    memo = self.note.scan(/<#{MLV_CHANGE::WORD2}[：:](\S+)>/).flatten
    
    #最大レベル増加値を取得する。
    
    @olv_extend = (memo != nil && !memo.empty?) ? memo[0] : "100"
    
    #データを返す。
    
    return @olv_extend
    
  end
end
class RPG::Class < RPG::BaseItem
  #--------------------------------------------------------------------------
  # 必要経験値補正配列
  #--------------------------------------------------------------------------
  def etc_array
    
    #キャッシュがある場合はキャッシュを返す。
    
    return @etc_array if @etc_array != nil
    
    #空の配列を作成。
    
    @etc_array = []
    
    #メモ欄の行別に処理。
    
    @note.each_line {|line|
    
    #メモ欄からデータを取得。
    
    memo = line.scan(/<#{MLV_CHANGE::WORD4}[：:](\S+),(\S+)>/).flatten
    
    #適切なデータが得られない場合は次の行へ。
    
    next if memo == nil or memo.size != 2
    
    #配列に配列を加える。
    
    @etc_array.push([memo[0].to_i,memo[1]])
    
    }
    
    #配列を返す。
    
    return @etc_array
    
  end
  #--------------------------------------------------------------------------
  # 必要経験値
  #--------------------------------------------------------------------------
  alias exp_for_level_etc_array exp_for_level unless $!
  def exp_for_level(level)
    
    #本来の値に必要経験値補正配列のデータを加えた物を返す。
    
    exp_for_level_etc_array(level) +
    etc_array.inject(0) {|r, array|
    r += (level >= array[0]) ? eval(array[1]) * (level - array[0] + 1) : 0}
    
  end

end
class RPG::Class::Learning
  #--------------------------------------------------------------------------
  # 習得レベル
  #--------------------------------------------------------------------------
  def level
    
    #キャッシュがあればキャッシュを返す。
    
    return @true_level if @true_level != nil
    
    #メモ欄からデータを取得
    
    memo = @note.scan(/<#{MLV_CHANGE::WORD3}[：:](\S+)>/).flatten
    
    #習得レベルを取得する。
    
    @true_level = (memo != nil && !memo.empty?) ? memo[0].to_i : @level
    
    #データを返す。
    
    return @true_level
  end
end
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # 最大レベル
  #--------------------------------------------------------------------------
  alias max_level_lb max_level
  def max_level
    
    #本来の処理での最大レベルを取得する。
    
    data = max_level_lb
    
    #各特徴の最大レベル増加値を足す。
    
    feature_objects.each {|f| data += f.mlv_plus}
    
    return data
  end
  #--------------------------------------------------------------------------
  # 通常能力値の基本値取得
  #--------------------------------------------------------------------------
  alias param_base_lb param_base
  def param_base(param_id)
    
    #レベル99以下の時は通常の処理を行い
    #100以上の場合は通常処理にレベル99以上でのパラメータを加える。
    
    olp = @level > 99 ? over_level_param(param_id) : 0
    l = @level.to_i
    if l > 99
      @level = 99
    end
    d = param_base_lb(param_id) + olp
    @level = l
    d
    
  end
  #--------------------------------------------------------------------------
  # レベル99以上でのパラメータ
  #--------------------------------------------------------------------------
  def over_level_param(param_id)
    
    #レベル98→99でのパラメータ増加値を取得。
    
    data = self.class.params[param_id, 99] - self.class.params[param_id, 98]
    
    #もしも0である場合は0を返す。
    
    return 0 if data == 0
    
    #現在レベルから99を引いた値、基本パラメータ補正、
    #パラメータ補正特徴による補正をパラメータ増加値に乗算し
    #最後に小数点以下を切り捨てる。
    
    data = (data * (@level - 99) * olextend_data_1 * olextend_data_2).truncate
    
    #データを返す。
    
    return data
  end
  #--------------------------------------------------------------------------
  # レベル99以上でのパラメータ補正1（基本）
  #--------------------------------------------------------------------------
  def olextend_data_1
    
    #初期データを用意。
    
    data = eval(MLV_CHANGE::P_RATE)
    
    #データが0の場合は0を返す。
    
    return 0 if data == 0
    
    #データが0でない場合は倍率にして返す。
    
    data = data.to_f / 100
    
    #データを返す。
    
    return data
  end
  #--------------------------------------------------------------------------
  # レベル99以上でのパラメータ補正2（特徴依存）
  #--------------------------------------------------------------------------
  def olextend_data_2
    
    #初期データを用意。
    
    data = 100
    
    #各特徴のパラメータ補正を加算。
    
    feature_objects.each {|f| data += eval(f.olv_extend) - 100}
    
    #データが0の場合は0を返す。
    
    return 0 if data == 0
    
    #データが0でない場合は倍率にして返す。
    
    data = data.to_f / 100
    
    #データを返す。
    
    return data
  end
end
if MLV_CHANGE::LVDRW > 0
  class Window_Base < Window
    #--------------------------------------------------------------------------
    # レベルの描画
    #--------------------------------------------------------------------------
    def draw_actor_level(actor, x, y)
      
      #文字色を変える。
      
      change_color(system_color)
      
      #システムで指定したレベルの文字を返す。
      
      draw_text(x, y, 32, line_height, Vocab::level_a)
      
      #文字色を変える。
      
      change_color(normal_color)
      
      #レベルの値を記述する。
      
      draw_text(x + 32 - MLV_CHANGE::LVDRW, y, 24 + MLV_CHANGE::LVDRW, line_height, actor.level, 2)
    end
  end
end