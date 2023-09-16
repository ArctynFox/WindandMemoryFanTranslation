#==============================================================================
# ■ RGSS3 簡易アイテム合成ショップ Ver1.04　by 星潟
#------------------------------------------------------------------------------
# 特定スイッチがONの場合のみ、通常のショップがアイテム合成ショップ化します。
# アイテム合成ショップでは規定のアイテム・武器・防具を合成し
# 新たなアイテムを作成する事が出来ます。
# 基本的に通常のショップの機能を踏襲し
# 合成費用はショップ設定時のアイテムの価格となります。
# 
# なお、日本で配布されているアイテム合成のスクリプトの多くは
# スクリプト上で素材設定を行う物ですが
# 本スクリプトはアイテムのメモ欄で設定するようにしています。
#==============================================================================
# ★合成素材の設定方法
# 合成対象となるアイテムのメモ欄に記載。
# <合成設定:A,B,C>
# Aの部分にアイテムのタイプ(0がアイテム、1が武器、2が防具)
# Bの部分にアイテムのID、
# Cの部分にそのアイテムの必要数をそれぞれ入れる。
# 行を分けていくつでも設定可能だが、表示限界に注意。
#------------------------------------------------------------------------------
# <合成設定:0,1,2>
# 
# アイテムID1番を2個、合成素材リストに追加する。
#------------------------------------------------------------------------------
# <合成設定:1,2,3>
# 
# 武器ID2番を3個、合成素材リストに追加する。
#------------------------------------------------------------------------------
# <合成設定:2,3,4>
# 
# 防具ID3番を4個、合成素材リストに追加する。
#------------------------------------------------------------------------------
# <合成設定:0,1,2>
# <合成設定:1,2,3>
# <合成設定:2,3,4>
# 
# アイテムID1番を2個、武器ID2番を3個、防具ID3番を4個、
# それぞれ合成素材リストに追加する。
# 当然、これら全てが揃っていないと合成出来ない。
#==============================================================================
module EasyCompose
  
  #合成屋の条件となるスイッチIDを指定。
  #このスイッチがONの時、ショップを合成ショップとして扱う。
  
  SID  = 935
  
  #アイテムへの合成設定を行う際のキーワードを指定。
  
  Word = "合成設定"
  
  #合成コマンド名を指定。
  #購入コマンドがこの名称に変化する。
  
  Name = "Exchange"
  
  #装備品の合成素材表示とステータス表示を切り替える為の対応ボタンシンボルを指定。
  #:XでデフォルトAキー。
  #:YでデフォルトSキー。
  #:ZでデフォルトDキー。
  #:ALTでALTキー。
  #:CTRLでCTRLキー。
  #他にもある事にはあるが、基本的に上記5種で他スクリプトと
  #機能上被らない物を推奨とする。
  
  Key  = :X
  
  #材料描写時のフォントサイズを指定。
  #画面サイズ544×416の時は16等の低めの数値を推奨。
  #640×480であればデフォルトサイズの24でも基本的に問題なし。
  
  FS1 = 16
  
  #素材一覧の見出しを設定。
  
  Title = "Candies required:"
  
  #キー入力に関する文章を設定。
  #他の表示と被ったりして不要な場合はText = ""として下さい。
  
  Text = " "
  
  #キー入力に関する文章のフォントサイズを指定。
  
  FS2 = 16
  
  #キー入力に関する文章のテキストカラーを指定。
  #特にウィンドウの画像データや文字色指定を変更していない場合
  #0が通常色（白）、16がシステムカラー（青白）
  
  TC  = 0
  
  #費用0Gの物は費用を描写しないようにするか否かを指定。
  #trueで描写しない。falseで描写する。
  #仕様上、他素材との競合の恐れがあるので注意。
  
  NoDraw = true
  
end
class Window_ShopCommand < Window_HorzCommand
  #--------------------------------------------------------------------------
  # コマンドリストの作成
  #--------------------------------------------------------------------------
  alias make_command_list_easy_compose make_command_list
  def make_command_list
    make_command_list_easy_compose
    return unless $game_switches[EasyCompose::SID]
    a = []
    @list.each_with_index {|c,i| a.push(i) if c[:symbol] == :buy}
    a.each {|i| @list[i][:name] = EasyCompose::Name}
  end
