#===========================================================================
# ◆ A1 Scripts ◆
#    ネームウィンドウ（RGSS2/RGSS3共用）
#
# バージョン   ： 2.40 (2012/01/19)
# 作者         ： A1
# URL　　　　　： http://a1tktk.web.fc2.com/
#---------------------------------------------------------------------------
# 機能：
# ・ネームウィンドウを表示します
#---------------------------------------------------------------------------
# 更新履歴　　 ：2011/12/15 Ver1.00 リリース
#         　　 ：2011/12/29 Ver1.10 アクター名表示対応
#         　　 ：2011/12/30 Ver2.00 左右顔グラフィック対応
#         　　 ：2011/12/30 Ver2.00 表示位置「上」対応
#         　　 ：2011/12/30 Ver2.10 RGSS2対応
#         　　 ：2011/12/30 Ver2.11 名前が切り替わる度にウィンドウを閉じる不具合を修正
#         　　 ：2012/01/02 Ver2.20 同じ顔グラフィックの別名表示機能追加
#         　　 ：2012/01/02 Ver2.20 表示名の直接指定機能追加
#         　　 ：2012/01/02 Ver2.30 A1共通スクリプトVer3.30対応
#         　　 ：2012/01/19 Ver2.40 バトルネームウィンドウ対応
#---------------------------------------------------------------------------
# 設置場所      
#　　A1共通スクリプトより下
#　　(左右顔グラフィックスクリプトより下)
#
# 必要スクリプト
#    A1共通スクリプトVer3.30以上
#---------------------------------------------------------------------------
# 使い方
#　設定項目を設定します
#　
#　  設定項目の「表示する名前」を Actor[ID] とすると
#　  IDで指定したアクターの名前を表示します
#　
#　イベントコマンド「注釈」に記述
#
#　　ネームウィンドウ on|off
#      表示の on/off を切り替えます
#
#    NWインデックス index
#      同じ顔グラフィックに複数の名前を配列で登録している場合
#      次に表示するネームウィンドウを指定した index の名前を使用します
#      省略時には 0番目 の名前を使用します
#
#    NW名前指定 Name
#      次に表示するネームウィンドウに Name を使用します
#      顔グラフィックなしでも表示されます
#==============================================================================
$imported ||= {}
$imported["A1_Name_Window"] = true
if $imported["A1_Common_Script"]
old_common_script("ネームウィンドウ", "3.30") if common_version < 3.30
#==============================================================================
# ■ 設定項目
#==============================================================================
module A1_System::NameWindow

  #--------------------------------------------------------------------------
  # ネームウィンドウを使用するクラス
  #--------------------------------------------------------------------------
  USE_NAME_WINDOW_CLASS = [Window_Message]
  
  #--------------------------------------------------------------------------
  # ネームウィンドウのフォント
  #--------------------------------------------------------------------------
  NAME_FONT = "UmePlus Gothic"
  
  #--------------------------------------------------------------------------
  # 長い名前の時に左(右)に寄せる
  #--------------------------------------------------------------------------
  FIX_LONG_NAME = false
  
  #--------------------------------------------------------------------------
  # 顔グラフィックと名前の対応
  #
  #  "[ファイル名]_[Index]" => "表示する名前" ※Index毎に設定
  #  "[ファイル名]"         => "表示する名前" ※該当ファイル全てに適用
  #                            "Actor[ID]"    ※該当するIDのアクター名を表示
  #--------------------------------------------------------------------------
  NAME_LIST = {
    "ahiru"    => "Ugly Duckling",
    "ねずみ"    => "Pat the Rat",
    "ねずみ狂"    => "вbЁ@Ёif@ыbЁ",
    "にわとり"    => "Chikerost",
    "にわとり狂"    => "цiqsf⌡w╚Ё",
    "バッタ"    => "Insolent Grasshopper",
    "シロクマ"    => "Polar Bear",
    "hituzi"    => "Old Sheep",
    "baia"    => "Master",
    "baia２"    => "Byakhee",
    "チワワ"    => "Sergeant Gilbert",
    "チワワ狂"    => "Бf⌡hfbvЁ@гqtcf⌡Ё",
    "ガンマン"    => "Sheriff Sullivan",
    "ガンマン狂"    => "Бif⌡qgg@Б╢ttq╣bv",
    "へんぜる"    => "Cursed Brother Hansel",
    "ぐれーてる"    => "Cursed Sister Gretel",
    "シンド"    => "Sinbad, King of the Seas",
    "ねこ"    => "Mesmerizing Cat",
    "いぬ"    => "Murderous Dog",
    "にわ"    => "Noble Chicken",
    "ろば"    => "Silent Donkey",
    "ぶれーめん"    => "Musicians of Bremen",
    "はんす"    => "Iron Hans",
    "ぱと"    => "Sacrificed Patrasche",
    "kata"    => "Our Lady Catherine",
    "ほし"    => "The Little Prince",
    "娘アリス"    => "Alice",
    "妹アリス"    => "Alice",
    "母アリス"    => "Alice",
    "チェシャ猫"    => "Cheshire Cat",
    "ノーデ"    => "White Rabbit Node",
    "ノーデ2"    => "White Queen Node",
    "紅ずきん"    => "Red Hood",
    "公爵夫人"    => "Duchess Margaret von Tyrol",
    "帽子屋"    => "Hatter Hatta",
    "三月兎"    => "March Hare Haigha",
    "眠り鼠"    => "Sleeping Rat Dormouse",
    "ロリーナ"    => "Queen of the Heart Lorina",
    "ウミガメ"    => "Mock Turtle",
    "グリフィ"    => "Griffin Knight Griffy",
    "ドド"    => "Foolish Bird Dodo",
    "ビル"    => "Lizard Bill",
    "シーシャ"    => "Caterpillar Shisha",
    "プリ"    => "Red Idol Prickett",
    "ハン"    => "Humpty Dumpty",
    "ハン２"    => "Actor[63] ",
    "トゥダム"    => "Tweedledum",
    "トゥディ"    => "Tweedledee",
    "バン"    => "Frumious Bandersnatch",
    "ジャバ"    => "Corpse Dragon Jabberwock",
    "ジャブ"    => "Mad Bird Jubjub",
    "ビク"    => "Maid Victoria",
    "メアリー"    => "Mary Ann",
    "ブラ"    => "Doctor Blackwell",
    "ブラ狂"    => "дwdЁw⌡@бtbds╤ftt",
    "ホームズ"    => "Detective Holmes",
    "ホームズ狂"    => "дfЁfdЁq╣f@хwtuf╚",
    "ばにー"    => "Bunny Girl Mary",
    "ばにー狂"    => "б╢vv╦@гq⌡t@тb⌡╦",
    "魔獣"    => "бfb╚Ё",
    "よろい"    => "Knight in Armor",
    "ぱんぷ"    => "Knight Pumpkin-O'",
    "ぱんぷ狂"    => "в╢uxsqv`ж}",
    "doro"    => "Witch Dorothy",
    "eriza"    => "Torture Queen Elizabeth",
    "roba"    => "The Donkey King",
    "hain"    => "Black Conductor Hein",
    "あし"    => "Daddy-Long-Legs",
    "うさぎ騎士"    => "Rabbit Knight Vernai",
    "ロビン"    => "Robin Hood",
    "アリス・リデル"    => "Alice Liddell",
    "アリス・リデル２"    => "аtqdf@сqeeftt",
    "ピーター"    => "Peter Pan",
    "poro"    => "Poro",
    "眠り鼠2"    => "Sleeping Rat Dormouse",
    "シヴーチ"    => "Wolris, Predator of the Deep Sea",
    "カキ"    => "Cheeky Oyster",
    "クティ"    => "Secret Princess Kuti",
    "ピノッキオ"    => "Puppet Boy Pinocchio",
    "ピノッキオ２"    => "Puppet",
    "me"    => "Meryphillia, the Ghoul",
    "メイベル"    => "Mabel, Girl of Nihility",
    "蛇神"    => "The Serpent God",
    "カーナッキ"    => "Carnacki, the Ghost-Finder",
    "ロルド"    => "Playwright Lorde",
    "シヨ"    => "Dissolution Queen Sho",
    "ゲルダ"    => "Snow Girl Gerda",
    "ユニス"    => "White Unicorn Unis",
    "ライデン"    => "White Lion Leiden",
    "アリス・ドール"    => "Doll Alice",
    "ランジェ"    => "Brutalizing Angel Lingeriena",
    "フローレンス"    => "Founding Doctor Florence",
    "カイ"    => "Snow Boy Kai",
    "リンダメア"    => "Black Knight Lindamea",
    "ハインリヒ"    => "Frog Heinrich",
    "多萝西 (2)"    => "Dorothy",
    "「塞塔兹」"    => "Setatz",
    "希莉娅"    => "Celia",
    "？？？"    => "???",
    "「格劳」"    => "Grau",
    "「稻草人」"    => "Scarecrow",
    "桔子"    => "Tangerine",
    "萝斯梅可 (2)"    => "Rose Moko",
  }
