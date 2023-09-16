#==============================================================================
# ■ RGSS3 レギュラー変数ウィンドウ Ver1.09 by 星潟
#------------------------------------------------------------------------------
# 特定変数をマップ及び戦闘中に表示し続けるウィンドウを作成します。
# ウィンドウのフォントサイズ、幅、高さはもちろん
# スイッチによるウィンドウの表示可否や、各変数項目の表示可否も設定できます。
#------------------------------------------------------------------------------
# Ver1.01 各部への説明を追加。
#         項目内に:afterwordを追加。
#         項目ハッシュ内の:icon_id、:name、:afterwordが
#         省略されていても機能するように仕様を変更。
# Ver1.02 戦闘時に情報ビューポートに表示される物より下に表示されるように変更。
# Ver1.03 戦闘時に使わない場合の処理を修正。
# Ver1.04 表示する変数の種類そのものを指定変数に応じて変更できるように拡張。
#         ビューポート関連の指定ミスを修正。
# Ver1.05 軽量化対策の処理が誤作動して処理の更新を妨げていた致命的不具合を修正。
# Ver1.06 一度切り替えたデータを繰り返し切り替えられない不具合を修正。
# Ver1.07 ゲージ描写機能を追加。
# Ver1.08 表示内容変数に応じて位置・大きさが変えられるように変更。
# Ver1.09 表示内容変数もしくは項目別にフォントサイズが変えられるように変更。
#==============================================================================
module W_REGULAR
  
  #空のハッシュを用意。
  M_W_X  = {}
  M_W_Y  = {}
  B_W_X  = {}
  B_W_Y  = {}
  WIDTH  = {}
  HEIGHT = {}
  ITEM   = {}
  FSIZE  = {}
  
  #マップ上でレギュラー変数ウィンドウを表示するか否かを設定します。
  #true => 使用する/false => 使用しない
  
  M_USE  = true
  
  #マップでのウィンドウ表示許可スイッチを設定します。
  
  M_SID  = 859
  
  #戦闘でレギュラー変数ウィンドウを表示するか否かを設定します。
  #true => 使用する/false => 使用しない
  
  B_USE  = false
  
  #戦闘でのウィンドウ表示許可スイッチを設定します。
  
  B_SID  = 100
  
  #ウィンドウ内に描写する変数の種類を指定する変数IDを設定します。
  
  VID = 0
  
  #ウィンドウ内に記述される文字のフォントサイズを指定します。
  
  FSIZE[0]   = 24
  FSIZE[1]   = 24

  
  #VIDの変数IDに格納されている値に応じてマップでのウィンドウのX座標を指定します。
  
  M_W_X[0]   = 495
  M_W_X[1]   = 495
  
  #VIDの変数IDに格納されている値に応じてマップでのウィンドウのY座標を指定します。
  
  M_W_Y[0]   = 0
  M_W_Y[1]   = 96
  
  #VIDの変数IDに格納されている値に応じて戦闘でのウィンドウのX座標を指定します。
  
  B_W_X[0]   = 400
  
  #VIDの変数IDに格納されている値に応じて戦闘でのウィンドウのY座標を指定します。
  
  B_W_Y[0]   = 200
  
  #VIDの変数IDに格納されている値に応じてウィンドウの幅を設定します。
  
  WIDTH[0]  = 144
  WIDTH[1]  = 144
  
  #VIDの変数IDに格納されている値に応じてウィンドウの高さを設定します。
  
  HEIGHT[0] = 56
  HEIGHT[1] = 56
  
  #ウィンドウ内の項目を設定します。
  #各項目の最後は必ず「,」（鍵括弧は除く）で区切って下さい。
  #配列内のハッシュを追加/削除/設定する事で
  #ウィンドウ内の項目の編集が可能です。
  
  #それぞれの項目は
  #{:icon_id => 1（項目のアイコンID。0を指定するか省略すると
  #                アイコンを描写せず、そのまま項目名を描写する）
  # :name => "項目の名前"（必ず""で囲む。この部分を省略すると描写しない）,
  # :afterword => 1（後付けで表示する変数の値の単位。
  #                  ""を指定するか省略すると描写しない）,,
  # :font_size => 20（フォントサイズ。省略するとFSIZEで設定した値がそのまま適用）
  # :variable_id => 1（表示する変数のID）,
  # :switch_id => 1（表示許可を示すスイッチID。省略すると常時表示）,
  # :x => 0（ウィンドウ内のx座標。省略すると0になる）,
  # :y => 0（ウィンドウ内のy座標。x座標と違い省略不可）,
  # :width => 65（ウィンドウ内での表示幅。
  #               省略するとウィンドウの中身の幅になる。
  #               また、:xとの合計がウィンドウ内の幅を超える時
  #               ウィンドウ幅から:xの値を引いた値に自動調整される）,
  # :name_c => 16（項目の名前を描写する際の文字色。省略すると通常色になる）,
  # :no_value => false（変数値の描写無効設定。
  #                     trueで描写無効、falseか省略で描写有効）
  #}
  #これで1セットとなっています。
  #データ更新の際は、x座標とy座標、そして表示幅とフォントサイズを元に
  #その領域を消去する仕様になっており、処理は比較的軽めに抑えてありますが
  #複数項目で領域をかぶせた場合、片方の更新の際に
  #もう片方の表示の一部が消えてしまう可能性がありますので
  #表示領域を被せないように微調整してやって下さい。
  
  #Ver1.07よりゲージ描写も可能になりました。
  #基本的にゲージは項目内領域の右上を基準位置として描写されます。
  #ゲージ描写の場合は以下のような形で指定して下さい。
  #{:icon_id => 1（項目のアイコンID。0を指定するか省略すると
  #                アイコンを描写せず、そのまま項目名を描写する）
  # :name => "項目の名前"（必ず""で囲む。""を指定するか省略すると描写しない）,
  # :afterword => 1（後付けで表示する変数の値の単位。
  #                  ""を指定するか省略すると描写しない）,,
  # :font_size => 20（フォントサイズ。省略するとFSIZEで設定した値がそのまま適用）
  # :variable_id => 1（表示する変数のID）,
  # :switch_id => 1（表示許可を示すスイッチID。省略すると常時表示）,
  # :x => 0（ウィンドウ内のx座標。省略すると0になる）,
  # :y => 0（ウィンドウ内のy座標。x座標と違い省略不可）,
  # :width => 65（ウィンドウ内での表示幅。
  #               省略するとウィンドウの中身の幅になる。
  #               また、:xとの合計がウィンドウ内の幅を超える時
  #               ウィンドウ幅から:xの値を引いた値に自動調整される）
  # :name_c => 16（項目の名前を描写する際の文字色。省略すると通常色になる）,
  # :no_value => false（変数値の描写無効設定。
  #                     trueで描写無効、falseか省略で描写有効）,
  # :gauge_color1 => [128,64,32]（ゲージ左端の色。
  #                               省略すると:gauge_color2の設定が使用される。
  #                               どちらも設定しない場合ゲージ無効）,
  # :gauge_color2 => [255,128,64]（ゲージ右端の色。
  #                                省略すると:gauge_color1の設定が使用される。
  #                                どちらも設定しない場合ゲージ無効）,
  # :gauge_color3 => [32,16,8]（ゲージ下地の色。省略すると描写しない）,
  # :gauge_x => 0（ゲージ用のX座標補正値。省略すると0扱い）,
  # :gauge_y => 0（ゲージ用のY座標補正値。省略すると0扱い）,
  # :gauge_min => 0（ゲージ用の変数最小値。省略するとゲージ無効）,
  # :gauge_max => 100（ゲージ用の変数最大値。省略するとゲージ無効）,
  # :gauge_width => 50（ゲージの幅。省略すると項目の幅がそのまま適用）,
  # :gauge_height => 8（ゲージの高さ。省略すると項目の高さがそのまま適用）
  #}
  
  #VIDの変数IDに格納されている値が0の時
  
  ITEM[0] = [
  {:icon_id => 0,:name => "Layer:",:afterword => "",:variable_id => 119,:switch_id => 859,:x => 0,:y => 0,:width => 119,:name_c => 16},
]
  
