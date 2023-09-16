#==============================================================================
# ■ RGSS3 アイテム預かり所 Ver1.05 by 星潟
#------------------------------------------------------------------------------
# アイテムを預ける事が出来るようになります。
# 莫大な数のアイテムが登場する作品におすすめです。
# 
# 最大所持数を越える量のアイテムを引き出せないようにする機能や
# 預けられないアイテムの作成、預けられる数の限界設定の他、
# アイテムの預かり・引き出しに関わるイベントコマンドをいくつか実装します。
#==============================================================================
# アイテム・武器・防具のメモ欄に以下のように書き込む事で
# それぞれ特殊な設定が行われます。
#------------------------------------------------------------------------------
# <保存禁止>
# 
# このアイテムは預かり所で預ける事が出来ません。
#------------------------------------------------------------------------------
# <保存制限:20>
# 
# このアイテムは預かり所にも20個までしか預ける事が出来ません。
#==============================================================================
# 以下、イベントコマンドのスクリプトで使用します。
#------------------------------------------------------------------------------
# SceneManager.call(Scene_Item_Keep)
# 
# call_keep
# 
# アイテム預かり所画面を呼び出します。
# （どちらでもいいですが、call_keepの方が安定しています）
#------------------------------------------------------------------------------
# item_keep_all(data_a)
# 
# data_aが0の時……預けられるアイテムを預けられるだけ預けます。
# data_aが1の時……アイテムを全て引き出せるだけ引き出します。
#------------------------------------------------------------------------------
# weapon_keep_all(data_a)
# 
# data_aが0の時……預けられる武器を預けられるだけ預けます。
# data_aが1の時……武器を全て引き出せるだけ引き出します。
#------------------------------------------------------------------------------
# armor_keep_all(data_a)
# 
# data_aが0の時……預けられる防具を預けられるだけ預けます。
# data_aが1の時……防具を全て引き出せるだけ引き出します。
#------------------------------------------------------------------------------
# item_keep_get(vid,id)
# 
# id番のアイテムを預けている数を変数IDvidに格納します。
#------------------------------------------------------------------------------
# weapon_keep_get(vid,id)
# 
# id番の武器を預けている数を変数IDvidに格納します。
#------------------------------------------------------------------------------
# armor_keep_get(vid,id)
# 
# id番の防具を預けている数を変数IDvidに格納します。
#------------------------------------------------------------------------------
# item_keep(data_a, data_b)
# 
# data_aが0の時……data_bで指定したIDのアイテムを預けられるだけ預けます。
# data_aが1の時……data_bで指定したIDのアイテムを引き出せるだけ引き出します。
#------------------------------------------------------------------------------
# weapon_keep(data_a, data_b)
# 
# data_aが0の時……data_bで指定したIDの武器を預けられるだけ預けます。
# data_aが1の時……data_bで指定したIDの武器を引き出せるだけ引き出します。
#------------------------------------------------------------------------------
# armor_keep(data_a, data_b)
# 
# data_aが0の時……data_bで指定したIDの防具を預けられるだけ預けます。
# data_aが1の時……data_bで指定したIDの防具を引き出せるだけ引き出します。
#------------------------------------------------------------------------------
# word_keep_all(data_a, data_b)
# 
# data_aが0の時
# data_bで指定した言葉がメモ欄に含まれる
# アイテム・武器・防具を預けられるだけ預けます。
#
# data_aが1の時
# data_bで指定した言葉がメモ欄に含まれる
# アイテム・武器・防具を引き出せるだけ引き出します。
#
# word_keep_allで、data_bで設定する言葉は、前後を""で囲んでください。
# 【例.word_keep_all(1, "回復")】
# この場合、回復という言葉をメモ欄に含んだアイテム・武器・防具を
# 預かり所から全て引き出します。
#==============================================================================
# Ver1.01 導入前のセーブデータを使用した場合に正常に機能しなくなる不具合を修正。
#         軽量化スクリプトと統合し、軽量化モード切替機能を追加。
#         説明ウィンドウ機能を追加。
#
# Ver1.02 一部機能を更に軽量化。
#         Scene_Shop及び継承しているシーンクラスにおいて
#         買った物を直接預かり所へ送る機能を追加。
#         所持限界数を超えてアイテムを入手した際に
#         自動的に預かり所に送る機能を追加。
#
# Ver1.03 ロード時に更に一部軽量化。
#
# Ver1.04 呼び出しコマンドを1つ追加。
#         また、指定アイテム/武器/防具の倉庫に預けている数を
#         変数に取得するイベントコマンドのスクリプトを追加。
#
# Ver1.05 不具合修正。
#==============================================================================
module ITEM_KEEPER
  
  #ショップ画面で預かり所への売買機能を付与するかを設定できます。
  
  SHOP      = true
  
  #ショップ画面で預かり所モードへの切り替えボタンを設定できます。
  
  KEY       = :Z
  
  #預かり所モードから所持品モードに切り替えた際のメッセージを設定します。
  
  TEXT1     = "Switched to buying to Inventory"
  
  #所持品モードから預かり所モードに切り替えた際のメッセージを設定します。
  
  TEXT2     = "Switched to buying to Storage"
  
  #モードに切り替え時のSEを設定します。
  #配列内は、名前、音量、ピッチの順に設定して下さい。
  
  SE        = ["Decision3",80,100]
  
  #ショップでの預けている数の項目名を設定します。
  
  SHOP_POS  = "Stored:"
  
  #預かり所モードの際の数字入力幅の増加値を設定します。（3桁以上の入力を考慮）
  
  SHOP_FIG  = 1
  
  #ショップでの預り所への売買機能を無効化する為のスイッチを指定します。
  
  SWITCH1   = 201
  
  #保存禁止アイテムについて、預かり所で表示しないようにするかを設定できます。
  #true 表示しない　false 表示する 
  
  UNVISIBLE = false
  
  #保存禁止アイテムについて、預かり所で表示しないようにするかを設定できます。
  #true 表示しない　false 表示する
  
  WORD1     = "保存禁止"
  
  #保存に個数制限を設ける為の設定用キーワードです。
  
  WORD2     = "保存制限"
  
  #保存制限のないアイテムについていくつまで預けられるかを設定します。
  
  LIMIT     = 999
  
  #所持数を超えて入手したアイテムが自動で預かり所に送られるかどうかを設定します。
  
  AUTOKEEP  = true
  
  #所持数を超えて入手したアイテムが自動で預かり所に送られる機能を
  #一時的に封印するスイッチを指定します。
  
  SWITCH2   = 202
  
  #説明ウィンドウを表示するかどうかを設定します。
  
  DESCRIPT  = true
  
  #数量ウィンドウと説明ウィンドウの背景透明度を変更します。
  
  B_OPACITY = 255
  
  #軽量化フラグ。
  
  FLAG      = true
  
  #説明ウィンドウに表示する項目を設定します。
  #（基本的にこの部分を変更する必要はありません）
  
  D         = [
  ["Down",": withdraw 1"],
  ["Up",": deposit 1"],
  ["Left",": withdraw 10"],
  ["Right",": deposit 10"],
  ["Ctrl",": withdraw 100"],
  ["Shift",": deposit 100"]
  ]
  
