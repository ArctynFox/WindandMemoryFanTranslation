#==============================================================================
# ■ RGSS3 ステータス画面　カスタマイズスクリプト　by オシブ
#------------------------------------------------------------------------------
# ステータス画面を色々カスタマイズできるスクリプトです。
# 方向キー　← → で表示（ページ）の切り替えができるようになります。
# 再定義をかなり多用しています。
# スクリプトにある程度慣れている必要があるかも。
#==============================================================================

module Oxib_status
  #--------------------------------------------------------------------------
  # ◆ キャラ立ち絵を使用するかどうか
  #-------------------------------------------------------------------------
  # 使用する場合はtrue、使用しない場合はfalseにしてください。
  STANDING_PICTURE_USE = false
  #--------------------------------------------------------------------------
  # ◆ キャラ立ち絵のファイル名　※ファイルは、Pictureフォルダに入れてください。
  #--------------------------------------------------------------------------
  # 例：ファイル名を "ST_Actor_1にすると、アクター1のときに表示されます。
  STANDING_PICTURE = "ST_Actor_%d" #後ろの%dはそのままにしてください。
  #--------------------------------------------------------------------------
  # ◆ 立ち絵画像の大きさ
  #--------------------------------------------------------------------------  
  PICTURE_WIDTH = 272 #横幅
  PICTURE_HEIGHT = 288 #縦幅
  #--------------------------------------------------------------------------
  # ◆ 立ち絵の位置の設定
  #--------------------------------------------------------------------------  
  # Graphics.width は画面の横の長さ、Graphics.height は縦の長さです
  STANDING_PICTURE_X = 0 #X座標  
  STANDING_PICTURE_Y = Graphics.height - PICTURE_HEIGHT #Y座標
  
  #--------------------------------------------------------------------------
  # ◆ 背景に画像を使用するか
  #--------------------------------------------------------------------------  
  # 使用する場合はtrue、使用しない場合はfalseにしてください。
  WALLPAPER_USE = false
  #--------------------------------------------------------------------------
  # ◆ 背景画像のファイル名　※ファイルは、Pictureフォルダに入れてください。
  #--------------------------------------------------------------------------  
  WALLPAPER = "WallPaper"
  #--------------------------------------------------------------------------
  # ◆ 最前面に画像を使用するか
  #--------------------------------------------------------------------------  
  #最前面に画像を表示することができます。
  # 使用する場合はtrue、使用しない場合はfalseにしてください。
  FRONT_PICTURE_USE = false
  #--------------------------------------------------------------------------
  # ◆ 最前面の画像のファイル名　※ファイルは、Pictureフォルダに入れてください。
  #--------------------------------------------------------------------------  
  FRONT_PICTURE = "Frame"
  
  #--------------------------------------------------------------------------
  # ◆ ステータスウインドウのウインドウ枠
  #--------------------------------------------------------------------------  
  # 表示する場合はtrue、表示させない場合はfalseにしてください。
  STATUS_WINDOW_USE = true  
  #--------------------------------------------------------------------------
  # ◆ ステータス画面の大きさ
  #--------------------------------------------------------------------------  
  # Graphics.width は画面の横の長さ、Graphics.height は縦の長さです
  STATUS_WIDTH = Graphics.width - PICTURE_WIDTH #横幅
  STATUS_HEIGHT = Graphics.height #縦幅
  #--------------------------------------------------------------------------
  # ◆ ステータス画面の位置の設定
  #--------------------------------------------------------------------------  
  STATUS_X = STANDING_PICTURE_X + PICTURE_WIDTH #X座標  
  STATUS_Y = 0 #Y座標

  #--------------------------------------------------------------------------
  # ◆ ページ数の設定
  #--------------------------------------------------------------------------  
  # 方向キーの← → でページ切り替えできます。
  NUMBER_PAGES = 3
  #--------------------------------------------------------------------------
  # ◆ ページ送りの音を使用するか
  #--------------------------------------------------------------------------  
  #効果音を使用するならtrue、使用しないならfalse
  SE_UZE = true      
  #--------------------------------------------------------------------------
  # ◆ ページ送りの音の設定
  #--------------------------------------------------------------------------  
  #　効果音のファイル名、音量、ピッチの高さの設定
  PAGE_SE = RPG::SE.new("Cursor1", 80, 100)
  #--------------------------------------------------------------------------
  # ● 一行の高さ（変更する必要はありません）
  #--------------------------------------------------------------------------  
  def self.line_height
    return 24
  end
  #--------------------------------------------------------------------------
  # ◆ ステータス画面に載せる情報を設定
  #--------------------------------------------------------------------------  
  # 載せるページ毎に載せるかどうかの設定。
  # 載せるなら true、載せないなら false
  # 例 : ACTOR_NAME = [1ページ目に表示するか, 2ページ目に表示するか,
  #                    3ページ目に表示するか, ……]
  #      NAME_POS = [x座標, y座標]
  
  # line_heightは、一行の高さの数値が入っています。必要ならご利用ください。
  # そのまま数字を入れても動きます。

  #名前
  ACTOR_NAME  = [true, true, true, true]
    NAME_POS  = [4, line_height * 0]
  #顔グラ
  ACTOR_FACE  = [true, false, false, true]
    FACE_POS  = [4, line_height * 1 + 12]
  #歩行グラ
  ACTOR_GRAPHIC  = [false, false, false, true]
    GRAPHIC_POS  = [104, line_height * 4]
  #レベル
  ACTOR_LEVEL = [true, true, true, true]
    LEVEL_POS = [124, line_height * 0]
  #職業
  ACTOR_CLASS = [true, false, false, false]
    CLASS_POS = [124, line_height * 1 + 12]
  #かかってるステート
  ACTOR_SATES = [false, false, false, false]
    SATES_POS = [124, line_height * 0]
  #HP MP（TP）
  ACTOR_HP_MP = [true, false, false, false]
    HP_MP_POS = [124, line_height * 2 + 12]
  #経験値、次の経験値
  ACTOR_EXP   = [true, false, false, false]
    EXP_POS   = [4, line_height * 6]
  #基本ステータス
  ACTOR_PARAMS = [true, false, false, false]
    PARAMS_POS = [4, line_height * 9]
  #追加能力値、特殊能力値
  ACTOR_EXPARAMS = [true, false, false, false]
    EXPARAMS_POS = [124, line_height * 9]
  #装備
  ACTOR_EQUIP = [false, false, false, false]
    EQUIP_POS = [4, line_height * 1 + 8]
  #スキル
  ACTOR_SKILLS = [false, false, true, false]
    SKILLS_POS = [4, line_height * 1 + 12]
  #属性耐性
  ACTOR_ELEMENTS_RATE = [false, true, false]
    ELEMENTS_RATE_POS = [4, line_height * 8]
  #ステート耐性
  ACTOR_SATES_RATE = [false, true, false]
    SATES_RATE_POS = [4, line_height * 12]
  #二つ名
  ACTOR_NICKNANE = [false, false, false, true]
    NICKNANE_POS = [140, line_height * 4 + 12]
  #キャラ説明
  ACTOR_DESCRIPTION = [false, false, false, false]
    DESCRIPTION_POS = [4, line_height * 6]
  
  #--------------------------------------------------------------------------
  # ◆ 表示する追加能力値と特殊能力値の設定
  #--------------------------------------------------------------------------  
  # 表示する追加能力値に該当する番号を入れてください。
  # 該当する番号一覧
  # 0; 命中率, 1; 回避率, 2; 会心率, 3; 会心回避率
  # 4; 魔法回避率, 5; 魔法反射率, 6; 反撃率, 7; ＨＰ再生率
  # 8; ＭＰ再生率, 9; ＴＰ再生率
  EX_PARAM = [0, 1, 2, 4, 6, 7, 8]
  
  # 表示する特殊能力値に該当する番号を入れてください。
  # 該当する番号一覧
  # 0; 狙われやすさ, 1; 防御効果, 2; 回復効果, 3; 薬の知識
  # 4; ＭＰ消費, 5; ＴＰチャージ, 6; 物理ダメージ, 7; 魔法ダメージ
  # 8; 地形ダメージ, 9; 取得経験値
  SP_PARAM = [1,4]
  
  #--------------------------------------------------------------------------
  # ◆ 属性耐性とステート耐性の設定
  #--------------------------------------------------------------------------  
  # 表示する属性のIDと対応するアイコンのIDの配列
  # 属性ID=>アイコンID
  ELEMENTS_WORD = "Resistances:"
  ELEMENTS = {1=>131, 3=>96,4=>97, 5=>98, 9=>102, 10=>103}
  # ステート耐性の表示対象となるステートID
  STATES_WORD = "Ailment avoidance:"
  STATES = [2, 6, 13, 26, 28, 29,55,56]
  
  #--------------------------------------------------------------------------
  # ● 罫線の設定
  #--------------------------------------------------------------------------  
  # 設定の仕方 ：        1本目                   2本目
  # ページ数 => [ [x座標, y座標, 長さ], [x座標, y座標, 長さ] ]
  # [x座標, y座標, 長さ]を書き足していくことで何本でも引くことができます。
  # ※ 文末にある ], は消さないでください。
  
  LINE = {1 => [[0, line_height * 0 + 12, 240],
                [0, line_height * 8, 240]],
          2 => [[0, line_height * 0 + 12, 240],
                [0, line_height * 7, 240]],
          3 => [[0, line_height * 0 + 12, 240]], 
          4 => [[0, line_height * 0 + 12, 240],],
          5 => [], #一本も引かない場合はこのように記述してください。
          
  } #これは消さないでください。

  #-------------------------------------------------------------------------
  # ● 罫線の色を設定
  #--------------------------------------------------------------------------
  # 色をRGBで指定します。4番目の数値は透明度(0～255)です。
  LINE_COLOR = Color.new(255, 255, 255, 48) 
    