end
class Scene_Base
  #--------------------------------------------------------------------------
  # レギュラーウィンドウを設定
  #--------------------------------------------------------------------------
  def create_regular_window
    @regular_window = Window_Regular.new
  end
end
class Window_Regular < Window_Base
  #--------------------------------------------------------------------------
  # 初期化
  #--------------------------------------------------------------------------
  def initialize
    
    #設定データからウィンドウを生成。
    
    super(x, y, width, height)
    
    #Z座標を指定。
    
    self.z = 10000
    
    #全ての項目を記述。
    
    draw_all_item
    
    #可視フラグから可視状態を変更。
    
    self.visible = visible_flag
  end
  #--------------------------------------------------------------------------
  # ウィンドウのX座標を指定
  #--------------------------------------------------------------------------
  def x
    
    #マップか戦闘中かでX座標を変更。
    #どちらでもない場合はとりあえず0を返す。
    
    return W_REGULAR::M_W_X[$game_variables[W_REGULAR::VID]] if SceneManager.scene_is?(Scene_Map)
    return W_REGULAR::B_W_X[$game_variables[W_REGULAR::VID]] if SceneManager.scene_is?(Scene_Battle)
    0
  end
  #--------------------------------------------------------------------------
  # ウィンドウのY座標を指定
  #--------------------------------------------------------------------------
  def y
    
    #マップか戦闘中かでY座標を変更。
    #どちらでもない場合はとりあえず0を返す。
    
    return W_REGULAR::M_W_Y[$game_variables[W_REGULAR::VID]] if SceneManager.scene_is?(Scene_Map)
    return W_REGULAR::B_W_Y[$game_variables[W_REGULAR::VID]] if SceneManager.scene_is?(Scene_Battle)
    0
  end
  #--------------------------------------------------------------------------
  # 可視フラグを取得
  #--------------------------------------------------------------------------
  def visible_flag
    
    #マップか戦闘中かで可視フラグ判定用スイッチを変更。
    #どちらでもない場合はとりあえずfalseを返す。
    
    return $game_switches[W_REGULAR::M_SID] if SceneManager.scene_is?(Scene_Map)
    return $game_switches[W_REGULAR::B_SID] if SceneManager.scene_is?(Scene_Battle)
    false
  end
  #--------------------------------------------------------------------------
  # ウィンドウの幅を指定
  #--------------------------------------------------------------------------
  def width
    
    #設定データから幅を取得。
    
    W_REGULAR::WIDTH[$game_variables[W_REGULAR::VID]]
  end
  #--------------------------------------------------------------------------
  # ウィンドウの高さを指定
  #--------------------------------------------------------------------------
  def height
    
    #設定データから高さを取得。
    
    W_REGULAR::HEIGHT[$game_variables[W_REGULAR::VID]]
  end
  #--------------------------------------------------------------------------
  # 全ての項目を描写
  #--------------------------------------------------------------------------
  def draw_all_item
    
    @last_type = $game_variables[W_REGULAR::VID]
    
    #全項目のデータ取得用配列を生成。
    
    @item_variables = []
    
    #項目別のデータを取得し、個別リフレッシュを実行。
    
    cw = contents_width
    items.each_with_index {|item, i_data|
    ix = item[:x] ? item[:x] : 0
    iw = item[:width] ? item[:width] : cw
    iw = cw - ix if ix + iw > cw
    rect = Rect.new(ix, item[:y], iw, item[:font_size] ? item[:font_size] : W_REGULAR::FSIZE[$game_variables[W_REGULAR::VID]])
    s_id = item[:switch_id]
    v_id = item[:variable_id]
    @item_variables.push([s_id ? $game_switches[s_id] : true, $game_variables[v_id],[rect]])
    part_refresh(i_data, true)}
  end
  def items
    
    #変数タイプ別の配列を取得。
    #取得出来ない場合や正常な配列ではない場合は空の配列にする。
    
    a = W_REGULAR::ITEM[@last_type]
    a && a.is_a?(Array) ? a : []
  end
  #--------------------------------------------------------------------------
  # 更新
  #--------------------------------------------------------------------------
  def update
    
    #スーパークラスの処理を実行。
    
    super
    
    #現在の可視状態が可視フラグと異なる時
    #全項目を再描写した上で処理を中断する。
    
    #可視フラグを取得。
    
    vf = visible_flag
    
    #変数タイプを取得。
    
    vd = $game_variables[W_REGULAR::VID]
    
    #現在の可視状態と可視フラグ、現在の変数タイプと指定された変数タイプの
    #どちらかが異なる場合は全体再描写。
    #そうでない場合は個別リフレッシュを行う。
    
    if !(self.visible == vf && @last_vid == vd)
      move(x,y,width,height)
      create_contents
      self.visible = vf
      @last_vid = vd
      draw_all_item
    else
      @item_variables.each_index {|i_data| part_refresh(i_data)}
    end
  end
  #--------------------------------------------------------------------------
  # 各項目のリフレッシュ
  #--------------------------------------------------------------------------
  def part_refresh(i_data, first = false)
    
    #各項目のデータを取得。
    
    a = items[i_data]
    b = @item_variables[i_data]
    
    #スイッチID、変数IDを取得
    
    s_id = a[:switch_id]
    v_id = a[:variable_id]
    
    #初回描写ではなく、表示フラグに変更がなく、変数の変更もない場合は
    #リフレッシュを行わない。
    
    s = s_id ? $game_switches[s_id] : true
    v = $game_variables[v_id]
    
    return if !first && s == b[0] && v == b[1]
    
    #項目描写範囲の矩形を取得。
    
    rect = b[2][0]
    
    #項目データを最新のデータに変更する。
    
    @item_variables[i_data] = [s, v,[rect]]
    
    #項目描写範囲内の既存の描写を消去する。
    
    self.contents.clear_rect(rect)
    
    #フォントサイズを変更する。
    
    self.contents.font.size = a[:font_size] ? a[:font_size] : W_REGULAR::FSIZE[$game_variables[W_REGULAR::VID]]
    
    #表示フラグがOFFの場合、処理を中断する。
    
    return if !s
    
    #ゲージ描写の実行。
    
    if (a[:gauge_color1] or a[:gauge_color2]) && a[:gauge_max] && a[:gauge_min]
      gxa = a[:gauge_x] ? a[:gauge_x] : 0
      gya = (a[:gauge_y] && a[:gauge_y] > 0) ? a[:gauge_y] : 0
      gw = a[:gauge_width] ? a[:gauge_width] : rect.width
      gw = rect.width if gw > rect.width
      gh = a[:gauge_height] ? a[:gauge_height] : rect.height
      gh = rect.height if gh > rect.height
      gx = rect.width - gw + gxa
      gx = 0 if gx < 0
      gx = rect.width - gw if gx + gw > rect.width
      gy = rect.y + gya
      rectymax = rect.y + rect.height
      gy = rect.y + rect.height - gh if gy + gh > rectymax
      grect = Rect.new(gx,gy,gw,gh)
      c1 = a[:gauge_color1] ? a[:gauge_color1] : a[:gauge_color2]
      c2 = a[:gauge_color2] ? a[:gauge_color2] : a[:gauge_color1]
      gmax = a[:gauge_max]
      gmin = a[:gauge_min]
      gvmax = gmax - gmin
      gvmax = 1 if gvmax < 1
      gv = v - gmin
      gv = 0 if gv < 0
      gv = gvmax if gv > gvmax
      gvw = (gw * gv.to_f / gvmax).to_i
      c3 = a[:gauge_color3]
      contents.gradient_fill_rect(grect, Color.new(c1[0],c1[1],c1[2]), Color.new(c2[0],c2[1],c2[2]))
      if gvw < gw
        if c3
          contents.fill_rect(gx + gvw, gy, gw - gvw, gh, Color.new(c3[0],c3[1],c3[2]))
        else
          contents.clear_rect(gx + gvw, gy, gw - gvw, gh)
        end
      end
    end
    
    #アイコンID設定がされており、なおかつIDが0でない場合は
    #アイコンを描写する。
    
    if a[:icon_id] != nil && a[:icon_id] != 0
      draw_icon(a[:icon_id], rect.x, rect.y)
      
      #矩形を複製する。
      
      rect2 = rect.clone
      
      #項目名が設定されており、なおかつ設定内容が空でない場合は項目名を描写する。
      
      if a[:name] != nil && a[:name] != ""
        
        #複製した矩形のx座標をアイコン分ずらす。
        
        rect2.x += 24
        
        #変更を行った矩形情報を用いて
        #指定色で項目名を描写する。
        
        self.contents.font.color = text_color(a[:name_c] ? a[:name_c] : 0)
        draw_text(rect2, a[:name], 0)
        
      end
    else
      
      #項目名が設定されており、なおかつ設定内容が空でない場合は項目名を描写する。
      
      if a[:name] != nil && a[:name] != ""
        
        #指定色で項目名を描写する。
        
        self.contents.font.color = text_color(a[:name_c] ? a[:name_c] : 0)
        draw_text(rect, a[:name], 0)
        
      end
    end
    
    #文字描写色を元に戻す。
    
    self.contents.font.color = normal_color
    
    #値を描写しない場合はここで終了。
    
    return if a[:no_value]
    
    #描写する変数の値を文字列として取得。
    
    text = v.to_s
    
    #単位が設定されており、なおかつ空でない場合は
    #変数の文字列の後に単位の文字列を加える。
    
    text += a[:afterword] if a[:afterword] != nil && a[:afterword] != ""
    
    #矩形情報を元に文字列を描写する。
    
    draw_text(rect, text, 2)
  end
