#==============================================================================
# RGSS3_戦闘コマンドカスタム ver1.05
# 2013/12/23公開
# 2014/03/03 STATUS_MODEが無効になっていたのを修正
# 2014/05/04 PARTY_MODEに設定追加　 PARTY_WINDOW_POS PARTY_WIDTH PARTY_ROWを追加
#           「XP風バトル(STR11_aからSTR11_eまで全て使用したもののみ)」に対応
#           拡張「DAアクターコマンドPT編成」に対応
# 2014/05/07スクリプト「CW戦闘中パーティ編成」に対応
# 2014/05/31設定項目 PARTY_USE_MODE PARTY_ON_ACTOR_BUTTON などを追加
#           アクターコマンドからパーティコマンドを開けるように
#           「CW戦闘中パーティ編成」を導入していないとエラーになったのを修正
# 2014/06/07戦闘中のパーティ編成後にエラーになることがあったのを修正
# C Winter (http://ccwinter.blog.fc2.com/)
#==============================================================================


module BattleCommand_Custom
  #--------------------------------------------------------------------------
  # ● 設定項目
  #--------------------------------------------------------------------------
  
  # 用語
  # アクターコマンドウインドウ：　「攻撃、防御、スキル、アイテム」を選択
  # パーティコマンドウインドウ：　「戦う、逃げる」を選択
  # ステータスウインドウ：　各キャラのHPなどを表示
  
  

  # アクターコマンドウインドウの表示位置
  #   0: ステータスの右に表示（デフォルトと同じ）
  #   1: ステータスの左に表示（デフォルトのパーティコマンドの位置）
  #   2: ACTOR_WINDOW_POSで指定した位置に表示
  ACTOR_MODE = 2
  
  # ※ACTOR_MODEが2の時のみ
  #   アクターコマンドウインドウの位置指定 [x座標, y座標]
  ACTOR_WINDOW_POS = [0, 296]
  # ※ACTOR_MODEが2の時のみ
  #   ウインドウy座標の基準
  #   0:「ACTOR_WINDOW_POSのy座標」をウインドウの上端にする
  #   1:「ACTOR_WINDOW_POSのy座標」をウインドウの下端にする
  ACTOR_WINDOW_Y_MODE = 1
  
  
  
  # ※ACTOR_MODEが2の時のみ
  #   コマンドウインドウの１ページの「縦の行数」の[最小数, 最大数]
  #   行が「最小数」より少ない場合、余った行は空白
  #   行が「最大数」より多い場合、スクロールで表示
  ACTOR_ROW = [4, 8]
  
  # コマンドウインドウの[横の列数, ウインドウの横幅]
  # 「横の列数」を nil にすると、横の列数はコマンドの数と同じになる
  #   （列数とコマンドの数が同じ＝１行で全コマンドを表示）
  # ウインドウの横幅はデフォルトでは128
  ACTOR_COL = [1, 128]
  
  
  
  # アクターコマンドに表示するコマンドを指定
  #   :attack     攻撃
  #   :skill      スキル
  #   :guard      防御
  #   :item       アイテム
  #   :escape     逃走
  #   :CW_party   パーティ編成　使用にはスクリプト「CW戦闘中パーティ編成」が必須
  #   :DA_party   パーティ編成　使用には拡張「DAアクターコマンドPT編成」が必須
  #   
  # 指定した並び順でアクターコマンドに表示する　指定しなかったものは表示されない
  # アイテムを使わないゲーム、攻撃と防御を無くしてスキルのみ使うゲーム、
  # パーティコマンドを無くしてアクターコマンドで逃走するゲーム　などが作れる
  #   デフォルト          [:attack, :skill, :guard, :item]
  #   逃走を追加          [:attack, :skill, :guard, :item, :escape]
  #   パーティ編成を追加  [:attack, :skill, :guard, :item, :CW_party]
  ACTOR_COMMAND_LIST = [:attack, :skill, :guard, :item, :escape]
  
  
  
  # アクターコマンドの各項目にアイコンを表示するかどうか
  # true なら表示する　false なら表示しない
  ACTOR_ICON  = false
  
  # ※ACTOR_ICONが true の時のみ
  # 　スキルのスキルタイプごとのアイコン番号
  ACTOR_ICON_SKILL  = [116, 117, 16, 16, 16, 16, 16, 16]
  # ※ACTOR_ICONが true の時のみ
  #   [通常攻撃, 防御, アイテム, 逃走] のアイコン番号
  ACTOR_ICON_OTHER = [116, 160, 260, 467]
  # ※ACTOR_ICONが true の時のみ
  #   true  : 通常攻撃のアイコンを「装備している武器」のアイコンにする
  #   false : 通常攻撃のアイコンを ACTOR_ICON_OTHER で設定したアイコンにする
  # 　（ここが true なら
  #     スキルリストの「ID1番のスキル」も「装備している武器」のアイコンにする）
  ACTOR_ICON_ATTACK_WEAPON = true
  
  
  
  # パーティコマンド(戦う、逃げる)の形式
  #   0: ステータスの左に表示（デフォルトと同じ）
  #   1: ステータスの右に表示（デフォルトのアクターコマンドの位置）
  #   2: PARTY_WINDOW_POSで指定した位置に表示
  #   3: 画面上部　横幅いっぱいに表示　項目横並び
  #   4: 画面上部　横幅いっぱいに表示　項目縦並び
  PARTY_MODE = 3
  
  # ※PARTY_MODEが2の時のみ
  #   パーティコマンドウインドウの位置指定 [x座標, y座標]
  PARTY_WINDOW_POS = [0, 0]
  # ※PARTY_MODEが2の時のみ
  #   パーティコマンドウインドウの横幅　デフォルトでは128
  PARTY_WIDTH = 128
  # ※PARTY_MODEが2の時のみ
  #   パーティコマンドウインドウの１ページの「縦の行数」　デフォルトでは4
  PARTY_ROW = 4
  
  # パーティコマンドの各項目にアイコンを表示するかどうか
  # true なら表示する　false なら表示しない
  PARTY_ICON = false
  # ※PARTY_ICON が true の時のみ
  #   各項目のアイコン番号（パーティコマンドの数だけ設定）
  PARTY_ICON_LIST = [147, 467, 16, 16, 16, 16]
  
  
  # パーティコマンドを表示するかどうか
  #  1: 表示する
  #  2: 無くす
  #  3: （他スクリプトとの競合発生率が高め）普段は表示しないが、
  #     アクターコマンド入力中に PARTY_ON_ACTOR_BUTTON が押されると表示する
  PARTY_USE_MODE = 2
  
  # PARTY_USE_MODE が 3 の時のみ
  # アクターコマンドからパーティコマンドを開くボタン
  #   「Qキー = :L」「Wキー = :R」
  #   「Aキー = :X」「Sキー = :Y」「Dキー = :Z」「Shiftキー = :A」
  PARTY_ON_ACTOR_BUTTON = []
  # PARTY_USE_MODE が 3 の時のみ
  # 「パーティコマンドからアクターコマンドに戻る」のに
  # 「戦う」とキャンセルキーに加えて PARTY_ON_ACTOR_BUTTON の入力でも戻れるか
  PARTY_ON_ACTOR_CLOSE_BY_OPEN_BUTTON   = true
  
  
  # ステータスウインドウの横幅
  #   0: デフォルトと同じ横幅
  #   1: 画面サイズと同じ横幅（ゲージの長さなどもそれに合わせて表示されます）
  STATUS_MODE = 1
  
  
  
  STATUS_X = [128, 128, 128]
  # 画面下部の「パーティコマンドとステータスとアクターコマンド のセット」の位置
  # 
  # それぞれ[パーティコマンド選択中, アクターコマンド選択中, ターン中]の位置指定
  # 設定値は
  #     0:右側に移動　アクターコマンドは右の画面外に押し出される
  #    64:中央に移動　ターン中
  #   128:左側に移動　パーティコマンドは左の画面外に押し出される
  #   （ACTOR_MDOEやPARTY_MODEが2以上だと、
  # 　そのウインドウはずっと定位置にあるのでステータスと一緒に動くことはない）
  # 設定例
  #   ACTOR_MODEが0、PARTY_MODEが0　　　の時は[0, 128, 64]
  #   ACTOR_MODEが0、PARTY_MODEが2以上　の時は[64, 128, 64]や[128, 128, 128]
  #   ACTOR_MODEが2、PARTY_MODEが0　　　の時は[0, 64, 64]  や[0, 128, 128]
  #   ACTOR_MODEが2、PARTY_MODEが2以上　の時は[64, 64, 64] や[128, 128, 128]
  #   STATUS_MODEが1　の時は[128, 128, 128]
  
  
