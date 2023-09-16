#==============================================================================
# ■リージョン通行設定 for RGSS3 Ver2.00-β3
# □作成者 kure
#===============================================================================

module KURE
  module RegionPass
    #初期設定
    Z_Region = []; TRANSPARENT_Region = [] ;SWITH_PASS = []
    
    #交差点となるリージョンID---------------------------------------------------
      CROSS_Region = [63,59]
    
    #透明度変化リージョン-------------------------------------------------------
      #TRANSPARENT_Region[ID] = 不透明度(0～255)
      TRANSPARENT_Region[59] = 50
    
    #プライオリティ設定タイプ---------------------------------------------------
      #(0 → キャラクターより下=90　キャラクターと同じ = 100　キャラクターより上 = 110)
      #(1 → キャラクターより下=0　キャラクターと同じ = 100　キャラクターより上 = 200)
      PRIORITY_TYPE = 1

    #Z座標設定------------------------------------------------------------------
      #Z_Region[ID] = 設定値
      Z_Region[60] = 400
      Z_Region[62] = 300
      
    #リージョンを通行可にするスイッチ-------------------------------------------
      #SWITH_PASS[ID] = [スイッチID]
      SWITH_PASS[1] = [53]
      SWITH_PASS[2] = [55]
      SWITH_PASS[3] = [242]
      SWITH_PASS[39] = [121]
      SWITH_PASS[45] = [884]
      SWITH_PASS[56] = [931]

  end
end    
  
#==============================================================================
# ■ Game_Map
#==============================================================================
class Game_Map
  #--------------------------------------------------------------------------
  # ● 指定座標に存在するイベント（すり抜け以外）の配列取得
  #--------------------------------------------------------------------------
  def events_xy_ex(x, y, obj, z)
    @events.values.select {|event| event.pos_nt?(x, y) && event.normal_priority? && event.same_height2?(obj,z)}
  end
  #--------------------------------------------------------------------------
  # ● 指定座標に同じ高さのプレイヤーの存在するか取得
  #--------------------------------------------------------------------------
  def player_xy_ex(x, y, z)
    return true if $game_player.x == x && $game_player.y == y && $game_player.screen_z == z
    return false
  end
end

#==============================================================================
# ■ Game_Event
#==============================================================================
class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化(エイリアス再定義)
  #     event : RPG::Event
  #--------------------------------------------------------------------------
  alias k_before_initialize initialize
  def initialize(map_id, event)
    k_before_initialize(map_id, event)
    real_first_z
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ(エイリアス再定義)
  #--------------------------------------------------------------------------
  alias k_before_refresh refresh
  def refresh
    k_before_refresh
    real_first_z
  end
  #--------------------------------------------------------------------------
  # ● 初期 Z 座標の取得(追加定義)
  #--------------------------------------------------------------------------
  def real_first_z
    unless @event.name
      @first_z_pos = 90 + @priority_type * 10 if KURE::RegionPass::PRIORITY_TYPE == 0
      @first_z_pos = @priority_type * 100 if KURE::RegionPass::PRIORITY_TYPE == 1
    end
    @event.name.match(/<Z座標\s?(\d+)\s?>/)
      @first_z_pos = 90 + @priority_type * 10 if KURE::RegionPass::PRIORITY_TYPE == 0
      @first_z_pos = @priority_type * 100 if KURE::RegionPass::PRIORITY_TYPE == 1
    return unless $1
    @first_z_pos = $1.to_i
  end
  #--------------------------------------------------------------------------
  # ● 接触イベントの起動判定(再定義)
  #--------------------------------------------------------------------------
  def check_event_trigger_touch(x, y)
    return if $game_map.interpreter.running?
    if @trigger == 2 && $game_player.pos?(x, y)
      start if !jumping? && normal_priority? && same_height?
    end
  end
  #--------------------------------------------------------------------------
  # ● プレイヤーとの衝突判定（フォロワーを含む）(再定義)
  #--------------------------------------------------------------------------
  def collide_with_player_characters?(x, y)
    same_height? && normal_priority? && $game_player.collide?(x, y)
  end
  #--------------------------------------------------------------------------
  # ● 同じ高さかどうか(プレイヤー用)
  #--------------------------------------------------------------------------
  def same_height?
    return true if self.region_id == 0
    return true if $game_player.region_id == 0
    #Z座標±10の範囲内は同じ高さと判定する
    case KURE::RegionPass::PRIORITY_TYPE
    when 0
      return true if self.screen_z - 11 < $game_player.screen_z && self.screen_z + 11 > $game_player.screen_z
    when 1
      return true if self.screen_z - 101 < $game_player.screen_z && self.screen_z + 101 > $game_player.screen_z
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 同じ高さかどうか(イベント用)
  #--------------------------------------------------------------------------
  def same_height2?(obj, z)
    return true if self.region_id == 0
    return true if obj.region_id == 0
    #Z座標±10の範囲内は同じ高さと判定する
    return true if self.screen_z - 11 < z && self.screen_z + 11 > z
    return false
  end
