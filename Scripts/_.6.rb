=begin #=======================================================================
  
◆◇入手インフォメーション＋マップエフェクトベース RGSS3◇◆ ※starさんの移植品
　★-----更にカスタマイズを施したバージョン

◆VX Ace移植◆
◆DEICIDE ALMA
◆レーネ　
◆http://blog.goo.ne.jp/exa_deicide_alma

◆カスタマイズ◆
◆Jun.A

★変更点(移植版)

  インフォの文章はヘルプの１行目の文章になります。
  (<info:任意の文字列>で指定した場合はそちらを優先)
  
  GET = true ならインフォを出したアイテムを入手します。
  (アイテム、武器、防具、お金が対象)

★変更点(カスタマイズ版 / Jun.A)

  指定スイッチをオンにした状態で、アイテム・武器・防具・スキル・お金・経験値を
  入手したり失ったりすると、自動で情報を表示するようにしました。
  
  なお、コマンドスクリプトから書き出す場合、スイッチを無視して表示されます。

  また、テキスト出力に対応しました。
  簡単な情報をテキスト出力したいときに便利かと思います。
  
  (注意)
    コマンドスクリプトで経験値増減・スキル習得を呼び出した場合、
    表示されるだけで、実際には増減・習得しません。別途スクリプト必須です。
    コマンド「経験値の増減」「スキルの増減」から呼び出した場合には自動習得します。

◆導入箇所
▼素材のところ、mainより上
　ひきも記(tomoaky)さんのアイコンポップスクリプトが競合するため、
　アイコンポップスクリプトはこのスクリプトの下に配置してください。

=end #=========================================================================
#==============================================================================
# ★RGSS2 
# STEMB_マップエフェクトベース v0.8
# 
# ・エフェクト表示のための配列定義、フレーム更新、ビューポート関連付け
#
#==============================================================================
# ★RGSS2 
# STR20_入手インフォメーション v1.2 09/03/17
# 
# ・マップ画面にアイテム入手・スキル修得などの際に表示するインフォです。
# ・表示内容は 任意指定の名目+アイテム名+ヘルプメッセージとなります。
# ・アイテムのメモ欄に <info:任意の文字列> と記述することで
# 　通常とは別の説明文をインフォに表示させることができます。
# [仕様]インフォが表示されている間も移動できます。
# 　　　移動させたくない場合はウェイトを入れてください。
#
#==============================================================================

# 追加モジュール
module CUSTOM_GET_WINDOW
  DISPLAY_FLAG = 22
  GOLD_TEXT_ADD      = "Souls GET!"      #お金を入手した際の表示テキスト
  GOLD_TEXT_REMOVE   = "Souls lost…"      #お金を消失した際の表示テキスト
  ITEM_TEXT_ADD      = "Item GET!"  #アイテムを入手した際の表示テキスト
  ITEM_TEXT_REMOVE   = "Item lost…"  #アイテムを消失した際の表示テキスト
  WEAPON_TEXT_ADD    = "Weapon GET!"      #武器を入手した際の表示テキスト
  WEAPON_TEXT_REMOVE = "Weapon lost…"      #武器を消失した際の表示テキスト
  ARMOR_TEXT_ADD     = "Armor GET!"      #防具を入手した際の表示テキスト
  ARMOR_TEXT_REMOVE  = "Armor lost…"      #防具を消失した際の表示テキスト
  SKILL_TEXT_ADD     = "Skill learned!"    #スキルを習得した際の表示テキスト
  SKILL_TEXT_REMOVE  = "Skill forgotten…"    #スキルを忘れた際の表示テキスト
  EXP_TEXT_ADD       = "EXP GET!"       #EXPを入手した際の表示テキスト
  EXP_TEXT_REMOVE    = "EXP lost…"       #EXPを消失した際の表示テキスト


end

