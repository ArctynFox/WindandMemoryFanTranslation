#==============================================================================
# ■ BMSP マップフォグ[MAPFOG] Ver1.00 2012/08/06
#------------------------------------------------------------------------------
# 　マップ画面にフォグを表示します．
#==============================================================================
#------------------------------------------------------------------------------
# ■内容
# RPGツクールXPにあったフォグ機能を再現します．
# マップに霧などの様な画像を表示することが出来ます．
#
# 位置：特に指定はありません
#
# ■使用方法
# スクリプトに丸ごと貼り付けていただければ使用できます。
#
# マップのメモ欄に
# 以下のフォーマットで記述します．
#   ==マップフォグ%filename%[%xspd%,%yspd%,%z%,%opacity%,%blend%]==
#
# %filename%は表示するファイル名を記述します．
# このとき，参照される場所は「Graphics/Parallaxes」です．
#
# %xspd%,%yspd%はそれぞれx方向，y方向のスクロール速度です．
# 20で1フレームごとに1ピクセル移動します．
#
# %z%はフォグのZ座標を記述します．
# 参考までに，マップタイルのZ座標は0，ピクチャや天候などは50，
# メッセージウインドウなどは100です．
#
# %opacity%はフォグの不透明度です．0～255で指定します．
#
# %blend%はフォグのブレンドタイプを指定します．
#   0：通常
#   1：加算
#   2：減算
#
# 例
#  ==マップフォグfogfile[-5,2,10,128,0]==
#
# また，スクリプトコマンドにより，一時的にフォグの設定を変えることができます．
# それぞれ以下のように対応します．
#   MapFog.name      ：フォグのファイル名
#   MapFog.xspeed    ：フォグのX方向の速度
#   MapFog.yspeed    ：フォグのY方向の速度
#   MapFog.z         ：フォグのZ座標
#   MapFog.opacity   ：フォグの不透明度
#   MapFog.blend_type：フォグのブレンドタイプ
# これらのプロパティに対して任意の操作を行うことができます．
#
# 例・実行するたびに速くなる
#   MapFog.xspeed += 2
#
# 例・実行するたびに流れる方向が反転する
#   MapFog.yspeed *= -1
#
# ■注意
# このスクリプトでは
# 「RPG::Map」「Game_Map」「Spriteset_Map」
# のメソッドを改変しています。
# ■情報
# このスクリプトはgentlawkによって作られたものです。
# 利用規約はhttp://blueredzone.comをご覧ください。
#------------------------------------------------------------------------------
module BMSP
  @@includes ||= {}
  @@includes[:MapFog] = true
  module MapFog
    # メモ欄から設定を抽出する正規表現
    MATCH = /==マップフォグ(.*)\[([+-]?\d+),([+-]?\d+),([+-]?\d+),(\d+),(\d)\]==/o
    #--------------------------------------------------------------------------
    # ● 正規表現とのマッチ
    #--------------------------------------------------------------------------
    def self.match(str)
      ret = []
      if MATCH =~ str
        filename = $1
        xspeed = $2.to_i
        yspeed = $3.to_i
        z = $4.to_i
        alpha = $5.to_i
        blend = [[0, $6.to_i].max, 2].min
        return {file: filename, xspd: xspeed, yspd: yspeed,
                  z: z, alpha: alpha, blend: blend}
      else
        return {file: "", xspd: 0, yspd: 0, z: 0, alpha: 255, blend: 0}
      end
    end
    module Interface
      ::MapFog = self
      #------------------------------------------------------------------------
      # ● アクセス：フォグ画像
      #------------------------------------------------------------------------
      def self.name
        $game_map.bmsp_fog[:file]
      end
      def self.name=(new_name)
        $game_map.bmsp_fog[:file] = new_name
      end
      #------------------------------------------------------------------------
      # ● アクセス：X速度
      #------------------------------------------------------------------------
      def self.xspeed
        $game_map.bmsp_fog[:xspd]
      end
      def self.xspeed=(new_xspd)
        $game_map.bmsp_fog[:xspd] = new_xspd
      end
      #------------------------------------------------------------------------
      # ● アクセス：Y速度
      #------------------------------------------------------------------------
      def self.yspeed
        $game_map.bmsp_fog[:yspd]
      end
      def self.yspeed=(new_yspd)
        $game_map.bmsp_fog[:yspd] = new_yspd
      end
      #------------------------------------------------------------------------
      # ● アクセス：Z座標
      #------------------------------------------------------------------------
      def self.z
        $game_map.bmsp_fog[:z]
      end
      def self.z=(new_z)
        $game_map.bmsp_fog[:z] = new_z
      end
      #------------------------------------------------------------------------
      # ● アクセス：不透明度
      #------------------------------------------------------------------------
      def self.opacity
        $game_map.bmsp_fog[:alpha]
      end
      def self.opacity=(new_alpha)
        $game_map.bmsp_fog[:alpha] = new_alpha
      end
      #------------------------------------------------------------------------
      # ● アクセス：ブレンドタイプ
      #------------------------------------------------------------------------
      def self.blend_type
        $game_map.bmsp_fog[:blend]
      end
      def self.blend_type=(new_blend)
        $game_map.bmsp_fog[:blend] = [[0, new_blend].max, 2].min
      end
    end
  end
end
#==============================================================================
# ■ RPG::Map
#==============================================================================
class RPG::Map
  #--------------------------------------------------------------------------
  # ● フォグ情報取得
  #--------------------------------------------------------------------------
  def fog_data
    return BMSP::MapFog.match(@note)
  end