end
class Window_ShopStatus < Window_Base
  attr_accessor :number_window
  attr_reader :compose_mode
  #--------------------------------------------------------------------------
  # オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_easy_compose initialize
  def initialize(x, y, width, height)
    f = $game_switches[EasyCompose::SID] ? true : false
    @compose_mode_main = f
    @compose_mode = f
    initialize_easy_compose(x, y, width, height)
  end
  #--------------------------------------------------------------------------
  # リフレッシュ
  #--------------------------------------------------------------------------
  alias refresh_easy_compose refresh
  def refresh
    refresh_easy_compose
    if @compose_mode_main && @item
      if @item.is_a?(RPG::EquipItem)
        cfc = contents.font.clone
        contents.font.size = EasyCompose::FS2
        contents.font.color = text_color(EasyCompose::TC)
        draw_text(4,line_height,contents_width,line_height,EasyCompose::Text)
        contents.font = cfc
      end
      draw_compose_list(4, line_height * 2)
    end
  end
  #--------------------------------------------------------------------------
  # 装備情報の描画
  #--------------------------------------------------------------------------
  alias draw_equip_info_easy_compose draw_equip_info
  def draw_equip_info(x, y)
    draw_equip_info_easy_compose(x, y) unless @compose_mode
  end
  #--------------------------------------------------------------------------
  # 最大ページ数の取得
  #--------------------------------------------------------------------------
  alias page_max_easy_compose page_max
  def page_max
    (@compose_mode_main && @item && @item.is_a?(RPG::EquipItem) && @compose_mode) ? 1 : page_max_easy_compose
  end
  #--------------------------------------------------------------------------
  # ページの更新
  #--------------------------------------------------------------------------
  alias update_page_easy_compose update_page
  def update_page
    if visible && Input.trigger?(EasyCompose::Key) && @item && @item.is_a?(RPG::EquipItem)
      if $game_switches[EasyCompose::SID]
        Sound.play_cursor
        @compose_mode ^= true
        @page_index = 0
        refresh
      end
    end
    update_page_easy_compose
  end
  #--------------------------------------------------------------------------
  # 合成素材リストの描写
  #--------------------------------------------------------------------------
  def draw_compose_list(x,y)
    return unless @item
    return unless @compose_mode_main
    return if @item.is_a?(RPG::EquipItem) && !@compose_mode
    contents.font.name = ["VL Gothic"]
    cfc = contents.font.clone
    contents.font.size = EasyCompose::FS1
    cw = contents_width - x
    lh = line_height
    change_color(system_color)
    draw_text(x,y,cw,lh,EasyCompose::Title)
    change_color(normal_color)
    i = 0
    @item.easy_compose_item_list.each {|k1,v1|
    v1.each {|k2,v2|
    case k1
    when 0;it = $data_items[k2]
    when 1;it = $data_weapons[k2]
    when 2;it = $data_armors[k2]
    end
    n1 = v2 * number_window_number
    n2 = $game_party.item_number(it)
    yd = y + line_height * (i + 1)
    draw_item_name(it,x,yd,n2 >= n1)
    draw_text(x,yd,cw,lh,sprintf("%s/%s",n1,n2),2)
    i += 1}}
    contents.font = cfc
  end
  #--------------------------------------------------------------------------
  # ナンバーウィンドウのナンバーを取得
  #--------------------------------------------------------------------------
  def number_window_number
    w = @number_window
    (w && w.active) ? w.number : 1
  end
end
class Window_ShopNumber < Window_Selectable
  attr_accessor :status_window
  #--------------------------------------------------------------------------
  # リフレッシュ
  #--------------------------------------------------------------------------
  alias refresh_easy_compose refresh
  def refresh
    refresh_easy_compose
    @status_window.refresh if @status_window && @status_window.compose_mode
  end
