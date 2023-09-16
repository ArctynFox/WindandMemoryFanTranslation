#==============================================================================
#    ☆VXAce RGSS3 「ダメージポップアップ」☆
#　　　　　　EnDlEss DREamER
#     URL:http://mitsu-evo.6.ql.bz/
#     製作者 mitsu-evo
#     Last:2014/5/3
#     ▼ 素材のすぐ下辺り。
#==============================================================================
$ed_rgss3 = {} if $ed_rgss2 == nil
$ed_rgss3["ed_damage_popup"] = true

=begin
5/3：ダメージ表示が二重に表示されてしまうのを修正。



      ★　機能説明　★
    
    ・ツクールＸＰのダメージポップアップ準拠の動作を行なわせるポップアップ。
    ・継続ダメージと継続回復の場合は継続回復優先表示
    ・文字色はシステムカラーから取得。
      「Popup_Font」のメソッドから取得しているので
      変更する場合は文字色は「text_color(0)」の括弧内の数字を変更すること。
    ・文字色は「通常：白。回復：緑。MPダメージ：青。クリティカル：赤」
    ・表示したくないステートIDをHIDE_STATEの配列に入れて下さい。
    ・FF_MASSAGE_SYSTEMがtrueだとスキル名などだけが表示されます。

=end

  # ポップアップの表示時間
  POPUP_DURATION = 30
  # ＦＦのようスキル名及びスキルメッセージ以外表示しない。
  FF_MASSAGE_SYSTEM = false
  # 表示しないステートのID
  HIDE_STATE = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,
24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,
49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,
75,76,77]

#==============================================================================
# ■ Popup_Font
#------------------------------------------------------------------------------
# 　ポップアップ文字の設定モジュールです。
# 文字色は「Sprite_Battler」クラスの「damageメソッド」の真ん中ら辺
# などの部分を以下のモジュールのメソッド名に変更することで
# ウィンドウスキンから指定の文字色を適用します。
# 「Window_base」の設定と同じです。
#==============================================================================
module Popup_Font
  
  # ポップアップに使用するフォント。「Vocab」を使用するので基本は日本語で。
  POPUP_FONT = Font.default_name#"UmePlus Gothic"
  # ポップアップ文字サイズ
  POPUP_FONT_SIZE = 30  
  
  # 以下は文字色の設定メソッド。Window_baseのコピーがベースです。
  
  #--------------------------------------------------------------------------
  # ● 文字色取得
  #     n : 文字色番号 (0～31)
  #--------------------------------------------------------------------------
  def text_color(n)
    x = 64 + (n % 8) * 8
    y = 96 + (n / 8) * 8
    skin = Cache.system("Window")
    return skin.get_pixel(x, y)
  end
  #--------------------------------------------------------------------------
  # ● 通常ダメージ文字色の取得
  #--------------------------------------------------------------------------
  def normal_color
    return text_color(0)
  end
  #--------------------------------------------------------------------------
  # ● HP回復文字色の取得
  #--------------------------------------------------------------------------
  def recovery_color
    return text_color(3)
  end
  #--------------------------------------------------------------------------
  # ● MP回復文字色の取得
  #--------------------------------------------------------------------------
  def system_color
    return text_color(16)
  end
  #--------------------------------------------------------------------------
  # ● クリティカル文字色の取得
  #--------------------------------------------------------------------------
  def knockout_color
    return text_color(18)
  end
  module_function
end
  
#==============================================================================
# ■ Vocab
#------------------------------------------------------------------------------
# 　用語とメッセージを定義するモジュールです。定数でメッセージなどを直接定義す
# るほか、グローバル変数 $data_system から用語データを取得します。
#==============================================================================

module Vocab
  
  Str_Miss    = "Miss"          # ポップアップ用文字「ミス」
  Str_Evaded  = "Evaded"          # ポップアップ用文字「回避」
  Str_Absobed = "Absorbed"          # ポップアップ用文字「吸収」
  
end
#==============================================================================
# ■ Game_Battler
#------------------------------------------------------------------------------
# 　バトラーを扱うクラスです。このクラスは Game_Actor クラスと Game_Enemy クラ
# スのスーパークラスとして使用されます。
#==============================================================================

