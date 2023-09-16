#==============================================================================
# ★ RGSS3_バトルミスト Ver1.0
#==============================================================================
=begin

作者：tomoaky
webサイト：ひきも記 (http://hikimoki.sakura.ne.jp/)

戦闘シーンの背景に霧を表示します。

動作に必要な画像
  Graphics/System/mist.png
  
使用するゲームスイッチ（初期設定）
  0005

2011.12.15  Ver1.0
  公開

=end

#==============================================================================
# □ 設定項目
#==============================================================================
module TMBMIST
  SW_NOUSE   = 5       # バトルミスト無効化フラグとして使うゲームスイッチ番号
  BLEND_TYPE = 1        # 霧画像の合成方法（0=通常 / 1=加算 / 2=減算）
  MIST_NUM   = 10       # 霧の量
end

#==============================================================================
# □ Sprite_Mist
#==============================================================================
class Sprite_Mist < Sprite
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    self.bitmap = Cache.system("mist")
    self.blend_type = TMBMIST::BLEND_TYPE
    self.ox = self.bitmap.width / 2
    self.oy = self.bitmap.height / 2
    setup
    self.z += rand(570)
    update_position
  end
  #--------------------------------------------------------------------------
  # ○ セットアップ
  #--------------------------------------------------------------------------
  def setup
    @base_x = rand(Graphics.width / 2) + Graphics.width / 4
    self.z = 20
    self.mirror = (rand(3) == 0)
    update_position
  end
  #--------------------------------------------------------------------------
  # ○ 座標の更新
  #--------------------------------------------------------------------------
  def update_position
    self.x = (@base_x - (Graphics.width / 2)) * self.z / 128 + @base_x
    self.y = self.z / 4 + 160
    self.zoom_x = self.z * 0.003 + 0.25
    self.zoom_y = self.zoom_x
    self.opacity = (self.z >= 536 ? (600 - self.z) * 4 : self.z)
  end
  #--------------------------------------------------------------------------
  # ● 更新
  #--------------------------------------------------------------------------
  def update
    super
    self.z += 1
    self.z >= 600 ? setup : update_position
  end
end

#==============================================================================
# ■ Spriteset_Battle
#==============================================================================
class Spriteset_Battle
  #--------------------------------------------------------------------------
  # ● 戦闘背景（床）スプライトの作成
  #--------------------------------------------------------------------------
  alias tmbmist_spriteset_battle_create_battleback1 create_battleback1
  def create_battleback1
    tmbmist_spriteset_battle_create_battleback1
    @mist_sprites = []
    unless $game_switches[TMBMIST::SW_NOUSE]
      @mist_sprites = Array.new(TMBMIST::MIST_NUM) { Sprite_Mist.new(@viewport1) }
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘背景（床）スプライトの解放
  #--------------------------------------------------------------------------
  alias tmbmist_spriteset_battle_dispose_battleback1 dispose_battleback1
  def dispose_battleback1
    tmbmist_spriteset_battle_dispose_battleback1
    @mist_sprites.each {|sprite| sprite.dispose }
  end
  #--------------------------------------------------------------------------
  # ● 戦闘背景（床）スプライトの更新
  #--------------------------------------------------------------------------
  alias tmbmist_spriteset_battle_update_battleback1 update_battleback1
  def update_battleback1
    tmbmist_spriteset_battle_update_battleback1
    @mist_sprites.each {|sprite| sprite.update }
  end
end

