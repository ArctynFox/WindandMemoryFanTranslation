=begin
      RGSS3
      
　　　★ 陽炎 ★

      マップにゆらゆらと歪む陽炎のようなエフェクトをかけます。
      砂漠や火山のマップにどうぞ。
      
      ● 使い方 ●========================================================
      設定箇所に陽炎エフェクトを表示させるマップIDを設定してください。
      ====================================================================
      
      ● 仕様 ●==========================================================
      陽炎のエフェクトがかかる対象は原則、マップチップのみとなります。
      --------------------------------------------------------------------
      遠景およびイベントは歪みの対象から外れます。
      例外としてイベント名に「#置物」という文字列を含んでいるイベントは、
      歪みの対象に含めることが出来ます。
      ただしこの置物設定は、画像の変化のないイベント且つ、
      移動することのないイベントに限り行うようにしてください。
      --------------------------------------------------------------------
      また、ループ設定のされているマップには対応していません。
      --------------------------------------------------------------------
      陽炎エフェクトを表示するマップへ移動する際、
      若干の読み込み時間がかかりますのでご了承ください。
      ====================================================================
      
      ver1.00
      
      Last Update : 2015/10/05
      10/05 : 新規
      
      ろかん　　　http://kaisou-ryouiki.sakura.ne.jp/
=end

#===========================================
#   設定箇所
#===========================================
module HEAT_HAZE
  # 陽炎エフェクトを有効化するマップIDを配列で設定
  MAP_ID = [47,126,127,133,128,311]
end
#===========================================
#   ここまで
#===========================================

$rsi ||= {}
$rsi["陽炎"] = true

class RPG::Event
  def heat_haze_target?
    @hht ||= self.name.include?("#置物")
    @hht
  end
end

class Game_Temp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :heat_haze_bitmap
  attr_reader :heat_haze_parameters
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias heat_haze_initialize initialize
  def initialize
    heat_haze_initialize
    @heat_haze_bitmap = nil
    @heat_haze_parameters = [rand(51)+40, rand(2).zero?, 0]
  end
end

class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # ● 陽炎で歪ませる対象に含めるイベントであるか
  #--------------------------------------------------------------------------
  def heat_haze_target?
    @event.heat_haze_target?
  end
end