end
#==============================================================================
# ■ Cache
#------------------------------------------------------------------------------
# 　各種グラフィックを読み込み、Bitmap オブジェクトを作成、保持するモジュール
# です。読み込みの高速化とメモリ節約のため、作成した Bitmap オブジェクトを内部
# のハッシュに保存し、同じビットマップが再度要求されたときに既存のオブジェクト
# を返すようになっています。
#==============================================================================

module Cache
  #--------------------------------------------------------------------------
  # ○ ネームウィンドウ用ビットマップの取得
  #--------------------------------------------------------------------------
  def self.name_bitmap(name)
    return load_name_bitmap(name)
  end
  #--------------------------------------------------------------------------
  # ○ 名前bitmapの作成
  #--------------------------------------------------------------------------
  def self.load_name_bitmap(name)
    @cache ||= {}
    key = [name, "name_window"]
    return @cache[key] if include?(key)
    
    # 計算用ダミービットマップ
    bitmap = Cache.system("")
    bitmap.font.name = A1_System::NameWindow::NAME_FONT
    bitmap.font.size = 16
    tw = bitmap.text_size(name).width + 8
    
    # ビットマップ作成
    bitmap = Bitmap.new(tw, bitmap.font.size + 4)
    bitmap.font.name = A1_System::NameWindow::NAME_FONT
    bitmap.font.size = 16
    bitmap.font.color = Color.new(255,255,255)
    bitmap.draw_text(0, 0, bitmap.width, bitmap.height, name, 1)
    
    @cache[key] = bitmap
    return @cache[key]
  end
