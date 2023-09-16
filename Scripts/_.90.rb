#==============================================================================
# ■ RGSS3 オーラエフェクト機能 Ver1.01 by 星潟
#------------------------------------------------------------------------------
# バトラー・キャラクター・ピクチャー画像に対し
# それぞれの画像を用いたスプライトを継続的に発生させ
# オーラのような表示を実装します。
# 
# まずオーラタイプIDに応じた設定を行い
# そのオーラタイプIDを用いてオーラパターンデータの設定を行います。
# 最後にそれぞれの画像に対応したオーラパターンデータを設定して
# 設定が完了となります。
# 
# なお、共通して以下のいずれかの条件の場合はオーラエフェクトが発生しません.
# 1.不透明度が0
# 2.非表示扱いとなっている
# 3.画像なしの場合
# 
# キャラクター画像の場合は透明状態の場合も発生しません。
# イベントのキャラクター画像の場合は画面外判定となった場合も発生しません。
#==============================================================================
# 特徴を有する項目(アクター・エネミー・職業・ステート・装備等)のメモ欄に記述。
#------------------------------------------------------------------------------
# <オーラエフェクト:0>
# 
# この特徴を有するバトラーはオーラパターンデータ0の設定を得る。
#------------------------------------------------------------------------------
# <オーラエフェクト:0,1>
# 
# この特徴を有するバトラーはオーラパターンデータ0と1の設定を得る。
#==============================================================================
# アクター・エネミー用設定方法
# （ただし、アクターはデフォルト状態では戦闘中はバトラー画像が存在しない。
#   バトラー画像の設定例としては、XPスタイルバトルスクリプトで
#   顔グラフィックや歩行グラフィックではなく
#   実際にバトラー画像を用いる設定をすることで
#   正式にバトラー画像が設定される）
#==============================================================================
# イベントコマンドのスクリプトで使用。
# なお、削除処理を行う際、特徴によって付与されたものは削除できない。
#------------------------------------------------------------------------------
# actor_star_aura_effect_add(1,4)
# 
# アクターID1のアクターにオーラエフェクトパターンデータ4を設定する。
#------------------------------------------------------------------------------
# actor_star_aura_effect_delete(2,3)
# 
# アクターID2のアクターに設定したオーラエフェクトパターンデータ3を削除する。
#------------------------------------------------------------------------------
# actor_star_aura_effect_all_delete(3)
# 
# アクターID3のアクターに設定したオーラエフェクトパターンデータを全て削除する。
#------------------------------------------------------------------------------
# party_star_aura_effect_add(0,3)
# 
# パーティの先頭(index0)のアクターに
# オーラエフェクトパターンデータ3を設定する。
#------------------------------------------------------------------------------
# party_star_aura_effect_delete(1,2)
# 
# パーティの先頭から2番目(index1)のアクターに設定した
# オーラエフェクトパターンデータ2を削除する。
#------------------------------------------------------------------------------
# party_star_aura_effect_all_delete(2)
# 
# パーティの先頭から3番目(index2)のアクターに設定した
# オーラエフェクトパターンデータを全て削除する。
#------------------------------------------------------------------------------
# enemy_star_aura_effect_add(0,3)
# 
# 敵グループの先頭(index0)のエネミーに
# オーラエフェクトパターンデータ3を設定する。
#------------------------------------------------------------------------------
# enemy_star_aura_effect_delete(1,2)
# 
# 敵グループの先頭から2番目(index1)のエネミーに設定した
# オーラエフェクトパターンデータ2を削除する。
#------------------------------------------------------------------------------
# enemy_star_aura_effect_all_delete(2)
# 
# 敵グループの先頭から3番目(index2)のエネミーに設定した
# オーラエフェクトパターンデータを全て削除する。
#==============================================================================
# キャラクター用(プレイヤー・イベント・乗り物)
#==============================================================================
# イベントの名前欄に記述。
#------------------------------------------------------------------------------
# <オーラ:0>
# 
# この記述を有するイベントは全ページにおいてオーラパターンデータ0の設定を得る。
#------------------------------------------------------------------------------
# <オーラ:1_2>
# 
# この記述を有するイベントが1ページ目の場合
# オーラパターンデータ2の設定を得る。
#------------------------------------------------------------------------------
# <オーラ:3,1_4,2_5>
# 
# この記述を有するイベントは全ページにおいてオーラパターンデータ3の設定を得、
# 更に1ページ目の場合はオーラパターンデータ4、
# 2ページ目の場合はオーラパターンデータ5の設定を得る。
#==============================================================================
# イベントコマンドのスクリプトで使用。
#------------------------------------------------------------------------------
# player_star_aura_effect_add(0,3)
# 
# パーティの先頭(index0)のキャラチップに
# オーラエフェクトパターンデータ3を設定する。
#------------------------------------------------------------------------------
# player_star_aura_effect_delete(1,2)
# 
# パーティの先頭から2番目(index1)のキャラチップに設定した
# オーラエフェクトパターンデータ2を削除する。
#------------------------------------------------------------------------------
# player_star_aura_effect_all_delete(2)
# 
# パーティの先頭から3番目(index2)のキャラチップに設定した
# オーラエフェクトパターンデータを全て削除する。
#------------------------------------------------------------------------------
# event_star_aura_effect_add(1,4)
# 
# イベントID1のイベントにオーラエフェクトパターンデータ4を設定する。
#------------------------------------------------------------------------------
# event_star_aura_effect_delete(2,3)
# 
# イベントID2のイベントに設定したオーラエフェクトパターンデータ3を削除する。
#------------------------------------------------------------------------------
# event_star_aura_effect_all_delete(3)
# 
# イベントID3のイベントに設定したオーラエフェクトパターンデータを全て削除する。
#------------------------------------------------------------------------------
# vehicle_star_aura_effect_add(0,3)
# 
# 小型船にオーラエフェクトパターンデータ3を設定する。
#------------------------------------------------------------------------------
# vehicle_star_aura_effect_delete(1,2)
# 
# 大型船に設定したオーラエフェクトパターンデータ2を削除する。
#------------------------------------------------------------------------------
# vehicle_star_aura_effect_all_delete(2)
# 
# 飛行船に設定したオーラエフェクトパターンデータを全て削除する。
#==============================================================================
# ピクチャ用
#==============================================================================
# イベントコマンドのスクリプトで使用。
# これらの設定はピクチャの消去で失われる。
#------------------------------------------------------------------------------
# picture_star_aura_effect_add(1,4)
# 
# ピクチャ番号1のピクチャに
# オーラエフェクトパターンデータ4を設定する。
#------------------------------------------------------------------------------
# picture_star_aura_effect_delete(2,3)
# 
# ピクチャ番号2のピクチャに設定した
# オーラエフェクトパターンデータ3を削除する。
#------------------------------------------------------------------------------
# picture_star_aura_effect_all_delete(3)
# 
# ピクチャ番号3のピクチャに設定した
# オーラエフェクトパターンデータを全て削除する。
#==============================================================================
module StarAuraEffect
  
  #設定用キーワードを指定。
  
  Word1 = "オーラエフェクト"
  
  #設定用キーワードを指定。
  
  Word2 = "オーラ"
  
  #空のハッシュを2種用意。
  
  T = {}
  P = {}
  
  #オーラタイプIDに応じた設定を指定。
  
  #例.
  #T[0] = {
  #:opacity => 160,
  #:zoom_rate => 0.02,
  #:erase_start => 5,
  #:erase_speed => 8,
  #:x_add => 0,
  #:y_add => 0,
  #:z => -1,
  #:blend_type => 1,
  #:position_type => 1,
  #:trace => true,
  #:color => [0,0,255,128],
  #:tone => [0,0,0,0]
  #}
  #
  #この場合、初期不透明度160、
  #1フレーム毎の拡大度は0.02％、
  #表示され始めてから5フレームで更なる透明化開始、
  #透明化開始後は1フレーム毎に不透明度が8ずつ減少、
  #1フレーム毎にX座標に0、Y座標に0を加算、
  #表示対象のバトラーのZ座標に対し-1のZ座標で表示され、
  #合成タイプは加算、
  #合成する色は赤の要素0、緑の要素128、青の要素255、不透明度160の色。
  #色調は赤の要素32、緑の要素-64、青の要素16、グレイスケール48。
  
  #なお、:blend_type(合成タイプ)は0で通常、1で加算、2で減算。
  #:position_type(位置)は0で元画像の上から下方向に広がり、
  #1で元画像の中央から広がり、2で元画像の下から上方向に広がる。
  #:traceは主にマップ上のキャラクターを想定したもので
  #trueの場合は元画像の位置を基準にして表示し、
  #falseの場合は表示開始位置を基準にして表示する。
  
  #設定内で数字を用いている部分はスクリプト文に置き換えることが可能。
  
  #具体的には、:x_add => "rand(3)-1"などといった記述ができる。
  #この場合、0から2の間の数字から1を引いた値なので-1、0、1のいずれかとなる。
  
  T[0] = {
  :opacity => 160,
  :zoom_rate => 0.02,
  :erase_start => 5,
  :erase_speed => 8,
  :x_add => 0,
  :y_add => 0,
  :z => -1,
  :blend_type => 1,
  :position_type => 1,
  :trace => true,
  :color => [0,0,255,128],
  :tone => [0,0,0,0]
  }
  T[1] = {
  :opacity => 160,
  :zoom_rate => 0.02,
  :erase_start => 5,
  :erase_speed => 8,
  :x_add => 0,
  :y_add => 0,
  :z => -1,
  :blend_type => 1,
  :position_type => 1,
  :trace => true,
  :color => [0,255,0,128],
  :tone => [0,0,0,0]
  }
  T[2] = {
  :opacity => 160,
  :zoom_rate => 0.02,
  :erase_start => 5,
  :erase_speed => 8,
  :x_add => 0,
  :y_add => 0,
  :z => -1,
  :blend_type => 1,
  :position_type => 1,
  :trace => true,
  :color => [255,0,0,128],
  :tone => [0,0,0,0]
  }
  T[3] = {
  :opacity => 192,
  :zoom_rate => 0.00,
  :erase_start => 5,
  :erase_speed => 8,
  :x_add => 0,
  :y_add => 0,
  :z => -1,
  :blend_type => 1,
  :position_type => 1,
  :trace => false,
  :color => [0,128,255,128],
  :tone => [0,0,0,0]
  }
  
  #オーラパターンデータIDに応じた設定を指定。
  
  #P[0] = {
  #:end => 40,
  #:pattern => {
  #0 => [0,1,2],
  #10 => [0],
  #20 => [1],
  #30 => [2]
  #}}
  #
  #この場合、終点は40で
  #40フレームに到達した時点で0フレーム目に戻される。
  #(40フレーム目の判定はされず0フレームが優先される)
  #0フレーム目にオーラタイプID0、1、2の設定のスプライトを追加する。
  #10フレーム目にオーラタイプID0の設定のスプライトを追加する。
  #20フレーム目にオーラタイプID1の設定のスプライトを追加する。
  #30フレーム目にオーラタイプID2の設定のスプライトを追加する。
  
  P[0] = {
  :end => 30,
  :pattern => {
  0 => [1],
  10 => [0],
  20 => [2]
  }}
  
  P[1] = {
  :end => 10,
  :pattern => {
  0 => [0]
  }}
  
