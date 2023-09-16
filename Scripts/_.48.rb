=begin
RGSS3
      
      ★ リージョンからのコモンイベント呼び出し ★
      
      プレイヤーの居るリージョンによってコモンイベントを呼び出すことができます。
      マップ毎にリージョンから呼び出すコモンイベントの設定が可能です。
      
      ● 使い方 ●========================================================
      マップの設定にあるメモ欄に次の記述を行ってください。
      改行して記述することで、複数のリージョンにコモンイベント起動の
      設定を行うこともできます。
      
      RCE:n,m,o
      
      n => コモンイベントを起動するリージョンID
      
      m => 起動するコモンイベントID
      
      o => コモンイベント起動のタイプ
        0 => プレイヤーのいるリージョンが変わった時にコモンイベントを起動
        1 => そのリージョンにいる限りコモンイベントを起動し続ける
      --------------------------------------------------------------------
      例： 
      RCE:10,4,0
      RCE:8,2,1
      
      リージョンID10にプレイヤーが足を踏み入れた時、
      コモンイベントID4を実行する。
      リージョンID8にプレイヤーが居る間、
      コモンイベントID2を実行し続ける。
      ====================================================================
        
      ver1.00

      Last Update : 2013/11/26
      11/26 : 新規
      
      ろかん　　　http://kaisou-ryouiki.sakura.ne.jp/
=end

$rsi ||= {}
$rsi["リージョンからのコモンイベント呼び出し"] = true

class RPG::Map
  def get_event_call_regions
    result = {}
    self.note.each_line{|line|
      result[$1.to_i] = [$2.to_i, $3.to_i] if line =~ /RCE:(\d+),(\d+),(\d+)/i
    }
    result
  end
end

class Game_Map
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias _event_call_regions_initialize initialize
  def initialize
    _event_call_regions_initialize
    @event_call_regions = {}
    @old_region = -1
  end
  #--------------------------------------------------------------------------
  # ● セットアップ
  #--------------------------------------------------------------------------
  alias _event_call_regions_setup setup
  def setup(map_id)
    _event_call_regions_setup(map_id)
    @event_call_regions = @map.get_event_call_regions
    @old_region = -1
  end
  #--------------------------------------------------------------------------
  # ● プレイヤー位置のリージョン取得
  #--------------------------------------------------------------------------
  def get_player_region
    region_id($game_player.x, $game_player.y)
  end
  #--------------------------------------------------------------------------
  # ● プレイヤー位置のリージョンID変更判定
  #--------------------------------------------------------------------------
  def region_change?(pri)
    @old_region != pri
  end
  #--------------------------------------------------------------------------
  # ● リージョンによるイベント起動判定
  #--------------------------------------------------------------------------
  def event_call_for_region?(pri)
    if @event_call_regions.has_key?(pri)
      @event_call_regions[pri][1].zero? ? region_change?(pri) : true
    else
      false
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias _event_call_regions_update update
  def update(main = false)
    pri = get_player_region
    if event_call_for_region?(pri)
      $game_temp.reserve_common_event(@event_call_regions[pri][0])
    end
    @old_region = pri
    _event_call_regions_update(main)
  end
end