=begin
  
  ももまるLabs 様「XPスタイルバトル」使用時
  
    ACTOR_MODE
    ACTOR_WINDOW_POS
    ACTOR_WINDOW_Y_MODE
      は無効　アクターコマンドの座標は、XPスタイルバトル側の設定で決まる
      
    STATUS_MODE
    STATUS_X
      は無効
      
      
  DEICIDE ALMA 様(代理配布：誰かへの宣戦布告 様）「XP風バトル」使用時
  （XP風バトルへの対応確認は不十分なのでうまく動かない部分があるかもしれません）
  
    ACTOR_MODE
    ACTOR_WINDOW_POS
    ACTOR_WINDOW_Y_MODE
      は無効
      
    STATUS_MODE
    STATUS_X
      は無効
      
=end
  
end

#==============================================================================
# ■ BattleCommand_Custom
#==============================================================================
module BattleCommand_Custom
  def self.sideview?
    begin
      N03::ACTOR_POSITION
      return true
    rescue
      return false
    end
  end
  
  def self.xp_style?
    return ($lnx_include != nil and $lnx_include[:lnx11a] != nil)
  end
  def self.renne_xp_huu?
    return ($renne_rgss3 != nil and $renne_rgss3[:xp_style_battle_a] != nil)
  end
  def self.no_layout_script?
    return false if self.xp_style?
    return false if self.renne_xp_huu?
    return true
  end
  
  STRRGSS2::PCOMMAND_W = false if self.renne_xp_huu?

  def self.renne_member_change_in_battle?
    return ($renne_rgss3 != nil and $renne_rgss3[:member_change_in_battle] != nil)
  end
  def self.ex_DA_party?
    return false
  end
  
  def self.default_under_viewport?
    return false if self.xp_style?
    return false if self.renne_xp_huu?
    return true
  end
  def self.default_actor_command_window?
    return false if self.xp_style?
    return false if self.renne_xp_huu?
    return false if ACTOR_MODE == 2
    return true
  end
end

$cwinter_script_battle_command_custom = true

#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● 情報表示ビューポートの更新
  #--------------------------------------------------------------------------
  def update_info_viewport
    if BattleCommand_Custom.default_under_viewport?
      move_info_viewport(BattleCommand_Custom::STATUS_X[0]) if @party_command_window.active
      move_info_viewport(BattleCommand_Custom::STATUS_X[1]) if @actor_command_window.active
      move_info_viewport(BattleCommand_Custom::STATUS_X[2]) if BattleManager.in_turn?
    end
    if sideview_actor_pos_command?
      @actor_command_window.set_position
    end
  end
  def sideview_actor_pos_command?
    return false
  end
  #--------------------------------------------------------------------------
  # ● 全ウィンドウの作成
  #--------------------------------------------------------------------------
  alias :battle_command_custom_create_all_windows :create_all_windows
  def create_all_windows
    battle_command_custom_create_all_windows
    default_create_all_windows      if BattleCommand_Custom.no_layout_script?
    xp_style_create_all_windows     if BattleCommand_Custom.xp_style?
    renne_xp_huu_create_all_windows if BattleCommand_Custom.renne_xp_huu?
    set_ex_handler
  end
  def default_create_all_windows
    # アクターコマンドの位置を変えると
    # ウインドウリフォーム使用時にスキルウインドウ等と重なって変なことになる
    # のを防止するためz座標を変更
    @actor_command_window.z = 5
    @actor_command_window.viewport = nil if BattleCommand_Custom::ACTOR_MODE >= 2
    @party_command_window.viewport = nil if BattleCommand_Custom::PARTY_MODE >= 2
    @actor_command_window.x = 0 if BattleCommand_Custom::ACTOR_MODE == 1
    case BattleCommand_Custom::PARTY_MODE
    when 1
      @party_command_window.x = Graphics.width
    when 2
      @party_command_window.x = BattleCommand_Custom::PARTY_WINDOW_POS[0]
      @party_command_window.y = BattleCommand_Custom::PARTY_WINDOW_POS[1]
    end
    if BattleCommand_Custom::PARTY_USE_MODE == 1
      @info_viewport.ox = BattleCommand_Custom::STATUS_X[0]
    else
      @info_viewport.ox = BattleCommand_Custom::STATUS_X[1]
    end
  end
  def xp_style_create_all_windows
  end
  def renne_xp_huu_create_all_windows
  end
  #--------------------------------------------------------------------------
  # ● ハンドラの追加
  #--------------------------------------------------------------------------
  def set_ex_handler
    if BattleCommand_Custom::PARTY_USE_MODE == 3
      @party_command_window.set_handler(:fight_on_actor,  method(:command_fight_on_actor))
      @party_command_window.set_handler(:cancel,  method(:command_fight_on_actor))
    end
    @actor_command_window.set_handler(:party_on_actor, method(:open_party_command_on_actor))
    @actor_command_window.set_handler(:escape, method(:command_escape))
    if defined?(command_CW_formation)
      @actor_command_window.set_handler(:CW_party, method(:command_CW_formation))
    end
  end
  #--------------------------------------------------------------------------
  # ○ アクタースプライトの作成
  #--------------------------------------------------------------------------
  def sv_re_create_actor_sprites
    @spriteset.dispose_actors
    @spriteset.create_actors
    refresh_status
    Graphics.frame_reset
  end
  #--------------------------------------------------------------------------
  # ○ CWパーティ編成　ステータスの再作成
  #--------------------------------------------------------------------------
  def cw_status_window_reset
    if BattleCommand_Custom.xp_style?
      # XPスタイルバトル　SVXP
      refresh_actors
    elsif BattleCommand_Custom.sideview?
      # サイドビュー
      sv_re_create_actor_sprites
    elsif BattleCommand_Custom.renne_xp_huu?
      # XP風バトル
      process_event
      refresh_status
    end
  end
end
if BattleCommand_Custom.renne_member_change_in_battle?
#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ○ PT編成選択終了
  #--------------------------------------------------------------------------
  alias :battle_command_custom_member_change_end :member_change_end
  def member_change_end
    cw_status_window_reset
    battle_command_custom_member_change_end
  end
end
end
#==============================================================================
# ■ Window_ActorCommand
#==============================================================================
class Window_ActorCommand < Window_Command
  #--------------------------------------------------------------------------
  # ● 桁数の取得
  #--------------------------------------------------------------------------
  def col_max
    if BattleCommand_Custom::ACTOR_COL[0] == nil
      return @list.size == 0 ? 1 : @list.size
    else
      return BattleCommand_Custom::ACTOR_COL[0]
    end
  end
  #--------------------------------------------------------------------------
  # ● カーソルを下に移動
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    return if item_max <= 1
    return if (item_max - 1) / col_max <= 0
    if wrap || (index / col_max != (item_max - 1) / col_max)
      i = index + col_max
      if i >= item_max
        if index / col_max == (item_max - 1) / col_max
          i = index % col_max
        else
          i = item_max - 1
        end
      end
      select(i)
    end
  end
  #--------------------------------------------------------------------------
  # ● カーソルを上に移動
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    return if item_max <= 1
    return if (item_max - 1) / col_max <= 0
    if wrap || (index / col_max != 0)
      i = index - col_max
      if i < 0
        if index % col_max <= (item_max - 1) % col_max
          i = index + (item_max - 1) / col_max * col_max
        else
          i = item_max - 1
        end
      end
      select(i)
    end
  end
  #--------------------------------------------------------------------------
  # ● カーソルを右に移動
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    return if item_max <= 1
    return if col_max <= 1
    if wrap || (index % col_max != (col_max - 1))
      i = index + 1
      if (i >= item_max) or (index / col_max != i / col_max)
        i -= col_max
        i = [i, 0].max
      end
      select(i)
    end
  end
  #--------------------------------------------------------------------------
  # ● カーソルを左に移動
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    return if item_max <= 1
    return if col_max <= 1
    if wrap || (index % col_max != 0)
      i = index - 1
      if index / col_max != i / col_max
        if i + col_max < item_max
          i += col_max
        end
      end
      select(i)
    end
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def original_window_width
    return BattleCommand_Custom::ACTOR_COL[1]
  end
  def window_width
    return original_window_width
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ高さの取得
  #--------------------------------------------------------------------------
  def original_window_height
    if BattleCommand_Custom.default_actor_command_window?
      return 120
    else
      fitting_height(visible_line_number)
    end
  end
  def window_height
    return original_window_height
  end
  #--------------------------------------------------------------------------
  # ● 表示行数の取得
  #--------------------------------------------------------------------------
  def visible_line_number
    if (not BattleCommand_Custom.default_actor_command_window?)
      return custom_visible_line_number
    else
      return default_visible_line_number
    end
  end
  def default_visible_line_number
    return 4
  end
  def custom_visible_line_number
    n = @list.size / col_max + (@list.size % col_max > 0 ? 1 : 0)
    n = [BattleCommand_Custom::ACTOR_ROW[0], n].max
    n = [BattleCommand_Custom::ACTOR_ROW[1], n].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● 横に項目が並ぶときの空白の幅を取得
  #--------------------------------------------------------------------------
  def spacing
    return 0
  end
  #--------------------------------------------------------------------------
  # ● セットアップ
  #--------------------------------------------------------------------------
  alias :battle_command_custom_setup :setup
  def setup(actor)
    battle_command_custom_setup(actor)
    show
    open
    self.arrows_visible = true
  end
  #--------------------------------------------------------------------------
  # ● コマンドリストの作成
  #--------------------------------------------------------------------------
  def make_command_list
    return unless @actor
    for symbol in BattleCommand_Custom::ACTOR_COMMAND_LIST
      make_command_list_by_symbol(symbol)
    end
    set_position if BattleCommand_Custom::ACTOR_MODE >= 2
  end
  def make_command_list_by_symbol(symbol)
    case symbol
    when :attack    ; add_attack_command
    when :skill     ; add_skill_commands
    when :guard     ; add_guard_command
    when :item      ; add_item_command
    when :escape    ; add_escape_command
    when :CW_party  ; add_CW_party_command
    when :DA_party  ; add_DA_party_command
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティ編成コマンドの追加
  #--------------------------------------------------------------------------
  def add_CW_party_command
    unless $cwinter_script_battle_formation
      text  = "エラー「戦闘コマンドカスタム」nn"
      text += "元スクリプト「CW戦闘中パーティ編成」が導入されていませんnn"
      text += "元スクリプト「CW戦闘中パーティ編成」を導入するかn"
      text += "設定項目 ACTOR_COMMAND_LIST から :CW_party を消してください"
      msgbox text
    end
    name = BATTLE_FORMATION::BATTLE_COMMAND_NAME
    icon = BATTLE_FORMATION::ACTOR_ICON_CW_MEMBER_CHANGE
    flag = BATTLE_FORMATION.can_CW_formation?
    add_command([name, icon], :CW_party, flag)
  end
  #--------------------------------------------------------------------------
  # ● パーティ編成コマンドの追加
  #--------------------------------------------------------------------------
  def add_DA_party_command
    unless BattleCommand_Custom.ex_DA_party?
      text  = "エラー「戦闘コマンドカスタム」nn"
      text += "拡張スクリプト「DAアクターコマンドPT編成」が導入されていませんnn"
      text += "拡張スクリプト「DAアクターコマンドPT編成」を導入するかn"
      text += "設定項目 ACTOR_COMMAND_LIST から :DA_party を消してください"
      msgbox text
    end
    name = RENNE::Member_Change::NAME
    icon = BattleCommand_Custom::ACTOR_ICON_MEMBER_CHANGE
    flag = true
    add_command([name, icon], :DA_party, flag)
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #--------------------------------------------------------------------------
  def draw_item(index)
    change_color(normal_color, command_enabled?(index))
    par = command_name(index)
    rect = item_rect_for_text(index)
    if BattleCommand_Custom::ACTOR_ICON
      draw_icon(par[1], rect.x, rect.y)
      rect.x += 24
      rect.width -= 24
      draw_text(rect, par[0], alignment)
    else
      draw_text(rect, par[0], alignment)
    end
  end
  #--------------------------------------------------------------------------
  # ● 高さと座標の更新
  #--------------------------------------------------------------------------
  def set_position
    self.height = window_height
    pos = window_pos
    if $cwinter_script_actor_command_reform_ex_image
      l_space = left_space
      t_space = top_space
      u_space = under_space
    else
      l_space = 0
      t_space = 0
      u_space = 0
    end
    self.x = pos[0] + l_space
    if BattleCommand_Custom::ACTOR_WINDOW_Y_MODE == 0
      self.y = pos[1] + t_space
    else
      self.y = pos[1] - self.height - u_space
    end
  end
  def window_pos
    return BattleCommand_Custom::ACTOR_WINDOW_POS
  end
  #--------------------------------------------------------------------------
  # ● [追加]:X 座標をアクターに合わせる
  #--------------------------------------------------------------------------
  def actor_x(actor)
    if $cwinter_script_actor_command_reform_ex_image
      l_space = left_space
    else
      l_space = 0
    end
    left_width  = self.width - l_space
    right_width = self.width
    ax = $game_party.members_screen_x_nooffset[actor.index] - left_width / 2
    left_pad  = LNX11::STATUS_SIDE_PADDING / 2 + l_space
    right_pad = LNX11::STATUS_SIDE_PADDING / 2
    # 画面内に収める
    self.x = [[ax, left_pad].max, Graphics.width - right_pad - right_width].min
    self.x += LNX11::ACTOR_COMMAND_OFFSET[:x]
  end
  #--------------------------------------------------------------------------
  # ● [追加]:Y 座標をアクターに合わせる
  #--------------------------------------------------------------------------
  def actor_y(actor)
    if $cwinter_script_actor_command_reform_ex_image
      u_space = under_space
    else
      u_space = 0
    end
    self_height = self.height + u_space
    self.y = actor.screen_y_top - self_height
    self.y += LNX11::ACTOR_COMMAND_OFFSET[:y]
  end
  #--------------------------------------------------------------------------
  # ● [追加]:固定 Y 座標
  #--------------------------------------------------------------------------
  def screen_y
    if $cwinter_script_actor_command_reform_ex_image
      u_space = under_space
    else
      u_space = 0
    end
    if LNX11::ACTOR_COMMAND_Y_POSITION == 0
      self_height = self.height + u_space
      self.y = Graphics.height - self_height + LNX11::ACTOR_COMMAND_OFFSET[:y]
    else
      self.y = LNX11::ACTOR_COMMAND_OFFSET[:y]
    end
  end
  #--------------------------------------------------------------------------
  # ● 攻撃コマンドをリストに追加
  #--------------------------------------------------------------------------
  def add_attack_command
    if BattleCommand_Custom::ACTOR_ICON_ATTACK_WEAPON and @actor.weapons[0]
      par = [Vocab::attack, @actor.weapons[0].icon_index]
    else
      par = [Vocab::attack, BattleCommand_Custom::ACTOR_ICON_OTHER[0]]
    end
    add_command(par, :attack, @actor.attack_usable?)
  end
  #--------------------------------------------------------------------------
  # ● スキルコマンドをリストに追加
  #--------------------------------------------------------------------------
  def add_skill_commands
    @actor.added_skill_types.sort.each do |stype_id|
      name = $data_system.skill_types[stype_id]
      par = [name, BattleCommand_Custom::ACTOR_ICON_SKILL[stype_id - 1]]
      add_command(par, :skill, true, stype_id)
    end
  end
  #--------------------------------------------------------------------------
  # ● 防御コマンドをリストに追加
  #--------------------------------------------------------------------------
  def add_guard_command
    par = [Vocab::guard, BattleCommand_Custom::ACTOR_ICON_OTHER[1]]
    add_command(par, :guard, @actor.guard_usable?)
  end
  #--------------------------------------------------------------------------
  # ● アイテムコマンドをリストに追加
  #--------------------------------------------------------------------------
  def add_item_command
    par = [Vocab::item, BattleCommand_Custom::ACTOR_ICON_OTHER[2]]
    add_command(par, :item)
  end
  #--------------------------------------------------------------------------
  # ● 逃走コマンドをリストに追加
  #--------------------------------------------------------------------------
  def add_escape_command
    par = [Vocab::escape, BattleCommand_Custom::ACTOR_ICON_OTHER[3]]
    add_command(par, :escape, BattleManager.can_escape?)
  end
end
#==============================================================================
# ■ Window_SkillList
#==============================================================================
class Window_SkillList < Window_Selectable
  #--------------------------------------------------------------------------
  # ● アイテム名の描画
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = 172)
    return unless item
    if item.id == 1 and
       BattleCommand_Custom::ACTOR_ICON_ATTACK_WEAPON and @actor.weapons[0]
      icon = @actor.weapons[0].icon_index
    else
      icon = item.icon_index
    end
    draw_icon(icon, x, y, enabled)
    change_color(normal_color, enabled)
    draw_text(x + 24, y, width, line_height, item.name)
  end
