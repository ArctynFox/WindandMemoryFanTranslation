#==============================================================================
# ■ VXAce-RGSS3-38 精霊システム <入替画面>             by Claimh
#==============================================================================

#==============================================================================
# ■ Window_MenuCommand
#==============================================================================
class Window_MenuCommand < Window_Command
  #--------------------------------------------------------------------------
  # ● 独自コマンドの追加用
  #--------------------------------------------------------------------------
  alias add_original_commands_partner add_original_commands
  def add_original_commands
    add_original_commands_partner
    add_command("Covenants", :partner, partner_enable?) # if $game_switches[1]
  end
  #--------------------------------------------------------------------------
  # ● コマンド追加？［パートナー設定］
  #--------------------------------------------------------------------------
  def add_spirits?
    $game_party.members.size > 0 and $game_party.spirit_num > 0 #and $game_switches[1]
  end
  #--------------------------------------------------------------------------
  # ● コマンド可能？［パートナー設定］
  #--------------------------------------------------------------------------
  def partner_enable?
    $game_party.spirit_num > 0 # and $game_switches[1]
  end
end

#==============================================================================
# ■ Scene_Menu
#==============================================================================
class Scene_Menu < Scene_MenuBase
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウの作成
  #--------------------------------------------------------------------------
  alias create_command_window_partner create_command_window
  def create_command_window
    create_command_window_partner
    @command_window.set_handler(:partner, method(:command_personal))
  end
  #--------------------------------------------------------------------------
  # ● コマンド［パートナー設定］
  #--------------------------------------------------------------------------
  def command_partner
    SceneManager.call(Scene_EditPartner)
  end
  #--------------------------------------------------------------------------
  # ● 個人コマンド［決定］
  #--------------------------------------------------------------------------
  alias on_personal_ok_partner on_personal_ok
  def on_personal_ok
    if @command_window.current_symbol == :partner
      command_partner
    else
      on_personal_ok_partner
    end
  end
end



#==============================================================================
# ■ Window_SptActor
#==============================================================================
class Window_SptActor < Window_Base
  attr_accessor :index   # 入れ替え対象index
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(actor)
    @actor  = actor
    @spirit = nil
    @index  = 0
    @diff_on = false
    super(0, 0, Graphics.width, fitting_height(9))
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 描画エリア
  #--------------------------------------------------------------------------
  def redraw_area
    Rect.new(100, line_height, 150, contents.height - line_height)
  end
  #--------------------------------------------------------------------------
  # ● 差分描画on/off
  #--------------------------------------------------------------------------
  def diff_on
    @diff_on = true
    part_refresh
  end
  def diff_off
    @diff_on = false
    @spirit = nil
    part_refresh
  end
  #--------------------------------------------------------------------------
  # ● アクター設定
  #--------------------------------------------------------------------------
  def actor=(a)
    return if @actor == a
    @actor = a
    @spirit = nil
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 精霊設定
  #--------------------------------------------------------------------------
  def spirit=(s)
    return if @spirit == s
    @spirit = s
    part_refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return if @actor.nil?
    draw_actor_name(@actor, 0, 0)
    draw_actor_face(@actor, 140, 0)
    draw_status_vocab
    part_refresh(false)
    change_color(system_color)
    draw_text(contents_width - 200, 0, 200, line_height, "Covenant")
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def part_refresh(clear=true)
    contents.fill_rect(redraw_area, Color.new(0,0,0,0)) if clear
    return if @actor.nil?
    draw_actor_status
  end
  #--------------------------------------------------------------------------
  # ● 顔グラフィックの描画
  #     enabled : 有効フラグ。false のとき半透明で描画
  #--------------------------------------------------------------------------
  def draw_face(face_name, face_index, x, y, enabled = true)
    bitmap = Cache.face(face_name)
    h = line_height
    hh = (96 - h) / 2
    rect = Rect.new(face_index % 4 * 96, face_index / 4 * 96 + hh, 96, h)
    contents.blt(x, y, bitmap, rect, enabled ? 255 : translucent_alpha)
    bitmap.dispose
  end
  #--------------------------------------------------------------------------
  # ● ステータス描画
  #--------------------------------------------------------------------------
  def draw_status_vocab
    8.times do |i|
      draw_param_vocab(10, i * line_height + line_height, i)
    end
  end
  #--------------------------------------------------------------------------
  # ● パラメータVcab描画
  #--------------------------------------------------------------------------
  def draw_param_vocab(x, y, param_id)
    change_color(system_color)
    draw_text(x, y, 120, line_height, Vocab::param(param_id))
  end
  #--------------------------------------------------------------------------
  # ● ステータス描画
  #--------------------------------------------------------------------------
  def draw_actor_status
    8.times do |i|
      draw_actor_param(@actor, @spirit, 10, i * line_height + line_height, i, 300)
    end
  end
  #--------------------------------------------------------------------------
  # ● パラメータ描画
  #--------------------------------------------------------------------------
  def draw_actor_param(actor, spirit, x, y, param_id, width)
    now = actor.param(param_id)
    change_color(normal_color)
    draw_text(x+90, y, 60, line_height, now, 2)
    return if !@diff_on or (spirit.nil? and @actor.partners[@index].nil?)
    # 差分描画
    draw_actor_new_param(actor, spirit, x, y, param_id, width)
  end
  #--------------------------------------------------------------------------
  # ● パラメータ描画
  #--------------------------------------------------------------------------
  def draw_actor_new_param(actor, spirit, x, y, param_id, width)
    now = actor.param(param_id)
    spirit_id = spirit.nil? ? 0 : spirit.spirit_id
    new = @actor.v_chg_param(spirit_id, @index, param_id)
    change_color(system_color)
    draw_text(x+150, y, 32, line_height, "→")
    change_color(param_change_color(new - now))
    draw_text(x+170, y, 60, line_height, new, 2)
  end