end

#==============================================================================
# ■ Game_Player
#==============================================================================
class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # ● マップイベントの起動(再定義)
  #     triggers : トリガーの配列
  #     normal   : プライオリティ［通常キャラと同じ］かそれ以外か
  #--------------------------------------------------------------------------
  def start_map_event(x, y, triggers, normal)
    $game_map.events_xy(x, y).each do |event|
      if event.trigger_in?(triggers) && event.normal_priority? == normal && event.same_height?
        event.start
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● プレイヤー判定（フォロワーを含む）(追加定義)
  #--------------------------------------------------------------------------
  def player?
    return true
  end
end

#==============================================================================
# ■ Game_CharacterBase
#==============================================================================
class Game_CharacterBase
  attr_accessor :keep_region            # リージョンID保存
  attr_accessor :region_z_pos           # Z座標保存
  attr_accessor :first_z_pos            # 初期Z座標保存
  attr_accessor :keep_trans             # 透明化設定保存
  #--------------------------------------------------------------------------
  # ● プレイヤー判定（フォロワーを含む）(追加定義)
  #--------------------------------------------------------------------------
  def player?
    return false
  end
  #--------------------------------------------------------------------------
  # ● 通行可能判定(再定義)
  #     d : 方向（2,4,6,8）
  #--------------------------------------------------------------------------
  def passable?(x, y, d)
    x2 = $game_map.round_x_with_direction(x, d)
    y2 = $game_map.round_y_with_direction(y, d)
    return false unless $game_map.valid?(x2, y2)
    return true if @through || debug_through?

    #リージョン追加設定
    pass = cross_region_passable?(x, y, x2, y2)
    return true if pass == 1
    return false if pass == 2
    
    #リージョン追加設定2
    pass = region_passable?(x, y, x2, y2, d)
    return true if pass == 1
    
    return false unless map_passable?(x, y, d)
    return false unless map_passable?(x2, y2, reverse_dir(d))    
    return false if collide_with_characters?(x2, y2)
    
    return true
  end
  #--------------------------------------------------------------------------
  # ● 画面 Z 座標の取得(再定義)
  #--------------------------------------------------------------------------
  def screen_z
    return @region_z_pos if @region_z_pos
    return @first_z_pos if @first_z_pos
    return @priority_type * 100
  end
  #--------------------------------------------------------------------------
  # ● 初期 Z 座標の取得(追加定義)
  #--------------------------------------------------------------------------
  def real_first_z
    @first_z_pos = nil
  end
  #--------------------------------------------------------------------------
  # ● Z 座標の更新(追加定義)
  #--------------------------------------------------------------------------
  def refresh_z
    id = $game_map.region_id(@x, @y)
    
    if @keep_trans != id
      if KURE::RegionPass::TRANSPARENT_Region[id]
        @opacity = KURE::RegionPass::TRANSPARENT_Region[id]
      else
        @opacity = 255
      end
      @keep_trans = id
    end
    
    unless KURE::RegionPass::CROSS_Region.include?(id)
      @region_z_pos = nil
      if KURE::RegionPass::Z_Region[id]
        @region_z_pos = KURE::RegionPass::Z_Region[id]
        @first_z_pos = nil
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 歩数増加(エイリアス再定義)
  #--------------------------------------------------------------------------
  alias k_before_increase_steps increase_steps
  def increase_steps
    refresh_z
    k_before_increase_steps
  end
  #--------------------------------------------------------------------------
  # ● ジャンプ時の更新(エイリアス再定義)
  #--------------------------------------------------------------------------
  alias k_before_update_jump update_jump
  def update_jump
    k_before_update_jump
    refresh_z if @jump_count == 0
  end
  #--------------------------------------------------------------------------
  # ● リージョン通行設定(追加定義)
  #--------------------------------------------------------------------------
  def region_passable?(x, y, x2, y2, d)
    #リージョン設定を取得
    region_s = KURE::RegionPass::SWITH_PASS
    #現在地と移動先のリージョンIDを取得
    point1 = $game_map.region_id(x, y)
    point2 = $game_map.region_id(x2, y2)
    
    #プレーヤー以外は関係ない
    return 0 unless player?
    
    #移動先のリージョンの許可スイッチが入っていれば通行できる
    return 1 if region_s[point2] && $game_switches[region_s[point2][0]]

    #足元のリージョンの許可スイッチが入っていて、移動先が通れるなら通行できる
    return 1 if region_s[point1] && $game_switches[region_s[point1][0]] && map_passable?(x2, y2, reverse_dir(d))
    
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 交差点リージョン通行設定(追加定義)
  #--------------------------------------------------------------------------
  def cross_region_passable?(x, y, x2, y2)
    #立体交差リージョンを取得
    cross = KURE::RegionPass::CROSS_Region
    #現在地と移動先のリージョンIDを取得
    point1 = $game_map.region_id(x, y)
    point2 = $game_map.region_id(x2, y2)
        
    #立体交差リージョンで無ければリージョンIDを取得
    @keep_region = point1 unless cross.include?(point1)
    
    #立体交差リージョンと関係移動ないは判定しない
    return 0 if !cross.include?(point1) && !cross.include?(point2)
    
    #移動先に同じ高さのイベントがあれば通行できない
    return 2 if $game_map.events_xy_ex(x2, y2, self, self.screen_z) != []
    
    #移動先が同じ高さのプレイヤーでも移動できない
    return 0 if $game_map.player_xy_ex(x2, y2, self.screen_z)
    
    #移動先の侵入可能設定
    if point2 != 0
      return 0 if point1 == 0
      return 1 if cross.include?(point2)
      return 1 if point2 == @keep_region
      return 2
    end
    
    return 0
  end
end

#==============================================================================
# ■ Game_Follower
#==============================================================================
class Game_Follower < Game_Character
  #--------------------------------------------------------------------------
  # ● フレーム更新(再定義)
  #--------------------------------------------------------------------------
  def update
    @move_speed     = $game_player.real_move_speed
    @transparent    = $game_player.transparent
    @walk_anime     = $game_player.walk_anime
    @step_anime     = $game_player.step_anime
    @direction_fix  = $game_player.direction_fix
    #@opacity        = $game_player.opacity
    @blend_type     = $game_player.blend_type
    super
  end
  #--------------------------------------------------------------------------
  # ● プレイヤー判定（フォロワーを含む）(追加定義)
  #--------------------------------------------------------------------------
  def player?
    return true
  end
end

#==============================================================================
# ■ Game_Interpreter
#==============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● リージョンID取得
  #--------------------------------------------------------------------------
  def get_region_id
    x = $game_player.x ; y = $game_player.y
    return $game_map.region_id(x, y)
  end
end