class Window_Getinfo < Window_Base
  # 設定箇所
  #G_ICON  = 260   # ゴールド入手インフォに使用するアイコンインデックス 
  G_ICON  = 120   # ゴールド入手インフォに使用するアイコンインデックス 
  T_ICON  = 125   # テキスト表示インフォに使用するアイコンインデックス 
  Y_TYPE  = 1     # Y座標の位置(0 = 上基準　1 = 下基準)
  Z       = 188   # Z座標(問題が起きない限り変更しないでください)
  TIME    = 180   # インフォ表示時間(1/60sec)
  OPACITY = 32    # 透明度変化スピード
  B_COLOR = Color.new(0, 0, 0, 160)        # インフォバックの色
  INFO_SE = RPG::SE.new("magic1", 80, 80) # インフォ表示時の効果音
  
  #STR20W  = /info\[\/(.*)\/\]/im # メモ設定ワード(VXと同じ)
  STR20W  = /<info:(.*?)>/im      # メモ設定ワード
  
  GET = true # インフォを出したアイテムを入手するかどうか(スキルは除く)
end
#
if false
# ★以下をコマンドのスクリプト等に貼り付けてテキスト表示----------------★

# 種類 / 0=ｱｲﾃﾑ 1=武器 2=防具 3=ｽｷﾙ 4=金 5=テキスト(新規対応)
type = 0
# ID  / 金の場合は金額を入力
id   = 1
# 入手テキスト / 金の場合無効
text = "アイテム入手！"
# 増減(数) / プラス・マイナス両対応 
value = 1
e = $game_temp.streffect
e.push(Window_Getinfo.new(id, type, text, value))
# ★ここまで------------------------------------------------------------★
# □ 追加でテキスト機能を追加。

# 種類 / 0=ｱｲﾃﾑ 1=武器 2=防具 3=ｽｷﾙ 4=金 5=テキスト(新規対応)
type = 0
# ID / 大きく表示される部分のテキスト
id   = "テストコメント"
# テキスト / 小さく表示される部分のテキスト
text = "ミニインフォメーション"
# 意味はありませんが、必ずvalueにゼロを記してください
# ※無いとミニインフォが表示されません
value = 0
#
e = $game_temp.streffect
e.push(Window_Getinfo.new(id, type, text))
# ★ここまで------------------------------------------------------------★
#
# ◇スキル修得時などにアクター名を直接打ち込むと
# 　アクターの名前が変えられるゲームなどで問題が生じます。
# 　なので、以下のようにtext部分を改造するといいかもしれません。
#
# 指定IDのアクターの名前取得
t = $game_actors[1].name 
text = t + " / スキル修得！"
#
end

class Game_Temp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :streffect
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_stref initialize
  def initialize
    initialize_stref
    @streffect = []
  end
end

class Spriteset_Map
  #--------------------------------------------------------------------------
  # ● エフェクトの作成
  #--------------------------------------------------------------------------
  def create_streffect
    $game_temp.streffect = []
  end
  #--------------------------------------------------------------------------
  # ● エフェクトの解放
  #--------------------------------------------------------------------------
  def dispose_streffect
    (0...$game_temp.streffect.size).each do |i|
      $game_temp.streffect[i].dispose if $game_temp.streffect[i] != nil
    end
    $game_temp.streffect = []
  end
  #--------------------------------------------------------------------------
  # ● エフェクトの更新
  #--------------------------------------------------------------------------
  def update_streffect
    (0...$game_temp.streffect.size).each do |i|
      if $game_temp.streffect[i] != nil
        $game_temp.streffect[i].viewport = @viewport1
        $game_temp.streffect[i].update
        $game_temp.streffect.delete_at(i) if $game_temp.streffect[i].disposed?
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 遠景の作成(エイリアス)
  #--------------------------------------------------------------------------
  alias create_parallax_stref create_parallax
  def create_parallax
    create_parallax_stref
    create_streffect
  end
  #--------------------------------------------------------------------------
  # ● 解放(エイリアス)
  #--------------------------------------------------------------------------
  alias dispose_stref dispose
  def dispose
    dispose_streffect
    dispose_stref
  end
  #--------------------------------------------------------------------------
  # ● 更新(エイリアス)
  #--------------------------------------------------------------------------
  alias update_stref update
  def update
    update_stref
    update_streffect
  end