end


#==============================================================================
# ■ Window_SptListBase
#==============================================================================
class Window_SptListBase < Window_Selectable
  attr_accessor :info_window         # help_window2
  #--------------------------------------------------------------------------
  # ● ウィンドウのアクティブ化
  #--------------------------------------------------------------------------
  def activate
    select(0) if @index < 0
    super
  end
  #--------------------------------------------------------------------------
  # ● アイテムの取得
  #--------------------------------------------------------------------------
  def item
    i_item(index)
  end
  #--------------------------------------------------------------------------
  # ● アイテムの取得
  #--------------------------------------------------------------------------
  def i_item(index)
    @data && index >= 0 ? @data[index] : nil
  end
  #--------------------------------------------------------------------------
  # ● 選択項目の有効状態を取得
  #--------------------------------------------------------------------------
  def current_item_enabled?
    enable?(item)
  end
  #--------------------------------------------------------------------------
  # ● 許可状態で表示するかどうか
  #--------------------------------------------------------------------------
  def enable?(item)
    item.nil?
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = i_item(index)
    rect = item_rect(index)
    if item
      enabled = enable?(item)
      rect.x += draw_actor_line_graphic(item, rect.x, rect.y, enabled)
      draw_spirit_name(item, rect.x, rect.y, enabled)
    else
      draw_empty_text(rect)
    end
  end
  #--------------------------------------------------------------------------
  # ● 空項目の描画
  #--------------------------------------------------------------------------
  def draw_empty_text(rect)
  end
  #--------------------------------------------------------------------------
  # ● アクター設定
  #--------------------------------------------------------------------------
  def actor=(a)
    return if @actor == a
    @actor = a
    data_refresh
  end
  #--------------------------------------------------------------------------
  # ● カーソルを右に移動
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    @help_window.next_page
  end
  #--------------------------------------------------------------------------
  # ● カーソルを左に移動
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    @help_window.prev_page
  end
end

