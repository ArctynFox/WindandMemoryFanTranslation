=begin
      RGSS3
      
　　　★ 思考ノイズ ★

      画面を一瞬だけ「ザザッ」という感じで歪ませます。
      マップおよび戦闘中に実行可能です。
      
      ノイズ実行中の一瞬(5フレーム、約0.08秒程)の間は、
      ノイズ以外の更新処理が行われません。
      よってプレイヤー操作を受け付けているシーンでの利用には不向きです。
      イベント中等にご利用ください。
      
      ● 準備 ●==========================================================
      「Graphics\System\」に下記のファイルを入れます
　      BrainNoise.png
      ====================================================================
      
      ● エフェクトの実行 ●==============================================
      次の２つの実行方法があります。
      --------------------------------------------------------------------
      ① イベントコマンドで次のスクリプトを実行します。
        brain_noise_start
      --------------------------------------------------------------------
      ② イベントコマンドの文章の表示にて次の制御文字を記述します。
        \B
      ====================================================================
      
      
      ver1.00
      
      Last Update : 2017/05/30
      5/30 : 新規
      
      ろかん　　　http://kaisou-ryouiki.sakura.ne.jp/
=end

$rsi ||= {}
$rsi["思考ノイズ"] = true

class Game_Temp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :brain_noise  # 思考ノイズ判定
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias brain_noise_initialize initialize
  def initialize
    brain_noise_initialize
    @brain_noise = false
  end
end

class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● 思考ノイズの開始
  #--------------------------------------------------------------------------
  def brain_noise_start
    $game_temp.brain_noise = true
  end
end

class Spriteset_Map
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias brain_noise_initialize initialize
  def initialize
    create_brain_noise
    brain_noise_initialize
  end
  #--------------------------------------------------------------------------
  # ● 思考ノイズの作成
  #--------------------------------------------------------------------------
  def create_brain_noise
    @brain_noise = Brain_Noise.new
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  alias brain_noise_dispose dispose
  def dispose
    brain_noise_dispose
    @brain_noise.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias brain_noise_update update
  def update
    brain_noise_update
    update_brain_noise
  end
  #--------------------------------------------------------------------------
  # ● 思考ノイズの更新
  #--------------------------------------------------------------------------
  def update_brain_noise
    @brain_noise.update
  end
end

class Spriteset_Battle
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias brain_noise_initialize initialize
  def initialize
    create_brain_noise
    brain_noise_initialize
  end
  #--------------------------------------------------------------------------
  # ● 思考ノイズの作成
  #--------------------------------------------------------------------------
  def create_brain_noise
    @brain_noise = Brain_Noise.new
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  alias brain_noise_dispose dispose
  def dispose
    brain_noise_dispose
    @brain_noise.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias brain_noise_update update
  def update
    brain_noise_update
    update_brain_noise
  end
  #--------------------------------------------------------------------------
  # ● 思考ノイズの更新
  #--------------------------------------------------------------------------
  def update_brain_noise
    @brain_noise.update
  end
end

class Brain_Noise
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    create_sprite
  end
  #--------------------------------------------------------------------------
  # ● 思考ノイズ関連スプライトの作成
  #--------------------------------------------------------------------------
  def create_sprite
    w = Graphics.width
    h = Graphics.height / 2
    @over_sprite = Sprite.new
    @over_sprite.z = 1000000
    @over_sprite.bitmap = Cache.system("BrainNoise")
    @over_sprite.visible = false
    @snap_sprite_t = Sprite.new
    @snap_sprite_u = Sprite.new
    @snap_sprite_t.x = w / 2
    @snap_sprite_t.y = h
    @snap_sprite_t.z = 1000000
    @snap_sprite_t.ox = w / 2
    @snap_sprite_t.oy = h
    @snap_sprite_t.wave_amp = 3
    @snap_sprite_t.wave_length = 180
    @snap_sprite_t.wave_speed = 1000
    @snap_sprite_t.wave_phase = 0
    @snap_sprite_t.zoom_x = 1.005
    @snap_sprite_t.bitmap = Bitmap.new(w, h)
    @snap_sprite_t.update
    @snap_sprite_u.x = w / 2
    @snap_sprite_u.y = h
    @snap_sprite_u.z = 1000000
    @snap_sprite_u.ox = w / 2
    @snap_sprite_u.oy = 0
    @snap_sprite_u.wave_amp = 2
    @snap_sprite_u.wave_length = 180
    @snap_sprite_u.wave_speed = 1000
    @snap_sprite_u.wave_phase = 90
    @snap_sprite_u.zoom_x = 1.005
    @snap_sprite_u.bitmap = Bitmap.new(w, h)
    @snap_sprite_u.update
  end
  #--------------------------------------------------------------------------
  # ● 思考ノイズビットマップの更新
  #--------------------------------------------------------------------------
  def update_bitmap
    Graphics.freeze
    @snap_sprite_t.bitmap.clear
    @snap_sprite_u.bitmap.clear
    @over_sprite.visible = true
    bitmap = Graphics.snap_to_bitmap
    @over_sprite.visible = false
    Graphics.transition
    w = Graphics.width
    h = Graphics.height / 2
    @snap_sprite_t.bitmap.blt(0, 0, bitmap, Rect.new(0, 0, w, h))
    @snap_sprite_u.bitmap.blt(0, 0, bitmap, Rect.new(0, h, w, h))
    @snap_sprite_t.visible = @snap_sprite_u.visible = true
    bitmap.dispose
    
    Graphics.frame_reset     
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    if $game_temp.brain_noise
      Audio.bgm_play("Audio/BGM/#{RPG::BGM.last.name}", 0, RPG::BGM.last.pitch) if !RPG::BGM.last.name.empty?
      Audio.bgs_play("Audio/BGS/#{RPG::BGS.last.name}", 0, RPG::BGS.last.pitch) if !RPG::BGS.last.name.empty?
      Audio.se_play("Audio/SE/Paralyze2", 100, 190) 
      update_bitmap
      5.times{
        Graphics.update
        Input.update
      }
      @snap_sprite_t.visible = @snap_sprite_u.visible = false
      Audio.bgm_play("Audio/BGM/#{RPG::BGM.last.name}", RPG::BGM.last.volume, RPG::BGM.last.pitch) if !RPG::BGM.last.name.empty?
      Audio.bgs_play("Audio/BGS/#{RPG::BGS.last.name}", RPG::BGS.last.volume, RPG::BGS.last.pitch) if !RPG::BGS.last.name.empty?
      $game_temp.brain_noise = false
    end
  end
  #--------------------------------------------------------------------------
  # ● 思考ノイズの解放
  #--------------------------------------------------------------------------
  def dispose
    @over_sprite.dispose
    @snap_sprite_t.bitmap.dispose
    @snap_sprite_u.bitmap.dispose
    @snap_sprite_t.dispose
    @snap_sprite_u.dispose
  end
end

class Window_Message < Window_Base
  #--------------------------------------------------------------------------
  # ● 制御文字の処理
  #--------------------------------------------------------------------------
  alias brain_noise_process_escape_character process_escape_character
  def process_escape_character(code, text, pos)
    case code.upcase
    when 'B' # 思考ノイズ 開始
      $game_temp.brain_noise = true
    end
    brain_noise_process_escape_character(code, text, pos)
  end
end