end

class Window_Getinfo < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(id, type, text = "", value)
    #super(-16, 0, 544 + 32, 38 + 32)
    super(-16, 0, 640 + 32, 38 + 32)
    self.z = Z
    self.contents_opacity = 0
    self.back_opacity = 0
    self.opacity = 0
    @value = value
    @count = 0
    @i = $game_temp.getinfo_size.index(nil)
    @i = $game_temp.getinfo_size.size if (@i == nil)
    if Y_TYPE == 0
      self.y = -14 + (@i * 40)
    else
      #self.y = 418 - 58 - (@i * 40)
      self.y = 480 - 58 - (@i * 40)
    end
    $game_temp.getinfo_size[@i] = true 
    refresh(id, type, text, @value)
    #SE発音　タイプチェック　0～3ならvalueを見る　4(お金)ならidを見る
    case type
    when 0..3
      if @value >= 1
        INFO_SE.play
      elsif @value <= -1
        #Sound.play_evasion #減るときは音を鳴らなさい
      end
    when 4
      if id >= 1
        Audio.se_play("Audio/SE/magic1", 80, 80)
      elsif id <= -1
        #Sound.play_evasion #減るときは音を鳴らなさい
      end
    when 5
        Audio.se_play('Audio/SE/Chime1', 80)
    when 6
      if @value >= 1
        INFO_SE.play
      elsif @value <= -1
        #Sound.play_evasion #減るときは音を鳴らなさい
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    $game_temp.getinfo_size[@i] = nil
    super
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    self.viewport = nil
    @count += 1
    unless @count >= TIME
      self.contents_opacity += OPACITY
    else
      if Y_TYPE == 0
        self.y -= 1
      else
        self.y += 1
      end
      self.contents_opacity -= OPACITY
      dispose if self.contents_opacity == 0
    end
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(id, type, text = "", value)
    case type
    when 0 ; data = $data_items[id]
    when 1 ; data = $data_weapons[id]
    when 2 ; data = $data_armors[id]
    when 3 ; data = $data_skills[id]
    when 4 ; data = id
    when 5 ; data = id  #無理やりidに載せたテキストデータをdataに格納してます。
    when 6 ; data = id  #経験値増減の実際の値です。
    else   ; p "typeの値がおかしいです><;"
    end
    c = B_COLOR
    #self.contents.fill_rect(0, 14, 544, 24, c)
    self.contents.fill_rect(0, 14, 644, 24, c)
    case type #表示分岐
    when 0..2 #アイテム・武器・防具表示
      draw_item_name(data, 4, 14)
      self.contents.draw_text(204, 14, 18, line_height, "ｘ")
      self.contents.draw_text(220, 14, 36, line_height, value)
      self.contents.draw_text(258, 14, 382, line_height, description(data))
    when 3 # スキル表示
      draw_item_name(data, 4, 14)
      self.contents.draw_text(204, 14, 436, line_height, description(data))
    when 4 # お金表示
      draw_icon(G_ICON, 4, 14)
      self.contents.draw_text(28, 14, 176, line_height, 
      data.to_s + Vocab.currency_unit)
      $game_party.gain_gold(id) if GET
    when 5 # テキスト出力
      draw_icon(T_ICON, 4, 14)
      self.contents.draw_text(28, 14, 612, line_height, data)
    when 6
      self.contents.draw_text(16, 14, 48, line_height, "Exp：")
      self.contents.draw_text(56, 14, 584, line_height, data)
    end
    self.contents.font.size = 14
    w = self.contents.text_size(text).width
    self.contents.fill_rect(0, 0, w + 4, 14, c)
    self.contents.draw_text_f(4, 0, 340, 14, text)
    #アイテムの入手・消失操作
    $game_party.gain_item(data,@value) if type <= 2 && GET && @value >= 1  #入手
    $game_party.gain_item(data,@value) if type <= 2 && GET && @value <= -1 #消失
    Graphics.frame_reset
  end
  #--------------------------------------------------------------------------
  # ● 解説文取得
  #--------------------------------------------------------------------------
  def description(data)
    if data.note =~ /#{STR20W}/
      return $1
    end
    text = data.description.dup
    text.sub!(/[\r\n]+.*/m, "")
    return text
  end