end
#==============================================================================
# ■ Game_Map
#==============================================================================
class Game_Map
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor   :bmsp_fog                   # フォグの情報
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias bmsp_mapfog_initialize initialize
  def initialize
    bmsp_mapfog_initialize
    @bmsp_fog = nil
  end
  #--------------------------------------------------------------------------
  # ● セットアップ
  #--------------------------------------------------------------------------
  alias bmsp_mapfog_setup setup
  def setup(map_id)
    bmsp_mapfog_setup(map_id)
    @bmsp_fog = @map.fog_data
    @bmsp_fog_x = 0
    @bmsp_fog_y = 0
  end
  #--------------------------------------------------------------------------
  # ● 表示位置の設定
  #--------------------------------------------------------------------------
  alias bmsp_mapfog_set_display_pos set_display_pos
  def set_display_pos(x, y)
    bmsp_mapfog_set_display_pos(x, y)
    @bmsp_fog_x = x
    @bmsp_fog_y = y
  end
  #--------------------------------------------------------------------------
  # ● 下にスクロール
  #--------------------------------------------------------------------------
  alias bmsp_mapfog_scroll_down scroll_down
  def scroll_down(distance)
    last_y = @display_y
    if loop_vertical?
      @bmsp_fog_y += distance
    else
      @bmsp_fog_y += @display_y - last_y
    end
    bmsp_mapfog_scroll_down(distance)
  end
  #--------------------------------------------------------------------------
  # ● 左にスクロール
  #--------------------------------------------------------------------------
  alias bmsp_mapfog_scroll_left scroll_left
  def scroll_left(distance)
    last_x = @display_x
    if loop_horizontal?
      @bmsp_fog_x -= distance
    else
      @bmsp_fog_x += @display_x - last_x
    end
    bmsp_mapfog_scroll_left(distance)
  end
  #--------------------------------------------------------------------------
  # ● 右にスクロール
  #--------------------------------------------------------------------------
  alias bmsp_mapfog_scroll_right scroll_right
  def scroll_right(distance)
    last_x = @display_x
    if loop_horizontal?
      @bmsp_fog_x += distance
    else
      @bmsp_fog_x += @display_x - last_x
    end
    bmsp_mapfog_scroll_right(distance)
  end
  #--------------------------------------------------------------------------
  # ● 上にスクロール
  #--------------------------------------------------------------------------
  alias bmsp_mapfog_scroll_up scroll_up
  def scroll_up(distance)
    last_y = @display_y
    if loop_vertical?
      @bmsp_fog_y -= distance
    else
      @bmsp_fog_y += @display_y - last_y
    end
    bmsp_mapfog_scroll_up(distance)
  end
  #--------------------------------------------------------------------------
  # ● フォグのX座標
  #--------------------------------------------------------------------------
  def bmsp_mapfog_fog_x
    @bmsp_fog_x / 20
  end
  #--------------------------------------------------------------------------
  # ● フォグのY座標
  #--------------------------------------------------------------------------
  def bmsp_mapfog_fog_y
    @bmsp_fog_y / 20
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias bmsp_mapfog_update update
  def update(main = false)
    bmsp_mapfog_update(main)
    bmsp_mapfog_update_fog
  end
  #--------------------------------------------------------------------------
  # ● フォグの更新
  #--------------------------------------------------------------------------
  def bmsp_mapfog_update_fog
    return if @bmsp_fog[:file].empty?
    @bmsp_fog_x += @bmsp_fog[:xspd]
    @bmsp_fog_y += @bmsp_fog[:yspd]
  end
end
#==============================================================================
# ■ Spriteset_Map
#==============================================================================
class Spriteset_Map
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias bmsp_mapfog_initialize initialize
  def initialize
    bmsp_mapfog_create_fog
    bmsp_mapfog_initialize
  end
  #--------------------------------------------------------------------------
  # ● フォグの作成
  #--------------------------------------------------------------------------
  def bmsp_mapfog_create_fog
    @bmsp_fog = Plane.new
    @bmsp_fog.z = $game_map.bmsp_fog[:z]
    @bmsp_fog.opacity = $game_map.bmsp_fog[:alpha]
    @bmsp_fog.blend_type = $game_map.bmsp_fog[:blend]
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  alias bmsp_mapfog_dispose dispose
  def dispose
    bmsp_mapfog_dispose
    bmsp_mapfog_dispose_fog
  end
  #--------------------------------------------------------------------------
  # ● フォグの解放
  #--------------------------------------------------------------------------
  def bmsp_mapfog_dispose_fog
    @bmsp_fog.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias bmsp_mapfog_update update
  def update
    bmsp_mapfog_update
    bmsp_mapfog_update_fog
  end
  #--------------------------------------------------------------------------
  # ● フォグの更新
  #--------------------------------------------------------------------------
  def bmsp_mapfog_update_fog
    fog_data = $game_map.bmsp_fog
    if @bmsp_fog_name != fog_data[:file]
      @bmsp_fog_name = fog_data[:file]
      if @bmsp_fog.bitmap != nil
        @bmsp_fog.bitmap.dispose
        @bmsp_fog.bitmap = nil
      end
    end
    unless @bmsp_fog_name.empty?
      @bmsp_fog.bitmap = Cache.parallax(@bmsp_fog_name)
    end
    @bmsp_fog.z = fog_data[:z] if @bmsp_fog.z != fog_data[:z]
    @bmsp_fog.opacity = fog_data[:alpha] if @bmsp_fog.opacity != fog_data[:alpha]
    @bmsp_fog.blend_type = fog_data[:blend] if @bmsp_fog.blend_type != fog_data[:blend]
    @bmsp_fog.ox = $game_map.bmsp_mapfog_fog_x
    @bmsp_fog.oy = $game_map.bmsp_mapfog_fog_y
  end
end
							