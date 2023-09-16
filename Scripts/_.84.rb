=begin
      RGSS3
      
　　　★ リッチフォグ ★

      もやもやとしたフォグを表現します。
      
      ● 準備 ●==========================================================
      「Graphics\System\」に下記のファイルを入れます
　      RichFog.png
      ====================================================================
      
      ● エフェクトの開始 ●==============================================
      イベントコマンドで次のスクリプトを実行します
      --------------------------------------------------------------------
      rich_fog_start
      ====================================================================
      
      ● エフェクトの終了 ●==============================================
      イベントコマンドで次のスクリプトを実行します
      --------------------------------------------------------------------
      rich_fog_stop
      ====================================================================
      
      ver1.00
      
      Last Update : 2017/05/27
      5/27 : 新規
      
      ろかん　　　http://kaisou-ryouiki.sakura.ne.jp/
=end

$rsi ||= {}
$rsi["リッチフォグ"] = true

class Game_System
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :rich_fog # リッチフォグの有効判定
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias rich_fog_effect_initialize initialize
  def initialize
    rich_fog_effect_initialize
    @rich_fog = false
  end
end

class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● リッチフォグの開始
  #--------------------------------------------------------------------------
  def rich_fog_start
    $game_system.rich_fog = true
  end
  #--------------------------------------------------------------------------
  # ● リッチフォグの終了
  #--------------------------------------------------------------------------
  def rich_fog_stop
    $game_system.rich_fog = false
  end
end

class Spriteset_Richfog
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(viewport)
    @f = 0
    @x = [0, 0, 0]
    @y = [0, 0, 0]
    @last_active = false
    create_fog(viewport)
  end
  #--------------------------------------------------------------------------
  # ● フォグの作成
  #--------------------------------------------------------------------------
  def create_fog(viewport)
    @fog_planes = []
    3.times{|i|
      @fog_planes << Plane.new(viewport)
      @fog_planes[i].bitmap = Cache.system("RichFog")
      @x[i] = rand(Graphics.width)
      @y[i] = rand(Graphics.height)
      @fog_planes[i].ox = map_ox + @x[i]
      @fog_planes[i].oy = map_oy + @y[i]
      @fog_planes[i].visible = false
    }
    @fog_planes[0].opacity = 100
    @fog_planes[1].opacity = 50
    @fog_planes[2].opacity = 0
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    @fog_planes.each{|plane| plane.dispose}
  end
  #--------------------------------------------------------------------------
  # ● マップ表示位置 X
  #--------------------------------------------------------------------------
  def map_ox
    $game_map.display_x * 32
  end
  #--------------------------------------------------------------------------
  # ● マップ表示位置 Y
  #--------------------------------------------------------------------------
  def map_oy
    $game_map.display_y * 32
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    if $game_system.rich_fog
      unless @last_active
        @fog_planes.each{|plane| plane.visible = true}
        @last_active = true
      end
      case @f
      when 0
        @fog_planes[0].opacity -= 2
        @fog_planes[1].opacity += 1
        @fog_planes[2].opacity += 1
        if @fog_planes[0].opacity.zero?
          @f = 1
          @x[0] = rand(Graphics.width)
          @y[0] = rand(Graphics.height)
        end
      when 1
        @fog_planes[0].opacity += 1
        @fog_planes[1].opacity -= 2
        @fog_planes[2].opacity += 1
        if @fog_planes[1].opacity.zero?
          @f = 2
          @x[1] = rand(Graphics.width)
          @y[1] = rand(Graphics.height)
        end
      when 2
        @fog_planes[0].opacity += 1
        @fog_planes[1].opacity += 1
        @fog_planes[2].opacity -= 2
        if @fog_planes[2].opacity.zero?
          @f = 0
          @x[2] = rand(Graphics.width)
          @y[2] = rand(Graphics.height)
        end
      end
      if (Graphics.frame_count%5).zero?
        @x.map!{|n| n.next}
        @y.map!{|n| n.next}
      end
      @fog_planes.each_with_index{|plane, index|
        plane.ox = map_ox + @x[index]
        plane.oy = map_oy + @y[index]
      }
    else
      if @last_active
        @fog_planes.each{|plane| plane.visible = false}
        @last_active = false
      end
    end
  end
end

class Spriteset_Map
  #--------------------------------------------------------------------------
  # ● ビューポートの作成
  #--------------------------------------------------------------------------
  alias rich_fog_effect_create_viewports create_viewports
  def create_viewports
    rich_fog_effect_create_viewports
    @rich_fog_effect_set = Spriteset_Richfog.new(@viewport2)
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  alias rich_fog_effect_dispose dispose
  def dispose
    rich_fog_effect_dispose
    @rich_fog_effect_set.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias rich_fog_effect_update update
  def update
    rich_fog_effect_update
    update_rich_fog_effect
  end
  #--------------------------------------------------------------------------
  # ● リッチフォグの更新
  #--------------------------------------------------------------------------
  def update_rich_fog_effect
    @rich_fog_effect_set.update
  end
end