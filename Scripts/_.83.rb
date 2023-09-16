=begin
      RGSS3
      
　　　★ リッチ木漏れ日 ★

      ゆらゆらとした入射光を表現します。
      
      ● 準備 ●==========================================================
      「Graphics\System\」に下記の2ファイルを入れます
　      Sunshine_1.png
  　    Sunshine_2.png
      ====================================================================
      
      ● エフェクトの開始 ●==============================================
      イベントコマンドで次のスクリプトを実行します
      --------------------------------------------------------------------
      rich_sunshine_start(type, position)
      --------------------------------------------------------------------
      引数の type には 1 or 2 を、
      position には 1 or 2 or 3 を指定してください
        type
          1 : 白みがかった光を表示します
          2 : 青みがかった光を表示します
        position
          1 : 画面の左上から光が差し込みます
          2 : 画面の中央上部から光が差し込みます
          3 : 画面の右上から光が差し込みます
      ====================================================================
      
      ● エフェクトの終了 ●==============================================
      イベントコマンドで次のスクリプトを実行します
      --------------------------------------------------------------------
      rich_sunshine_stop
      ====================================================================
      
      ver1.00
      
      Last Update : 2017/05/27
      5/27 : 新規
      
      ろかん　　　http://kaisou-ryouiki.sakura.ne.jp/
=end

$rsi ||= {}
$rsi["リッチ木漏れ日"] = true

class Game_System
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :sunshine_type     # 木漏れ日の種別
  attr_accessor :sunshine_position # 木漏れ日の表示位置
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias rich_sunshine_effect_initialize initialize
  def initialize
    rich_sunshine_effect_initialize
    @sunshine_type = 0
    @sunshine_position = 0
  end
  #--------------------------------------------------------------------------
  # ● 木漏れ日の種別
  #--------------------------------------------------------------------------
  def sunshine_type
    @sunshine_type ||= 0
    @sunshine_type
  end
  #--------------------------------------------------------------------------
  # ● 木漏れ日の表示位置
  #--------------------------------------------------------------------------
  def sunshine_position
    @sunshine_position ||= 0
    @sunshine_position
  end
end

class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● 木漏れ日の開始
  #--------------------------------------------------------------------------
  def rich_sunshine_start(type, position)
    $game_system.sunshine_type = type
    $game_system.sunshine_position = position
  end
  #--------------------------------------------------------------------------
  # ● 木漏れ日の終了
  #--------------------------------------------------------------------------
  def rich_sunshine_stop
    $game_system.sunshine_type = 0
  end
end

class Spriteset_Sunshine
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(viewport)
    @viewport = viewport
    @last_type = 0
    @last_position = 0
    @s = [true, true]
    create_sunshine
    update
  end
  #--------------------------------------------------------------------------
  # ● 木漏れ日の作成
  #--------------------------------------------------------------------------
  def create_sunshine
    @sunshine_sprites = []
    3.times{|i|
      @sunshine_sprites << Sprite.new(@viewport)
      @sunshine_sprites[i].y = -180
      @sunshine_sprites[i].blend_type = 1
    }
    @sunshine_sprites[0].opacity = 150
    @sunshine_sprites[1].opacity = 0
    @sunshine_sprites[2].opacity = 0
  end
  #--------------------------------------------------------------------------
  # ● 木漏れ日の解放
  #--------------------------------------------------------------------------
  def dispose
    @sunshine_sprites.each{|sprite| sprite.dispose}
  end
  #--------------------------------------------------------------------------
  # ● 木漏れ日のビットマップ設定
  #--------------------------------------------------------------------------
  def set_bitmap
    if $game_system.sunshine_type != @last_type
      @sunshine_sprites.each{|sprite|
        case $game_system.sunshine_type
        when 0
          sprite.bitmap = nil
        when 1
          sprite.bitmap = Cache.system("Sunshine_1")
        when 2
          sprite.bitmap = Cache.system("Sunshine_2")
        end
        if sprite.bitmap
          sprite.ox = sprite.bitmap.width / 2
          sprite.oy = sprite.bitmap.height / 2
        end
      }
      @last_type = $game_system.sunshine_type
    end
  end
  #--------------------------------------------------------------------------
  # ● 木漏れ日の表示位置設定
  #--------------------------------------------------------------------------
  def set_position
    if $game_system.sunshine_position != @last_position
      @sunshine_sprites.each{|sprite|
        case $game_system.sunshine_position
        when 1
          sprite.x = 50
        when 2
          sprite.x = Graphics.width / 2
        when 3
          sprite.x = Graphics.width - 50
        else
          sprite.x = 0
        end
      }
      @last_position = $game_system.sunshine_position
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    set_bitmap
    set_position
    unless $game_system.sunshine_type.zero?
      if (Graphics.frame_count%2).zero?
        if @s[0]
          @sunshine_sprites[0].opacity -= 2
          @sunshine_sprites[1].opacity += 2
          if @sunshine_sprites[0].opacity.zero?
            @s[0] = false
            @sunshine_sprites[0].angle = rand(360)
          end
        else
          @sunshine_sprites[0].opacity += 2
          @sunshine_sprites[1].opacity -= 2
          if @sunshine_sprites[1].opacity.zero?
            @s[0] = true
            @sunshine_sprites[1].angle = rand(360)
          end
        end
      end
      if (Graphics.frame_count%3).zero?
        if @s[1]
          @sunshine_sprites[2].opacity -= 2
          if @sunshine_sprites[2].opacity.zero?
            @s[1] = false
            @sunshine_sprites[2].angle = rand(360)
          end
        else
          @sunshine_sprites[2].opacity += 2
          @s[1] = @sunshine_sprites[2].opacity == 150
        end
      end
    end
  end
end

class Spriteset_Map
  #--------------------------------------------------------------------------
  # ● ビューポートの作成
  #--------------------------------------------------------------------------
  alias rich_sunshine_effect_create_viewports create_viewports
  def create_viewports
    rich_sunshine_effect_create_viewports
    @rich_sunshine_effect_set = Spriteset_Sunshine.new(@viewport2)
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  alias rich_sunshine_effect_dispose dispose
  def dispose
    rich_sunshine_effect_dispose
    @rich_sunshine_effect_set.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias rich_sunshine_effect_update update
  def update
    rich_sunshine_effect_update
    update_rich_sunshine_effect
  end
  #--------------------------------------------------------------------------
  # ● 木漏れ日の更新
  #--------------------------------------------------------------------------
  def update_rich_sunshine_effect
    @rich_sunshine_effect_set.update
  end
end