#==============================================================================
# ■ Window_SptPartner
#==============================================================================
class Window_SptPartner < Window_SptListBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(x, height, actor)
    @actor = actor
    @data  = actor.partners
    y = line_height
    super(x, y, Graphics.width - x, height - y)
    self.z += 10
    self.opacity = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def data_refresh
    @data  = @actor.partners
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 項目数の取得
  #--------------------------------------------------------------------------
  def item_max
    @actor.max_spirits
  end
  #--------------------------------------------------------------------------
  # ● 許可状態で表示するかどうか
  #--------------------------------------------------------------------------
  def enable?(item)
    return false if item_max == 0
    super(item) or !item.partner_locked
  end
  #--------------------------------------------------------------------------
  # ● 空項目の描画
  #--------------------------------------------------------------------------
  def draw_empty_text(rect)
    draw_text(rect.x, rect.y, contents_width-8, line_height, "-- none --", 1)
  end
  #--------------------------------------------------------------------------
  # ● ヘルプテキスト更新
  #--------------------------------------------------------------------------
  def update_help
    @help_window.spirit = item
    @info_window.index = @index unless @info_window.nil?
  end
end

#==============================================================================
# ■ Window_SptSpiritList
#==============================================================================
class Window_SptSpiritList < Window_SptListBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(x, y, actor)
    @actor = actor
    @data = $game_party.spirit_stay_members + [nil]
    super(x, y, Graphics.width - x, Graphics.height - y)
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def data_refresh
    @data = $game_party.spirit_stay_members + [nil]
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 項目数の取得
  #--------------------------------------------------------------------------
  def item_max
    (@data ? @data.size : 0)
  end
  #--------------------------------------------------------------------------
  # ● 許可状態で表示するかどうか
  #--------------------------------------------------------------------------
  def enable?(item)
    super(item) or @actor.can_partner(item.spirit_id)
  end
  #--------------------------------------------------------------------------
  # ● ヘルプテキスト更新
  #--------------------------------------------------------------------------
  def update_help
    @help_window.spirit = item
    @info_window.spirit = item unless @info_window.nil?
  end
end