class Heat_Haze
  #--------------------------------------------------------------------------
  # ● インクルード HEAT_HAZE
  #--------------------------------------------------------------------------
  include HEAT_HAZE
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :viewport
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(owner)
    @owner = owner
    @viewport = nil
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    dispose if @heat_haze_sprite
    if MAP_ID.include?($game_map.map_id)
      create_heat_haze_map unless $game_temp.heat_haze_bitmap
      create_heat_haze
      dispose_heat_haze_map if @tilemap
    end
  end
  #--------------------------------------------------------------------------
  # ● 陽炎作成用のマップを作成
  #--------------------------------------------------------------------------
  def create_heat_haze_map
    create_tilemap
    create_characters
  end
  #--------------------------------------------------------------------------
  # ● タイルマップの作成
  #--------------------------------------------------------------------------
  def create_tilemap
    @tilemap = Tilemap.new(Viewport.new)
    @tilemap.map_data = $game_map.data
    load_tileset
  end
  #--------------------------------------------------------------------------
  # ● キャラクタースプライトの作成
  #--------------------------------------------------------------------------
  def create_characters
    @character_sprites = []
    $game_map.events.values.each{|event|
      if event.heat_haze_target?
        sprite = Sprite_Character.new(@tilemap.viewport, event)
        sprite.update
        @character_sprites.push(sprite)
      end
    }
  end
  #--------------------------------------------------------------------------
  # ● タイルセットのロード
  #--------------------------------------------------------------------------
  def load_tileset
    @tileset = $game_map.tileset
    @tileset.tileset_names.each_with_index{|name, i|
      @tilemap.bitmaps[i] = Cache.tileset(name)
    }
    @tilemap.flags = @tileset.flags
  end
  #--------------------------------------------------------------------------
  # ● 陽炎作成用のマップを削除
  #--------------------------------------------------------------------------
  def dispose_heat_haze_map
    @tilemap.viewport.dispose
    @tilemap.dispose
    @tileset = nil
    @character_sprites.each {|sprite| sprite.dispose }
    @character_sprites = nil
  end
  #--------------------------------------------------------------------------
  # ● 陽炎用のSpriteを作成
  #--------------------------------------------------------------------------
  def create_heat_haze
    # Sprite作成の前準備
    old_brightness = Graphics.brightness
    Graphics.freeze
    Graphics.brightness = 255
    # Spriteの作成
    @heat_haze_sprite = Sprite.new
    unless $game_temp.heat_haze_bitmap
      @owner.viewport3.visible = false
      $game_temp.heat_haze_bitmap = Bitmap.new($game_map.width * 32, $game_map.height * 32)
      # Bitmapの作成
      sw = $game_map.screen_tile_x
      sh = $game_map.screen_tile_y
      ($game_map.width / sw.to_f).ceil.times{|x|
        ($game_map.height / sh.to_f).ceil.times{|y|
          update_snap(sw * x, sh * y)
          bitmap = Graphics.snap_to_bitmap
          $game_temp.heat_haze_bitmap.blt($game_map.display_x * 32, $game_map.display_y * 32, bitmap, bitmap.rect)
          bitmap.dispose
        }
      }
      2.times{$game_temp.heat_haze_bitmap.blur}
      # 表示状態の戻し
      @owner.viewport3.visible = true
      $game_player.center($game_player.x, $game_player.y)
    end
    @heat_haze_sprite.bitmap = $game_temp.heat_haze_bitmap
    # Spriteのパラメータをセット
    @heat_haze_sprite.z = 100
    @heat_haze_sprite.wave_amp = 3      # 振幅
    @heat_haze_sprite.wave_length = 90  # 周期
    @heat_haze_sprite.wave_speed = 700  # 速度
    @heat_haze_sprite.viewport = @viewport
    @heat_haze_sprite.opacity = $game_temp.heat_haze_parameters[0]
    @heat_haze_sprite.wave_phase = $game_temp.heat_haze_parameters[2]
    # Sprite作成の後処理
    Graphics.frame_reset
    if old_brightness != 255
      Graphics.transition(0)
      Graphics.brightness = old_brightness
    end
  end
  #--------------------------------------------------------------------------
  # ● 陽炎bitmap作成時の撮影領域の更新
  #--------------------------------------------------------------------------
  def update_snap(x, y)
    $game_map.set_display_pos(x, y)
    @tilemap.ox = $game_map.display_x * 32
    @tilemap.oy = $game_map.display_y * 32
    @character_sprites.each {|sprite| sprite.update_snap}
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    if @heat_haze_sprite
      $game_temp.heat_haze_parameters[0] = @heat_haze_sprite.opacity
      $game_temp.heat_haze_parameters[2] = @heat_haze_sprite.wave_phase
      if SceneManager.scene.is_a?(Scene_Map)
        $game_temp.heat_haze_bitmap.dispose
        $game_temp.heat_haze_bitmap = nil
      end
      @heat_haze_sprite.dispose
      @heat_haze_sprite = nil
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    return unless @heat_haze_sprite
    if (Graphics.frame_count % 3).zero?
      # 陽炎のゆらめき更新
      @heat_haze_sprite.update
      # 陽炎の不透明度変化方向 (- or +)
      $game_temp.heat_haze_parameters[1] = rand(2).zero? if rand(3).zero?
      # 陽炎の不透明度変化 (40～90)
      if $game_temp.heat_haze_parameters[1]
        @heat_haze_sprite.opacity = [@heat_haze_sprite.opacity + 3, 90].min
      else
        @heat_haze_sprite.opacity = [@heat_haze_sprite.opacity - 3, 40].max
      end
    end
    # 陽炎の座標更新
    @heat_haze_sprite.ox = @owner.tilemap.ox
    @heat_haze_sprite.oy = @owner.tilemap.oy + 3
  end
end

class Sprite_Character < Sprite_Base
  #--------------------------------------------------------------------------
  # ● 陽炎bitmap作成時の撮影領域の更新
  #--------------------------------------------------------------------------
  def update_snap
    self.x = @character.screen_x
    self.y = @character.screen_y
  end
end

class Spriteset_Map
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :tilemap
  attr_reader   :viewport3
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias heat_haze_initialize initialize
  def initialize
    @heat_haze = Heat_Haze.new(self)
    heat_haze_initialize
  end
  #--------------------------------------------------------------------------
  # ● ビューポートの作成
  #--------------------------------------------------------------------------
  alias heat_haze_create_viewports create_viewports
  def create_viewports
    heat_haze_create_viewports
    @heat_haze.viewport = @viewport1
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  alias heat_haze_dispose dispose
  def dispose
    heat_haze_dispose
    dispose_heat_haze
  end
  #--------------------------------------------------------------------------
  # ● 陽炎の解放
  #--------------------------------------------------------------------------
  def dispose_heat_haze
    @heat_haze.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias heat_haze_update update
  def update
    heat_haze_update
    update_heat_haze
  end
  #--------------------------------------------------------------------------
  # ● 陽炎の更新
  #--------------------------------------------------------------------------
  def update_heat_haze
    @heat_haze.update
  end
  #--------------------------------------------------------------------------
  # ● キャラクタースプライトの作成
  #--------------------------------------------------------------------------
  alias heat_haze_create_characters create_characters
  def create_characters
    @heat_haze.refresh
    heat_haze_create_characters
  end
end