end
#==============================================================================
# ■ Window_FaceName
#==============================================================================

class Window_FaceName < Window_Base
  #--------------------------------------------------------------------------
  # ○ オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(name, z)
    info = create_name_sprite(name)
    super(0, 0, info[0], info[1])
    self.visible = true
    self.openness = 0
    self.z = z
    skin = Cache.system("Window").clone
    skin.clear_rect(80, 16, 32, 32)
    self.windowskin = skin
    @name_sprite.z = self.z + 10
  end
  #--------------------------------------------------------------------------
  # ○ ネームウィンドウのセットアップ
  #--------------------------------------------------------------------------
  def setup_name_window(name)
    info = create_name_sprite(name)
    self.width  = info[0]
    self.height = info[1]
    create_contents
    @name_sprite.z = self.z + 10
  end
  #--------------------------------------------------------------------------
  # ○ フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @name_sprite.visible = self.visible && self.open?
    return unless self.open?
    @name_sprite.update
  end
  #--------------------------------------------------------------------------
  # ○ 解放
  #--------------------------------------------------------------------------
  def dispose
    @name_sprite.bitmap.dispose
    @name_sprite.dispose
    super
  end
  #--------------------------------------------------------------------------
  # ○ ウィンドウを開く
  #--------------------------------------------------------------------------
  def open
    super
    @name_sprite.x = self.x + self.width / 2
    @name_sprite.y = self.y + self.height / 2
  end
  #--------------------------------------------------------------------------
  # ○ スプライトの作成
  #--------------------------------------------------------------------------
  def create_name_sprite(name)
    # ビットマップの取得
    bitmap = Cache.name_bitmap(name)
    
    # スプライト設定
    @name_sprite         = Sprite.new
    @name_sprite.bitmap  = bitmap
    @name_sprite.ox      = bitmap.width / 2
    @name_sprite.oy      = bitmap.height / 2
    @name_sprite.visible = false
    
    return [bitmap.width + 8, bitmap.height + 8]
  end
end
#==============================================================================
# ■ Window_Base
#------------------------------------------------------------------------------
# 　ゲーム中のすべてのウィンドウのスーパークラスです。
#==============================================================================