end
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # 全ウィンドウの作成
  #--------------------------------------------------------------------------
  alias create_all_windows_rw create_all_windows
  def create_all_windows
    
    #本来の処理を実行する。
    
    create_all_windows_rw
    
    #レギュラー変数ウィンドウをマップで使用する設定の場合は作成する。
    
    create_regular_window if W_REGULAR::M_USE
  end
end
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # 全ウィンドウの作成
  #--------------------------------------------------------------------------
  alias create_all_windows_rw create_all_windows
  def create_all_windows
    
    #本来の処理を実行する。
    
    create_all_windows_rw
    
    #レギュラーウィンドウを戦闘で使用する設定の場合は作成する。
    
    if W_REGULAR::B_USE
      
      #レギュラーウィンドウ用ビューポートを作成。
      
      create_regular_viewport
      
      #ウィンドウを作成。
      
      create_regular_window
      
      #ウィンドウにビューポートを設定。
      
      @regular_window.viewport = @regular_window_viewport
    end
  end
  #--------------------------------------------------------------------------
  # レギュラーウィンドウ用ビューポート作成
  #--------------------------------------------------------------------------
  def create_regular_viewport
    
    #ビューポートを作成。
    
    @regular_window_viewport = Viewport.new
    
    #ビューポートの座標は情報ビューポートより1低い座標にする。
    
    @regular_window_viewport.z = @info_viewport.z - 1
  end
  #--------------------------------------------------------------------------
  # スプライトセットの解放
  #--------------------------------------------------------------------------
  alias dispose_spriteset_rw dispose_spriteset
  def dispose_spriteset
    
    #本来の処理を実行。
    
    dispose_spriteset_rw
    
    #レギュラーウィンドウ用ビューポートを解放。
    
    @regular_window_viewport.dispose if W_REGULAR::B_USE
  end
end