#==============================================================================
#    ☆VXAce RGSS3 「戦闘画面顔グラ表示」☆
#　　　　　　EnDlEss DREamER
#     URL:http://mitsu-evo.6.ql.bz/
#     製作者 mitsu-evo
#     Last:2012/1/1
#　　 戦闘画面の名前付近にキャラの顔グラを表示
#     ▼ 素材のすぐ下辺りにでも。
#==============================================================================
$ed_rgss3 = {} if $ed_rgss3 == nil
$ed_rgss3["ed_battle_face"] = true
=begin



=end
module ED
  
  # 顔グラの表示設定。
  # 顔グラの左上を座標(0,0)
  # 座標(0,0)を基点として幅96・高さ24のサイズを基本設定では表示。
  # ようは顔グラ1枚が「幅96×高さ96」の画用紙で、どの辺りを表示するかという設定。
  
  BTL_FACE_RECT_X = 0          # 顔グラの表示を始める基点座標Ｘ
  BTL_FACE_RECT_Y = 38         # 顔グラの表示を始める基点座標Ｙ
  BTL_FACE_RECT_WIDTH = 96     # 基点座標Ｘ・Ｙからの表示幅
  BTL_FACE_RECT_HEIGHT = 24    # 基点座標Ｘ・Ｙからの表示高さ
  
end

class Window_Base < Window
#==============================================================================
# ■ Window_Base
#------------------------------------------------------------------------------
# 　ゲーム中のすべてのウィンドウのスーパークラスです。
#==============================================================================

  
  #--------------------------------------------------------------------------
  # ● 顔グラフィックの描画
  #     face_name  : 顔グラフィック ファイル名
  #     face_index : 顔グラフィック インデックス
  #     x          : 描画先 X 座標
  #     y          : 描画先 Y 座標
  #     size       : 表示サイズ
  #--------------------------------------------------------------------------
  def draw_battle_face(face_name, face_index, x, y, size = 96)
    bitmap = Cache.face(face_name)
    #顔グラ(開始Ｘ,開始Ｙ,表示幅,表示高さ)
    rect = Rect.new(0,0,0,0)
    # + ED::BTL_FACE_RECT_Xが顔グラＸ座標の表示開始位置
    rect.x = face_index % 4 * 96 + ED::BTL_FACE_RECT_X
    # + ED::BTL_FACE_RECT_Yが顔グラＹ座標の表示開始位置
    rect.y = face_index / 4 * 96 + ED::BTL_FACE_RECT_Y
    # 顔グラ表示幅
    rect.width = ED::BTL_FACE_RECT_WIDTH
    # 顔グラ表示高さ
    rect.height = ED::BTL_FACE_RECT_HEIGHT
    # 戦闘ウィンドウへの表示座標と表示領域及び、表示画像の指定。
    self.contents.blt(x, y, bitmap, rect)
    # 表示画像bitmapの解放。
    bitmap.dispose
  end
end
  
class Window_BattleStatus < Window_Selectable 
  
#==============================================================================
# ■ Window_BattleStatus
#------------------------------------------------------------------------------
# 　バトル画面でパーティメンバーのステータスを表示するウィンドウです。
#==============================================================================

  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index   : 項目番号
  #--------------------------------------------------------------------------
  alias ed_battle_face_draw_basic_area draw_basic_area
  def draw_basic_area(rect, actor)
    # 実際の戦闘ステータスウィンドウでの顔グラ表示座標設定。
    draw_battle_face(actor.face_name, actor.face_index, 4, rect.y)
    ed_battle_face_draw_basic_area(rect, actor)
  end
end
 