end
class RPG::BaseItem
  #--------------------------------------------------------------------------
  # オーラエフェクト
  #--------------------------------------------------------------------------
  def star_aura_effect
    @star_aura_effect ||= create_star_aura_effect
  end
  #--------------------------------------------------------------------------
  # オーラエフェクト配列作成
  #--------------------------------------------------------------------------
  def create_star_aura_effect
    r = /<#{StarAuraEffect::Word1}[:：](\S+)>/ =~ note ? $1.to_s : ""
    a = r.empty? ? [] : r.split(/\s*,\s*/).inject([]) {|r,i| r.push(i.to_i)}
    a.uniq
  end
end
class RPG::Event
  #--------------------------------------------------------------------------
  # オーラエフェクト配列作成
  #--------------------------------------------------------------------------
  def create_star_aura_effect
    h = {}
    return if @star_aura_effect_flag
    a1 = /<#{StarAuraEffect::Word2}[:：](\S+)>/ =~ name ? $1.to_s : ""
    a2 = a1.empty? ? [] : a1.split(/\s*,\s*/).inject([]) {|r,i| r.push(i.to_s)}
    a2.each {|s|
    a3 = s.split(/\s*_\s*/)
    case a3.size
    when 1
      page_id = :all
      aura_effect_id = a3[0].to_i
    when 2
      page_id = a3[0].to_i - 1
      aura_effect_id = a3[1].to_i
    end
    h[page_id] ||= []
    h[page_id].push(aura_effect_id)}
    @pages.each_with_index {|page,i|
    page.star_aura_effect += h[:all] if h[:all]
    page.star_aura_effect += h[i] if h[i]}
    @star_aura_effect_flag = true
  end