class Window_Base < Window
  #--------------------------------------------------------------------------
  # ☆ オブジェクト初期化
  #--------------------------------------------------------------------------
  alias a1_name_window_window_base_initialize initialize 
  def initialize(x, y, width, height)
    a1_name_window_window_base_initialize(x, y, width, height)
    create_name_window
  end
  #--------------------------------------------------------------------------
  # ☆ フレーム更新
  #--------------------------------------------------------------------------
  alias a1_name_window_window_base_update update 
  def update
    a1_name_window_window_base_update
    update_name_window
  end
  #--------------------------------------------------------------------------
  # ☆ 顔グラフィックの描画
  #--------------------------------------------------------------------------
  alias a1_name_window_window_base_draw_face draw_face
  def draw_face(face_name, face_index, x, y, size = 96)
    a1_name_window_window_base_draw_face(face_name, face_index, x, y, size)
    show_name_window(face_name, face_index, x, size)
  end
  #--------------------------------------------------------------------------
  # ☆ ウィンドウを閉じる
  #--------------------------------------------------------------------------
  alias a1_name_window_window_base_close close
  def close
    a1_name_window_window_base_close
  end
  #--------------------------------------------------------------------------
  # ☆ 解放
  #--------------------------------------------------------------------------
  alias a1_name_window_window_base_dispose dispose
  def dispose
    a1_name_window_window_base_dispose
    dispose_name_window
  end
  #--------------------------------------------------------------------------
  # ○ ネームウィンドウの解放
  #--------------------------------------------------------------------------
  def dispose_name_window
    @name_windows.values.each {|window| window.dispose }
  end
  #--------------------------------------------------------------------------
  # ○ ネームウィンドウの更新
  #--------------------------------------------------------------------------
  def update_name_window
    @name_windows.values.each {|window| window.update }
  end
  #--------------------------------------------------------------------------
  # ○ ネームウィンドウを使用？
  #--------------------------------------------------------------------------
  def use_name_window?
    A1_System::NameWindow::USE_NAME_WINDOW_CLASS.each {|clas| return true if self.is_a?(clas) }
    return false
  end
  #--------------------------------------------------------------------------
  # ○ ネームウィンドウの作成
  #--------------------------------------------------------------------------
  def create_name_window
    @name_windows = {}
  end
  #--------------------------------------------------------------------------
  # ○ 表示する名前の取得
  #--------------------------------------------------------------------------
  def show_name(face_name, face_index)
    return nil unless $game_system.use_name_window
    name = $game_temp.direct_show_name
    if name.empty?
      return nil if face_name == nil || face_name.empty?
      name = A1_System::NameWindow::NAME_LIST[sprintf("%s_%d", face_name, face_index)]
      name = A1_System::NameWindow::NAME_LIST[face_name] if name == nil
      name = name[$game_temp.name_index] if name.is_a?(Array)
      name = $game_actors[$1.to_i].name if name =~ /Actor\[(\d+)\]/
    end
    $game_temp.name_index       = 0
    $game_temp.direct_show_name = ""
    return name
  end
  #--------------------------------------------------------------------------
  # ○ ネームウィンドウの表示
  #--------------------------------------------------------------------------
  def show_name_window(face_name, face_index, x, size = 96)
    return unless use_name_window?
    name = show_name(face_name, face_index)
    return if name == nil or name.empty?
    if name == "兎" #this if-elsif chain wasn't present in the mod, but was in base BS2. Left it in, but can be removed again if it causes problems.
      name = "Rabbit"
    elsif name == "蜈"
      name = "ыbccqЁ"
    elsif name == "胸像"
      name = "Bust"
    elsif name == "閭ｸ蜒"
      name = "б╢╚Ё"
    elsif name == "びっくり箱"
      name = "Jack-in-the-Box"
    elsif name == "釣り人"
      name = "Fisherman"
    elsif name == "驥｣繧贋ｺｺ"
      name = "фq╚if⌡ubv"
    elsif name == "夢ピエロ"
      name = "Dream Clown"
    elsif name == "螟｢繝斐お繝ｭ"
      name = "д⌡fbu@цtw╤v"
    elsif name == "ピエロ"
      name = "Clown"
    elsif name == "扉"
      name = "Door"
    elsif name == "謇"
      name = "дww⌡"
    elsif name == "死刑執行人ケッチ"
      name = "Ketch the Executioner"
    elsif name == "恐怖のフレデリック"
      name = "Frederick of Fear"
    elsif name == "行方不明のノミ"
      name = "Unaccounted Flea"
    elsif name == "玩具のカエル"
      name = "Skipjack"
    elsif name == "失敗作"
      name = "Failure"
    elsif name == "天使の製造者アメリア"
      name = "Angel Manufacturer Amelia"
    elsif name == "呪術師コットン"
      name = "Cotton the Witch"
    elsif name == "拷問家ブラウンリッグ"
      name = "Sadistic Mistress Brownrigg"
    elsif name == "怪物執事アーチボルド"
      name = "Monster Butler Archibald"
    elsif name == "虚ろの兵士クリスティ"
      name = "Hollow Soldier Christie"
    elsif name == "食人族ソニー・ビーン"
      name = "Cannibal Sawney Bean"
    elsif name == "死体盗みヘア"
      name = "Corpse Thief Hare"
    elsif name == "死体運びバーク"
      name = "Corpse Carrier Burke"
    elsif name == "逃亡騎士ジム"
      name = "Fleeing Knight Jim"
    elsif name == "ブージャム"
      name = "Boojum"
    elsif name == "罪作りなウェインライト"
      name = "Wainwright the Sinful"
    elsif name == "闇医者ハロルド"
      name = "Dark Doctor Harold"
    elsif name == "理髪師トッド"
      name = "Barber Todd"
    elsif name == "邪竜狩りヴォーパル"
      name = "Wicked Dragon Hunter Vorpal"
    elsif name == "首狩りのビースト"
      name = "Headhunting Beast"
    elsif name == "獣被りブッチャー"
      name = "Beastclad Butcher"
    elsif name == "迯｣陲ｫ繧翫ヶ繝?メ繝｣繝ｼ"
      name = "бfb╚Ёdtbe@б╢Ёdif⌡"
    elsif name == "呼鐘のベルマン"
      name = "Bellcaller Bellman"
    elsif name == "繝吶Ν繝槭Φ"
      name = "бfttubv"
    elsif name == "鈍色の大鷲イーディス"
      name = "Great Grey Eagle Edith"
    elsif name == "驤崎牡縺ｮ螟ｧ鮃ｲ繧､繝ｼ繝?ぅ繧ｹ"
      name = "г⌡fbЁ@г⌡f╦@еbhtf@еeqЁi"
    elsif name == "トカゲのビル"
      name = "Lizard Bill"
    elsif name == "繝医き繧ｲ縺ｮ繝薙Ν"
      name = "сq╧b⌡e@бqtt"
    elsif name == "愚鳥ドド"
      name = "Foolish Bird Dodo"
    elsif name == "諢夐ｳ･繝峨ラ"
      name = "фwwtq╚i@бq⌡e@дwew"
    elsif name == "芋虫シーシャ"
      name = "Caterpillar Shisha"
    elsif name == "闃玖勠繧ｷ繝ｼ繧ｷ繝｣"
      name = "цbЁf⌡xqttb⌡@Бiq╚ib"
    elsif name == "公爵夫人マルガレーテ・フォン・ティロル"
      name = "Duchess Margaret von Tyrol"
    elsif name == "公爵夫人"
      name = "The Duchess"
    elsif name == "蜈ｬ辷ｵ螟ｫ莠ｺ繝槭Ν繧ｬ繝ｬ繝ｼ繝??繝輔か繝ｳ繝ｻ繝?ぅ繝ｭ繝ｫ"
      name = "д╢dif╚╚@тb⌡hb⌡fЁ@╣wv@Ц╦⌡wt"
    elsif name == "トゥイードルダム" || name == "トゥイードル・ダム"
      name = "Tweedledum"
    elsif name == "トゥイードル・ディー" || name == "トゥイードルディー"
      name = "Tweedledee"
    elsif name == "繝医ぇ繧､繝ｼ繝峨Ν繝?繝?"
      name = "Ц╤ffetfe╢u"
    elsif name == "繝医ぇ繧､繝ｼ繝峨Ν繝?ぅ繝ｼ"
      name = "Ц╤ffetfeff"
    elsif name == "葡萄の番獣"
      name = "Grape Guardbeast"
    elsif name == "ウミガメモドキ"
      name = "Mock Turtle"
    elsif name == "繧ｦ繝溘ぎ繝｡繝｢繝峨く"
      name = "Цif@тwds@Ц╢⌡Ёtf"
    elsif name == "淫魔獣ビクトリア"
      name = "Lewd Demonbeast Victoria"
    elsif name == "鷲獅子グリフィ"
      name = "Griffy the Griffin"
    elsif name == "鮃ｲ迯?ｭ舌げ繝ｪ繝輔ぅ"
      name = "г⌡qgg╦@Ёif@г⌡qggqv"
    elsif name == "青ひげ"
      name = "Bluebeard"
    elsif name == "遥かなる獣ラスカル"
      name = "Farthest Beast Rascal"
    elsif name == "狡猾な猿"
      name = "Sly Monkey"
    elsif name == "猿殺しの大蟹"
      name = "The Great Monkey-Killing Crab"
    elsif name == "狼少年"
      name = "Boy Who Cried Wolf"
    elsif name == "欲張りな犬"
      name = "Greedy Dog"
    elsif name == "かちかち山の狸"
      name = "Tanuki of the Crackling Mountain"
    elsif name == "クマのプーさん"
      name = "Winnie-the-Pooh"
    elsif name == "フランクリン・ボルヴォルト1世"
      name = "Franklin Bollvolt I"
    elsif name == "拳の決闘士バイロン"
      name = "Fist Duelist Byron"
    elsif name == "子山羊"
      name = "Goatling"
    elsif name == "酸術師ヘイグ"
      name = "Acid Practitioner Haigh"
    elsif name == "洋食器の毒殺者グレアム"
      name = "Teacup Poisoner Graham"
    elsif name == "医師ブラックウェル"
      name = "Doctor Blackwell"
    elsif name == "蛹ｻ蟶ｫ繝悶Λ繝?け繧ｦ繧ｧ繝ｫ"
      name = "дwdЁw⌡@бtbds╤ftt"
    elsif name == "心臓の女王ロリーナ"
      name = "Queen of the Heart Lorina"
    elsif name == "帽子屋"
      name = "The Hatter"
    elsif name == "三月兎"
      name = "The March Hare"
    elsif name == "眠り鼠"
      name = "The Dormouse"
    elsif name == "黒髭エドワード"
      name = "Blackbeard Edward"
    elsif name == "キャプテン・キッド"
      name = "Captain Kidd"
    elsif name == "溟海の捕食者シヴーチ"
      name = "Deep Sea Predator, Wolris"
    elsif name == "貅滓ｵｷ縺ｮ謐暮｣溯??す繝ｴ繝ｼ繝"
      name = "дffx@Бfb@в⌡febЁw⌡k@Фwt⌡q╚"
    elsif name == "ルルイエの姫君ゾーア"
      name = "Zoa, the Princess of R'lyeh"
    elsif name == "繝ｫ繝ｫ繧､繧ｨ縺ｮ蟋ｫ蜷帙だ繝ｼ繧｢"
      name = "Иwbk@Ёif@в⌡qvdf╚╚@wg@ы}t╦fi"
    elsif name == "おぞましいヒンドリー"
      name = "Repulsive Hindley"
    elsif name == "おぞましいブレイディ"
      name = "Repulsive Brady"
    elsif name == "看板"
      name = "Sign"
    elsif name == "逵区攸"
      name = "Бqhv"
    elsif name == "受付"
      name = "Receptionist"
    elsif name == "蜿嶺ｻ"
      name = "ыfdfxЁqwvq╚Ё"
    elsif name == "心折れた兵士"
      name = "Crestfallen Soldier"
    elsif name == "犬男"
      name = "Dogman"
    elsif name == "迥ｬ逕ｷ"
      name = "дwhubv"
    elsif name == "包帯の男"
      name = "Bandaged Man"
    elsif name == "蛹?ｸｯ縺ｮ逕ｷ"
      name = "бbvebhfe@тbv"
    elsif name == "船乗り"
      name = "Sailor"
    elsif name == "闊ｹ荵励ｊ"
      name = "Бbqtw⌡"
    elsif name == "年寄りカキ"
      name = "Old Oyster"
    elsif name == "門兵"
      name = "Gate Soldier"
    elsif name == "髢?蜈ｵ"
      name = "гbЁf@Бwteqf⌡"
    elsif name == "トランプ庭師"
      name = "Card Gardener"
    elsif name == "繝医Λ繝ｳ繝怜ｺｭ蟶ｫ"
      name = "цb⌡e@гb⌡efvf⌡"
    elsif name == "トランプ守護者"
      name = "Card Guardian"
    elsif name == "繝医Λ繝ｳ繝怜ｮ郁ｭｷ閠"
      name = "цb⌡e@г╢b⌡eqbv"
    elsif name == "蟹"
      name = "Crab"
    elsif name == "陝ｹ"
      name = "ц⌡bc"
    elsif name == "フクロウ"
      name = "Owl"
    elsif name == "繝輔け繝ｭ繧ｦ"
      name = "ж╤t"
    elsif name == "ダックワース"
      name = "Duckworth"
    elsif name == "繝?繝?け繝ｯ繝ｼ繧ｹ"
      name = "д╢ds╤w⌡Ёi"
    elsif name == "リス"
      name = "Squirrel"
    elsif name == "繝ｪ繧ｹ"
      name = "Б▀╢q⌡⌡ft"
    elsif name == "ひよこ"
      name = "Chick"
    elsif name == "縺ｲ繧医％"
      name = "цiqds"
    elsif name == "アライグマ"
      name = "Raccoon"
    elsif name == "繧｢繝ｩ繧､繧ｰ繝"
      name = "ыbddwwv"
    elsif name == "にわとり"
      name = "Chicken"
    elsif name == "縺ｫ繧上→繧"
      name = "цiqdsfv"
    elsif name == "キツネ"
      name = "Fox"
    elsif name == "繧ｭ繝?ロ"
      name = "фw╥"
    elsif name == "カササギ"
      name = "Magpie"
    elsif name == "繧ｫ繧ｵ繧ｵ繧ｮ"
      name = "тbhxqf"
    elsif name == "隠れピエロ"
      name = "Hiding Clown"
    elsif name == "料理人"
      name = "Cook"
    elsif name == "店主サハギン"
      name = "Storekeeper Sahagin"
    elsif name == "蠎嶺ｸｻ繧ｵ繝上ぐ繝ｳ"
      name = "БЁw⌡fsffxf⌡@Бbibhqv"
    elsif name == "ベルマン"
      name = "Bellman"
    elsif name == "靴磨きブーツ"
      name = "Shoeshiner Boots"
    elsif name == "髱ｴ逎ｨ縺阪ヶ繝ｼ繝"
      name = "Бiwf╚iqvf⌡@бwwЁ╚"
    elsif name == "カボチャ霊"
      name = "Pumpkin Ghost"
    elsif name == "繧ｫ繝懊メ繝｣髴"
      name = "в╢uxsqv@гiw╚Ё"
    elsif name == "壁尻の兎"
      name = "Wallbutt Rabbit"
    elsif name == "螢∝ｰｻ縺ｮ蜈"
      name = "Фbttc╢ЁЁ@ыbccqЁ"
    elsif name == "少年の声"
      name = "Boy's Voice"
    elsif name == "娼婦"
      name = "Prostitute"
    elsif name == "螽ｼ蟀ｦ"
      name = "в⌡w╚ЁqЁ╢Ёf"
    elsif name == "壁嵌りトロール"
      name = "Stuck Troll"
    elsif name == "螢∝ｵ後ｊ繝医Ο繝ｼ繝ｫ"
      name = "БЁ╢ds@Ц⌡wtt"
    elsif name == "奴隷后タビカット"
      name = "Slave Empress Tabikat"
    elsif name == "螂ｴ髫ｷ蜷弱ち繝薙き繝?ヨ"
      name = "Бtb╣f@еux⌡f╚╚@ЦbcqsbЁ"
    elsif name == "奴隷帝シビメット"
      name = "Slave Emperor Sibimet"
    elsif name == "螂ｴ髫ｷ蟶昴す繝薙Γ繝?ヨ"
      name = "Бtb╣f@еuxf⌡w⌡@БqcqufЁ"
    elsif name == "青い熊"
      name = "Blue Bear"
    elsif name == "赤い熊"
      name = "Red Bear"
    elsif name == "黄色い熊"
      name = "Yellow Bear"
    elsif name == "古時計"
      name = "Antique Clock"
    elsif name == "びっくりマドンナ"
      name = "Madonna-in-the-Box"
    elsif name == "夢魔"
      name = "Succubus"
    elsif name == "ヴォクソール売店"
      name = "Vauxhall Stall"
    elsif name == "螢ｲ蠎励ヴ繧ｨ繝ｭ"
      name = "БЁbtt@цtw╤v"
    elsif name == "受付ゴースト"
      name = "Ghost Receptionist"
    elsif name == "蜿嶺ｻ倥ざ繝ｼ繧ｹ繝"
      name = "гiw╚Ё@ыfdfxЁqwvq╚Ё"
    elsif name == "商人"
      name = "Merchant"
    elsif name == "亡者コック"
      name = "Hollow Cook"
    elsif name == "莠｡閠?さ繝?け"
      name = "хwttw╤@цwws"
    elsif name == "邪竜ジャバウォック"
      name = "Wicked Dragon Jabberwock"
    elsif name == "白鴉"
      name = "White Crow"
    elsif name == "雋ｴ譌城｢ｨ縺ｮ逕ｷ"
      name = "а⌡q╚Ёwd⌡bЁqd@тbv"
    elsif name == "貴族風の男"
      name = "Aristocratic Man"
    elsif name == "漂流患者"
      name = "Drifter Patient"
    elsif name == "患者"
      name = "Patient"
    elsif name == "麻袋女"
      name = "Sackhead Girl"
    elsif name == "ジキル博士"
      name = "Dr. Jekyll"
    elsif name == "雪だるま"
      name = "Snowman"
    elsif name == "狂へる悪魔ハイド"
      name = "Mad Devil Hyde"
    elsif name == "暴魔ランジェリーナ"
      name = "Violence Demon Lingeriena"
    elsif name == "雪の女王ゲルダ"
      name = "Snow Queen Gerda"
    elsif name == "地獄のプリンス"
      name = "Prince of Hell"
    elsif name == "串刺し公女クルティザンヌ"
      name = "Courtisane the Impaler"
    elsif name == "追猎的阿纳托利"
      name = "Anatoly the Hunter"
    elsif name == "贪婪的乌鸦"
      name = "Greedy Crow"
    elsif name == "鸦人佛伦斯"
      name = "Floren the Crow"
    elsif name == "讥讽之草"
      name = "Sarcastic Grass"
    elsif name == "少女"
      name = "Girl"
    elsif name == "魔兽化的少女"
      name = "Demonized Girl"
    elsif name == "会说话的花"
      name = "Talking Flower"
    elsif name == "颓废主"
      name = "Decadent Lord"
    elsif name == "佛伦斯"
      name = "Floren"
    elsif name == "鸦人佛伦斯"
      name = "Floren the Crow"
    elsif name == "梅可"
      name = "Moko"
    elsif name == "鏉戞皯"
      name = "Sui1jxiXuzaakQ"
    elsif name == "村民"
      name = "Villager"
    elsif name == "女孩"
      name = "Young Girl"
    elsif name == "乌鸦"
      name = "Crow"
    elsif name == "？？？"
      name = "???"
    elsif name == "神官埃尔文"
      name = "Priest Elwyn"
    elsif name == "贵族"
      name = "Noble"
    elsif name == "平民"
      name = "Commoner"
    elsif name == "神父"
      name = "Priest"
    elsif name == "灰心的士兵"
      name = "Disheartened Soldier"
    elsif name == "希莉娅"
      name = "Celia"
    elsif name == "失落的男人"
      name = "Disheartened Man"
    elsif name == "护卫"
      name = "Bodyguard"
    elsif name == "奇怪的女人"
      name = "Strange Girl"
    elsif name == "格劳"
      name = "Grau"
    end
    
    @name_windows[name] ||= Window_FaceName.new(name, self.z + 10)
    if x <= Graphics.width / 2
      @name_windows[name].x = x + size + 20
      @name_windows[name].x = 0 if @name_windows[name].x + @name_windows[name].width > Graphics.width / 2 and A1_System::NameWindow::FIX_LONG_NAME
    else
      @name_windows[name].x = Graphics.width - size - @name_windows[name].width 
      @name_windows[name].x = Graphics.width - @name_windows[name].width if @name_windows[name].x < Graphics.width / 2 and A1_System::NameWindow::FIX_LONG_NAME
    end
    @name_windows[name].y = self.y      - 16 if self.y  > 0
    @name_windows[name].y = self.height - 16 if self.y == 0
    @name_windows[name].openness = 255 if self.open?
    @name_windows[name].open
    @name_windows[name].visible = true
  end
  #--------------------------------------------------------------------------
  # ○ ネームウィンドウを閉じる
  #--------------------------------------------------------------------------
  def name_window_close
    @name_windows.values.each {|window| window.close }
  end
  #--------------------------------------------------------------------------
  # ○ ネームウィンドウを非表示
  #--------------------------------------------------------------------------
  def name_window_visible_false
    @name_windows.values.each {|window| window.visible = false }
  end