class Game_Battler
  attr_accessor :damage_popup           # ダメージポップアップフラグ
  attr_accessor :damage                 # 行動結果文字列配列：ダメージ結果格納(数字＆文字)
  
  #--------------------------------------------------------------------------
  # ● スプライトとの通信用変数をクリア
  #--------------------------------------------------------------------------
  alias ed_damage_popup_clear_sprite_effects clear_sprite_effects
  def clear_sprite_effects
    @damage       = []                    # 数字でも文字でも
    @popup_subject = []
    @damage_popup = false
    ed_damage_popup_clear_sprite_effects
  end
  def popup_subject
    @popup_subject ||= []
    @popup_subject
  end
  def popup_subject=(value)
    @popup_subject ||= []
    @popup_subject = value
  end
  #--------------------------------------------------------------------------
  # ● 行動効果の中身
  #    value : 表示文字。nil で自動的に表示。0 で初期化
  #--------------------------------------------------------------------------
  def damage=(value)
    # value が 0 なら初期化し戻る。
    if value == 0 #or self.dead?
      @damage_popup = false
      @damage       = []
      @popup_subject = []
      return
    end
    @damage ||= []
    subject = []
    # ダメージは文字・ステートはデータベースの格納値によって表示を変更
    if value == "damage" or value == "slip" or value == "recovery"    # ダメージ表示
      # 何も無い場合は行動結果やダメージ値から表示文字を作成する。
      hp_value = @result.hp_damage
      mp_value = @result.mp_damage
      tp_value = @result.tp_damage
      if @result.missed and "damage"# ミスの場合
        subject << [Vocab::Str_Miss,false]
      elsif @result.evaded and "damage" # 回避の場合
        subject << [Vocab::Str_Evaded,false] 
      else 
        subject << [hp_value,false] if hp_value > 0
        subject << [hp_value,true] if hp_value < 0
        subject << [mp_value,false,"mp"] if mp_value > 0
        subject << [mp_value,true,"mp"] if mp_value < 0
        subject << [mp_value,false,"tp"] if tp_value > 0
        subject << [mp_value,true,"tp"] if tp_value < 0
      end
    elsif value.is_a?(Array) and value[0][0].is_a?(RPG::State) # ステート表示
      return if HIDE_STATE.include?(value[0][0].id) # 表示しないステートなら戻る
      # ステート名表示。
      value[0].each{|state| subject << [state.name,value[1]]}
    end
    @damage = subject #unless @damage.include?(subject)
    @damage.uniq!
    @damage_popup = true unless @damage.empty?
  end
  #--------------------------------------------------------------------------
  # ● HP の再生
  #--------------------------------------------------------------------------
  alias ed_damage_popup_regenerate_hp regenerate_hp
  def regenerate_hp
    ed_damage_popup_regenerate_hp
    #self.hp -= @result.hp_damage
    self.damage       = 0 # 初期化してからターンエンド処理。
    self.damage       = "recovery"
  end
  #--------------------------------------------------------------------------
  # ● MP の再生
  #--------------------------------------------------------------------------
  alias ed_damage_popup_regenerate_mp regenerate_mp
  def regenerate_mp
    ed_damage_popup_regenerate_mp
    #self.mp -= @result.mp_damage
    self.damage       = "recovery"
  end
end
#==============================================================================
# ■ Game_Actor
#------------------------------------------------------------------------------
# 　アクターを扱うクラスです。このクラスは Game_Actors クラス（$game_actors）
# の内部で使用され、Game_Party クラス（$game_party）からも参照されます。
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ● ダメージ効果の実行
  #--------------------------------------------------------------------------
  alias ed_damage_popup_perform_damage_effect perform_damage_effect
  def perform_damage_effect
    ed_damage_popup_perform_damage_effect
    self.damage       = 0 # 初期化してからターンエンド処理。
    self.damage       = "damage"
  end
end
#==============================================================================
# ■ Game_Enemy
#------------------------------------------------------------------------------
# 　敵キャラを扱うクラスです。このクラスは Game_Troop クラス（$game_troop）の
# 内部で使用されます。
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # ● ダメージ効果の実行
  #--------------------------------------------------------------------------
  alias ed_damage_popup_perform_damage_effect perform_damage_effect
  def perform_damage_effect
    ed_damage_popup_perform_damage_effect
    self.damage       = 0 # 初期化してからターンエンド処理。
    self.damage       = "damage"
  end