end
class RPG::Event::Page
  #--------------------------------------------------------------------------
  # オーラエフェクト
  #--------------------------------------------------------------------------
  def star_aura_effect
    @star_aura_effect ||= []
  end
  #--------------------------------------------------------------------------
  # オーラエフェクト設定
  #--------------------------------------------------------------------------
  def star_aura_effect=(new_star_aura_effect)
    @star_aura_effect = new_star_aura_effect
  end
end
module StarAuraEffect
  #--------------------------------------------------------------------------
  # オーラエフェクト
  #-------------------------------------------------------------------------
  def star_aura_effect
    @star_aura_effects ||= []
  end
  #--------------------------------------------------------------------------
  # オーラエフェクト追加
  #--------------------------------------------------------------------------
  def star_aura_effect_add(aura_effect_type)
    @star_aura_effects ||= []
    @star_aura_effects.push(aura_effect_type)
    @star_aura_effects.uniq!
    @star_aura_effect_update = true
  end
  #--------------------------------------------------------------------------
  # オーラエフェクト削除
  #--------------------------------------------------------------------------
  def star_aura_effect_delete(aura_effect_type)
    @star_aura_effects ||= []
    @star_aura_effects.delete(aura_effect_type)
    @star_aura_effect_update = true
  end
  #--------------------------------------------------------------------------
  # オーラエフェクト全削除
  #--------------------------------------------------------------------------
  def star_aura_effect_all_delete
    @star_aura_effects = []
    @star_aura_effect_update = true
  end
  #--------------------------------------------------------------------------
  # オーラエフェクトデータ
  #--------------------------------------------------------------------------
  def aura_effect_data
    @star_aura_effects_data ||= []
  end
  #--------------------------------------------------------------------------
  # オーラエフェクトデータ追加
  #--------------------------------------------------------------------------
  def aura_effect_data_add(hash)
    @star_aura_effects_data ||= []
    @star_aura_effects_data.push(hash)
  end
  #--------------------------------------------------------------------------
  # オーラエフェクトデータ消去
  #--------------------------------------------------------------------------
  def aura_effect_data_all_delete
    @star_aura_effects_data = []
  end
  #--------------------------------------------------------------------------
  # オーラエフェクトデータ消去
  #--------------------------------------------------------------------------
  def aura_effect_data_delete_opacity_zero
    @star_aura_effects_data.delete_if {|effect_array| effect_array[:opacity] == 0}
  end
  #--------------------------------------------------------------------------
  # オーラエフェクトデータ追加
  #--------------------------------------------------------------------------
  def aura_effect_data_create(effect_id,base_zoom_x,base_zoom_y,base_ox,base_oy,
    base_opacity,base_mirror,base_angle,
    bitmap_type,bitmap_name,bitmap_hue,bitmap_src_rect)
    return if bitmap_name.empty?
    hash = {}
    if self.is_a?(Game_Character)
      return if self.is_a?(Game_Follower) && !self.visible? or @transparent
      hash[:base_real_x] = self.real_x
      hash[:base_real_y] = self.real_y
      hash[:shift_y] = self.shift_y
      hash[:jump_height] = self.jump_height
      hash[:bush_depth] = self.bush_depth
    elsif self.is_a?(Game_Picture)
      hash[:base_real_x] = self.x
      hash[:base_real_y] = self.y
      hash[:bush_depth] = 0
    else
      hash[:base_real_x] = self.screen_x
      hash[:base_real_y] = self.screen_y
      hash[:bush_depth] = 0
    end
    m_hash = StarAuraEffect::T[effect_id]
    hash[:count] = 0
    hash[:zoom_rate] = 1.0
    hash[:zoom_rate_add] = m_hash[:zoom_rate].is_a?(String) ? eval(m_hash[:zoom_rate]) : m_hash[:zoom_rate]
    hash[:effect_id] = effect_id
    hash[:count] = 0
    hash[:bitmap_type] = bitmap_type
    hash[:bitmap_name] = bitmap_name
    hash[:bitmap_hue] = bitmap_hue
    hash[:bitmap_src_rect] = [bitmap_src_rect.x,bitmap_src_rect.y,bitmap_src_rect.width,bitmap_src_rect.height]
    hash[:base_ox] = base_ox
    hash[:base_oy] = base_oy
    hash[:base_zoom_x] = base_zoom_x
    hash[:base_zoom_y] = base_zoom_y
    hash[:zoom_x] = base_zoom_x
    hash[:zoom_y] = base_zoom_y
    hash[:opacity] = (base_opacity.to_f * (m_hash[:opacity].is_a?(String) ? eval(m_hash[:opacity]) : m_hash[:opacity]) / 255).to_i
    hash[:origin] = self.is_a?(Game_Picture) ? self.origin : -1
    hash[:real_x] = hash[:base_real_x]
    hash[:real_y] = hash[:base_real_y]
    hash[:trace] = m_hash[:trace]
    hash[:position] = m_hash[:position_type].is_a?(String) ? eval(m_hash[:position_type]) : m_hash[:position_type]
    hash[:mirror] = base_mirror
    hash[:angle] = base_angle
    v = m_hash[:x_add]
    hash[:x_add] = v ? (v.is_a?(String) ? eval(v) : v) : 0
    v = m_hash[:y_add]
    hash[:y_add] = v ? (v.is_a?(String) ? eval(v) : v) : 0
    hash
  end
  #--------------------------------------------------------------------------
  # オーラエフェクトデータ更新
  #--------------------------------------------------------------------------
  def update_aura_effect(sprite)
    aura_effect_data.each {|effect_data|
    m_hash = StarAuraEffect::T[effect_data[:effect_id]]
    effect_data[:count] += 1
    effect_data[:zoom_rate] += effect_data[:zoom_rate_add]
    effect_data[:zoom_x] = effect_data[:base_zoom_x] * effect_data[:zoom_rate]
    effect_data[:zoom_y] = effect_data[:base_zoom_y] * effect_data[:zoom_rate]
    effect_data[:opacity] -= m_hash[:erase_speed] if effect_data[:count] >= m_hash[:erase_start]
    effect_data[:opacity] = 0 if effect_data[:opacity] < 0
    if effect_data[:trace]
      effect_data[:base_ox] = sprite.ox
      effect_data[:base_oy] = sprite.oy
      if self.is_a?(Game_Character)
        effect_data[:screen_x] = ($game_map.adjust_x(@real_x + effect_data[:x_add] * effect_data[:count].to_f / 32) * 32 + 16).to_i
        effect_data[:screen_y] = ($game_map.adjust_y(@real_y + effect_data[:y_add] * effect_data[:count].to_f / 32) * 32 + 32 - shift_y - jump_height).to_i
      elsif self.is_a?(Game_Picture)
        effect_data[:screen_x] = self.x + effect_data[:x_add] * effect_data[:count]
        effect_data[:screen_y] = self.y + effect_data[:y_add] * effect_data[:count]
      else
        effect_data[:screen_x] = self.screen_x + effect_data[:x_add] * effect_data[:count]
        effect_data[:screen_y] = self.screen_y + effect_data[:y_add] * effect_data[:count]
      end
    else
      if self.is_a?(Game_Character)
        effect_data[:screen_x] = ($game_map.adjust_x(effect_data[:real_x] + effect_data[:x_add] * effect_data[:count].to_f / 32) * 32 + 16).to_i
        effect_data[:screen_y] = ($game_map.adjust_y(effect_data[:real_y] + effect_data[:y_add] * effect_data[:count].to_f / 32) * 32 + 32 - effect_data[:shift_y] - effect_data[:jump_height]).to_i
      else
        effect_data[:screen_x] = effect_data[:real_x] + effect_data[:x_add] * effect_data[:count]
        effect_data[:screen_y] = effect_data[:real_y] + effect_data[:y_add] * effect_data[:count]
      end
    end
    }
  end