end
#==============================================================================
# ■ Window_Message
#------------------------------------------------------------------------------
# 　文章表示に使うメッセージウィンドウです。
#==============================================================================

class Window_Message
  #--------------------------------------------------------------------------
  # ○ ウィンドウを閉じる
  #--------------------------------------------------------------------------
  def close
    name_window_close
    super
  end
end
#==============================================================================
# ◆ RGSS3用処理
#==============================================================================
if rgss_version == 3
#==============================================================================
# ■ Window_Message
#------------------------------------------------------------------------------
# 　文章表示に使うメッセージウィンドウです。
#==============================================================================

class Window_Message < Window_Base
  #--------------------------------------------------------------------------
  # ☆ 改ページ処理
  #--------------------------------------------------------------------------
  alias a1_name_window_window_message_new_page new_page 
  def new_page(text, pos)
    name_window_visible_false
    a1_name_window_window_message_new_page(text, pos)
  end
end
#==============================================================================
# ◆ RGSS2用処理
#==============================================================================
elsif rgss_version == 2
#==============================================================================
# ■ Window_Message
#------------------------------------------------------------------------------
# 　文章表示に使うメッセージウィンドウです。
#==============================================================================

class Window_Message < Window_Selectable
  #--------------------------------------------------------------------------
  # ☆ 改ページ処理
  #--------------------------------------------------------------------------
  alias a1_name_window_window_message_new_page new_page 
  def new_page
    name_window_visible_false
    a1_name_window_window_message_new_page
  end
