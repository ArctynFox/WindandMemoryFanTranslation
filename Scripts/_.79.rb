=begin
      RGSS2 & RGSS3
      
      ★ 落ち葉 ★

      落ち葉を降らせます。
      天候と似た使い方を想定しています。
      
      イベントコマンドのスクリプトから起動させてください。
      
      ● コマンド一覧 ●==================================================
      start_fallen_leaves(type)
      --------------------------------------------------------------------
      落ち葉エフェクトを開始します。
      引数の値によってエフェクトの種類が決定します
        1  => もみじ(赤)が画面上から下に向かって降ります
        2  => もみじ(赤)が画面左上から右下へ向かって降ります
        3  => もみじ(赤)が画面右上から左下へ向かって降ります
        
        4  => もみじ(黄)が画面上から下に向かって降ります
        5  => もみじ(黄)が画面左上から右下へ向かって降ります
        6  => もみじ(黄)が画面右上から左下へ向かって降ります
        
        7  => 楕円形の葉が画面上から下に向かって降ります
        8  => 楕円形の葉が画面左上から右下へ向かって降ります
        9  => 楕円形の葉が画面右上から左下へ向かって降ります
        
        10  => イチョウが画面上から下に向かって降ります
        11  => イチョウが画面左上から右下へ向かって降ります
        12  => イチョウが画面右上から左下へ向かって降ります
      ====================================================================
      end_fallen_leaves
      --------------------------------------------------------------------
      エフェクトの終了。画面上の落ち葉をすべて一気に開放します。
      ====================================================================
      end_fallen_leaves_fade
      --------------------------------------------------------------------
      エフェクトの終了。画面上の落ち葉を少しづつ開放します。
      ====================================================================
      
      ● 画像素材について ●==============================================
      Graphics/Systemフォルダの中に下記のグラフィックを入れてください。
        fallen_leaves01.png
      　fallen_leaves02.png
      　fallen_leaves03.png
      　fallen_leaves04.png
      --------------------------------------------------------------------
      素材の規格は 縦18コマ, 横18コマ で等間隔に並べたものが利用されます。
      画像サイズに制限はありません。
      縦と横、それぞれを18等分したものが1コマとして表示されます。
      --------------------------------------------------------------------
      ■ アニメーションのかんたんな仕組み
      18*18のコマの中からランダムで最初のコマが選択されます。
      ↓
      アニメーションの方向(上/下/左/右/左上/左下/右上/右下)をランダムで決定します。
      ↓
      決定した方向に向かって1コマずつアニメーションを続けます。
      ====================================================================
      
      ● 注意 ●==========================================================
      スクリプト導入後はニューゲームから始めてください。
      ====================================================================
      
      ver1.00

      Last Update : 2014/08/06
      08/06 : 新規
      
      ろかん　　　http://kaisou-ryouiki.sakura.ne.jp/
=end

$rsi ||= {}
$rsi["落ち葉"] = true

class Game_Temp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :fallen_leaves_sprites # 落ち葉スプライト群
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias fallen_leaves_initialize initialize
  def initialize
    fallen_leaves_initialize
    @fallen_leaves_sprites = []
  end
  #--------------------------------------------------------------------------
  # ● 落ち葉スプライトの解放
  #--------------------------------------------------------------------------
  def dispose_fallen_leaves
    @fallen_leaves_sprites.each{|sprite| sprite.dispose}
    @fallen_leaves_sprites = []
  end
end

class Game_System
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :fallen_leaves_type # 落ち葉効果の種類
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias fallen_leaves_initialize initialize
  def initialize
    fallen_leaves_initialize
    @fallen_leaves_type = 0
  end
  #--------------------------------------------------------------------------
  # ● 落ち葉効果の開始
  #--------------------------------------------------------------------------
  def start_fallen_leaves(type)
    $game_temp.dispose_fallen_leaves if @fallen_leaves_type != type
    @fallen_leaves_type = type
  end
  #--------------------------------------------------------------------------
  # ● 落ち葉効果の終了（瞬時）
  #--------------------------------------------------------------------------
  def end_fallen_leaves
    $game_temp.dispose_fallen_leaves
    @fallen_leaves_type = 0
  end
  #--------------------------------------------------------------------------
  # ● 落ち葉効果の終了（フェード）
  #--------------------------------------------------------------------------
  def end_fallen_leaves_fade
    @fallen_leaves_type = 0
  end