end
class Game_BattlerBase
  attr_accessor :star_aura_effect_update
  include StarAuraEffect
  #--------------------------------------------------------------------------
  # リフレッシュ
  #--------------------------------------------------------------------------
  alias refresh_star_aura_effect refresh
  def refresh
    @star_aura_effect_update = true
    refresh_star_aura_effect
  end
  #--------------------------------------------------------------------------
  # オーラエフェクト
  #-------------------------------------------------------------------------
  def star_aura_effect
    @star_aura_effects ||= []
    (@star_aura_effects + (feature_objects.inject([]) {|r,f| r += f.star_aura_effect})).uniq
  end
end
class Game_Character < Game_CharacterBase
  attr_accessor :star_aura_effect_update
  attr_accessor :star_aura_effects
  include StarAuraEffect
  #--------------------------------------------------------------------------
  # 画面内判定
  #--------------------------------------------------------------------------
  def near_the_screen_for_aura?
    true
  end
end
class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # リフレッシュ
  #--------------------------------------------------------------------------
  alias refresh_star_aura_effect refresh
  def refresh
    @star_aura_effect_update = true
    refresh_star_aura_effect
  end
end
class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # リフレッシュ
  #--------------------------------------------------------------------------
  alias refresh_star_aura_effect refresh
  def refresh
    @event.create_star_aura_effect
    @star_aura_effect_update = true
    refresh_star_aura_effect
  end
  #--------------------------------------------------------------------------
  # イベントページのセットアップ
  #--------------------------------------------------------------------------
  alias setup_page_star_aura_effect setup_page
  def setup_page(new_page)
    setup_page_star_aura_effect(new_page)
    @star_aura_effects = new_page ? new_page.star_aura_effect.clone : []
    @star_aura_effect_update = true
  end
  #--------------------------------------------------------------------------
  # 画面内判定
  #--------------------------------------------------------------------------
  def near_the_screen_for_aura?
    near_the_screen?
  end
