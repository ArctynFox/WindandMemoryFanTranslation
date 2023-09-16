#==============================================================================
# ■ RGSS3 ニッチな軽量化 Ver1.00 by 星潟
#------------------------------------------------------------------------------
# シンボルエンカウントやアドベンチャー/ホラーゲーム向けの特殊な軽量化を施します。
# 特に、歩行によるパーティメンバーへの全ての効果の無効化は
# ゲームシステムによっては大きな軽量化が見込めます。
# （歩いている途中、一定歩数歩く事で妙なカクつきが発生する原因の一つです）
#==============================================================================
module EX_LIGHT
  
  #歩行によるパーティメンバーへの全ての効果を無効にします。
  
  STEP_PT_DELETE = false
  
  #エンカウント処理を無効にします。
  
  ENCOUNT_DELETE = true
  
end
#歩行によるパーティメンバーへの全ての効果の無効化。
#具体的には、ダメージ床判定と歩行によるステート自動解除/自然回復等が消滅します。
if EX_LIGHT::STEP_PT_DELETE
class Game_Party < Game_Unit
  def on_player_walk
  end
end
end
#ランダムエンカウントを全て抹消。
if EX_LIGHT::ENCOUNT_DELETE
class Game_Player < Game_Character
  def update_encounter
  end
end
class Scene_Map < Scene_Base
  def update_encounter
  end
end
end