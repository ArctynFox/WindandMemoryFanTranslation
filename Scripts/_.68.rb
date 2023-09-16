=begin
      RGSS3
      
　　　★ シグナルディスプレイ ★

      SFのディスプレイ的なエフェクトを画面に表示します。
      
      ● 準備 ●==========================================================
      「Graphics\System\」に下記の3ファイルを入れてください
　      signal_display_front.png
  　    signal_display_middle.png
        signal_display_rear.png
      ====================================================================
      
      イベントコマンドのスクリプトから起動させてください。
      
      ● コマンド一覧 ●==================================================
      start_signal
      --------------------------------------------------------------------
      シグナルディスプレイエフェクトの開始。
      ====================================================================
      end_signal
      --------------------------------------------------------------------
      シグナルディスプレイエフェクトの終了。
      ====================================================================
      
      ver1.00
      
      Last Update : 2015/05/01
      5/1 : 新規
      
      ろかん　　　http://kaisou-ryouiki.sakura.ne.jp/
=end

$rsi ||= {}
$rsi["シグナルディスプレイ"] = true

class Game_Temp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :signal_display_set # シグナルディスプレイへの参照
  #--------------------------------------------------------------------------
  # ● ノイズの開始
  #--------------------------------------------------------------------------
  def start_signal
    @signal_display_set.start_signal
  end
  #--------------------------------------------------------------------------
  # ● ノイズの終了
  #--------------------------------------------------------------------------
  def end_signal
    @signal_display_set.end_signal
  end
end

class Game_System
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :signal_display # シグナルディスプレイ表示中判定
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias signal_display_initialize initialize
  def initialize
    signal_display_initialize
    @signal_display = false
  end
  #--------------------------------------------------------------------------
  # ● シグナルディスプレイの開始
  #--------------------------------------------------------------------------
  def start_signal
    $game_temp.start_signal
    @signal_display = true
  end
  #--------------------------------------------------------------------------
  # ● シグナルディスプレイの終了
  #--------------------------------------------------------------------------
  def end_signal
    $game_temp.end_signal
    @signal_display = false
  end
end

class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● シグナルディスプレイの開始
  #--------------------------------------------------------------------------
  def start_signal
    $game_system.start_signal
  end
  #--------------------------------------------------------------------------
  # ● シグナルディスプレイの終了
  #--------------------------------------------------------------------------
  def end_signal
    $game_system.end_signal
  end
end

class SignalDisplayRear_Sprite < Sprite
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    self.bitmap = Cache.system("signal_display_rear")
    self.visible = false
    @blink = true
    update
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    self.x = -(rand(self.bitmap.width - 544))
    self.y = -(rand(self.bitmap.height - 416))
    self.opacity = @blink ? 230 : 255
    @blink ^= true
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    self.viewport.dispose
    super
  end
end

class SignalDisplayMiddle_Plane < Plane
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    self.bitmap = Cache.system("signal_display_middle")
    self.visible = false
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    self.oy += 2
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    self.viewport.dispose
    super
  end
end

class SignalDisplayFront_Plane < Plane
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    self.bitmap = Cache.system("signal_display_front")
    self.visible = false
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    self.oy += 4
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    self.viewport.dispose
    super
  end
end

class SignalDisplaySet
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    create_signal
    start_signal if $game_system.signal_display
  end
  #--------------------------------------------------------------------------
  # ● シグナルディスプレイの生成
  #--------------------------------------------------------------------------
  def create_signal
    @viewport_rear = Viewport.new
    @viewport_middle = Viewport.new
    @viewport_front = Viewport.new
    @viewport_rear.z = 90
    @viewport_middle.z = @viewport_rear.z.next
    @viewport_front.z = @viewport_middle.z.next
    @signal_rear = SignalDisplayRear_Sprite.new(@viewport_rear) 
    @signal_middle = SignalDisplayMiddle_Plane.new(@viewport_middle) 
    @signal_front = SignalDisplayFront_Plane.new(@viewport_front) 
  end
  #--------------------------------------------------------------------------
  # ● シグナルディスプレイの解放
  #--------------------------------------------------------------------------
  def dispose_signal
    @signal_rear.dispose
    @signal_middle.dispose
    @signal_front.dispose
  end
  #--------------------------------------------------------------------------
  # ● シグナルディスプレイの開始
  #--------------------------------------------------------------------------
  def start_signal
    @signal_rear.visible = true
    @signal_middle.visible = true
    @signal_front.visible = true
  end
  #--------------------------------------------------------------------------
  # ● シグナルディスプレイの終了
  #--------------------------------------------------------------------------
  def end_signal
    @signal_rear.visible = false
    @signal_middle.visible = false
    @signal_front.visible = false
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    if $game_system.signal_display && (Graphics.frame_count % 3).zero?
      @signal_rear.update
      @signal_middle.update
      @signal_front.update
    end
  end
end

class Spriteset_Map
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias signal_display_initialize initialize
  def initialize
    @signal_display_set = SignalDisplaySet.new
    $game_temp.signal_display_set = @signal_display_set
    signal_display_initialize
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  alias signal_display_dispose dispose
  def dispose
    signal_display_dispose
    @signal_display_set.dispose_signal
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias signal_display_update update
  def update
    signal_display_update
    update_signal_display
  end
  #--------------------------------------------------------------------------
  # ● シグナルディスプレイの更新
  #--------------------------------------------------------------------------
  def update_signal_display
    @signal_display_set.update
  end
end