end
class << BattleManager
  #--------------------------------------------------------------------------
  # 戦闘終了
  #--------------------------------------------------------------------------
  alias battle_end_star_aura_effect battle_end
  def battle_end(result)
    battle_end_star_aura_effect(result)
    $game_party.aura_effect_actor_clear
  end
end
class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # オーラエフェクトを発生させたアクターID
  #--------------------------------------------------------------------------
  def aura_effect_actor_ids
    @aura_effect_actor_ids ||= {}
  end
  #--------------------------------------------------------------------------
  # オーラエフェクトを発生させたアクターIDを記憶
  #--------------------------------------------------------------------------
  def aura_effect_actor_ids_add(actor_id)
    @aura_effect_actor_ids ||= {}
    @aura_effect_actor_ids[actor_id] = true
  end
  #--------------------------------------------------------------------------
  # オーラエフェクトを発生させたアクターから
  # オーラエフェクトデータを削除して記憶用ハッシュを初期化
  #--------------------------------------------------------------------------
  def aura_effect_actor_clear
    aura_effect_actor_ids.keys.each {|actor_id|
    $game_actors[actor_id].aura_effect_data_all_delete}
    @aura_effect_actor_ids = {}
  end
end
class Game_Follower < Game_Character
  #--------------------------------------------------------------------------
  # リフレッシュ
  #--------------------------------------------------------------------------
  alias refresh_star_aura_effect refresh
  def refresh
    @star_aura_effect_update = true
    refresh_star_aura_effect
  end
end
class Game_Vehicle < Game_Character
  #--------------------------------------------------------------------------
  # リフレッシュ
  #--------------------------------------------------------------------------
  alias refresh_star_aura_effect refresh
  def refresh
    @star_aura_effect_update = true
    refresh_star_aura_effect
  end
end
class Game_Picture
  attr_accessor :star_aura_effect_update
  attr_accessor :star_aura_effects
  include StarAuraEffect
  #--------------------------------------------------------------------------
  # 基本変数の初期化
  #--------------------------------------------------------------------------
  alias init_basic_star_aura_effect init_basic
  def init_basic
    init_basic_star_aura_effect
    @star_aura_effect_update = true
    star_aura_effect
  end
  #--------------------------------------------------------------------------
  # ピクチャの消去
  #--------------------------------------------------------------------------
  alias erase_star_aura_effect erase
  def erase
    erase_star_aura_effect
    star_aura_effect_all_delete
  end
