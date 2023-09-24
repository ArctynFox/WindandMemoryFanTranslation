#==============================================================================
# ★ RGSS3_オーラエフェクト Ver1.0
#==============================================================================
=begin

作者：tomoaky
webサイト：ひきも記 (http://hikimoki.sakura.ne.jp/)

オーラステートとして設定したステートが付加されているバトラーに
それっぽい演出を表示するスクリプトです。

2011.12.15  Ver1.0
  公開

=end

#==============================================================================
# □ 設定項目
#==============================================================================
module TMAURA
  AURA_STATE = [31, 32, 33, 34, 35, 36, 38, 50, 51, 113, 213, 267, 412, 419, 279]  # オーラステートとして扱うステートID
end

#==============================================================================
# ■ Sprite_Battler
#==============================================================================
class Sprite_Battler < Sprite_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias tmaura_sprite_battler_initialize initialize
  def initialize(viewport, battler = nil)
    tmaura_sprite_battler_initialize(viewport, battler)
    @aura_sprite = Sprite.new(viewport)
    @aura_count = rand(180)
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  alias tmaura_sprite_battler_dispose dispose
  def dispose
    tmaura_sprite_battler_dispose
    @aura_sprite.bitmap.dispose if @aura_sprite.bitmap
    @aura_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias tmaura_sprite_battler_update update
  def update
    tmaura_sprite_battler_update
    if @battler
      if @use_sprite
        @aura_sprite.x = self.x
        @aura_sprite.y = self.y - (self.bitmap.height * self.zoom_y).round / 2
        @aura_sprite.z = self.z - 1
        @aura_sprite.mirror = self.mirror
        @aura_sprite.opacity = 0
        TMAURA::AURA_STATE.each do |id|
          if @battler.state?(id)
            @aura_sprite.opacity = self.opacity * 3 / 4
            @aura_count = (@aura_count + 1) % 180
            f = Math.sin(Math::PI * @aura_count / 90) * 0.05 + self.zoom_x * 1.1
            @aura_sprite.zoom_x = @aura_sprite.zoom_y = f
            break
          end
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 転送元ビットマップの更新
  #--------------------------------------------------------------------------
  alias tmaura_sprite_battler_update_bitmap update_bitmap
  def update_bitmap
    new_bitmap = Cache.battler(@battler.battler_name, @battler.battler_hue)
    if bitmap != new_bitmap
      @aura_sprite.bitmap = new_bitmap
      @aura_sprite.ox = @aura_sprite.bitmap.width / 2
      @aura_sprite.oy = @aura_sprite.bitmap.height / 2
      @aura_sprite.blend_type = 1
      @aura_sprite.opacity = 0
    end
    tmaura_sprite_battler_update_bitmap
  end
end

