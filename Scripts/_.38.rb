=begin #=======================================================================

◆◇逃走の仕様変更 RGSS3◇◆ 

◆DEICIDE ALMA
◆レーネ　
◆http://blog.goo.ne.jp/exa_deicide_alma

★機能
デフォの逃走のおかしい仕様を改善します

※デフォ仕様
 - 戦闘開始時に逃走率を計算(マイナスになる場合もあり)
 - この値に逃走失敗時の補正をしていくだけで再度計算はしない
 - 途中から出現の敵のAGIも計算に含めている

また、以下の３つの設定ができます
逃走率の最低値と最大値の設定
逃走失敗時に加算する逃走率の設定
スイッチがオンのときに変数の値(％)で逃走確率の設定

■確率計算は以下の手順で行われます
１．AGI差による基本計算
２．最低値を下回っていたら補正
３．逃走失敗時の補正
４．最大値を上回っていたら補正

※ 変数を利用する場合は、他の設定を無視します

◆導入箇所
▼素材のところ、mainより上

=end #=========================================================================
module RENNE ; module Escape
  
  MIN = 0.4   # 逃走率の最低値(1.0で100％)
  MAX = 1.0   # 逃走率の最大値(1.0で100％)
  CO  = 0.2   # 逃走失敗時に加算する逃走率(1.0で100%)
  
  SW  = 0 # 逃走率を変数で設定したいときにオンにするスイッチ
  VAR = 0 # 逃走率を格納する変数(値が100で100％)
  
end ; end

$renne_rgss3 = {} if $renne_rgss3.nil?
$renne_rgss3[:escape_setting] = true

class << BattleManager
  #--------------------------------------------------------------------------
  # ● メンバ変数の初期化(エイリアス)
  #--------------------------------------------------------------------------
  alias escape_setting_init_members init_members
  def init_members
    escape_setting_init_members
    @escape_rate_correction_count = 0
  end
  #--------------------------------------------------------------------------
  # ● 逃走成功率の作成 ※再定義
  #--------------------------------------------------------------------------
  def make_escape_ratio
    if $game_switches[RENNE::Escape::SW]
      @escape_ratio = $game_variables[RENNE::Escape::VAR] / 100.0
    else
      num = 1.5 - 1.0 * $game_troop.esc_agi / $game_party.esc_agi
      num = [RENNE::Escape::MIN, num].max
      num += @escape_rate_correction_count * RENNE::Escape::CO
      @escape_ratio = [num, RENNE::Escape::MAX].min
    end
  end
  #--------------------------------------------------------------------------
  # ● 逃走の処理(エイリアス)
  #--------------------------------------------------------------------------
  alias escape_setting_process_escape process_escape
  def process_escape
    make_escape_ratio
    @escape_rate_correction_count += 1
    escape_setting_process_escape
  end
end

class Game_Unit
  #--------------------------------------------------------------------------
  # ● 逃走用の敏捷性の平均値を計算
  #--------------------------------------------------------------------------
  def esc_agi
    arr = alive_members
    return 1 if arr.empty?
    arr.inject(0) {|r, member| r += member.agi } / arr.size
  end
end