end
class Game_Interpreter
  #--------------------------------------------------------------------------
  # アクターのバトラーグラフィックのオーラエフェクト追加
  #--------------------------------------------------------------------------
  def actor_star_aura_effect_add(actor_id,aura_effect_type)
    actor = $game_actors[actor_id]
    return unless actor
    actor.star_aura_effect_add(aura_effect_type)
  end
  #--------------------------------------------------------------------------
  # アクターのバトラーグラフィックのオーラエフェクト削除（タイプ指定）
  #--------------------------------------------------------------------------
  def actor_star_aura_effect_delete(actor_id,aura_effect_type)
    actor = $game_actors[actor_id]
    return unless actor
    actor.star_aura_effect_delete(aura_effect_type)
  end
  #--------------------------------------------------------------------------
  # アクターのバトラーグラフィックのオーラエフェクト全削除
  #--------------------------------------------------------------------------
  def actor_star_aura_effect_all_delete(actor_id)
    actor = $game_actors[actor_id]
    return unless actor
    actor.star_aura_effect_all_delete
  end
  #--------------------------------------------------------------------------
  # パーティメンバーのバトラーグラフィックのオーラエフェクト追加
  #--------------------------------------------------------------------------
  def party_star_aura_effect_add(party_member_index,aura_effect_type)
    member = $game_party.all_members[party_member_index]
    return unless member
    member.star_aura_effect_add(aura_effect_type)
  end
  #--------------------------------------------------------------------------
  # パーティメンバーのバトラーグラフィックのオーラエフェクト削除（タイプ指定）
  #--------------------------------------------------------------------------
  def party_star_aura_effect_delete(party_member_index,aura_effect_type)
    member = $game_party.all_members[party_member_index]
    return unless member
    member.star_aura_effect_delete(aura_effect_type)
  end
  #--------------------------------------------------------------------------
  # パーティメンバーのバトラーグラフィックのオーラエフェクト全削除
  #--------------------------------------------------------------------------
  def party_star_aura_effect_all_delete(party_member_index)
    member = $game_party.all_members[party_member_index]
    return unless member
    member.star_aura_effect_all_delete
  end
  #--------------------------------------------------------------------------
  # エネミーのバトラーグラフィックのオーラエフェクト追加
  #--------------------------------------------------------------------------
  def enemy_star_aura_effect_add(troop_member_index,aura_effect_type)
    member = $game_troop.members[troop_member_index]
    return unless member
    member.star_aura_effect_add(aura_effect_type)
  end
  #--------------------------------------------------------------------------
  # エネミーのバトラーグラフィックのオーラエフェクト削除（タイプ指定）
  #--------------------------------------------------------------------------
  def enemy_star_aura_effect_delete(troop_member_index,aura_effect_type)
    member = $game_troop.members[troop_member_index]
    return unless member
    member.star_aura_effect_delete(aura_effect_type)
  end
  #--------------------------------------------------------------------------
  # エネミーのバトラーグラフィックのオーラエフェクト全削除
  #--------------------------------------------------------------------------
  def enemy_star_aura_effect_all_delete(troop_member_index)
    member = $game_troop.members[troop_member_index]
    return unless member
    member.star_aura_effect_all_delete
  end
  #--------------------------------------------------------------------------
  # プレイヤー・フォロワーのバトラーグラフィックのオーラエフェクト追加
  #--------------------------------------------------------------------------
  def player_star_aura_effect_add(player_index,aura_effect_type)
    character = player_index == 0 ? $game_player : $game_player.followers[player_index - 1]
    return unless character
    character.star_aura_effect_add(aura_effect_type)
  end
  #--------------------------------------------------------------------------
  # プレイヤー・フォロワーのバトラーグラフィックのオーラエフェクト削除（タイプ指定）
  #--------------------------------------------------------------------------
  def player_star_aura_effect_delete(player_index,aura_effect_type)
    character = player_index == 0 ? $game_player : $game_player.followers[player_index - 1]
    return unless character
    character.star_aura_effect_delete(aura_effect_type)
  end
  #--------------------------------------------------------------------------
  # プレイヤー・フォロワーのバトラーグラフィックのオーラエフェクト全削除
  #--------------------------------------------------------------------------
  def player_star_aura_effect_all_delete(player_index)
    character = player_index == 0 ? $game_player : $game_player.followers[player_index - 1]
    return unless character
    character.star_aura_effect_all_delete
  end
  #--------------------------------------------------------------------------
  # イベントのバトラーグラフィックのオーラエフェクト追加
  #--------------------------------------------------------------------------
  def event_star_aura_effect_add(event_id,aura_effect_type)
    event = $game_map.events[event_id]
    return unless event
    event.star_aura_effect_add(aura_effect_type)
  end
  #--------------------------------------------------------------------------
  # イベントのバトラーグラフィックのオーラエフェクト削除（タイプ指定）
  #--------------------------------------------------------------------------
  def event_star_aura_effect_delete(event_id,aura_effect_type)
    event = $game_map.events[event_id]
    return unless event
    event.star_aura_effect_delete(aura_effect_type)
  end
  #--------------------------------------------------------------------------
  # イベントのバトラーグラフィックのオーラエフェクト全削除
  #--------------------------------------------------------------------------
  def event_star_aura_effect_all_delete(event_id)
    event = $game_map.events[event_id]
    return unless event
    event.star_aura_effect_all_delete
  end
  #--------------------------------------------------------------------------
  # 乗り物のバトラーグラフィックのオーラエフェクト追加
  #--------------------------------------------------------------------------
  def vehicle_star_aura_effect_add(vehicle_type,aura_effect_type)
    vehicle = $game_map.vehicles[vehicle_type]
    return unless vehicle
    vehicle.star_aura_effect_add(aura_effect_type)
  end
  #--------------------------------------------------------------------------
  # 乗り物のバトラーグラフィックのオーラエフェクト削除（タイプ指定）
  #--------------------------------------------------------------------------
  def vehicle_star_aura_effect_delete(vehicle_type,aura_effect_type)
    vehicle = $game_map.vehicles[vehicle_type]
    return unless vehicle
    vehicle.star_aura_effect_delete(aura_effect_type)
  end
  #--------------------------------------------------------------------------
  # 乗り物のバトラーグラフィックのオーラエフェクト全削除
  #--------------------------------------------------------------------------
  def vehicle_star_aura_effect_all_delete(vehicle_type)
    vehicle = $game_map.vehicles[vehicle_type]
    return unless vehicle
    vehicle.star_aura_effect_all_delete
  end
  #--------------------------------------------------------------------------
  # ピクチャのバトラーグラフィックのオーラエフェクト追加
  #--------------------------------------------------------------------------
  def picture_star_aura_effect_add(picture_id,aura_effect_type)
    picture = screen.pictures[picture_id]
    return unless picture
    picture.star_aura_effect_add(aura_effect_type)
  end
  #--------------------------------------------------------------------------
  # ピクチャのバトラーグラフィックのオーラエフェクト削除（タイプ指定）
  #--------------------------------------------------------------------------
  def picture_star_aura_effect_delete(picture_id,aura_effect_type)
    picture = screen.pictures[picture_id]
    return unless picture
    picture.star_aura_effect_delete(aura_effect_type)
  end
  #--------------------------------------------------------------------------
  # ピクチャのバトラーグラフィックのオーラエフェクト全削除
  #--------------------------------------------------------------------------
  def picture_star_aura_effect_all_delete(picture_id)
    picture = screen.pictures[picture_id]
    return unless picture
    picture.star_aura_effect_all_delete
  end
