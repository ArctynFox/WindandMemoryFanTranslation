#==============================================================================
# ★ RGSS3_自動天候 Ver1.0
#==============================================================================
=begin

作者：tomoaky
webサイト：ひきも記は閉鎖しました。 (http://hikimoki.sakura.ne.jp/)

天候をマップごとに設定し、マップ移動時に自動的に切り替わるようにします。
  
マップのメモ欄に <天候 タイプ, 強さ> のタグを書き込むことで
マップ単位で天候を指定することができます。
  例）<天候 snow,8>
  none = 天候解除 / rain = 雨 / storm = 嵐 / snow = 雪

2014.10.13  Ver1.0
  ・公開

=end

#==============================================================================
# □ 設定項目
#==============================================================================
module TMAWEATHER
  # 天候タグがない場合に天候を初期設定に変更するか（false で前マップを引き継ぐ）
  USE_DEFAULT_WEATHER = true
  
  # 天候の初期設定（[タイプ, 強さ(0 - 9)]）
  # :none / :rain / :storm / :snow
  DEFAULT_WEATHER = [:none, 0]
  
  # 天候による色調補正を利用する（false で利用しない）
  USE_WEATHER_DIMNESS = true
end

#==============================================================================
# ■ Game_Map
#==============================================================================
class Game_Map
  #--------------------------------------------------------------------------
  # ● セットアップ
  #--------------------------------------------------------------------------
  alias tmaweather_game_map_setup setup
  def setup(map_id)
    tmaweather_game_map_setup(map_id)
    if /<天候\s*(.+?)\s*,\s*(\d+)\s*>/ =~ @map.note
      @screen.change_weather($1.to_sym, $2.to_i, 0)
    elsif TMAWEATHER::USE_DEFAULT_WEATHER
      @screen.change_weather(*TMAWEATHER::DEFAULT_WEATHER, 0)
    end
  end
end

#==============================================================================
# ■ Spriteset_Weather
#==============================================================================
class Spriteset_Weather
  #--------------------------------------------------------------------------
  # ● 暗さの取得
  #--------------------------------------------------------------------------
  alias tmaweather_spriteset_weather_dimness dimness
  def dimness
    if TMAWEATHER::USE_WEATHER_DIMNESS
      return tmaweather_spriteset_weather_dimness
    else
      return 0
    end
  end
end