end #消さないでください
#==============================================================================
# ■ Vocab
#==============================================================================
module Vocab
  #追加能力値の用語設定
  def self.ex_param(param_id)
    case param_id
    when 0; "Accuracy"
    when 1; "Evasion"
    when 2; "Crit"
    when 3; "Crit Evasion"
    when 4; "MAG Eva"
    when 5; "MAG Reflect"
    when 6; "Counter"
    when 7; "HP Regen"
    when 8; "MP Regen"
    when 9; "TP Regen"
    end
  end

  #特殊能力値の用語設定
  def self.sp_param(param_id)
    case param_id
    when 0; "狙われやすさ"
    when 1; "Guard"
    when 2; "回復効果"
    when 3; "薬の知識"
    when 4; "MP Cost"
    when 5; "ＴＰチャージ"
    when 6; "物理ダメージ"
    when 7; "魔法ダメージ"
    when 8; "地形ダメージ"
    when 9; "取得経験値"
    end
  end
end

#==============================================================================
# ☆　設定ここまで　☆
#==============================================================================



#==============================================================================
# ■ Game_Actor
#------------------------------------------------------------------------------
# 　アクターを扱うクラスです。このクラスは Game_Actors クラス（$game_actors）
# の内部で使用され、Game_Party クラス（$game_party）からも参照されます。
#==============================================================================
class Game_Actor
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :standing_picture            # 立ち絵 ファイル名
  #--------------------------------------------------------------------------
  # ● 立ち絵のファイル名を取得
  #--------------------------------------------------------------------------
  def standing_picture
    return @standing_picture if @standing_picture
    return sprintf(Oxib_status::STANDING_PICTURE, self.id)
  end