end

class Game_Temp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :getinfo_size
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_str20 initialize
  def initialize
    initialize_str20
    @getinfo_size = []
  end
end

class Bitmap
  unless public_method_defined?(:draw_text_f)
    #--------------------------------------------------------------------------
    # ● 文字縁取り描画
    #--------------------------------------------------------------------------
    def draw_text_f(x, y, width, height, str, align = 0, color = Color.new(64,32,128))
      shadow = self.font.shadow
      b_color = self.font.color.dup
      outline = self.font.outline
      self.font.outline = false
      font.shadow = false
      font.color = color
      draw_text(x + 1, y, width, height, str, align) 
      draw_text(x - 1, y, width, height, str, align) 
      draw_text(x, y + 1, width, height, str, align) 
      draw_text(x, y - 1, width, height, str, align) 
      font.color = b_color
      draw_text(x, y, width, height, str, align)
      font.shadow = shadow
      self.font.outline = outline
    end
    def draw_text_f_rect(r, str, align = 0, color = Color.new(64,32,128)) 
      draw_text_f(r.x, r.y, r.width, r.height, str, align, color) 
    end
  end
end

#--------------------------------------------------------------------------
# ★ 追加箇所 - アイテム入手時、フラグなONなら自動で入手表示する。
#　　アイテム・武器・防具・スキル・テキスト　それぞれ全てに対応
#--------------------------------------------------------------------------