end
class Sprite
  #--------------------------------------------------------------------------
  # オーラエフェクト用データを準備
  #--------------------------------------------------------------------------
  def star_aura_effect_initialize
    @star_aura_effect_update = true
    @star_aura_effect_sprites = []
    @star_aura_effects = {}
    @star_aura_effect_keys = []
  end
  #--------------------------------------------------------------------------
  # オーラエフェクトの解放
  #--------------------------------------------------------------------------
  def dispose_star_aura_effects
    @star_aura_effect_sprites.each {|s| s.dispose}
    @star_aura_effect_sprites.clear
  end
  #--------------------------------------------------------------------------
  # オーラエフェクトの更新
  #--------------------------------------------------------------------------
  def star_aura_effects_update(aura_target)
    if aura_target
      @star_aura_last_x ||= self.x
      @star_aura_last_y ||= self.y
      if @star_aura_last_x != self.x or @star_aura_last_y != self.y
        @star_aura_last_x = self.x
        @star_aura_last_y = self.y
      end
      if aura_target.star_aura_effect_update or @star_aura_effect_update
        aura_target_star_aura_effect = aura_target.star_aura_effect
        aura_target.star_aura_effect_update = false
        @star_aura_effect_update = false
        @star_aura_effect_keys = aura_target_star_aura_effect
      end
      if self.visible && self.opacity > 0
        aura_bitmap_type = nil
        aura_bitmap_name = nil
        aura_bitmap_hue = nil
        aura_bitmap_src_rect = nil
        @star_aura_effect_keys.each {|i|
        if @star_aura_effects[i]
          @star_aura_effects[i] += 1
          @star_aura_effects[i] = 0 if @star_aura_effects[i] >= StarAuraEffect::P[i][:end]
        else
          @star_aura_effects[i] = 0
        end
        a = StarAuraEffect::P[i][:pattern][@star_aura_effects[i]]
        if a
          if !aura_bitmap_type
            if self.is_a?(Sprite_Battler)
              aura_bitmap_type = :b
              aura_bitmap_name = aura_target.battler_name
              aura_bitmap_hue  = aura_target.battler_hue
              aura_bitmap_src_rect = self.src_rect
            elsif self.is_a?(Sprite_Character)
              aura_bitmap_type = :c
              aura_bitmap_name = aura_target.character_name
              aura_bitmap_hue  = 0
              aura_bitmap_src_rect = self.src_rect
            elsif self.is_a?(Sprite_Picture)
              aura_bitmap_type = :p
              aura_bitmap_name = aura_target.name
              aura_bitmap_hue  = 0
              aura_bitmap_src_rect = self.src_rect
            end
          end
          if aura_bitmap_type != :c or aura_target.near_the_screen_for_aura?
            if !aura_bitmap_name.empty?
              a.each {|type|
              effect_hash = aura_target.aura_effect_data_create(
              type,self.zoom_x,self.zoom_y,self.ox,self.oy,
              self.opacity,self.mirror,self.angle,
              aura_bitmap_type,aura_bitmap_name,
              aura_bitmap_hue,aura_bitmap_src_rect)
              if effect_hash
                if aura_bitmap_type == :b && aura_target.actor?
                  $game_party.aura_effect_actor_ids_add(aura_target.id)
                end
                aura_target.aura_effect_data_add(effect_hash)
              end}
            end
          end
        end}
      end
    else
      @star_aura_last_x = nil
      @star_aura_last_y = nil
      @star_aura_effect_update = true
      dispose_star_aura_effects if !@star_aura_effects.empty?
      @star_aura_effect_sprites.delete_if {|s| s.disposed?}
      return
    end
    aura_target.update_aura_effect(self)
    aura_target.aura_effect_data.each_with_index {|effect_hash,i|
    @star_aura_effect_sprites[i] ||= Sprite_StarAuraEffect.new(self,effect_hash)
    @star_aura_effect_sprites[i].update_by_effect_hash(effect_hash)
    }
    aura_target.aura_effect_data_delete_opacity_zero
    @star_aura_effect_sprites.delete_if {|s| 
    s.dispose if s.opacity == 0
    s.disposed?}
  end
end
class Sprite_Character < Sprite_Base
  #--------------------------------------------------------------------------
  # オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_star_aura_effect initialize
  def initialize(viewport, character = nil)
    star_aura_effect_initialize
    initialize_star_aura_effect(viewport, character)
  end
  #--------------------------------------------------------------------------
  # 解放
  #--------------------------------------------------------------------------
  alias dispose_star_aura_effect dispose
  def dispose
    dispose_star_aura_effects
    dispose_star_aura_effect
  end
  #--------------------------------------------------------------------------
  # フレーム更新
  #--------------------------------------------------------------------------
  alias update_star_aura_effect update
  def update
    update_star_aura_effect
    star_aura_effects_update(@character)
  end