end

#==============================================================================
# ■ Window_Base
#------------------------------------------------------------------------------
# 　ゲーム中の全てのウィンドウのスーパークラスです。
#==============================================================================
class Window_Base < Window
  #--------------------------------------------------------------------------
  # ● ウインドウを透明にする
  #--------------------------------------------------------------------------
  def opacity_zero(window_use = true)
    return if window_use
    self.opacity = 0
    self.back_opacity = 0
  end
end
#==============================================================================
# ■ Window_ActorFace 
#------------------------------------------------------------------------------
# 　アクターの立ち絵を表示するウインドウです。
#==============================================================================
class Window_ActorFace < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(x, y, actor)
    super(x, y, window_width, window_height)
    @actor = actor
    opacity_zero(false)
    refresh
  end
  #--------------------------------------------------------------------------
  # ● パディングの変更
  #--------------------------------------------------------------------------
  def standard_padding
    0
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    return Oxib_status::PICTURE_WIDTH
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_height
    return Oxib_status::PICTURE_HEIGHT
  end
  #--------------------------------------------------------------------------
  # ● アクターの設定
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_actor_standing_picture(0, 0)
  end
  #--------------------------------------------------------------------------
  # ● 立ち絵の描画
  #--------------------------------------------------------------------------
  def draw_actor_standing_picture(x, y)
    bitmap = Cache.picture(@actor.standing_picture)
    self.contents.blt(x, y, bitmap, bitmap.rect)
  end
end
#==============================================================================
# ■ Window_Status
#------------------------------------------------------------------------------
# 　ステータス画面で表示する、フル仕様のステータスウィンドウです。
#==============================================================================