end
#==============================================================================
# ■ Window_BattleLog
#------------------------------------------------------------------------------
# 　戦闘の進行を実況表示するウィンドウです。枠は表示しませんが、便宜上ウィンド
# ウとして扱います。
#==============================================================================

class Window_BattleLog < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias ed_damage_popup_initialize initialize
  def initialize
    if FF_MASSAGE_SYSTEM
      wx = Graphics.width / 2 - window_width / 2
      super(wx, 0, window_width, window_height)
      self.z = 200
      self.opacity = 0
      @lines = []
      @num_wait = 0
      create_back_bitmap
      create_back_sprite
      refresh
    else
      ed_damage_popup_initialize
    end
  end
  #--------------------------------------------------------------------------
  # ● 背景スプライトの作成
  #--------------------------------------------------------------------------
  alias ed_damage_popup_create_back_sprite create_back_sprite
  def create_back_sprite
    ed_damage_popup_create_back_sprite
    @back_sprite.x = x
  end
  #--------------------------------------------------------------------------
  # ● 文章の追加
  #--------------------------------------------------------------------------
  alias ed_damage_popup_add_text add_text
  def add_text(text)
    return if FF_MASSAGE_SYSTEM
    ed_damage_popup_add_text(text)
  end
  #--------------------------------------------------------------------------
  # ● 最下行の文章の取得
  #--------------------------------------------------------------------------
  alias ed_damage_popup_last_text last_text
  def last_text
    return FF_MASSAGE_SYSTEM ? [] : ed_damage_popup_last_text
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  alias ed_damage_popup_window_width window_width
  def window_width
    return FF_MASSAGE_SYSTEM ? Graphics.width / 2 : ed_damage_popup_window_width
  end
  #--------------------------------------------------------------------------
  # ● 最大行数の取得
  #--------------------------------------------------------------------------
  alias ed_damage_popup_max_line_number max_line_number
  def max_line_number
    return FF_MASSAGE_SYSTEM ? 1 : ed_damage_popup_max_line_number
  end
  #--------------------------------------------------------------------------
  # ● 行の描画
  #--------------------------------------------------------------------------
  alias ed_damage_popup_draw_line draw_line
  def draw_line(line_number)
    if FF_MASSAGE_SYSTEM
      rect = item_rect_for_text(line_number)
      text = @lines[line_number]
      ww = text_size(text).width
      wx = rect.width / 2 - ww / 2#(spacing + standard_padding)
      contents.clear_rect(rect)
      draw_text_ex(wx, rect.y, @lines[line_number])
    else
      ed_damage_popup_draw_line(line_number)
    end
  end
  #--------------------------------------------------------------------------

  # ● スキル／アイテム使用の表示
  #--------------------------------------------------------------------------
  alias ed_damage_popup_display_use_item display_use_item
  def display_use_item(subject, item)
    if FF_MASSAGE_SYSTEM
      ed_damage_popup_add_text(item.name)
    else
      ed_damage_popup_display_use_item(subject, item)
    end
  end
  #--------------------------------------------------------------------------
  # ● スキル／アイテム使用の表示(メッセージ2)
  #--------------------------------------------------------------------------
  def display_use_item_massage2(subject, item)
    return unless FF_MASSAGE_SYSTEM
    return unless item.is_a?(RPG::Skill)
    unless item.message2.empty?
      back_one
      ed_damage_popup_add_text(item.message2)
    end
  end
  #--------------------------------------------------------------------------
  # ● ダメージのポップアップ
  #--------------------------------------------------------------------------
  def damage_pop(target)
    target.damage = 0
    return
    target.damage = "damage"
  end
  #--------------------------------------------------------------------------
  # ● ダメージの表示
  #--------------------------------------------------------------------------
  alias ed_damage_popup_display_damage display_damage
  def display_damage(target, item)
    ed_damage_popup_display_damage(target, item) 
    damage_pop(target)
  end
  #--------------------------------------------------------------------------
  # ● ステート付加の表示
  #--------------------------------------------------------------------------
  alias ed_damage_popup_display_added_states display_added_states
  def display_added_states(target)
    target.damage = [target.result.added_state_objects, false]
    target.result.added_state_objects.each do |state|
      state_msg = target.actor? ? state.message1 : state.message2
      target.perform_collapse_effect if state.id == target.death_state_id
      next if state_msg.empty?
      unless FF_MASSAGE_SYSTEM
        replace_text(target.name + state_msg)
        wait
      end
      wait_for_effect
    end
  end
  #--------------------------------------------------------------------------
  # ● ステート解除の表示
  #--------------------------------------------------------------------------
  alias ed_damage_popup_display_removed_states display_removed_states
  def display_removed_states(target)
    target.damage = [target.result.removed_state_objects, true]
    ed_damage_popup_display_removed_states(target) unless FF_MASSAGE_SYSTEM
  end
  #--------------------------------------------------------------------------
  # ● 能力強化／弱体の表示（個別）
  #--------------------------------------------------------------------------
  alias ed_damage_popup_display_buffs display_buffs
  def display_buffs(target, buffs, fmt)
    flag = (target.result.removed_buffs == buffs) # 解除バフなら回復フラグ
    target.damage = [buffs, flag]
    ed_damage_popup_display_buffs(target, buffs, fmt) unless FF_MASSAGE_SYSTEM
  end
