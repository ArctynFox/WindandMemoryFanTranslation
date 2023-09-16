#==============================================================================
# ■ Spriteset_Battle
#------------------------------------------------------------------------------
# 　バトル画面のスプライトをまとめたクラスです。このクラスは Scene_Battle クラ
# スの内部で使用されます。
#==============================================================================

class Spriteset_Battle
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    create_viewports
    create_battleback1
    create_battleback2
    create_enemies
    create_actors
    create_pictures
    create_timer
    update
  end
  #--------------------------------------------------------------------------
  # ● ビューポートの作成
  #--------------------------------------------------------------------------
  def create_viewports
    @viewport1 = Viewport.new
    @viewport2 = Viewport.new
    @viewport3 = Viewport.new
    @viewport2.z = 50
    @viewport3.z = 100
  end
  #--------------------------------------------------------------------------
  # ● 戦闘背景（床）スプライトの作成
  #--------------------------------------------------------------------------
  def create_battleback1
    @back1_sprite = Sprite.new(@viewport1)
    @back1_sprite.bitmap = battleback1_bitmap
    @back1_sprite.z = 0
    center_sprite(@back1_sprite)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘背景（壁）スプライトの作成
  #--------------------------------------------------------------------------
  def create_battleback2
    @back2_sprite = Sprite.new(@viewport1)
    @back2_sprite.bitmap = battleback2_bitmap
    @back2_sprite.z = 1
    center_sprite(@back2_sprite)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘背景（床）ビットマップの取得
  #--------------------------------------------------------------------------
  def battleback1_bitmap
    if battleback1_name
      Cache.battleback1(battleback1_name)
    else
      create_blurry_background_bitmap
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘背景（壁）ビットマップの取得
  #--------------------------------------------------------------------------
  def battleback2_bitmap
    if battleback2_name
      Cache.battleback2(battleback2_name)
    else
      Bitmap.new(1, 1)
    end
  end
  #--------------------------------------------------------------------------
  # ● マップ画面を加工した戦闘背景用ビットマップの作成
  #--------------------------------------------------------------------------
  def create_blurry_background_bitmap
    source = SceneManager.background_bitmap
    bitmap = Bitmap.new(640, 480)
    bitmap.stretch_blt(bitmap.rect, source, source.rect)
    bitmap.radial_blur(120, 16)
    bitmap
  end
  #--------------------------------------------------------------------------
  # ● 戦闘背景（床）ファイル名の取得
  #--------------------------------------------------------------------------
  def battleback1_name
    if $BTEST
      $data_system.battleback1_name
    elsif $game_map.battleback1_name
      $game_map.battleback1_name
    elsif $game_map.overworld?
      overworld_battleback1_name
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘背景（壁）ファイル名の取得
  #--------------------------------------------------------------------------
  def battleback2_name
    if $BTEST
      $data_system.battleback2_name
    elsif $game_map.battleback2_name
      $game_map.battleback2_name
    elsif $game_map.overworld?
      overworld_battleback2_name
    end
  end
  #--------------------------------------------------------------------------
  # ● フィールド 戦闘背景（床）ファイル名の取得
  #--------------------------------------------------------------------------
  def overworld_battleback1_name
    $game_player.vehicle ? ship_battleback1_name : normal_battleback1_name
  end
  #--------------------------------------------------------------------------
  # ● フィールド 戦闘背景（壁）ファイル名の取得
  #--------------------------------------------------------------------------
  def overworld_battleback2_name
    $game_player.vehicle ? ship_battleback2_name : normal_battleback2_name
  end
  #--------------------------------------------------------------------------
  # ● 通常時 戦闘背景（床）ファイル名の取得
  #--------------------------------------------------------------------------
  def normal_battleback1_name
    terrain_battleback1_name(autotile_type(1)) ||
    terrain_battleback1_name(autotile_type(0)) ||
    default_battleback1_name
  end
  #--------------------------------------------------------------------------
  # ● 通常時 戦闘背景（壁）ファイル名の取得
  #--------------------------------------------------------------------------
  def normal_battleback2_name
    terrain_battleback2_name(autotile_type(1)) ||
    terrain_battleback2_name(autotile_type(0)) ||
    default_battleback2_name
  end
  #--------------------------------------------------------------------------
  # ● 地形に対応する戦闘背景（床）ファイル名の取得
  #--------------------------------------------------------------------------
  def terrain_battleback1_name(type)
    case type
    when 24,25        # 荒れ地
      "Wasteland"
    when 26,27        # 土肌
      "DirtField"
    when 32,33        # 砂漠
      "Desert"
    when 34           # 岩地
      "Lava1"
    when 35           # 岩地（溶岩）
      "Lava2"
    when 40,41        # 雪原
      "Snowfield"
    when 42           # 雲
      "Clouds"
    when 4,5          # 毒の沼
      "PoisonSwamp"
    end
  end
  #--------------------------------------------------------------------------
  # ● 地形に対応する戦闘背景（壁）ファイル名の取得
  #--------------------------------------------------------------------------
  def terrain_battleback2_name(type)
    case type
    when 20,21        # 森
      "Forest1"
    when 22,30,38     # 低い山
      "Cliff"
    when 24,25,26,27  # 荒れ地、土肌
      "Wasteland"
    when 32,33        # 砂漠
      "Desert"
    when 34,35        # 岩地
      "Lava"
    when 40,41        # 雪原
      "Snowfield"
    when 42           # 雲
      "Clouds"
    when 4,5          # 毒の沼
      "PoisonSwamp"
    end
  end
  #--------------------------------------------------------------------------
  # ● デフォルト 戦闘背景（床）ファイル名の取得
  #--------------------------------------------------------------------------
  def default_battleback1_name
    "Grassland"
  end
  #--------------------------------------------------------------------------
  # ● デフォルト 戦闘背景（壁）ファイル名の取得
  #--------------------------------------------------------------------------
  def default_battleback2_name
    "Grassland"
  end
  #--------------------------------------------------------------------------
  # ● 乗船時 戦闘背景（床）ファイル名の取得
  #--------------------------------------------------------------------------
  def ship_battleback1_name
    "Ship"
  end
  #--------------------------------------------------------------------------
  # ● 乗船時 戦闘背景（壁）ファイル名の取得
  #--------------------------------------------------------------------------
  def ship_battleback2_name
    "Ship"
  end
  #--------------------------------------------------------------------------
  # ● プレイヤーの足元にあるオートタイルの種類を取得
  #--------------------------------------------------------------------------
  def autotile_type(z)
    $game_map.autotile_type($game_player.x, $game_player.y, z)
  end
  #--------------------------------------------------------------------------
  # ● スプライトを画面中央に移動
  #--------------------------------------------------------------------------
  def center_sprite(sprite)
    sprite.ox = sprite.bitmap.width / 2
    sprite.oy = sprite.bitmap.height / 2
    sprite.x = Graphics.width / 2
    sprite.y = Graphics.height / 2
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラスプライトの作成
  #--------------------------------------------------------------------------
  def create_enemies
    @enemy_sprites = $game_troop.members.reverse.collect do |enemy|
      Sprite_Battler.new(@viewport1, enemy)
    end
  end
  #--------------------------------------------------------------------------
  # ● アクタースプライトの作成
  #    デフォルトではアクター側の画像は表示しないが、便宜上、敵と味方を同じ
  #  ように扱うためにダミーのスプライトを作成する。
  #--------------------------------------------------------------------------
  def create_actors
    @actor_sprites = Array.new(4) { Sprite_Battler.new(@viewport1) }
  end
  #--------------------------------------------------------------------------
  # ● ピクチャスプライトの作成
  #    初期状態では空の配列だけ作っておき、必要になった時点で追加する。
  #--------------------------------------------------------------------------
  def create_pictures
    @picture_sprites = []
  end
  #--------------------------------------------------------------------------
  # ● タイマースプライトの作成
  #--------------------------------------------------------------------------
  def create_timer
    @timer_sprite = Sprite_Timer.new(@viewport2)
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    dispose_battleback1
    dispose_battleback2
    dispose_enemies
    dispose_actors
    dispose_pictures
    dispose_timer
    dispose_viewports
  end
  #--------------------------------------------------------------------------
  # ● 戦闘背景（床）スプライトの解放
  #--------------------------------------------------------------------------
  def dispose_battleback1
    @back1_sprite.bitmap.dispose
    @back1_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # ● 戦闘背景（壁）スプライトの解放
  #--------------------------------------------------------------------------
  def dispose_battleback2
    @back2_sprite.bitmap.dispose
    @back2_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラスプライトの解放
  #--------------------------------------------------------------------------
  def dispose_enemies
    @enemy_sprites.each {|sprite| sprite.dispose }
  end
  #--------------------------------------------------------------------------
  # ● アクタースプライトの解放
  #--------------------------------------------------------------------------
  def dispose_actors
    @actor_sprites.each {|sprite| sprite.dispose }
  end
  #--------------------------------------------------------------------------
  # ● ピクチャスプライトの解放
  #--------------------------------------------------------------------------
  def dispose_pictures
    @picture_sprites.compact.each {|sprite| sprite.dispose }
  end
  #--------------------------------------------------------------------------
  # ● タイマースプライトの解放
  #--------------------------------------------------------------------------
  def dispose_timer
    @timer_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # ● ビューポートの解放
  #--------------------------------------------------------------------------
  def dispose_viewports
    @viewport1.dispose
    @viewport2.dispose
    @viewport3.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    update_battleback1
    update_battleback2
    update_enemies
    update_actors
    update_pictures
    update_timer
    update_viewports
  end
  #--------------------------------------------------------------------------
  # ● 戦闘背景（床）スプライトの更新
  #--------------------------------------------------------------------------
  def update_battleback1
    @back1_sprite.update
  end
  #--------------------------------------------------------------------------
  # ● 戦闘背景（壁）スプライトの更新
  #--------------------------------------------------------------------------
  def update_battleback2
    @back2_sprite.update
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラスプライトの更新
  #--------------------------------------------------------------------------
  def update_enemies
    @enemy_sprites.each {|sprite| sprite.update }
  end
  #--------------------------------------------------------------------------
  # ● アクタースプライトの更新
  #--------------------------------------------------------------------------
  def update_actors
    @actor_sprites.each_with_index do |sprite, i|
      sprite.battler = $game_party.members[i]
      sprite.update
    end
  end
  #--------------------------------------------------------------------------
  # ● ピクチャスプライトの更新
  #--------------------------------------------------------------------------
  def update_pictures
    $game_troop.screen.pictures.each do |pic|
      @picture_sprites[pic.number] ||= Sprite_Picture.new(@viewport2, pic)
      @picture_sprites[pic.number].update
    end
  end
  #--------------------------------------------------------------------------
  # ● タイマースプライトの更新
  #--------------------------------------------------------------------------
  def update_timer
    @timer_sprite.update
  end
  #--------------------------------------------------------------------------
  # ● ビューポートの更新
  #--------------------------------------------------------------------------
  def update_viewports
    @viewport1.tone.set($game_troop.screen.tone)
    @viewport1.ox = $game_troop.screen.shake
    @viewport2.color.set($game_troop.screen.flash_color)
    @viewport3.color.set(0, 0, 0, 255 - $game_troop.screen.brightness)
    @viewport1.update
    @viewport2.update
    @viewport3.update
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラとアクターのスプライトを取得
  #--------------------------------------------------------------------------
  def battler_sprites
    @enemy_sprites + @actor_sprites
  end
  #--------------------------------------------------------------------------
  # ● アニメーション表示中判定
  #--------------------------------------------------------------------------
  def animation?
    battler_sprites.any? {|sprite| sprite.animation? }
  end
  #--------------------------------------------------------------------------
  # ● エフェクト実行中判定
  #--------------------------------------------------------------------------
  def effect?
    battler_sprites.any? {|sprite| sprite.effect? }
  end
end