end
class RPG::BaseItem
  #--------------------------------------------------------------------------
  # 保存禁止のフラグ
  #--------------------------------------------------------------------------
  def keep_seal_flag
    
    #キャッシュがある場合はキャッシュを返す。
    
    return @keep_seal_flag if @keep_seal_flag != nil
    
    #データを取得。
    
    @keep_seal_flag = self.note.include?("<" + ITEM_KEEPER::WORD1 + ">") ? true : false
    
    #データを返す。
    
    @keep_seal_flag
  end
  #--------------------------------------------------------------------------
  # 最大保管数を取得
  #--------------------------------------------------------------------------
  def max_item_keep_number
    
    #キャッシュが存在する場合はキャッシュを返す。
    
    return @max_item_keep_number if @max_item_keep_number != nil
    
    #メモ欄からデータを取得し、取得できない場合はデフォルト数を返す。
    
    memo = self.note.scan(/<#{ITEM_KEEPER::WORD2}[：:](\S+)>/).flatten
    @max_item_keep_number = memo != nil && !memo.empty? ? memo[0].to_i : ITEM_KEEPER::LIMIT
    
    #データを返す。
    
    @max_item_keep_number
  end
end
class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_ik initialize
  def initialize
    
    #本来の処理を実行。
    
    initialize_ik
    
    #パーティー外全アイテムリストを初期化。
    
    init_all_items_ik
  end
  #--------------------------------------------------------------------------
  # パーティー外全アイテムリストの初期化（強制）
  #--------------------------------------------------------------------------
  def init_all_items_ik
    
    #それぞれ、空のハッシュを生成。
    
    @items_k = {}
    @weapons_k = {}
    @armors_k = {}
  end
  #--------------------------------------------------------------------------
  # パーティー外全アイテムリストの初期化（nilの場合）
  #--------------------------------------------------------------------------
  def init_all_items_ik_un_nil
    
    #それぞれ、存在しない場合のみハッシュを生成。
    
    @items_k = {} if @items_k == nil
    @weapons_k = {} if @weapons_k == nil
    @armors_k = {} if @armors_k == nil
  end
  #--------------------------------------------------------------------------
  # アイテムの最大保管数取得
  #--------------------------------------------------------------------------
  def max_item_keep_number(item)
    
    #アイテムが存在しない場合はfalseを返す。
    
    return false if item == nil
    
    #アイテムの最大保管数を返す。
    
    item.max_item_keep_number
  end
  #--------------------------------------------------------------------------
  # アイテムの保管数取得
  #--------------------------------------------------------------------------
  def item_keep_number(item)
    
    #コンテナを取得。
    
    container = item_keep_container(item.class)
    
    #コンテナにデータが存在しない場合は0を返す。
    
    container ? container[item.id] || 0 : 0
  end
  #--------------------------------------------------------------------------
  # アイテムの保管
  #--------------------------------------------------------------------------
  def item_keep(item, number, get = false)
    
    #数量データを取得。
    
    number_data = number
    
    #アイテム保管を実行。
    
    item_keep_execute(item, number_data)
    
    #所持アイテムを減らす。
    
    gain_item(item, -number_data) if get == false
  end
  #--------------------------------------------------------------------------
  # 預けているアイテムのクラスに対応するコンテナオブジェクトを取得
  #--------------------------------------------------------------------------
  def item_keep_container(item_class)
    
    #アイテムの種類に応じてコンテナを取得。
    
    return @items_k   if item_class == RPG::Item
    return @weapons_k if item_class == RPG::Weapon
    return @armors_k  if item_class == RPG::Armor
    return nil
  end
  #--------------------------------------------------------------------------
  # アイテムの増加（減少）
  #--------------------------------------------------------------------------
  def item_keep_execute(item, amount)
    
    #コンテナを取得。
    
    container = item_keep_container(item.class)
    
    #コンテナが存在しない場合は処理をしない。
    
    return if container == nil
    
    #処理前の保管数を取得。
    
    last_number = item_keep_number(item)
    
    #処理後の保管数を取得。
    
    new_number = last_number + amount
    
    #保管数を変更する。
    
    container[item.id] = new_number
    
    #保管数が0となった場合はハッシュから削除する。
    
    container.delete(item.id) if container[item.id] == 0
    
    #マップのリフレッシュフラグを立てる。
    
    $game_map.need_refresh = true
  end
  
  #自動倉庫送りが有効な場合のみ変更
  
  if ITEM_KEEPER::AUTOKEEP
    
  #--------------------------------------------------------------------------
  # アイテムの増加（減少）
  #--------------------------------------------------------------------------
  alias gain_item_ik gain_item
  def gain_item(item, amount, include_equip = false)
      
    #自動倉庫送りスイッチが無効もしくは、スイッチがOFFの時で
    #なおかつアイテムが存在し、それが預かり所禁止出ない場合
    
    if (ITEM_KEEPER::SWITCH2 == 0 or !$game_switches[ITEM_KEEPER::SWITCH2]) && (item != nil && !item.keep_seal_flag)
      
      #アイテムコンテナを取得。
      
      container = item_container(item.class)
      
      #アイテムコンテナが存在しない場合は処理を飛ばす。
      
      return unless container
      
      #所持数と入手数の合計値を取得。
      
      ex_amount = item_number(item) + amount
      
      #合計値が最大所持数を上回る場合
      
      if ex_amount > max_item_number(item)
        
        #合計値から最大所持数を引いた値を取得。
        
        data = ex_amount - max_item_number(item)
        
        #倉庫アイテムコンテナを取得。
        
        ik_container = item_keep_container(item.class)
        
        #倉庫アイテムの数を変更する。
        
        ik_container[item.id] = [item_keep_number(item) + data, max_item_keep_number(item)].min
        
        #入手数を減らす。
        
        amount -= data
      end
    end
    
    #本来の処理を実行。
    
    gain_item_ik(item, amount, include_equip)
  end
  
  end
end
class Scene_Load < Scene_File
  #--------------------------------------------------------------------------
  # ロード成功時の処理
  #--------------------------------------------------------------------------
  alias on_load_success_ik on_load_success
  def on_load_success
    $game_party.init_all_items_ik_un_nil
    on_load_success_ik
  end
end
class Scene_Item_Keep < Scene_Item
  #--------------------------------------------------------------------------
  # 開始処理
  #--------------------------------------------------------------------------
  def start
    
    #スーパークラスの処理を実行。
    
    super
    
    #説明ウィンドウの作成
    
    create_description_window
    
    #個数入力ウィンドウの作成
    
    create_number_window
  end
  #--------------------------------------------------------------------------
  # カテゴリウィンドウの作成
  #--------------------------------------------------------------------------
  def create_category_window
    @category_window = Window_ItemCategory.new
    @category_window.viewport = @viewport
    @category_window.help_window = @help_window
    @category_window.y = @help_window.height
    @category_window.set_handler(:ok,     method(:on_category_ok))
    @category_window.set_handler(:cancel, method(:return_scene))
  end
  #--------------------------------------------------------------------------
  # アイテムウィンドウの作成
  #--------------------------------------------------------------------------
  def create_item_window
    wy = @category_window.y + @category_window.height
    wh = Graphics.height - wy
    @item_window = Window_PTItemList.new(0, wy, Graphics.width, wh)
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @category_window.item_window = @item_window
  end
  #--------------------------------------------------------------------------
  # 説明ウィンドウの作成
  #--------------------------------------------------------------------------
  def create_description_window
    
    #説明ウィンドウを作成しない場合は処理を行わない。
    
    return unless ITEM_KEEPER::DESCRIPT
    
    @description_window = Window_IKDescription.new
    @description_window.z = 100
    @description_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # 個数入力ウィンドウの作成
  #--------------------------------------------------------------------------
  def create_number_window
    @number_window = Window_IKInput.new
    @number_window.z = 100
    @number_window.item_window = @item_window
    @number_window.description_window = @description_window if ITEM_KEEPER::DESCRIPT
    @number_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # カテゴリ［決定］
  #--------------------------------------------------------------------------
  def on_category_ok
    @item_window.activate
    @item_window.select_last
    @category_window.deactivate
  end
  #--------------------------------------------------------------------------
  # アイテム［決定］
  #--------------------------------------------------------------------------
  def on_item_ok
    $game_party.last_item.object = item
    item == nil ? @item_window.activate : determine_item
  end
  #--------------------------------------------------------------------------
  # アイテムの決定
  #--------------------------------------------------------------------------
  def determine_item
    @number_window.number = 0
    item = @item_window.item
    @number_window.show
    @number_window.refresh
    @description_window.show if ITEM_KEEPER::DESCRIPT
    @item_window.deactivate
  end
  #--------------------------------------------------------------------------
  # アイテム［キャンセル］
  #--------------------------------------------------------------------------
  def on_item_cancel
    @item_window.unselect
    @category_window.activate
  end
end
#==============================================================================
# ■ Window_PTItemList
#------------------------------------------------------------------------------
# 　アイテム画面で、所持アイテムの一覧を表示するウィンドウです。
#==============================================================================

class Window_PTItemList < Window_ItemList
  #--------------------------------------------------------------------------
  # アイテムをリストに含めるかどうか
  #--------------------------------------------------------------------------
  def include?(item)
    
    #アイテムが存在しない場合、ウィンドウが不可視の場合
    #保管禁止アイテムを非表示にする場合は表示しない。
    
    return false if item == nil
    return false if self.visible == false
    return false if ITEM_KEEPER::UNVISIBLE == true && item.keep_seal_flag
    
    #本来の処理を実行。
    
    super(item)
  end
  #--------------------------------------------------------------------------
  # アイテムを許可状態で表示するかどうか
  #--------------------------------------------------------------------------
  def enable?(item)
    
    #アイテムが存在しない場合、もしくは保管禁止アイテムの場合はfalseを返す。
    
    return false if item == nil
    return false if item.keep_seal_flag
    return true
  end
  #--------------------------------------------------------------------------
  # アイテムリストの作成
  #--------------------------------------------------------------------------
  def make_item_list
    
    #全ての中から、所持アイテムか倉庫アイテムとして存在する物のみ取得する。
    
    item_data = $data_items + $data_weapons + $data_armors
    @data = item_data.select {|item| include?(item) && ($game_party.item_number(item) > 0 or $game_party.item_keep_number(item) > 0)}
    @data.push(nil) if include?(nil)
  end
  #--------------------------------------------------------------------------
  # 選択項目の有効状態を取得
  #--------------------------------------------------------------------------
  def current_item_enabled?
    enable?(@data[index])
  end
  #--------------------------------------------------------------------------
  # 桁数の取得
  #--------------------------------------------------------------------------
  def col_max
    return 1
  end
  #--------------------------------------------------------------------------
  # フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
  end
  #--------------------------------------------------------------------------
  # 項目の描画
  #--------------------------------------------------------------------------
  def draw_item(index, flag = false)
    
    #データからアイテムを取得し、各種データを記述する。
    
    item = @data[index]
    
    #アイテムが存在しない場合は処理を行わない。
    
    return unless item
    
    rect = item_rect(index)
    contents.clear_rect(rect) if flag
    rect.width -= 4
    draw_item_name(item, rect.x, rect.y, enable?(item))
    change_color(text_color(5))
    draw_text(180, rect.y, 100, line_height, "On Hand", 2)
    change_color(text_color(0))
    draw_text(220, rect.y, 100, line_height, $game_party.item_number(item), 2)
    draw_text(240, rect.y, 100, line_height,"／", 2)
    draw_text(270, rect.y, 100, line_height, $game_party.max_item_number(item), 2)
    change_color(text_color(5))
    draw_text(330, rect.y, 100, line_height, "Stored", 2)
    change_color(text_color(0))
    draw_text(370, rect.y, 100, line_height, $game_party.item_keep_number(item), 2)
    draw_text(390, rect.y, 100, line_height, "／", 2)
    draw_text(420, rect.y, 100, line_height, $game_party.max_item_keep_number(item), 2)
    
  end
end
class Window_IKInput < Window_Selectable
  #--------------------------------------------------------------------------
  # 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor   :item_window
  attr_accessor   :number
  attr_accessor   :description_window
  #--------------------------------------------------------------------------
  # オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    
    #ウィンドウを生成する。
    
    super(Graphics.width / 2 - 122, Graphics.height / 2 - 50, 244, 100)
    
    #設定に応じて背景透明度を変更する。
    
    self.back_opacity = ITEM_KEEPER::B_OPACITY
    
    #一旦隠す。
    
    hide
    
    #非アクティブにする。
    
    deactivate
  end
  #--------------------------------------------------------------------------
  # 数字の変更処理
  #--------------------------------------------------------------------------
  def update
    
    #見えない場合は更新しない。
    
    return unless self.visible
    
    #入力関連の各種処理を実行。
    
    if Input.press?(:UP) or Input.press?(:DOWN) or Input.press?(:RIGHT) or Input.press?(:LEFT) or Input.press?(Input::SHIFT) or Input.press?(Input::CTRL)
      if Input.press?(Input::SHIFT)   #100個預ける
        keep_exe(@item_window.item, 100)
      elsif Input.press?(Input::CTRL) #100個引き出す
        get_exe(@item_window.item, 100)
      elsif Input.repeat?(:RIGHT)     #10個預ける
        keep_exe(@item_window.item, 10)
      elsif Input.repeat?(:LEFT)      #10個引き出す
        get_exe(@item_window.item, 10)
      elsif Input.repeat?(:UP)        #1個預ける
        keep_exe(@item_window.item, 1)
      elsif Input.repeat?(:DOWN)      #1個引き出す
        get_exe(@item_window.item, 1)
      end
      refresh_number
    end
    if Input.trigger?(:C)
      
      #決定音を鳴らす。
      
      Sound.play_ok
      
      #数に応じてアイテム数を変更。
      
      $game_party.item_keep(@item_window.item, @number)
      
      #ウィンドウを隠す。
      
      self.hide
      
      #ウィンドウを非アクティブにする。
      
      self.deactivate
      
      #説明ウィンドウが存在する場合、説明ウィンドウを隠す。
      
      @description_window.hide if ITEM_KEEPER::DESCRIPT
      
      #条件に応じてアイテムウィンドウを変更する。
      
      ITEM_KEEPER::FLAG ? @item_window.draw_item(@item_window.index, true) : @item_window.refresh
      
      #アイテムウィンドウをアクティブにする。
      
      @item_window.activate
    elsif Input.trigger?(:B)
      
      #決定音を鳴らす。
      
      Sound.play_cancel
      
      #ウィンドウを隠す。
      
      self.hide
      
      #ウィンドウを非アクティブにする。
      
      self.deactivate
      
      #説明ウィンドウが存在する場合、説明ウィンドウを隠す。
      
      @description_window.hide if ITEM_KEEPER::DESCRIPT
      
      #アイテムウィンドウをアクティブにする。
      
      @item_window.activate
      
    end
  end
  #--------------------------------------------------------------------------
  # 預けられる限界をチェック
  #--------------------------------------------------------------------------
  def limitcheck1
    
    #所持数が既に0、もしくは預ける限界に達している場合はfalseを返す。
    
    return false if $game_party.item_number(@item_window.item) - @number == 0
    return false if $game_party.item_keep_number(@item_window.item) + @number == $game_party.max_item_keep_number(@item_window.item)
    return true
  end
  #--------------------------------------------------------------------------
  # 引き出せる限界をチェック
  #--------------------------------------------------------------------------
  def limitcheck2
    
    #所持数が既に限界に達している場合、もしくは預けている数が0の場合はfalseを返す。
    
    return false if $game_party.item_number(@item_window.item) - @number == $game_party.max_item_number(@item_window.item)
    return false if $game_party.item_keep_number(@item_window.item) + @number == 0
    return true
  end
  #--------------------------------------------------------------------------
  # 預ける
  #--------------------------------------------------------------------------
  def keep_exe(item, amount)
    
    #数量分処理する。
    
    amount.times do
      @number += 1 if limitcheck1
    end
  end
  #--------------------------------------------------------------------------
  # 引き出す
  #--------------------------------------------------------------------------
  def get_exe(item, amount)
    
    #数量分処理する。
    
    amount.times do
      @number -= 1 if limitcheck2
    end
  end
  #--------------------------------------------------------------------------
  # リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    
    #不可視状態の場合はリフレッシュしない。
    
    return false unless self.visible
    
    #数量を更新する。
    
    @last_number = @number
    
    #ウィンドウの内容を消去する。
    
    contents.clear
    create_contents
        
    #アイテム名を描写。
    
    draw_item_name(@item_window.item, 0, 0)
    change_color(system_color)
    draw_text(0, line_height * 1, 80, line_height, "Inventory", 1)
    draw_text(self.contents.width - 80, line_height * 1, 80, line_height, "Storage", 1)
    draw_text(0, line_height * 1, self.contents.width, line_height, "→", 1)
    draw_text(0, line_height * 2, self.contents.width, line_height, "←", 1)
    
    #所持数データを描写。
    
    $game_party.item_number(@item_window.item) + @number == $game_party.max_item_number(@item_window.item) ? change_color(text_color(3)) : change_color(normal_color)
    draw_text(0, line_height * 2, 80, line_height, $game_party.item_number(@item_window.item) - @number, 1)
    $game_party.item_keep_number(@item_window.item) + @number == $game_party.max_item_keep_number(@item_window.item) ? change_color(text_color(3)) : change_color(normal_color)
    draw_text(self.contents.width - 80, line_height * 2, 80, line_height, $game_party.item_keep_number(@item_window.item) + @number, 1)
  end
  #--------------------------------------------------------------------------
  # 数量のみリフレッシュ
  #--------------------------------------------------------------------------
  def refresh_number
    
    #不可視状態の場合はリフレッシュしない。
    
    return false unless self.visible
    
    #最後の数量と現在の数量が異なる場合は数量を更新する。
    
    if @last_number != @number
      Sound.play_cursor
      @last_number = @number
    end
    
    #ウィンドウの内容を消去する。
    
    contents.clear_rect(0, line_height * 2, 80, line_height)
    contents.clear_rect(self.contents.width - 80, line_height * 2, 80, line_height)
    
    #所持数データを描写。
    
    $game_party.item_number(@item_window.item) + @number == $game_party.max_item_number(@item_window.item) ? change_color(text_color(3)) : change_color(normal_color)
    draw_text(0, line_height * 2, 80, line_height, $game_party.item_number(@item_window.item) - @number, 1)
    $game_party.item_keep_number(@item_window.item) + @number == $game_party.max_item_keep_number(@item_window.item) ? change_color(text_color(3)) : change_color(normal_color)
    draw_text(self.contents.width - 80, line_height * 2, 80, line_height, $game_party.item_keep_number(@item_window.item) + @number, 1)
  end
end
class Window_IKDescription < Window_Base
  def initialize
    
    #ウィンドウを生成する。
    
    super(Graphics.width / 2 - 240, Graphics.height / 3 * 2, 480, 96)
    
    #設定に応じて背景透明度を変更する。
    
    self.back_opacity = ITEM_KEEPER::B_OPACITY
    
    #システムカラーで項目部分を描画する。
    
    change_color(system_color)
    
    draw_text(0, 0, self.contents.width / 2, line_height, ITEM_KEEPER::D[0][0], 0)
    draw_text(self.contents.width / 2, 0, self.contents.width / 2, line_height, ITEM_KEEPER::D[1][0], 0)
    draw_text(0, line_height * 1, self.contents.width / 2, line_height, ITEM_KEEPER::D[2][0], 0)
    draw_text(self.contents.width / 2, line_height * 1, self.contents.width / 2, line_height, ITEM_KEEPER::D[3][0], 0)
    draw_text(0, line_height * 2, self.contents.width / 2, line_height, ITEM_KEEPER::D[4][0], 0)
    draw_text(self.contents.width / 2, line_height * 2, self.contents.width / 2, line_height, ITEM_KEEPER::D[5][0], 0)

    #通常カラーで項目部分を描画する。
    
    change_color(normal_color)
    
    draw_text(90, 0, self.contents.width / 2, line_height, ITEM_KEEPER::D[0][1], 0)
    draw_text(self.contents.width / 2 + 90, 0, self.contents.width / 2, line_height, ITEM_KEEPER::D[1][1], 0)
    draw_text(90, line_height * 1, self.contents.width / 2, line_height, ITEM_KEEPER::D[2][1], 0)
    draw_text(self.contents.width / 2 + 90, line_height * 1, self.contents.width / 2, line_height, ITEM_KEEPER::D[3][1], 0)
    draw_text(90, line_height * 2, self.contents.width / 2, line_height, ITEM_KEEPER::D[4][1], 0)
    draw_text(self.contents.width / 2 + 90, line_height * 2, self.contents.width / 2, line_height, ITEM_KEEPER::D[5][1], 0)
    
    hide
  end
end
class Game_Interpreter
  #--------------------------------------------------------------------------
  # 倉庫画面を呼び出し
  #--------------------------------------------------------------------------
  def call_keep
    
    #呼び出しを実行。
    
    SceneManager.call(Scene_Item_Keep)
    
    #一時的に実行を停止。
    
    Fiber.yield
    
  end
  #--------------------------------------------------------------------------
  # アイテムを預けている数を指定変数に取得
  #--------------------------------------------------------------------------
  def item_keep_get(vid,id)
    
    #武器の預けている数を取得。
    
    item = $data_items[id]
    
    #倉庫に格納
    
    $game_variables[vid] = $game_party.item_keep_number(item)
    
  end
  #--------------------------------------------------------------------------
  # 武器を預けている数を指定変数に取得
  #--------------------------------------------------------------------------
  def weapon_keep_get(vid,id)
    
    #武器の預けている数を取得。
    
    item = $data_weapons[id]
    
    #倉庫に格納
    
    $game_variables[vid] = $game_party.item_keep_number(item)
    
  end
  #--------------------------------------------------------------------------
  # 防具を預けている数を指定変数に取得
  #--------------------------------------------------------------------------
  def armor_keep_get(vid,id)
    
    #武器の預けている数を取得。
    
    item = $data_armors[id]
    
    #倉庫に格納
    
    $game_variables[vid] = $game_party.item_keep_number(item)
    
  end
  #--------------------------------------------------------------------------
  # アイテムを全て預ける/引き出す
  #--------------------------------------------------------------------------
  def item_keep_all(data)
    
    #種類をアイテムとする。
    
    item_data = $data_items
    
    #共通処理を実行。
    
    common_keep_all(item_data, data)
  end
  #--------------------------------------------------------------------------
  # 武器を全て預ける/引き出す
  #--------------------------------------------------------------------------
  def weapon_keep_all(data)
    
    #種類を武器とする。
    
    item_data = $data_weapons
    
    #共通処理を実行。
    
    common_keep_all(item_data, data)
  end
  #--------------------------------------------------------------------------
  # 防具を全て預ける/引き出す
  #--------------------------------------------------------------------------
  def armor_keep_all(data)
    
    #種類を防具とする。
    
    item_data = $data_armors
    
    #共通処理を実行。
    
    common_keep_all(item_data, data)
  end
  #--------------------------------------------------------------------------
  # 全て預ける/引き出す場合の共通処理を実行
  #--------------------------------------------------------------------------
  def common_keep_all(item_data, data)
    
    #存在するオブジェクトの数分だけ処理。
    
    item_data.each do |i|
      
      #nilの場合は処理しない。
      
      next if i == nil
      
      #預けられないアイテムの場合は処理しない。
      
      next if i.keep_seal_flag
      
      #各種データを取得。
      
      data1 = $game_party.item_number(i)
      data2 = $game_party.max_item_number(i)
      data3 = $game_party.item_keep_number(i)
      data4 = $game_party.max_item_keep_number(i)
      
      #追加で所持できる数と、追加で預けられる数を計算。
      
      data5 = data4 - data3
      data6 = data2 - data1
      
      #処理内容に応じて、預ける場合と引き出す場合とをそれぞれ処理。
      
      amount = data == 0 ? (data5 < data1 ? data5 : data1) : (data6 < data3 ? -data6 : -data3)
      $game_party.item_keep(i, amount)
      
    end
  end
  #--------------------------------------------------------------------------
  # アイテムを一定個数預ける/引き出す
  #--------------------------------------------------------------------------
  def item_keep(data_a, data_b)
    
    #種類をアイテムとする。
    
    item_data = $data_items
    
    #共通処理を実行。
    
    common_keep(item_data, data_a, data_b)
    
  end
  #--------------------------------------------------------------------------
  # 武器を一定個数預ける/引き出す
  #--------------------------------------------------------------------------
  def weapon_keep(data_a, data_b)
    
    #種類を武器とする。
    
    item_data = $data_weapons
    
    #共通処理を実行。
    
    common_keep(item_data, data_a, data_b)
    
  end
  #--------------------------------------------------------------------------
  # 防具を一定個数預ける/引き出す
  #--------------------------------------------------------------------------
  def armor_keep(data_a, data_b)
    
    #種類を防具とする。
    
    item_data = $data_armors
    
    #共通処理を実行。
    
    common_keep(item_data, data_a, data_b)
    
  end
  #--------------------------------------------------------------------------
  # 一定個数預ける/引き出す場合の共通処理を実行します。
  #--------------------------------------------------------------------------
  def common_keep(item_data, data_a, data_b)
      
    #nilの場合は処理しない。
      
    return if item_data[data_b] == nil
      
    #預けられないアイテムの場合は処理しない。
    
    return if item_data[data_b].keep_seal_flag
      
    #各種データを取得。
    
    data1 = $game_party.item_number(item_data[data_b])
    data2 = $game_party.max_item_number(item_data[data_b])
    data3 = $game_party.item_keep_number(item_data[data_b])
    data4 = $game_party.max_item_keep_number(item_data[data_b])
      
    #追加で所持できる数と、追加で預けられる数を計算。
      
    data5 = data4 - data3
    data6 = data2 - data1
    
    #処理内容に応じて、預ける場合と引き出す場合とをそれぞれ処理。
    
    amount = data_a == 0 ? (data5 < data1 ? data5 : data1) : (data6 < data3 ? -data6 : -data3)
    $game_party.item_keep(item_data[data_b], amount)
    
  end
  #--------------------------------------------------------------------------
  # 特定ワードを含む単語を全て預ける/引き出す場合の処理を行う。
  #--------------------------------------------------------------------------
  def word_keep_all(data_a, data_b)
    
    #アイテム・武器・防具全てを含める配列を生成。
    
    item_data = $data_items + $data_weapons + $data_armors
    
    #存在するオブジェクトの数分だけ処理。
    
    item_data.each do |i|
      
      #nilの場合は処理しない。
      
      next if i == nil
      
      #預けられないアイテムの場合は処理しない。
      
      next if i.keep_seal_flag
      
      #指定されたワードがメモ欄に含まれていない場合は処理しない。
      
      next unless i.note.include?(data_b)
      
      #各種データを取得。
      
      data1 = $game_party.item_number(i)
      data2 = $game_party.max_item_number(i)
      data3 = $game_party.item_keep_number(i)
      data4 = $game_party.max_item_keep_number(i)
      
      #追加で所持できる数と、追加で預けられる数を計算。
      
      data5 = data4 - data3
      data6 = data2 - data1
      
      #処理内容に応じて、預ける場合と引き出す場合とをそれぞれ処理。
      
      amount = data_a == 0 ? (data5 < data1 ? data5 : data1) : (data6 < data3 ? -data6 : -data3)
      $game_party.item_keep(i, amount)
      
    end
  end
end
if ITEM_KEEPER::SHOP
class Game_Party < Game_Unit
  attr_accessor :shop_ik
  #--------------------------------------------------------------------------
  # 預かり所モードかどうかを確認
  #--------------------------------------------------------------------------
  def shop_ik?
    @shop_ik
  end
  #--------------------------------------------------------------------------
  # 全てのアイテムオブジェクトの配列取得
  #--------------------------------------------------------------------------
  alias all_items_ik all_items
  def all_items
    
    #預かり所モードでなければ、本来の処理を行う。
    
    return all_items_ik unless $game_party.shop_ik?
    
    #アイテム・武器・防具の預かり所データを取得し、まとめる。
    
    data1 = @items_k.keys.sort.collect {|id| $data_items[id] }
    data2 = @weapons_k.keys.sort.collect {|id| $data_weapons[id] }
    data3 = @armors_k.keys.sort.collect {|id| $data_armors[id] }
    data1 + data2 + data3
  end
  #--------------------------------------------------------------------------
  # アイテムのクラスに対応するコンテナオブジェクトを取得
  #--------------------------------------------------------------------------
  alias item_container_ik item_container
  def item_container(item_class)
    
    #預かり所モードでなければ、本来の処理を行う。
    
    return item_container_ik(item_class) unless $game_party.shop_ik?
    
    #預かり所モードの場合に限り、預かり所データを返す。
    
    return @items_k   if item_class == RPG::Item
    return @weapons_k if item_class == RPG::Weapon
    return @armors_k  if item_class == RPG::Armor
    return nil
  end
  #--------------------------------------------------------------------------
  # アイテムの所持数取得
  #--------------------------------------------------------------------------
  alias item_number_ik item_number
  def item_number(item)
    
    #預かり所モードでなければ、本来の処理を行う。
    
    return item_number_ik(item) unless $game_party.shop_ik?
    
    #預かり所のデータを返す。
    
    item_keep_number(item)
  end
  #--------------------------------------------------------------------------
  # アイテムの最大所持数取得
  #--------------------------------------------------------------------------
  alias max_item_number_ik max_item_number
  def max_item_number(item)
    
    #預かり所モードでなければ、本来の処理を行う。
    
    return max_item_number_ik(item) unless $game_party.shop_ik?
    
    #預かり所のデータを返す。
    
    max_item_keep_number(item)
  end
end
class Scene_Shop < Scene_MenuBase
  #--------------------------------------------------------------------------
  # モードチェンジ
  #--------------------------------------------------------------------------
  def item_keep_mode_change
    
    #ナンバーウィンドウがアクティブの場合は実行しない。
    
    return if @number_window.active
    
    #指定スイッチのIDが0より大きく、そのスイッチがONの場合は実行しない。
    
    return if ITEM_KEEPER::SWITCH1 > 0 && $game_switches[ITEM_KEEPER::SWITCH1]
    
    #預かり所フラグを切り替える。
    
    $game_party.shop_ik = $game_party.shop_ik? ? false : true
    
    #切り替えを示すウィンドウを表示。
    
    w = 400
    h = 48
    x = (Graphics.width - w) / 2
    y = (Graphics.height - h) / 2
    RPG::SE.new(ITEM_KEEPER::SE[0],ITEM_KEEPER::SE[1],ITEM_KEEPER::SE[2]).play
    @mode_change_window = Window_Base.new(x, y, w, h)
    @mode_change_window.back_opacity = 255
    @mode_change_window.z = 10000
    text = $game_party.shop_ik ? ITEM_KEEPER::TEXT2 : ITEM_KEEPER::TEXT1
    @mode_change_window.draw_text(0, 0, w - 32, 24, text, 1)
    60.times {Graphics.update}
    @mode_change_window.dispose
    @mode_change_window = nil
    
    #各ウィンドウをリフレッシュする。
    
    @status_window.refresh
    @buy_window.refresh
    @sell_window.refresh
    @sell_window.index = 0 if @sell_window.active
    @number_window.refresh
  end
  #--------------------------------------------------------------------------
  # フレーム更新
  #--------------------------------------------------------------------------
  alias update_ik update unless $!
  def update
    
    #本来の処理を実行。
    
    update_ik
    
    #指定したキーが押された場合、モードチェンジ実行。
    
    item_keep_mode_change if Input.trigger?(ITEM_KEEPER::KEY)
  end
end
class Window_ShopBuy < Window_Selectable
  #--------------------------------------------------------------------------
  # アイテムを許可状態で表示するかどうか
  #--------------------------------------------------------------------------
  alias enable_ik? enable?
  def enable?(item)
    
    #本来の処理を実行。
    
    flag1 = enable_ik?(item)
    
    #預かり所モードの場合、預かり所禁止アイテムは購入不可。
    
    flag2 = $game_party.shop_ik? ? !item.keep_seal_flag : true
    
    #どちらの条件も満たす場合のみ表示。
    
    flag1 && flag2
  end
end
class Window_ShopStatus < Window_Base
  #--------------------------------------------------------------------------
  # 所持数の描画
  #--------------------------------------------------------------------------
  alias draw_possession_ik draw_possession
  def draw_possession(x, y)
    
    #預かり所モードでなければ、本来の処理を行う。
    
    return draw_possession_ik(x, y) unless $game_party.shop_ik?
    
    #本来の処理を少し改変した物を実行。
    
    rect = Rect.new(x, y, contents.width - 4 - x, line_height)
    change_color(system_color)
    draw_text(rect, ITEM_KEEPER::SHOP_POS)
    change_color(normal_color)
    draw_text(rect, $game_party.item_keep_number(@item), 2)
  end
end
class Window_ShopNumber < Window_Selectable
  #--------------------------------------------------------------------------
  # 個数表示の最大桁数を取得
  #--------------------------------------------------------------------------
  alias figures_ik figures
  def figures
    
    #3桁以上を考慮して預かり所モードの場合は補正をかける。
    
    figures_ik + ($game_party.shop_ik? ? ITEM_KEEPER::SHOP_FIG : 0)
  end
end
class Scene_MenuBase < Scene_Base
  #--------------------------------------------------------------------------
  # 終了処理
  #--------------------------------------------------------------------------
  alias terminate_ik terminate
  def terminate
    
    #預かり所モードフラグを消去。
    
    $game_party.shop_ik = nil
    
    #本来の処理を実行。
    
    terminate_ik
  end
end
end