class Game_Interpreter
  
  #--------------------------------------------------------------------------
  # override method: command_125 // お金の増減
  #--------------------------------------------------------------------------
  alias game_interpreter_command_125_ew command_125
  def command_125
    #game_interpreter_command_125_ew #エイリアスを使わない(多重加算を回避)
    value = operate_value(@params[0], @params[1], @params[2])
    
    if value >= 1 #お金が増える場合
      # フラグチェックして、trueならアイテム入手メソッドに飛ばす
      if $game_switches[CUSTOM_GET_WINDOW::DISPLAY_FLAG] #フラグチェック
        # 種類 / 0=ｱｲﾃﾑ 1=武器 2=防具 3=ｽｷﾙ 4=金
        type = 4
        # ID  / 金の場合は金額を入力
        id = value
        # 入手テキスト / 金の場合無効
        text = CUSTOM_GET_WINDOW::GOLD_TEXT_ADD
        #
        e = $game_temp.streffect
        e.push(Window_Getinfo.new(id, type, text, value))
      else  #フラグがfalseなら、オリジナルメソッドと同じ動作
        $game_party.gain_gold(value)
      end
    elsif value <= -1  #お金が減る場合
      if $game_switches[CUSTOM_GET_WINDOW::DISPLAY_FLAG] #フラグチェック
        type = 4
        id = value
        text = CUSTOM_GET_WINDOW::GOLD_TEXT_REMOVE
        #
        e = $game_temp.streffect
        e.push(Window_Getinfo.new(id, type, text, value))
      else
        $game_party.gain_gold(value)
      end
    end
  end  
  #--------------------------------------------------------------------------
  # override method: command_126 // アイテムの増減
  #--------------------------------------------------------------------------
  alias game_interpreter_command_126_ew command_126
  def command_126
    #game_interpreter_command_126_ew
    value = operate_value(@params[1], @params[2], @params[3])
    
    if value >= 1 #アイテムが増える場合
      if $game_switches[CUSTOM_GET_WINDOW::DISPLAY_FLAG] #フラグチェック
        # 種類 / 0=ｱｲﾃﾑ 1=武器 2=防具 3=ｽｷﾙ 4=金
        type = 0
        # ID  / 金の場合は金額を入力
        id = @params[0]
        # 入手テキスト / 金の場合無効
        text = CUSTOM_GET_WINDOW::ITEM_TEXT_ADD
        #
        e = $game_temp.streffect
        e.push(Window_Getinfo.new(id, type, text, value))
      else  #フラグがfalseなら、オリジナルメソッドと同じ動作
        $game_party.gain_item($data_items[@params[0]], value)
      end
    elsif value <= -1  #アイテムが減る場合
      if $game_switches[CUSTOM_GET_WINDOW::DISPLAY_FLAG] #フラグチェック
        type = 0
        id = @params[0]
        text = CUSTOM_GET_WINDOW::ITEM_TEXT_REMOVE
        #
        e = $game_temp.streffect
        e.push(Window_Getinfo.new(id, type, text, value))
      else
        $game_party.gain_item($data_items[@params[0]], value)
      end
    end
  end  
  #--------------------------------------------------------------------------
  # override method: command_127 // 武器の増減
  #--------------------------------------------------------------------------
  alias game_interpreter_command_127_ew command_127
  def command_127
    #game_interpreter_command_127_ew
    value = operate_value(@params[1], @params[2], @params[3])
    
    if value >= 1 #武器が増える場合
      if $game_switches[CUSTOM_GET_WINDOW::DISPLAY_FLAG] #フラグチェック
        # 種類 / 0=ｱｲﾃﾑ 1=武器 2=防具 3=ｽｷﾙ 4=金
        type = 1
        # ID  / 金の場合は金額を入力
        id = @params[0]
        # 入手テキスト / 金の場合無効
        text = CUSTOM_GET_WINDOW::WEAPON_TEXT_ADD
        #
        e = $game_temp.streffect
        e.push(Window_Getinfo.new(id, type, text, value))
      else  #フラグがfalseなら、オリジナルメソッドと同じ動作
        $game_party.gain_item($data_weapons[@params[0]], value, @params[4])
      end
    elsif value <= -1  #武器が減る場合
      if $game_switches[CUSTOM_GET_WINDOW::DISPLAY_FLAG] #フラグチェック
        type = 1
        id = @params[0]
        text = CUSTOM_GET_WINDOW::WEAPON_TEXT_REMOVE
        #
        e = $game_temp.streffect
        e.push(Window_Getinfo.new(id, type, text, value))
      else
        $game_party.gain_item($data_weapons[@params[0]], value, @params[4])
      end
    end
  end  
  #--------------------------------------------------------------------------
  # override method: command_128 // 防具の増減
  #--------------------------------------------------------------------------
  alias game_interpreter_command_128_ew command_128
  def command_128
    #game_interpreter_command_128_ew
    value = operate_value(@params[1], @params[2], @params[3])
    
    if value >= 1 #防具が増える場合
      if $game_switches[CUSTOM_GET_WINDOW::DISPLAY_FLAG] #フラグチェック
        # 種類 / 0=ｱｲﾃﾑ 1=武器 2=防具 3=ｽｷﾙ 4=金
        type = 2
        # ID  / 金の場合は金額を入力
        id = @params[0]
        # 入手テキスト / 金の場合無効
        text = CUSTOM_GET_WINDOW::ARMOR_TEXT_ADD
        #
        e = $game_temp.streffect
        e.push(Window_Getinfo.new(id, type, text, value))
      else  #フラグがfalseなら、オリジナルメソッドと同じ動作
        $game_party.gain_item($data_armors[@params[0]], value, @params[4])
      end
    elsif value <= -1  #防具が減る場合
      if $game_switches[CUSTOM_GET_WINDOW::DISPLAY_FLAG] #フラグチェック
        type = 2
        id = @params[0]
        text = CUSTOM_GET_WINDOW::ARMOR_TEXT_REMOVE
        text = CUSTOM_GET_WINDOW::ARMOR_TEXT_REMOVE
        #
        e = $game_temp.streffect
        e.push(Window_Getinfo.new(id, type, text, value))
      else
        $game_party.gain_item($data_armors[@params[0]], value, @params[4])
      end
    end
  end
  #--------------------------------------------------------------------------
  # override method command_318 // スキルの増減
  #--------------------------------------------------------------------------
  alias game_interpreter_command_318_ew command_318
  def command_318
    # アクターを探して指定スキルを習得させる
    # @params[1] = アクターID / $data_actors[] データベース上のアクターID
    # @params[2] = 習得させる(0)か忘れさせる(1)か
    # @params[3] = スキルID
    iterate_actor_var(@params[0], @params[1]) do |actor|
      if @params[2] == 0
        actor.learn_skill(@params[3])
      else
        actor.forget_skill(@params[3])
      end
    end
    
    if $game_switches[CUSTOM_GET_WINDOW::DISPLAY_FLAG] #フラグチェック
      if @params[2] == 0 #習得
        type = 3
        id = @params[3]
        actor_name = $data_actors[@params[1]].name 
        text = actor_name + " / " + CUSTOM_GET_WINDOW::SKILL_TEXT_ADD
        value = 1 #習得表示フラグ
        e = $game_temp.streffect
        e.push(Window_Getinfo.new(id, type, text, value))
      elsif @params[2] == 1 #忘れる
        type = 3
        id = @params[3]
        actor_name = $data_actors[@params[1]].name 
        text = actor_name + " / " + CUSTOM_GET_WINDOW::SKILL_TEXT_REMOVE
        value = -1 #忘却表示フラグ
        e = $game_temp.streffect
        e.push(Window_Getinfo.new(id, type, text, value))
      end
    end
  end
  #--------------------------------------------------------------------------
  # override method command_315 // 経験値の増減
  #--------------------------------------------------------------------------
  def command_315
    value = operate_value(@params[2], @params[3], @params[4])
    iterate_actor_var(@params[0], @params[1]) do |actor|
      actor.change_exp(actor.exp + value, @params[5])
    end
    #p @params[1] #指定キャラか変数指定か(0 or 1)
    #p @params[14] #指定キャラ番号 or 挿入する値(変数時)★
    #p @params[2] #増やすのか、もしくは減らすのか(0 or 1)★
    #p @params[3] #指定数値か変数指定か(0 or 1)
    #p @params[4] #実際に入れる値★
    #p @params[5] #レベルアップ表示するか？★
    
    if $game_switches[CUSTOM_GET_WINDOW::DISPLAY_FLAG] #フラグチェック
      type = 6
      if @params[1] == 0  #パーティ全体か(0)、個別か(1～)
        actor_name = "パーティ全体"
      else
        actor_name = $data_actors[@params[1]].name
      end
      if @params[2] == 0  #増やす(0)のか減らす(1)のか
        text = actor_name + " / " + CUSTOM_GET_WINDOW::EXP_TEXT_ADD
        value = 1 #入手フラグ
        id = @params[4] #IDに増減の値を挿入
      elsif @params[2] == 1
        text = actor_name + " / " + CUSTOM_GET_WINDOW::EXP_TEXT_REMOVE
        value = -1 #消失フラグ
        id = @params[4] * -1
      end
      e = $game_temp.streffect
      e.push(Window_Getinfo.new(id, type, text, value))
    end
  end
end