end
if [2, 3, 4].include?(BattleCommand_Custom::PARTY_MODE)
#==============================================================================
# ■ Window_PartyCommand
#==============================================================================
class Window_PartyCommand < Window_Command
  #--------------------------------------------------------------------------
  # ● ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    case BattleCommand_Custom::PARTY_MODE
    when 2; return BattleCommand_Custom::PARTY_WIDTH
    when 3; return Graphics.width
    when 4; return Graphics.width
    end
  end
  #--------------------------------------------------------------------------
  # ● 表示行数の取得
  #--------------------------------------------------------------------------
  def visible_line_number
    case BattleCommand_Custom::PARTY_MODE
    when 2; return BattleCommand_Custom::PARTY_ROW
    when 3; return 1
    when 4; return @list.size
    end
  end
  #--------------------------------------------------------------------------
  # ● 桁数の取得
  #--------------------------------------------------------------------------
  def col_max
    case BattleCommand_Custom::PARTY_MODE
    when 2; return 1
    when 3; return @list.size
    when 4; return 1
    end
  end
  #--------------------------------------------------------------------------
  # ● 横に項目が並ぶときの空白の幅を取得
  #--------------------------------------------------------------------------
  def spacing
    return 16
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #--------------------------------------------------------------------------
  def draw_item(index)
    case BattleCommand_Custom::PARTY_MODE
    when 2; return draw_item_alignment_0(index)
    when 3; return draw_item_alignment_1(index)
    when 4; return draw_item_alignment_1(index)
    end
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #--------------------------------------------------------------------------
  def draw_item_alignment_0(index)
    rect   = item_rect_for_text(index)
    enable = command_enabled?(index)
    if BattleCommand_Custom::PARTY_ICON
      x = rect.x
      y = rect.y
      draw_icon(BattleCommand_Custom::PARTY_ICON_LIST[index], x, y, enable)
      rect.x += 24
    end
    change_color(normal_color, enable)
    draw_text(rect, command_name(index), 0)
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #--------------------------------------------------------------------------
  def draw_item_alignment_1(index)
    rect   = item_rect_for_text(index)
    enable = command_enabled?(index)
    if BattleCommand_Custom::PARTY_ICON
      t_rect = self.contents.text_size(command_name(index))
      x = rect.x + (rect.width / 2 - t_rect.width / 2) - 25
      y = rect.y
      draw_icon(BattleCommand_Custom::PARTY_ICON_LIST[index], x, y, enable)
    end
    rect   = item_rect_for_text(index)
    change_color(normal_color, enable)
    draw_text(rect, command_name(index), 1)
  end