end
class Sprite_Battler < Sprite_Base
  #--------------------------------------------------------------------------
  # オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_star_aura_effect initialize
  def initialize(viewport, battler = nil)
    star_aura_effect_initialize
    initialize_star_aura_effect(viewport, battler)
  end
  #--------------------------------------------------------------------------
  # 解放
  #--------------------------------------------------------------------------
  alias dispose_star_aura_effect dispose
  def dispose
    dispose_star_aura_effects
    dispose_star_aura_effect
  end
  #--------------------------------------------------------------------------
  # フレーム更新
  #--------------------------------------------------------------------------
  alias update_star_aura_effect update
  def update
    update_star_aura_effect
    star_aura_effects_update(battler)
  end
end
class Sprite_Picture < Sprite
  #--------------------------------------------------------------------------
  # オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_star_aura_effect initialize
  def initialize(viewport, picture)
    star_aura_effect_initialize
    initialize_star_aura_effect(viewport, picture)
  end
  #--------------------------------------------------------------------------
  # 解放
  #--------------------------------------------------------------------------
  alias dispose_star_aura_effect dispose
  def dispose
    dispose_star_aura_effects
    dispose_star_aura_effect
  end
  #--------------------------------------------------------------------------
  # フレーム更新
  #--------------------------------------------------------------------------
  alias update_star_aura_effect update
  def update
    update_star_aura_effect
    star_aura_effects_update(@picture)
  end
  #--------------------------------------------------------------------------
  # 原点取得
  #--------------------------------------------------------------------------
  def get_origin_star_aura_effect
    @picture.origin
  end
end
class Sprite_StarAuraEffect < Sprite
  #--------------------------------------------------------------------------
  # オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(parent,hash)
    super(parent.viewport)
    @parent = parent
    m_hash = StarAuraEffect::T[hash[:effect_id]]
    case hash[:bitmap_type]
    when :b
      self.bitmap = Cache.battler(hash[:bitmap_name],hash[:bitmap_hue])
    when :c
      self.bitmap = Cache.character(hash[:bitmap_name])
    when :p
      self.bitmap = Cache.picture(hash[:bitmap_name])
    end
    r = hash[:bitmap_src_rect]
    self.src_rect.set(Rect.new(r[0],r[1],r[2],r[3])) if r
    self.z = @parent.z + (m_hash[:z].is_a?(String) ? eval(m_hash[:z]) : m_hash[:z])
    self.blend_type = m_hash[:blend_type].is_a?(String) ? eval(m_hash[:blend_type]) : m_hash[:blend_type]
    c = m_hash[:color]
    self.color = Color.new(
    c[0].is_a?(String) ? eval(c[0]) : c[0],
    c[1].is_a?(String) ? eval(c[1]) : c[1],
    c[2].is_a?(String) ? eval(c[2]) : c[2],
    c[3].is_a?(String) ? eval(c[3]) : c[3]) if c
    t = m_hash[:tone]
    self.tone = Tone.new(
    t[0].is_a?(String) ? eval(t[0]) : t[0],
    t[1].is_a?(String) ? eval(t[1]) : t[1],
    t[2].is_a?(String) ? eval(t[2]) : t[2],
    t[3].is_a?(String) ? eval(t[3]) : t[3]) if t
    self.bush_depth = hash[:bush_depth].is_a?(String) ? eval(hash[:bush_depth]) : hash[:bush_depth]
    self.mirror = hash[:base_mirror].is_a?(String) ? eval(hash[:base_mirror]) : hash[:base_mirror]
    self.angle = hash[:angle].is_a?(String) ? eval(hash[:angle]) : hash[:angle]
  end
  #--------------------------------------------------------------------------
  # ハッシュデータからスプライトの更新
  #--------------------------------------------------------------------------
  def update_by_effect_hash(hash)
    self.opacity = hash[:opacity]
    self.zoom_x  = hash[:zoom_x]
    self.zoom_y  = hash[:zoom_y]
    self.ox = hash[:base_ox]
    self.oy = hash[:base_oy]
    case hash[:origin]
    when 0
      self.x = hash[:screen_x] - ((self.width * (self.zoom_x - hash[:base_zoom_x])) / 2).to_i
    when -1,1
      self.x = hash[:screen_x]
    end
    case hash[:position]
    when 0
      case hash[:origin]
      when -1
        self.y = hash[:screen_y] + (self.height * (self.zoom_y - hash[:base_zoom_y]))
      when 0
        self.y = hash[:screen_y]
      when 1
        self.y = hash[:screen_y] + (self.height * (self.zoom_y - hash[:base_zoom_y])) / 2
      end
    when 1
      case hash[:origin]
      when -1
        self.y = hash[:screen_y] + ((self.height * (self.zoom_y - hash[:base_zoom_y])) / 2).to_i
      when 0
        self.y = hash[:screen_y] - ((self.height * (self.zoom_y - hash[:base_zoom_y])) / 2).to_i
      when 1
        self.y = hash[:screen_y]
      end
    when 2
      case hash[:origin]
      when -1
        self.y = hash[:screen_y]
      when 0
        self.y = hash[:screen_y] - (self.height * (self.zoom_y - hash[:base_zoom_y])).to_i
      when 1
        self.y = hash[:screen_y] - ((self.height * (self.zoom_y - hash[:base_zoom_y])) / 2).to_i
      end
    end
    update
  end
end