end
#==============================================================================
# ◆ RGSS用処理
#==============================================================================
elsif rgss_version == 1
end
#==============================================================================
# ■ Game_System
#------------------------------------------------------------------------------
# 　システム周りのデータを扱うクラスです。乗り物や BGM などの管理も行います。
# このクラスのインスタンスは $game_system で参照されます。
#==============================================================================

class Game_System
  #--------------------------------------------------------------------------
  # ○ 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :use_name_window                # ネームウィンドウ表示フラグ
  #--------------------------------------------------------------------------
  # ☆ オブジェクト初期化
  #--------------------------------------------------------------------------
  alias a1_name_window_game_system_initialize initialize
  def initialize
    a1_name_window_game_system_initialize
    @use_name_window = false
  end
end
#==============================================================================
# ■ Game_Temp
#------------------------------------------------------------------------------
# 　セーブデータに含まれない、一時的なデータを扱うクラスです。このクラスのイン
# スタンスは $game_temp で参照されます。
#==============================================================================

class Game_Temp
  #--------------------------------------------------------------------------
  # ○ 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :name_index
  attr_accessor :direct_show_name
  #--------------------------------------------------------------------------
  # ☆ オブジェクト初期化
  #--------------------------------------------------------------------------
  alias a1_name_window_gt_initialize initialize
  def initialize
    a1_name_window_gt_initialize
    @name_index       = 0
    @direct_show_name = ""
  end