#==============================================================================
# ■ Window_SptSpirit
#==============================================================================
class Window_SptSpirit < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(y, width)
    @spirit = nil
    @page = 0
    @data = Spirits.status
    @max = @data.size
    @skill_start = @data.index(:skills)
    super(0, y, width, Graphics.height - y)
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 1ページに表示するスキル数
  #--------------------------------------------------------------------------
  def page_skills
    ((contents.height - (line_height * 2)) / line_height) * sr
  end
  def sr
    Spirits::SKILL_NUM
  end
  #--------------------------------------------------------------------------
  # ● ページ切り替え
  #--------------------------------------------------------------------------
  def page=(n)
    @page = [0, [@max-1, n].min].max
    refresh
  end
  def next_page
    self.page = @page + 1
  end
  def prev_page
    self.page = @page - 1
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ内容の幅を計算
  #--------------------------------------------------------------------------
  def contents_width
    super + (@spirit.nil? ? 0 : 10)
  end
  #--------------------------------------------------------------------------
  # ● 精霊設定
  #--------------------------------------------------------------------------
  def spirit=(s)
    return if @spirit == s
    @spirit = s
    is_skill = @data[@page] == :skills
    data_refresh
    refresh
    self.page = @data.index(:skills) if is_skill
  end
  #--------------------------------------------------------------------------
  # ● データリフレッシュ
  #--------------------------------------------------------------------------
  def data_refresh
    @data = Spirits.status
    @skill_start = @data.index(:skills)
    unless @spirit.nil?
      n = @spirit.skills.size
      if n > page_skills
        (n / page_skills).times {|i| @data.insert(@skill_start, :skills) }
      end
    end
    @max = @data.size
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    contents_width != contents.width ? create_contents : contents.clear
    self.ox = 0
    return if @spirit.nil?
    self.ox = (@page == 0 ? 0 : (@page == (@max-1) ? 10 : 5))
    draw_spirit_name(@spirit, self.ox, 0)
    draw_actor_level(@spirit, self.ox + 170, 0) if Spirits::USE_LV
    draw_actor_face(@spirit, self.ox + contents_width - 100, 0)
    case @data[@page]
    when :text    # description
      draw_actor_nickname(@spirit, self.ox + 100, line_height)
      draw_text_ex(self.ox, line_height * 2, @spirit.description)
    when :status  # status
      draw_actor_status
    when :skills  # skill
      i = @page - @skill_start
      n = page_skills
      draw_actor_skills(@spirit.skills[i*n, n])
    else    # feature
      draw_feature_status
    end
  end
  #--------------------------------------------------------------------------
  # ● 顔グラフィックの描画
  #     enabled : 有効フラグ。false のとき半透明で描画
  #--------------------------------------------------------------------------
  def draw_face(face_name, face_index, x, y, enabled = true)
    bitmap = Cache.face(face_name)
    h = line_height * 2
    hh = (96 - h) / 2
    rect = Rect.new(face_index % 4 * 96, face_index / 4 * 96 + hh, 96, h)
    contents.blt(x, y, bitmap, rect, enabled ? 255 : translucent_alpha)
    bitmap.dispose
  end
  #--------------------------------------------------------------------------
  # ● 能力値の描画
  #--------------------------------------------------------------------------
  def draw_actor_status
    change_color(system_color)
    draw_text(self.ox, line_height, 100, line_height, "能力")
    change_color(normal_color)
    8.times do |i|
      x = self.ox + i % 2 * contents_width / 2
      y = i / 2 * line_height + line_height * 2
      draw_spirit_param(@spirit, x, y, i)
    end
  end
  #--------------------------------------------------------------------------
  # ● スキルの描画
  #--------------------------------------------------------------------------
  def draw_actor_skills(skills)
    change_color(system_color)
    draw_text(self.ox, line_height, 100, line_height, "習得スキル")
    change_color(normal_color)
    skills.each_with_index do |skill, i|
      x = self.ox + i % sr * contents_width / sr
      y = i / sr * line_height + line_height * 2
      draw_item_name(skill, x, y)
    end
  end
  #--------------------------------------------------------------------------
  # ● 特徴の描画
  #--------------------------------------------------------------------------
  def draw_feature_status
    ft = Spirits::Features.new(@spirit)
    case @data[@page]
    when :rate;   draw_feature_rate(ft)
    when :param;  draw_feature_param(ft)
    when :attack; draw_feature_attack(ft)
    when :skill;  draw_feature_skill(ft)
    when :equip;  draw_feature_equip(ft)
    when :other;  draw_feature_other(ft)
    end
  end
  #--------------------------------------------------------------------------
  # ● 特徴テキストの描画
  #--------------------------------------------------------------------------
  def draw_feature_text(features, x, y, w=contents_width, col_max=2)
    features.each_with_index do |ft, i|
      ww = w / col_max
      xx = x + i % col_max * ww
      yy = y + i / col_max * line_height
      draw_text(xx, yy, ww, line_height, ft[0])
      draw_text(xx, yy, ww, line_height, ft[1], 2) unless ft[1].nil?
    end
  end
  #--------------------------------------------------------------------------
  # ● 特徴：耐性の描画
  #--------------------------------------------------------------------------
  def draw_feature_rate(ft)
    change_color(system_color)
    draw_text(self.ox, line_height, 100, line_height, "耐性")
    change_color(normal_color)
    draw_feature_text(ft.rate, self.ox, line_height * 2)
  end
  #--------------------------------------------------------------------------
  # ● 特徴：能力の描画
  #--------------------------------------------------------------------------
  def draw_feature_param(ft)
    change_color(system_color)
    draw_text(self.ox, line_height, 100, line_height, "能力特性")
    change_color(normal_color)
    draw_feature_text(ft.param, self.ox, line_height * 2)
  end
  #--------------------------------------------------------------------------
  # ● 特徴：攻撃の描画
  #--------------------------------------------------------------------------
  def draw_feature_attack(ft)
    change_color(system_color)
    draw_text(self.ox, line_height, 100, line_height, "攻撃特性")
    change_color(normal_color)
    draw_feature_text(ft.attack, self.ox, line_height * 2)
  end
  #--------------------------------------------------------------------------
  # ● 特徴：スキルの描画
  #--------------------------------------------------------------------------
  def draw_feature_skill(ft)
    change_color(system_color)
    draw_text(self.ox, line_height, 100, line_height, "スキル特性")
    change_color(normal_color)
    draw_feature_text(ft.skill, self.ox, line_height * 2)
  end
  #--------------------------------------------------------------------------
  # ● 特徴：装備の描画
  #--------------------------------------------------------------------------
  def draw_feature_equip(ft)
    change_color(system_color)
    draw_text(self.ox, line_height, 100, line_height, "装備特性")
    change_color(normal_color)
    draw_feature_text(ft.equip, self.ox, line_height * 2)
  end
  #--------------------------------------------------------------------------
  # ● 特徴：その他の描画
  #--------------------------------------------------------------------------
  def draw_feature_other(ft)
    change_color(system_color)
    draw_text(self.ox, line_height, 100, line_height, "特性")
    change_color(normal_color)
    draw_feature_text(ft.other, self.ox, line_height * 2)
  end
