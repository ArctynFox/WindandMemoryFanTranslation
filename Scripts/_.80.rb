=begin
      RGSS3
      
　　　★ 古の光 ★

      天候と同じように利用できる演出素材です。
      
      ● 準備 ●==========================================================
      「Graphics\System\」に下記の2ファイルを入れます
　      ancient_00.png
  　    ancient_01.png
      ====================================================================
      
      ● エフェクトの開始 ●==============================================
      イベントコマンドで次のスクリプトを実行します
      --------------------------------------------------------------------
      ancient_light
      ====================================================================
      
      ● エフェクトの終了 ●==============================================
      イベントコマンドの「天候の設定」で「なし」を実行します
      ====================================================================
      
      ver1.00
      
      Last Update : 2015/03/19
      3/19 : 新規
      
      ろかん　　　http://kaisou-ryouiki.sakura.ne.jp/
=end

$rsi ||= {}
$rsi["古の光"] = true

class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● 天候：舞い上がる光の開始
  #--------------------------------------------------------------------------
  def ancient_light
    screen.change_weather(:ancient_light, 3, 0)
  end
end

class Spriteset_Weather
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :viewport
  attr_reader   :sprites
  #--------------------------------------------------------------------------
  # ● 天候の種類を設定
  #--------------------------------------------------------------------------
  def type=(type)
    if @type != type
      @sprites.each{|sprite| sprite.dispose}
      @sprites = []
      if type == :ancient_light
        5.times{@sprites << Ancient_Light.new(self)}
      end
    end
    @type = type
  end
  #--------------------------------------------------------------------------
  # ● 天候の強さを設定
  #--------------------------------------------------------------------------
  alias ancient_light_power= power=
  def power=(power)
    if @type != :ancient_light
      self.ancient_light_power = power
    else
      @power = power
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias ancient_light_update update
  def update
    if @type == :ancient_light
      update_screen
      @sprites << Ancient_Light.new(self) if (Graphics.frame_count % 100).zero?
      @sprites.each{|sprite| sprite.update}
    else
      ancient_light_update
    end
  end
end

class Ancient_Light
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(owner)
    @owner = owner
    @exist_counter = 1200
    @origin_ox = @owner.ox
    @origin_oy = @owner.oy
    @x = rand(Graphics.width + 192) - 96
    @y = rand(Graphics.height + 192) - 96
    @angle_speed = rand(7) / 10.0 * (rand(2).zero? ? 1 : -1)
    @vector_x = rand(2).zero? ? 1 : -1
    @vector_y = rand(2).zero? ? 1 : -1
    create_sprite
  end
  #--------------------------------------------------------------------------
  # ● スプライトの生成
  #--------------------------------------------------------------------------
  def create_sprite
    @sprites = [Sprite.new(@owner.viewport), Sprite.new(@owner.viewport)]
    @sprites[0].bitmap = Cache.system("ancient_00")
    @sprites[1].bitmap = Cache.system("ancient_01")
    @sprites[0].blend_type = @sprites[1].blend_type = 1
    @sprites[0].angle = @sprites[1].angle = rand(360)
    @sprites[0].ox = @sprites[1].ox = @sprites[0].bitmap.width / 2
    @sprites[0].oy = @sprites[1].oy = @sprites[0].bitmap.height / 2
    @sprites[0].x = @sprites[1].x = @x + (@origin_ox - @owner.ox)
    @sprites[0].y = @sprites[1].y = @y + (@origin_oy - @owner.oy)
    @sprites[0].z = rand(2)
    @sprites[0].zoom_x = rand(11).next / 10.0 - 0.3
    @sprites[0].zoom_y = rand(11).next / 10.0 - 0.3
    @sprites[1].zoom_x = [0.2, @sprites[0].zoom_x].max
    @sprites[1].zoom_y = [0.2, @sprites[0].zoom_y].max
    @sprites[0].opacity = @sprites[1].opacity = 0
  end
  #--------------------------------------------------------------------------
  # ● X 軸方向の速度を取得
  #--------------------------------------------------------------------------
  def x_speed
    (@sprites[0].zoom_x + @sprites[0].zoom_y) / 3.0 * @vector_x
  end
  #--------------------------------------------------------------------------
  # ● Y 軸方向の速度を取得
  #--------------------------------------------------------------------------
  def y_speed
    x_speed / 2.0 * @vector_y
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    @sprites[0].dispose
    @sprites[1].dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    case @exist_counter
    when 1141..1200
      @sprites[0].zoom_x += 0.005
      @sprites[0].zoom_y += 0.005
      @sprites[1].zoom_x += 0.005
      @sprites[1].zoom_y += 0.005
      @sprites[0].opacity = @sprites[1].opacity += 5
    else
      if (Graphics.frame_count % 2).zero?
        @sprites[0].opacity = @sprites[1].opacity = @exist_counter
        @sprites[1].opacity -= rand(200)
        @sprites[0].angle = @sprites[1].angle += @angle_speed
      end
    end
    @x += x_speed
    @y += y_speed
    @sprites[0].x = @sprites[1].x = @x.to_i + (@origin_ox - @owner.ox)
    @sprites[0].y = @sprites[1].y = @y.to_i + (@origin_oy - @owner.oy)
    @exist_counter -= 1
    if @exist_counter.zero?
      dispose
      @owner.sprites.delete(self)
    else
      out_screen_process
    end
  end
  #--------------------------------------------------------------------------
  # ● 画面外に出た場合の処理(ループさせて画面内に戻す)
  #--------------------------------------------------------------------------
  def out_screen_process
    if @sprites[0].x < -96
      while @sprites[0].x < -96
        @sprites[0].x = @sprites[1].x += Graphics.width + 192
      end
    elsif @sprites[0].x > Graphics.width + 96
      while @sprites[0].x > Graphics.width + 96
        @sprites[0].x = @sprites[1].x -= Graphics.width + 192
      end
    end
    if @sprites[0].y < -96
      while @sprites[0].y < -96
        @sprites[0].y = @sprites[1].y += Graphics.height + 192
      end
    elsif @sprites[0].y > Graphics.height + 96
      while @sprites[0].y > Graphics.height + 96
        @sprites[0].y = @sprites[1].y -= Graphics.height + 192
      end
    end
  end
end