end
#==============================================================================
# ■ A1_System::CommonModule
#==============================================================================

class A1_System::CommonModule
  #--------------------------------------------------------------------------
  # ☆ 注釈コマンド定義
  #--------------------------------------------------------------------------
  alias a1_name_window_define_command define_command
  def define_command
    a1_name_window_define_command
    @cmd_108["ネームウィンドウ"] = :name_window
    @cmd_108["NWインデックス"]   = :nw_index
    @cmd_108["NW名前指定"]       = :nw_set_name
  end
end
#==============================================================================
# ■ Game_Interpreter
#------------------------------------------------------------------------------
# 　イベントコマンドを実行するインタプリタです。このクラスは Game_Map クラス、
# Game_Troop クラス、Game_Event クラスの内部で使用されます。
#==============================================================================

class Game_Interpreter
  #--------------------------------------------------------------------------
  # ○ ネームウィンドウ
  #--------------------------------------------------------------------------
  def name_window(params)
    $game_system.use_name_window = params[0] == "on" ? true : false
  end
  #--------------------------------------------------------------------------
  # ○ NWインデックス
  #--------------------------------------------------------------------------
  def nw_index(params)
    $game_temp.name_index = params[0].to_i
  end
  #--------------------------------------------------------------------------
  # ○ NW名前指定
  #--------------------------------------------------------------------------
  def nw_set_name(params)
    $game_temp.direct_show_name = params[0]
  end
end
end