end

#==============================================================================
# ■ Sprite_Battler
#------------------------------------------------------------------------------
# 　バトラー表示用のスプライトです。Game_Battler クラスのインスタンスを監視し、
# スプライトの状態を自動的に変化させます。
#==============================================================================

class Sprite_Battler < Sprite_Base
  include Popup_Font
  
  DAMAGE    = :damage_popup                      # ダメージポップアップ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     viewport : ビューポート
  #     battler  : バトラー (Game_Battler)
  #--------------------------------------------------------------------------
  alias ed_damage_popup_initialize initialize
  def initialize(viewport, battler = nil)
    ed_damage_popup_initialize(viewport, battler)
    @add_effect_type = 0
    @_damage_sprites = []
    @old_d = []
    @popup_subject = []
  end
  #--------------------------------------------------------------------------
  # ● ダメージポップアップ表示中判定
  #--------------------------------------------------------------------------
  def popup?
    return (@_damage_sprites.empty? ? false : true )
  end
  #--------------------------------------------------------------------------
  # ● 新しいエフェクトの設定
  #--------------------------------------------------------------------------
  def setup_new_effect
    if !@battler_visible && @battler.alive?
      start_effect(:appear)
    elsif @battler_visible && @battler.hidden?
      start_effect(:disappear)
    end
    if @battler_visible && @battler.sprite_effect_type
      start_effect(@battler.sprite_effect_type)
      @battler.sprite_effect_type = nil
    end
    
  end
  #--------------------------------------------------------------------------
  # ● 新しいエフェクトの設定
  #--------------------------------------------------------------------------
  alias ed_damage_popup_setup_new_effect setup_new_effect
  def setup_new_effect
    
    # ダメージポップアップが有効＆バトラーのスプライト表示＆
    # ポップアップが表示されていないか。
    if @battler.damage_popup && @use_sprite
      @add_effect_type = DAMAGE
      @battler.damage.each{|str_array|
      next if str_array == nil
      next if @battler.popup_subject.include?(str_array)
      @battler.popup_subject << str_array
      damage(str_array, @battler.result.critical) }
      #@battler.damage_popup = false# if @battler.damage.empty?
    end
    ed_damage_popup_setup_new_effect
  end
  #--------------------------------------------------------------------------
  # ● エフェクトの更新
  #--------------------------------------------------------------------------
  alias ed_damage_popup_update_effect update_effect
  def update_effect
    case @add_effect_type
    when DAMAGE
      update_damage_pop
    end
    ed_damage_popup_update_effect
  end
  #--------------------------------------------------------------------------
  # ● ダメージポップエフェクトの更新
  #--------------------------------------------------------------------------
  def update_damage_pop
    return unless @use_sprite
    return if @_damage_sprites == nil or @_damage_sprites.empty?
    return dispose_damage if (@battler.hidden?) and not popup?
    # ダメージ
    a = POPUP_DURATION # 設定表示時間
    @_damage_sprites.each_index {|index|
    sprite_array = @_damage_sprites[index]
    sprite = sprite_array[0]
    d = sprite_array[1]
    next if sprite == nil or sprite.disposed?
    if @old_d[index-1] != nil and @old_d[index-1] > (POPUP_DURATION / 2) and 
      index > 0
      sprite.visible = false
      next
    else
      sprite.visible = true
    end
    
    if d > 0
      d -= 1
      case d
      when a - 2..a - 1
        sprite.y -= 4
      when a - 4..a - 3
        sprite.y -= 2
      when a - 6..a - 5
        sprite.y += 2
      when a - 12..a - 7
        sprite.y += 4
      end
      sprite.opacity = 256 - (12 - d) * 32
      if d <= 0
        unless sprite == nil
          sprite.dispose
          sprite = nil
          sprite_array[0] = sprite
          @_damage_sprites.shift
        end
      end
    end
    sprite_array[1] = d
    @old_d[index] = d
    }
    dispose_damage if @_damage_sprites.empty?
  end
  #--------------------------------------------------------------------------
  # ● ポップアップダメージ
  #     value : ダメージ値及び状態異常
  #     critical  : クリティカルかどうか
  #--------------------------------------------------------------------------
  def damage(value, critical=false)
    @_damage_sprites ||= []
    @old_d ||= []
    # value を String に変換
    if value[0].is_a?(Numeric)
      damage_string = value[0].abs.to_s
    else
      damage_string = value[0].to_s
    end
    # ポップアップ文字が何も無い場合は戻る
    return if damage_string == ""
    
    # ベースとなるポップアップ文字の画像サイズ作成・設定
    bitmap = Bitmap.new(160, 48)
    
    # フォントと文字サイズ設定
    bitmap.font.name = Popup_Font::POPUP_FONT
    bitmap.font.size = Popup_Font::POPUP_FONT_SIZE
    bitmap.font.outline = true
    bitmap.font.shadow = true
    bitmap.font.color.set(0, 0, 0)
    
    # 色設定
    if value[1]
      # 回復の場合
      bitmap.font.color = recovery_color
    else
      # ダメージの場合(通常は文字色が白)
      if critical
        # クリティカル時は文字色が赤になる。
        bitmap.font.color = knockout_color
      else
        bitmap.font.color = normal_color
      end
    end
      # 以下、場合により文字色変化。
      unless value[2] == nil
        bitmap.font.color = system_color
      end
    # 文字画像描画
    bitmap.draw_text(0, 12, 160, 36, damage_string, 1)
    
    # スプライト作成
    sprite = ::Sprite.new(self.viewport)
    sprite.bitmap = bitmap
    sprite.ox = bitmap.width / 2
    sprite.oy = bitmap.height / 2
    sprite.x = self.x
    sprite.y = self.y - self.oy / 2
    sprite.z = 3000
    # ポップアップスプライト配列に追加、アニメ時間も
    @_damage_sprites << [sprite, POPUP_DURATION]
    @old_d << POPUP_DURATION
  end

  #--------------------------------------------------------------------------
  # ● ポップアップスプライト解放
  #--------------------------------------------------------------------------
  def dispose_damage
    return if @_damage_sprites == nil
    @_damage_sprites.each{|sprite_array|
    break if sprite_array == nil
    sprite = sprite_array[0]
      #d = sprite_array[1]
      unless sprite == nil
        sprite.bitmap.dispose
        sprite.dispose
        sprite = nil
        #@battler.damage = 0
      end
     }
    @_damage_sprites = []
    @old_d = []
    @battler.damage = 0
    @battler.damage_popup = false
    @battler.popup_subject = []
    @add_effect_type = 0
  end
end
#==============================================================================
# ■ Spriteset_Battle
#------------------------------------------------------------------------------
# 　バトル画面のスプライトをまとめたクラスです。このクラスは Scene_Battle クラ
# スの内部で使用されます。
#==============================================================================

class Spriteset_Battle
  
  #--------------------------------------------------------------------------
  # ● ダメージポップアップ表示中判定
  #--------------------------------------------------------------------------
  def popup?
    for sprite in @enemy_sprites + @actor_sprites
      return true if sprite.popup?
    end
    return false
  end
  
end

