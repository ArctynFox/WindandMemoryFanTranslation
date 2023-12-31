#===========================================================================
# ◆ A1 Scripts ◆
#    イベントがイベントを通過（RGSS3）
#
# バージョン   ： 1.00 (2011/12/31)
# 作者         ： A1
# URL　　　　　： http://a1tktk.web.fc2.com/
#---------------------------------------------------------------------------
# 機能：
# ・イベントが「通常キャラより下」及び「通常キャラより上」のイベントを
#   通過できるようにします
#---------------------------------------------------------------------------
# 更新履歴　　 ：2011/12/31 Ver1.00 リリース
#---------------------------------------------------------------------------
# 設置場所      
#　　A1共通スクリプトより下
#
# 必要スクリプト
#    A1共通スクリプト
#---------------------------------------------------------------------------
# 使い方
#　マップ設定のメモに <イベント通過> と記述
#==============================================================================
$imported ||= {}
$imported["A1_EventPath"] = true
if $imported["A1_Common_Script"]
#==============================================================================
# ■ Game_CharacterBase
#==============================================================================

class RPG::Map
  #--------------------------------------------------------------------------
  # ○ イベント通過
  #--------------------------------------------------------------------------
  def through_event
    @through_event ||= $a1_common.note_data(self.note, "イベント通過")
    return true if @through_event
    return false
  end
end
#==============================================================================
# ■ Game_Map
#------------------------------------------------------------------------------
# 　マップを扱うクラスです。スクロールや通行可能判定などの機能を持っています。
# このクラスのインスタンスは $game_map で参照されます。
#==============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # ○ イベントスルー
  #--------------------------------------------------------------------------
  def through_event
    return @map.through_event
  end
end
#==============================================================================
# ■ Game_CharacterBase
#------------------------------------------------------------------------------
# 　キャラクターを扱う基本のクラスです。全てのキャラクターに共通する、座標やグ
# ラフィックなどの基本的な情報を保持します。
#==============================================================================

class Game_CharacterBase
  #--------------------------------------------------------------------------
  # ☆ イベントとの衝突判定
  #--------------------------------------------------------------------------
  alias a1_event_through_gcb_collide_with_events? collide_with_events?
  def collide_with_events?(x, y)
    return a1_event_through_gcb_collide_with_events?(x, y) unless $game_map.through_event
    $game_map.events_xy_nt(x, y).any? {|event| event.normal_priority? }
  end
end
end