class Window_Status < Window_Selectable
  include Oxib_status
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(STATUS_X, STATUS_Y, STATUS_WIDTH, STATUS_HEIGHT)
    @actor = actor
    @page = 0
    opacity_zero(STATUS_WINDOW_USE)
    refresh
    activate
  end
  #--------------------------------------------------------------------------
  # ● ウインドウの描画範囲の幅を取得
  #--------------------------------------------------------------------------
  def window_width
    self.width - (8 + standard_padding * 2)
  end
  #--------------------------------------------------------------------------
  # ● ウインドウの描画範囲の高さを取得
  #--------------------------------------------------------------------------
  def window_height
    self.height - (8 + standard_padding * 2)
  end
  #--------------------------------------------------------------------------
  # ● 決定やキャンセルなどのハンドリング処理
  #--------------------------------------------------------------------------
  alias before_process_handling process_handling
  def process_handling
    before_process_handling
    return turn_page_up if Input.trigger?(:LEFT)
    return turn_page_down if Input.trigger?(:RIGHT)
  end
  #--------------------------------------------------------------------------
  # ● ページ送り
  #--------------------------------------------------------------------------
  def turn_page_up
    PAGE_SE.play if SE_UZE
    @page = (@page + 1) % NUMBER_PAGES
    refresh
  end
  #--------------------------------------------------------------------------
  # ● ページ戻り
  #--------------------------------------------------------------------------
  def turn_page_down
    PAGE_SE.play if SE_UZE
    @page = (@page - 1) % NUMBER_PAGES
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_item(@actor, @page)
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #--------------------------------------------------------------------------  
  def draw_item(actor, page)
    width = window_width
    
    draw_lines(page)
    draw_actor_name(actor, NAME_POS[0], NAME_POS[1], width) if ACTOR_NAME[page]
    draw_actor_face(actor, FACE_POS[0], FACE_POS[1]) if ACTOR_FACE[page]

    draw_actor_graphic(actor, GRAPHIC_POS[0] + 20, GRAPHIC_POS[1] + 32) if ACTOR_GRAPHIC[page]

    draw_actor_level(actor, LEVEL_POS[0], LEVEL_POS[1]) if ACTOR_LEVEL[page]
    draw_actor_class(actor, CLASS_POS[0], CLASS_POS[1], width) if ACTOR_CLASS[page]
    draw_actor_icons(actor, SATES_POS[0], SATES_POS[1]) if ACTOR_SATES[page]
    draw_actor_hpmptp(actor, HP_MP_POS[0], HP_MP_POS[1]) if ACTOR_HP_MP[page]
    draw_exp_info(EXP_POS[0], EXP_POS[1]) if ACTOR_EXP[page]

    draw_parameters(PARAMS_POS[0], PARAMS_POS[1]) if ACTOR_PARAMS[page]
    draw_ex_parameters(EXPARAMS_POS[0], EXPARAMS_POS[1]) if ACTOR_EXPARAMS[page]

    draw_equipments(EQUIP_POS[0], EQUIP_POS[1]) if ACTOR_EQUIP[page]
    draw_skills(SKILLS_POS[0], SKILLS_POS[1]) if ACTOR_SKILLS[page]
    draw_element_resist(actor, ELEMENTS_RATE_POS[0], ELEMENTS_RATE_POS[1]) if ACTOR_ELEMENTS_RATE[page]
    draw_state_resist(actor, SATES_RATE_POS[0], SATES_RATE_POS[1]) if ACTOR_SATES_RATE[page]
    draw_actor_nickname(actor, NICKNANE_POS[0], NICKNANE_POS[1], width) if ACTOR_NICKNANE[page]
    draw_description(DESCRIPTION_POS[0], DESCRIPTION_POS[1]) if ACTOR_DESCRIPTION[page]
    
  end
  #--------------------------------------------------------------------------
  # ● 追加・特殊能力値の描画
  #--------------------------------------------------------------------------
  def draw_ex_parameters(x, y)
    draw_actor_ex_param(@actor, x, y)
    draw_actor_sp_param(@actor, x, y + line_height * (EX_PARAM.size))
  end
  #--------------------------------------------------------------------------
  # ● 能力値の描画の幅
  #--------------------------------------------------------------------------
  def text_width
    return 72
  end
  #--------------------------------------------------------------------------
  # ● 能力値の描画
  #--------------------------------------------------------------------------
  def draw_actor_param(actor, x, y, param_id)
    change_color(system_color)
    draw_text(x, y, text_width, line_height, Vocab::param(param_id))
    change_color(normal_color)
    draw_text(x + text_width, y, 36, line_height, actor.param(param_id), 2)
  end
  #--------------------------------------------------------------------------
  # ○ 追加能力値の描画
  #--------------------------------------------------------------------------
  def draw_actor_ex_param(actor, x, y)
    i = 0
    for param_id in EX_PARAM
      change_color(system_color)
      draw_text(x, y + line_height * i, text_width, line_height, Vocab::ex_param(param_id))
      change_color(normal_color)
      draw_text(x + text_width, y + line_height * i, 48, line_height,
      sprintf("%d%%", (actor.xparam(param_id) * 100).truncate), 2)
      i += 1
    end
  end
  #--------------------------------------------------------------------------
  # ○ 特殊能力値の描画
  #--------------------------------------------------------------------------
  def draw_actor_sp_param(actor, x, y)
    i = 0
    for param_id in SP_PARAM
      change_color(system_color)
      draw_text(x, y + line_height * i, text_width, line_height, Vocab::sp_param(param_id))
      change_color(normal_color)
      draw_text(x + text_width, y + line_height * i, 48, line_height,
      sprintf("%d%%", (actor.sparam(param_id) * 100).truncate), 2)
      i += 1
    end
  end
  #--------------------------------------------------------------------------
  # ● HP,MP,TPの描画
  #--------------------------------------------------------------------------
  def draw_actor_hpmptp(actor, x, y)
    draw_actor_hp(actor, x, y + line_height * 0)
    draw_actor_mp(actor, x, y + line_height * 1)
    draw_actor_tp(actor, x, y + line_height * 2)if $data_system.opt_display_tp
  end
  #--------------------------------------------------------------------------
  # ● 経験値情報の描画
  #--------------------------------------------------------------------------
  def draw_exp_info(x, y)
    s1 = @actor.max_level? ? "-------" : @actor.exp
    s2 = @actor.max_level? ? "-------" : @actor.next_level_exp - @actor.exp
    s_next = sprintf(Vocab::ExpNext, Vocab::level)
    change_color(system_color)
    draw_text(x, y + line_height * 0, 128, line_height, Vocab::ExpTotal)
    draw_text(x, y + line_height * 1, 128, line_height, s_next)
    change_color(normal_color)
    draw_text(x + 128, y + line_height * 0, 115, line_height, s1, 2)
    draw_text(x + 128, y + line_height * 1, 115, line_height, s2, 2)
  end
  #--------------------------------------------------------------------------
  # ● 習得スキルの描画
  #--------------------------------------------------------------------------
  def draw_skills(x, y)
    change_color(system_color)
    draw_text(x, y, window_width, line_height, Vocab::skill)
    y += line_height
    data = @actor.skills
    item_max = data.size
    item_max.times {|i| 
    skill = data[i]
    if skill
      draw_item_name(skill, x + 4, y + line_height * i, true, window_width - 72)
      draw_skill_cost(x + window_width - 36, y + line_height * i, skill)
    end
    }
  end
  #--------------------------------------------------------------------------
  # ● スキルの使用コストを描画
  #--------------------------------------------------------------------------
  def draw_skill_cost(x, y, skill)
    if @actor.skill_tp_cost(skill) > 0
      change_color(tp_cost_color)
      draw_text(x, y, 36, line_height, @actor.skill_tp_cost(skill), 2)
    elsif @actor.skill_mp_cost(skill) > 0
      change_color(mp_cost_color)
      draw_text(x, y, 36, line_height, @actor.skill_mp_cost(skill), 2)
    end
  end
  #--------------------------------------------------------------------------
  # ● 装備品の描画
  #--------------------------------------------------------------------------
  def draw_equipments(x, y)
    change_color(system_color)
    draw_text(x, y, 168, line_height, Vocab::equip)
    y += line_height
    @actor.equips.each_with_index do |item, i|
      draw_item_name(item, x, y + line_height * i)
    end
  end
  #--------------------------------------------------------------------------
  # ● 折り返すかどうか
  #--------------------------------------------------------------------------
  def turn_back?(x, width)
    return window_width < x + width ? true : false
  end
  #--------------------------------------------------------------------------
  # ○ 属性耐性の描画
  #--------------------------------------------------------------------------
  def draw_element_resist(actor, x, y)
    change_color(system_color)
    draw_text(x, y, 168, line_height, ELEMENTS_WORD)
    y += line_height
    change_color(normal_color)
    icon_x = x
    for element_id in ELEMENTS.keys
      y += line_height if turn_back?(icon_x, 68) && y > line_height
      icon_x = x if turn_back?(icon_x, 68)
      icon_index = ELEMENTS[element_id]
      draw_icon(icon_index, icon_x, y)
      draw_text(icon_x + 18, y, 48, line_height,
      sprintf("%d%%", (actor.element_rate(element_id) * 100).truncate), 2)
      icon_x += 68
    end
  end
  #--------------------------------------------------------------------------
  # ○ ステート耐性の描画
  #--------------------------------------------------------------------------
  def draw_state_resist(actor, x, y)
    change_color(system_color)
    draw_text(x, y, 168, line_height, STATES_WORD)
    y += line_height
    change_color(normal_color)
    icon_x = x
    for state_id in STATES
      y += line_height if turn_back?(icon_x, 68) && y > line_height
      icon_x = x if turn_back?(icon_x, 68)
      icon_index = $data_states[state_id].icon_index
      draw_icon(icon_index, icon_x, y)
      draw_text(icon_x + 18, y, 48, line_height,
        sprintf("%d%%", (actor.state_rate(state_id) * 100).truncate), 2)
      icon_x += 68
    end
  end
  #--------------------------------------------------------------------------
  # ● 水平線の描画
  #--------------------------------------------------------------------------
  def draw_lines(page)
    page += 1    
    for line_number in LINE[page]
      draw_horz_line(line_number[0], line_number[1], line_number[2])
    end
  end  
  #--------------------------------------------------------------------------
  # ● 水平線の描画
  #--------------------------------------------------------------------------
  def draw_horz_line(x, y, width)
    line_y = y + line_height / 2 - 1
    color = LINE_COLOR
    contents.fill_rect(0, line_y, width, 2, color)
  end
  #--------------------------------------------------------------------------
  # ● 説明の描画
  #--------------------------------------------------------------------------
  def draw_description(x, y)
    word_count = (window_width / 20).to_i
    description = ""
    description_ex = ""
    description = @actor.description
    description.each_line{|line|
    line = line.insert(word_count + 1, "\n") if line.length > word_count
    description_ex += line}
    draw_text_ex(x, y, description_ex)
  end