end



#==============================================================================
# ■ Scene_EditPartner
#==============================================================================
class Scene_EditPartner < Scene_MenuBase
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    create_actor_window
    create_partner_window
    create_sptlist_window
    create_spirit_window
    @sptlist_window.info_window = @actor_window
    @sptlist_window.help_window = @spirit_window
    @partner_window.info_window = @actor_window
    @partner_window.help_window = @spirit_window
  end
  #--------------------------------------------------------------------------
  # ● アクターウィンドウ作成
  #--------------------------------------------------------------------------
  def create_actor_window
    @actor_window = Window_SptActor.new(@actor)
  end
  #--------------------------------------------------------------------------
  # ● パートナーリストウィンドウ作成
  #--------------------------------------------------------------------------
  def create_partner_window
    @partner_window = Window_SptPartner.new(@actor_window.width-200, @actor_window.height, @actor)
    @partner_window.set_handler(:ok,       method(:partner_ok))
    @partner_window.set_handler(:cancel,   method(:return_scene))
    @partner_window.set_handler(:pagedown, method(:next_actor))
    @partner_window.set_handler(:pageup,   method(:prev_actor))
    @partner_window.activate
  end
  #--------------------------------------------------------------------------
  # ● パートナーウィンドウ : OK
  #--------------------------------------------------------------------------
  def partner_ok
    @actor_window.diff_on
    @sptlist_window.activate
  end
  #--------------------------------------------------------------------------
  # ● 精霊リストウィンドウ作成
  #--------------------------------------------------------------------------
  def create_sptlist_window
    @sptlist_window = Window_SptSpiritList.new(@partner_window.x, @actor_window.height, @actor)
    @sptlist_window.set_handler(:ok,       method(:sptlist_ok))
    @sptlist_window.set_handler(:cancel,   method(:sptlist_cancel))
  end
  #--------------------------------------------------------------------------
  # ● 精霊リストウィンドウ : OK
  #--------------------------------------------------------------------------
  def sptlist_ok
    if @sptlist_window.item.nil?
      unless @partner_window.item.nil?
        @actor.change_partner(0, @partner_window.index)
      end
    else
      @actor.change_partner(@sptlist_window.item.spirit_id, @partner_window.index)
      @sptlist_window.item.change_partner(@actor.id)
    end
    unless @partner_window.item.nil?
      @partner_window.item.change_partner(0)
    end
    @sptlist_window.data_refresh
    @partner_window.data_refresh
    @partner_window.activate
    @actor_window.diff_off
  end
  #--------------------------------------------------------------------------
  # ● 精霊リストウィンドウ : Cancel
  #--------------------------------------------------------------------------
  def sptlist_cancel
    @partner_window.activate
    @actor_window.diff_off
  end
  #--------------------------------------------------------------------------
  # ● 精霊ウィンドウ作成
  #--------------------------------------------------------------------------
  def create_spirit_window
    @spirit_window = Window_SptSpirit.new(@actor_window.height, @partner_window.x)
  end
  #--------------------------------------------------------------------------
  # ● アクターの切り替え
  #--------------------------------------------------------------------------
  def on_actor_change
    @actor_window.actor   = @actor
    @partner_window.actor = @actor
    @sptlist_window.actor = @actor
    @partner_window.select(0)
    @sptlist_window.select(0)
    @partner_window.activate
  end
end
