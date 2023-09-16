=begin
      RGSS3
      
      ★ スクリーンノイズ ★

      ゲーム画面に古い映像フィルムのようなノイズ効果を与えます。
      天候と似た使い方を想定しています。
      
      イベントコマンドのスクリプトから起動させてください。
      
      ● コマンド一覧 ●==================================================
      start_noise
      --------------------------------------------------------------------
      ノイズエフェクトの開始。
      ====================================================================
      end_noise
      --------------------------------------------------------------------
      ノイズエフェクトの終了。
      ====================================================================
      
      ver1.00

      Last Update : 2011/12/17
      12/17 : RGSS2からの移植
      
      ろかん　　　http://kaisou-ryouiki.sakura.ne.jp/
=end

$rsi ||= {}
$rsi["スクリーンノイズ"] = true

class Game_Temp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :r_noise_effect_spriteset # ノイズスプライトセットへの参照
  #--------------------------------------------------------------------------
  # ● ノイズの開始
  #--------------------------------------------------------------------------
  def start_noise
    @r_noise_effect_spriteset.start_noise
  end
  #--------------------------------------------------------------------------
  # ● ノイズの終了
  #--------------------------------------------------------------------------
  def end_noise
    @r_noise_effect_spriteset.end_noise
  end
end

class Game_System
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :r_noise_effect # ノイズエフェクト表示中判定
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias r_noise_effect_initialize initialize
  def initialize
    r_noise_effect_initialize
    @r_noise_effect = false
  end
  #--------------------------------------------------------------------------
  # ● ノイズの開始
  #--------------------------------------------------------------------------
  def start_noise
    $game_temp.start_noise
    @r_noise_effect = true
  end
  #--------------------------------------------------------------------------
  # ● ノイズの終了
  #--------------------------------------------------------------------------
  def end_noise
    $game_temp.end_noise
    @r_noise_effect = false
  end
end

class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● ノイズの開始
  #--------------------------------------------------------------------------
  def start_noise
    $game_system.start_noise
  end
  #--------------------------------------------------------------------------
  # ● ノイズの終了
  #--------------------------------------------------------------------------
  def end_noise
    $game_system.end_noise
  end
end

class NoiseBase_Sprite < Sprite
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    self.bitmap = Cache.system("noise_base")
    self.visible = false
    self.blend_type = 1
    @blink = true
    update
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    self.x = -(rand(self.bitmap.width - 544))
    self.opacity = @blink ? 230 : 255
    @blink ^= true
  end
end

class NoiseLine_Sprite < Sprite
  VX = [-2, -1, -1, 0, 1, 1, 2]
  OS = [-50, -20, -10, 0, 10, 20, 30, 50]
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(viewport, start_x)
    super(viewport)
    self.bitmap = Cache.system("noise_line")
    self.visible = false
    self.x = start_x
    @vector_x = VX[rand(VX.size)]
    @opacity_speed = OS[rand(OS.size)]
    update
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    self.x = [[self.x + @vector_x, 0].max, 640].min
    self.y = -(rand(self.bitmap.height - 480))
    self.opacity += @opacity_speed
    @vector_x = VX[rand(VX.size)] if rand(6).zero?
    @opacity_speed = OS[rand(OS.size)] if rand(6).zero?
  end
end

class NoiseDot_Sprite < Sprite
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    self.bitmap = Cache.system("noise_dot")
    self.visible = false
    update
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    if rand(50).zero?
      self.zoom_x = rand(100).next / 100.0
      self.zoom_y = rand(100).next / 100.0
      self.angle = rand(360)
      self.x = rand(640)
      self.y = rand(480)
      self.opacity = 255
    else
      self.opacity = 0
    end
  end
end

class Spriteset_Noise
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    create_noise
    start_noise if $game_system.r_noise_effect
  end
  #--------------------------------------------------------------------------
  # ● ノイズの生成
  #--------------------------------------------------------------------------
  def create_noise
    @viewport_base = Viewport.new(0, 0, 640, 480)
    @viewport_line = Viewport.new(0, 0, 640, 480)
    @viewport_dot = Viewport.new(0, 0, 640, 480)
    @viewport_base.z = 90
    @viewport_line.z = @viewport_base.z.next
    @viewport_dot.z = @viewport_line.z.next
    @base_sprite = NoiseBase_Sprite.new(@viewport_base)
    @line_sprites = []
    @line_sprites << NoiseLine_Sprite.new(@viewport_line, 50)
    @line_sprites << NoiseLine_Sprite.new(@viewport_line, 350)
    @line_sprites << NoiseLine_Sprite.new(@viewport_line, 400)
    @line_sprites << NoiseLine_Sprite.new(@viewport_line, 500)
    @dot_sprite = NoiseDot_Sprite.new(@viewport_dot)
  end
  #--------------------------------------------------------------------------
  # ● ノイズの解放
  #--------------------------------------------------------------------------
  def dispose_noise
    @base_sprite.dispose
    @line_sprites.each{|sprite| sprite.dispose}
    @dot_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # ● ノイズの開始
  #--------------------------------------------------------------------------
  def start_noise
    @base_sprite.visible = true
    @line_sprites.each{|sprite| sprite.visible = true}
    @dot_sprite.visible = true
  end
  #--------------------------------------------------------------------------
  # ● ノイズの終了
  #--------------------------------------------------------------------------
  def end_noise
    @base_sprite.visible = false
    @line_sprites.each{|sprite| sprite.visible = false}
    @dot_sprite.visible = false
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    if $game_system.r_noise_effect && (Graphics.frame_count % 3).zero?
      @base_sprite.update
      @line_sprites.each{|sprite| sprite.update}
      @dot_sprite.update
    end
  end
end

class Spriteset_Map
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias r_noise_effect_initialize initialize
  def initialize
    @r_noise_effect_set = Spriteset_Noise.new
    $game_temp.r_noise_effect_spriteset = @r_noise_effect_set
    r_noise_effect_initialize
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  alias r_noise_effect_dispose dispose
  def dispose
    r_noise_effect_dispose
    @r_noise_effect_set.dispose_noise
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias r_noise_effect_update update
  def update
    r_noise_effect_update
    update_noise_effect
  end
  #--------------------------------------------------------------------------
  # ● スクリーンノイズの更新
  #--------------------------------------------------------------------------
  def update_noise_effect
    @r_noise_effect_set.update
  end
end