end
#==============================================================================
# ■ Scene_Status
#------------------------------------------------------------------------------
# 　ステータス画面の処理を行うクラスです。
#==============================================================================

class Scene_Status < Scene_MenuBase
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  alias before_start  start
  def start
    before_start
    create_actor_face_window
  end
  #--------------------------------------------------------------------------
  # ● 立ち絵ウィンドウの作成
  #--------------------------------------------------------------------------
  def create_actor_face_window
    return if !Oxib_status::STANDING_PICTURE_USE
    x = Oxib_status::STANDING_PICTURE_X
    y = Oxib_status::STANDING_PICTURE_Y
    @actor_face_window = Window_ActorFace.new(x, y, @actor)
  end
  #--------------------------------------------------------------------------
  # ● アクターの切り替え
  #--------------------------------------------------------------------------
  alias before_on_actor_change on_actor_change
  def on_actor_change
    @actor_face_window.actor = @actor if @actor_face_window #追加
    before_on_actor_change
  end
  #--------------------------------------------------------------------------
  # ● 背景の作成
  #--------------------------------------------------------------------------
  alias before_create_background create_background
  def create_background
    before_create_background
    create_wallpaper
    create_front_picture
  end
  #--------------------------------------------------------------------------
  # ● 背景の作成
  #--------------------------------------------------------------------------
  def create_wallpaper
    return if !Oxib_status::WALLPAPER_USE
    @wallpaper_sprite = Sprite.new
    @wallpaper_sprite.bitmap = Cache.picture(Oxib_status::WALLPAPER)
  end
  #--------------------------------------------------------------------------
  # ● 前景の作成
  #--------------------------------------------------------------------------
  def create_front_picture
    return if !Oxib_status::FRONT_PICTURE_USE
    @foreground_sprite = Sprite.new
    @foreground_sprite.bitmap = Cache.picture(Oxib_status::FRONT_PICTURE)
    @foreground_sprite.z = 1000
  end
  #--------------------------------------------------------------------------
  # ● 背景の解放
  #--------------------------------------------------------------------------
  alias before_dispose_background dispose_background
  def dispose_background
    @wallpaper_sprite.dispose if @wallpaper_sprite
    @foreground_sprite.dispose if @foreground_sprite
    before_dispose_background
  end
end