end
end
#==============================================================================
# ■ Window_PartyCommand
#==============================================================================
class Window_PartyCommand < Window_Command
  #--------------------------------------------------------------------------
  # ● セットアップ
  #--------------------------------------------------------------------------
  alias :setup_on_actor :setup
  def setup
    if BattleCommand_Custom::PARTY_USE_MODE == 1
      setup_on_actor
    else
      call_handler(:fight)
    end
  end
end
# PARTY_USE_MODE
#==============================================================================
# ■ Window_PartyCommand
#==============================================================================
class Window_PartyCommand < Window_Command
  #--------------------------------------------------------------------------
  # ● コマンドリストの作成
  #--------------------------------------------------------------------------
  alias :battle_command_custom_make_command_list :make_command_list
  def make_command_list
    battle_command_custom_make_command_list
    if BattleCommand_Custom::PARTY_USE_MODE == 3
      @list[0][:symbol] = :fight_on_actor
    end
  end
  #--------------------------------------------------------------------------
  # ● 決定やキャンセルなどのハンドリング処理
  #--------------------------------------------------------------------------
  def process_handling
    return unless open? && active
    return process_ok       if ok_enabled?        && Input.trigger?(:C)
    return process_cancel   if cancel_enabled?    && Input.trigger?(:B)
    if BattleCommand_Custom::PARTY_ON_ACTOR_CLOSE_BY_OPEN_BUTTON
      for symbol in BattleCommand_Custom::PARTY_ON_ACTOR_BUTTON
        return process_cancel   if cancel_enabled?    && Input.trigger?(symbol)
      end
    end
    return process_pagedown if handle?(:pagedown) && Input.trigger?(:R)
    return process_pageup   if handle?(:pageup)   && Input.trigger?(:L)
  end
