 
#==============================================================================
#                   「根性（踏み止まり）ステート」(ACE) ver3  by奈々
#
#   ◇使用規約
#   使用される場合はスクリプト作成者として「奈々」を明記して下さい。
#   このスクリプトを改変したり、改変したものを配布するなどは自由ですが
#   その場合も元のスクリプトの作成者として名前は載せて下さい。
#
#------------------------------------------------------------------------------
#
#   致死量のダメージを受けてもHPを1残すステートを作成できます。
#   初期設定でステートIDと「耐えられるダメージの上限」「残るHPの量」「発動モード」を設定して下さい。
#
#==============================================================================
#
# ◇初期設定
module Nana
  
#根性が発動するステートのID
  STATE_KONJO = 59
    
#耐えられるダメージの上限、↓で直接指定か％指定か選択する
  KONJO_DAMAGE = 999999
#falseなら↑の数値そのまま、trueなら最大HPの何％という風になる
  KONJO_DAMAGE_PER = false

#残るHPの量、↓で直接指定か％指定か選択する
  KONJO_HP = 1
#falseなら↑の数値そのまま、trueなら最大HPの何％という風になる
  KONJO_HP_PER = false

#falseならステート時は何度でも発動、trueなら↑で設定したHP以下だと発動しない
  KONJO_MODE = true
  
end
# ここまで
# 以下は弄らないで下さい

#==============================================================================
# ■ Game_Battler
#------------------------------------------------------------------------------
# 　スプライトや行動に関するメソッドを追加したバトラーのクラスです。このクラス
# は Game_Actor クラスと Game_Enemy クラスのスーパークラスとして使用されます。
#==============================================================================

class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # ● ダメージの処理
  #    呼び出し前に @result.hp_damage @result.mp_damage @result.hp_drain
  #    @result.mp_drain が設定されていること。
  #--------------------------------------------------------------------------
  alias konjo_execute_damage execute_damage
  def execute_damage(user)
    if Nana::KONJO_DAMAGE_PER == 1
      damper = @result.hp_damage / self.mhp * 100
    else
      damper = @result.hp_damage
    end
    hpmode = Nana::KONJO_HP_PER
    if Nana::KONJO_HP_PER == true
      konhp = self.mhp * Nana::KONJO_HP / 100
    else
      konhp = Nana::KONJO_HP
    end
    if state?(Nana::STATE_KONJO) and damper <= Nana::KONJO_DAMAGE and self.hp <= @result.hp_damage
      unless Nana::KONJO_MODE == true and self.hp <= konhp
        @result.hp_damage = self.hp - konhp
      end
    end
    konjo_execute_damage(user)
  end
end