end
class Window_ShopBuy < Window_Selectable
  #--------------------------------------------------------------------------
  # アイテムを許可状態で表示するかどうか
  #--------------------------------------------------------------------------
  alias enable_easy_compose? enable?
  def enable?(item)
    enable_easy_compose?(item) && composable?(item)
  end
  #--------------------------------------------------------------------------
  # 合成可否
  #--------------------------------------------------------------------------
  def composable?(item)
    return true unless $game_switches[EasyCompose::SID]
    item.easy_compose_item_list.each {|k1,v1|
    v1.each {|k2,v2|
    case k1
    when 0;it = $data_items[k2]
    when 1;it = $data_weapons[k2]
    when 2;it = $data_armors[k2]
    end
    n1 = v2
    n2 = $game_party.item_number(it)
    return false unless n2 / n1 > 0
    }}
    true
  end
  #0Gの物を描写しない場合限定
  if EasyCompose::NoDraw
  #--------------------------------------------------------------------------
  # 項目の描画
  #--------------------------------------------------------------------------
  alias draw_item_easy_compose draw_item
  def draw_item(index)
    item = @data[index]
    if !$game_switches[EasyCompose::SID] or price(item) > 0
      draw_item_easy_compose(index)
    else
      rect = item_rect(index)
      draw_item_name(item, rect.x, rect.y, enable?(item))
    end
  end
  end
end
class Scene_Shop < Scene_MenuBase
  #--------------------------------------------------------------------------
  # ステータスウィンドウの作成
  #--------------------------------------------------------------------------
  alias create_status_window_easy_compose create_status_window
  def create_status_window
    create_status_window_easy_compose
    return unless $game_switches[EasyCompose::SID]
    @status_window.number_window = @number_window
    @number_window.status_window = @status_window
  end
  #--------------------------------------------------------------------------
  # 最大購入可能個数の取得
  #--------------------------------------------------------------------------
  alias max_buy_easy_compose max_buy
  def max_buy
    r1 = max_buy_easy_compose
    return r1 unless $game_switches[EasyCompose::SID]
    ra = []
    ra.push(r1)
    @item.easy_compose_item_list.each {|k1,v1|
    v1.each {|k2,v2|
    next if v2 <= 0
    case k1
    when 0;n1 = $game_party.item_number($data_items[k2])
    when 1;n1 = $game_party.item_number($data_weapons[k2])
    when 2;n1 = $game_party.item_number($data_armors[k2])
    end
    ra.push(n1 / v2)}}
    ra.min
  end
  #--------------------------------------------------------------------------
  # 購入の実行
  #--------------------------------------------------------------------------
  alias do_buy_easy_compose do_buy
  def do_buy(number)
    if $game_switches[EasyCompose::SID]
      @item.easy_compose_item_list.each {|k1,v1|
      v1.each {|k2,v2|
      next if v2 <= 0
      n = v2 * number
      case k1
      when 0;it = $data_items[k2]
      when 1;it = $data_weapons[k2]
      when 2;it = $data_armors[k2]
      end
      $game_party.lose_item(it,n)}}
    end
    do_buy_easy_compose(number)
  end
end
class RPG::BaseItem
  #--------------------------------------------------------------------------
  # 合成素材リスト
  #--------------------------------------------------------------------------
  def easy_compose_item_list
    @easy_compose_item_list ||= create_easy_compose_item_list
  end
  #--------------------------------------------------------------------------
  # 合成素材リストの作成
  #--------------------------------------------------------------------------
  def create_easy_compose_item_list
    list = {}
    list[0] = {}
    list[1] = {}
    list[2] = {}
    w = EasyCompose::Word
    note.each_line {|l|
    if /#{w}[:：](\d+),(\S+)/ =~ l
      a = [$1.to_i] + $2.to_s.split(/\s*,\s*/).inject([]) {|r,i| r.push(i.to_i)}
      if a[0] < 0 or a[0] > 2
        p @item.name + "の合成リストに範囲外の値が設定されています。"
        p "アイテムタイプは0、1、2の3種類のみ設定が可能です。"
        next
      end
      case a[0]
      when 0;it = $data_items[a[1]]
      when 1;it = $data_weapons[a[1]]
      when 2;it = $data_armors[a[1]]
      end
      unless it
        p @item.name + "の合成リストに存在しないアイテムが含まれています。"
        next
      end
      a.push(1) if a.size == 2
      list[a[0]][a[1]] = a[2]
    end}
    list
  end
end