end
#==============================================================================
# ■ Window_ActorCommand
#==============================================================================
class Window_ActorCommand < Window_Command
  #--------------------------------------------------------------------------
  # ● 決定やキャンセルなどのハンドリング処理
  #--------------------------------------------------------------------------
  def process_handling
    return unless open? && active
    return process_ok       if ok_enabled?        && Input.trigger?(:C)
    return process_cancel   if cancel_enabled?    && Input.trigger?(:B)
    if BattleCommand_Custom::PARTY_USE_MODE == 3
      for symbol in BattleCommand_Custom::PARTY_ON_ACTOR_BUTTON
        return process_party_on_actor if handle?(:party_on_actor) && Input.trigger?(symbol)
      end
    end
    return process_pagedown if handle?(:pagedown) && Input.trigger?(:R)
    return process_pageup   if handle?(:pageup)   && Input.trigger?(:L)
  end
  #--------------------------------------------------------------------------
  # ● サブウインドウキーが押された時の処理
  #--------------------------------------------------------------------------
  def process_party_on_actor
    Sound.play_ok
    Input.update
    # XPスタイルバトル導入時は deactivate を使うと自動的に hide されるため
    # deactivateは使わない
    self.active = false
    call_handler(:party_on_actor)
  end
end
#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  def open_party_command_on_actor
    @actor_command_window.close
    @actor_command_window.deactivate
    @party_command_window.setup_on_actor
  end
  def command_fight_on_actor
    start_actor_command_selection
  end
  #--------------------------------------------------------------------------
  # ● アクターコマンド選択の開始
  #--------------------------------------------------------------------------
  alias :battle_command_custom_start_actor_command_selection :start_actor_command_selection
  def start_actor_command_selection
    if BattleManager.actor == nil
      next_command
    else
      battle_command_custom_start_actor_command_selection
    end
  end