end

class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● 落ち葉効果の開始
  #--------------------------------------------------------------------------
  def start_fallen_leaves(type)
    $game_system.start_fallen_leaves(type)
  end
  #--------------------------------------------------------------------------
  # ● 落ち葉効果の終了（瞬時）
  #--------------------------------------------------------------------------
  def end_fallen_leaves
    $game_system.end_fallen_leaves
  end
  #--------------------------------------------------------------------------
  # ● 落ち葉効果の終了（フェード）
  #--------------------------------------------------------------------------
  def end_fallen_leaves_fade
    $game_system.end_fallen_leaves_fade
  end
end

class Sprite_Fallen_Leaves < Sprite
  HORIZON_COUNT = 18   # 葉グラフィックの横コマ数
  VERTICAL_COUNT = 18  # 葉グラフィックの縦コマ数
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(viewport, type)
    super(viewport)
    @base_xy = [0, 0]          # 基本座標
    @move_xy = [0.0, 0.0]      # 基本座標からの移動量
    @rd = rand(25).next.to_f   # 初期座標からの半径
    @roll_direction = [0, 0]   # 葉の回転方向
    @roll_span = [rand(4), 3 + rand(3)] # 葉の回転頻度を管理するための値
    setGraphic(type)
    setZoom
    case type
    when 1, 4, 7, 10 # 落下
      setStartPosition(0)
      @moveSpeed_x = 0
    when 2, 5, 8, 11 # 流れ(左から右)
      setStartPosition(1)
      @moveSpeed_x = @moveSpeed_y
    when 3, 6, 9, 12 # 流れ(右から左)
      setStartPosition(2)
      @moveSpeed_x = -@moveSpeed_y
    end
    @nextAngle = rand(360).to_f
    @existCount = 600
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    if self.y > height + self.oy || self.opacity.zero?
      dispose
      $game_temp.fallen_leaves_sprites.delete(self)
    else
      @nextAngle += @moveSpeed_y
      @nextAngle = 0.0 if @nextAngle >= 360
      @move_xy[0] += @moveSpeed_x
      @move_xy[1] += @moveSpeed_y
      self.x = @base_xy[0] + @move_xy[0].round + @rd * Math.cos(@nextAngle * 1.74533 * 0.01)
      self.y = @base_xy[1] + @move_xy[1].round
      self.opacity = @existCount
      updateBitmap
      @existCount -= 1
    end
  end
  #--------------------------------------------------------------------------
  # ● 画面の横幅を取得
  #--------------------------------------------------------------------------
  def width
    Graphics.width
  end
  #--------------------------------------------------------------------------
  # ● 画面の縦幅を取得
  #--------------------------------------------------------------------------
  def height
    Graphics.height
  end
  #--------------------------------------------------------------------------
  # ● 拡大率の一括設定
  #--------------------------------------------------------------------------
  def zoom=(value)
    self.zoom_x = self.zoom_y = value
  end
  #--------------------------------------------------------------------------
  # ● 落ち葉の初期座標の決定
  #--------------------------------------------------------------------------
  def setStartPosition(type)
    case type
    when 0
      @base_xy[0] = rand(width + 100) - 50
      @base_xy[1] = -30
    when 1
      if rand(2).zero?
        @base_xy[0] = 30
        @base_xy[1] = rand(height) - 50
      else
        @base_xy[0] = rand(width) - 50
        @base_xy[1] = -30
      end
    when 2
      if rand(2).zero?
        @base_xy[0] = width + 30
        @base_xy[1]= rand(height) - 50
      else
        @base_xy[0] = rand(width) - 50
        @base_xy[1] = -30
      end
    end
    self.x = @base_xy[0]
    self.y = @base_xy[1]
  end
  #--------------------------------------------------------------------------
  # ● 落ち葉のグラフィックを決定(ここで落ち葉の回転方向も決定)
  #--------------------------------------------------------------------------
  def setGraphic(type)
    case type
    when 1..3   # もみじ(赤)
      self.bitmap = Cache.system("fallen_leaves01")
    when 4..6   # もみじ(黄)
      self.bitmap = Cache.system("fallen_leaves02")
    when 7..9   # 楕円型
      self.bitmap = Cache.system("fallen_leaves03")
    when 10..12 # いちょう
      self.bitmap = Cache.system("fallen_leaves04")
    end
    self.angle = rand(360)
    self.ox = getBitmapWidth / 2
    self.oy = getBitmapHeight / 2
    @blt_xy = [rand(HORIZON_COUNT), rand(VERTICAL_COUNT)]
    @roll_direction[0] = [-1, 0, 1][rand(3)]
    @roll_direction[1] = @roll_direction[0].zero? ? [-1, 1][rand(2)] : [-1, 0, 1][rand(3)]
    setSrcRect
    updateBitmap
  end
  #--------------------------------------------------------------------------
  # ● 落ち葉の遠近感を決定(遠近感による落下速度の調整もここで)
  #--------------------------------------------------------------------------
  def setZoom
    case rand(105)
    when 0..47
      self.zoom = (3 + rand(2)) / 10.0
    when 48..86
      self.zoom = (6 + rand(2)) / 10.0
    when 87..97
      self.zoom = (9 + rand(2)) / 10.0
    when 98..104
      self.zoom = (12 + rand(2)) / 10.0
    end
    self.z = self.zoom_x * 10
    @moveSpeed_y = self.zoom_x * 1.6
  end
  #--------------------------------------------------------------------------
  # ● 落ち葉 1コマ あたりの横幅を取得
  #--------------------------------------------------------------------------
  def getBitmapWidth
    self.bitmap.width / HORIZON_COUNT
  end
  #--------------------------------------------------------------------------
  # ● 落ち葉 1コマ あたりの縦幅を取得
  #--------------------------------------------------------------------------
  def getBitmapHeight
    self.bitmap.height / VERTICAL_COUNT
  end
  #--------------------------------------------------------------------------
  # ● スプライトに落ち葉を投影
  #--------------------------------------------------------------------------
  def setSrcRect
    self.src_rect.set(@blt_xy[0] * getBitmapWidth, @blt_xy[1] * getBitmapHeight, getBitmapWidth, getBitmapHeight)
  end
  #--------------------------------------------------------------------------
  # ● 表示するビットマップの更新
  #--------------------------------------------------------------------------
  def updateBitmap
    if @roll_span[0].zero?
      @blt_xy[0] += @roll_direction[0]
      @blt_xy[1] += @roll_direction[1]
      case @blt_xy[0]
      when HORIZON_COUNT
        @blt_xy[0] = 0
      when -1
        @blt_xy[0] = HORIZON_COUNT - 1
      end
      case @blt_xy[1]
      when VERTICAL_COUNT
        @blt_xy[1] = 0
      when -1
        @blt_xy[1] = VERTICAL_COUNT - 1
      end
      setSrcRect
      @roll_span[0] = @roll_span[1]
    end
    @roll_span[0] -= 1
  end
end

class Spriteset_Map
  @@leaves_add_count = 0
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  alias fallen_leaves_dispose dispose
  def dispose
    fallen_leaves_dispose
    $game_temp.dispose_fallen_leaves
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias fallen_leaves_update update
  def update
    fallen_leaves_update
    update_fallen_leaves
  end
  #--------------------------------------------------------------------------
  # ● 落ち葉エフェクトの更新
  #--------------------------------------------------------------------------
  def update_fallen_leaves
    unless $game_system.fallen_leaves_type.zero?
      if @@leaves_add_count.zero?
        sprite = Sprite_Fallen_Leaves.new(@viewport3, $game_system.fallen_leaves_type)
        $game_temp.fallen_leaves_sprites << sprite
        case $game_system.fallen_leaves_type
        when 1, 4, 7, 10
          @@leaves_add_count = 20
        else
          @@leaves_add_count = 15
        end
      end
      @@leaves_add_count -= 1
    end
    $game_temp.fallen_leaves_sprites.each{|sprite| sprite.update}
  end
end