end
# PARTY_USE_MODE
if BattleCommand_Custom.no_layout_script? and
   BattleCommand_Custom::STATUS_MODE == 1
#==============================================================================
# ■ Window_BattleStatus
#==============================================================================
class Window_BattleStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # ● ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width
  end
  #--------------------------------------------------------------------------
  # ● ゲージエリアの幅を取得
  #--------------------------------------------------------------------------
  def gauge_area_width
    return 348
  end
  #--------------------------------------------------------------------------
  # ● ゲージエリアの描画（TP あり）
  #--------------------------------------------------------------------------
  def draw_gauge_area_with_tp(rect, actor)
    draw_actor_hp(actor, rect.x + 128 - 60 + 0, rect.y, 72 + 20)
    draw_actor_mp(actor, rect.x + 128 - 40 + 82, rect.y, 64 + 20)
    draw_actor_tp(actor, rect.x + 128 - 20 + 156, rect.y, 64 + 20)
  end
  #--------------------------------------------------------------------------
  # ● ゲージエリアの描画（TP なし）
  #--------------------------------------------------------------------------
  def draw_gauge_area_without_tp(rect, actor)
    draw_actor_hp(actor, rect.x + 128 - 60 + 0, rect.y, 134 + 30)
    draw_actor_mp(actor, rect.x + 128 - 30 + 144,  rect.y, 76 + 30)
  end
end
#==============================================================================
# ■ Window_BattleActor
#==============================================================================
class Window_BattleActor < Window_BattleStatus
  #--------------------------------------------------------------------------
  # ● ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width - 128
  end
  #--------------------------------------------------------------------------
  # ● ゲージエリアの幅を取得
  #--------------------------------------------------------------------------
  def gauge_area_width
    return 220
  end
  #--------------------------------------------------------------------------
  # ● ゲージエリアの描画（TP あり）
  #--------------------------------------------------------------------------
  def draw_gauge_area_with_tp(rect, actor)
    draw_actor_hp(actor, rect.x + 0, rect.y, 72)
    draw_actor_mp(actor, rect.x + 82, rect.y, 64)
    draw_actor_tp(actor, rect.x + 156, rect.y, 64)
  end
  #--------------------------------------------------------------------------
  # ● ゲージエリアの描画（TP なし）
  #--------------------------------------------------------------------------
  def draw_gauge_area_without_tp(rect, actor)
    draw_actor_hp(actor, rect.x + 0, rect.y, 134)
    draw_actor_mp(actor, rect.x + 144,  rect.y, 76)
  end
end
end