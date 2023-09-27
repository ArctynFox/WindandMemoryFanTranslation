#==============================================================================
#  ■移動用画面 for RGSS3 Ver1.06-β-fix
#　□作成者 kure
#
#　呼び出し方法 　SceneManager.call(Scene_ShortMove)
#
#==============================================================================

module KURE
  module ShortMove
    #初期設定(変更しないこと)  
    MOVE_LIST = []
    EXPLAN = []
    PLAYER_ICON = []
    CALL_COMMON = []
    ICONLIST = []
  
    
    #移動先設定(以下の設定は項目が対応している為注意)---------------------------
    #MOVE_LIST[0]、EXPLAN[0]、PLAYER_ICON[0]、CALL_COMMON[0]は対応しています。
    
      #表示名、移動先設定
      #MOVE_LIST[0～] = [[表示名,表示するスイッチ,選択可スイッチ,消去スイッチ] ,[マップID, x座標, y座標, 向き(2468)]] #if this messes something up, revert to chinese names
      MOVE_LIST[0] = [["Library Dream",127,0,0],[101,21,21,8]]
      MOVE_LIST[1] = [["Crash Chamber",128,0,0],[1,20,59,2]]
      MOVE_LIST[2] = [["Rabbit Hole",129,0,0],[53,50,52,8]]
      MOVE_LIST[3] = [["Lutwidge Town",130,0,0],[2,24,57,2]]
      MOVE_LIST[4] = [["Mental Ward",131,0,0],[66,21,21,8]] 
      MOVE_LIST[5] = [["Park of Fog",132,0,0],[6,37,67,8]] 
      MOVE_LIST[6] = [["Upper Lutwidge",133,0,0],[151,19,6,8]] 
      MOVE_LIST[7] = [["Ox Ward University",134,0,0],[9,6,83,4]] 
      MOVE_LIST[8] = [["Endless Tea Party",135,0,0],[156,31,36,8]] 
      MOVE_LIST[9] = [["Sick Clock Tower",136,0,0],[158,21,39,4]]       
      MOVE_LIST[10] = [["Liddell Cemetery",137,0,0],[33,33,90,2]]
      MOVE_LIST[11] = [["Ripon Cathedral",138,0,0],[34,48,10,8]] 
      MOVE_LIST[12] = [["Garden of Heart",139,0,0],[35,6,58,4]] 
      MOVE_LIST[13] = [["Red Castle Frissel",140,0,0],[36,11,25,8]] 
      MOVE_LIST[14] = [["Pond of Bloody Tears",141,0,0],[37,22,16,6]] 
      MOVE_LIST[15] = [["Spore Forest",142,0,0],[38,68,17,2]] 
      MOVE_LIST[16] = [["Mushroom Village",143,0,0],[39,49,30,6]] 
      MOVE_LIST[17] = [["Duchess' Mansion",144,0,0],[78,6,8,8]] 
      MOVE_LIST[18] = [["Infinite Food",145,0,0],[42,18,23,8]] 
      MOVE_LIST[19] = [["Billingsgate Market",146,0,0],[91,8,9,8]] 
      MOVE_LIST[20] = [["Fuming Forest",147,0,0],[126,87,14,8]] 
      MOVE_LIST[21] = [["Slaughterhouse",148,0,0],[95,9,13,8]] 
      MOVE_LIST[22] = [["Beach of Grief",149,0,0],[26,16,38,8]] 
      MOVE_LIST[23] = [["Oysters' Rotted Sea",150,0,0],[123,13,11,8]] 
      MOVE_LIST[24] = [["Carroll River",151,0,0],[31,87,50,8]] 
      MOVE_LIST[25] = [["Nameless Forest",152,0,0],[161,127,17,6]] 
      MOVE_LIST[26] = [["Station Hanover",153,0,0],[45,15,28,8]] 
      MOVE_LIST[27] = [["Queensland",154,0,0],[57,9,82,4]] 
      MOVE_LIST[28] = [["Ship Graveyard",155,0,0],[11,58,41,8]] 
      MOVE_LIST[29] = [["Deep Sea",156,0,0],[141,12,32,2]] 
      MOVE_LIST[30] = [["Chaos Dungeon",126,0,0],[202,18,10,2]]
      MOVE_LIST[31] = [["Nursing Graveyard",1041,0,0],[310,14,12,8]]
      MOVE_LIST[32] = [["Deserted Road",1042,0,0],[331,11,8,8]]
      MOVE_LIST[33] = [["Windless Valley",1043,0,0],[343,19,34,6]]
      MOVE_LIST[34] = [["White Castletown",1044,0,0],[347,8,77,2]]
      MOVE_LIST[35] = [["Winterbell",1045,0,0],[353,53,54,2]]
      MOVE_LIST[36] = [["Field of Poppies",1110,0,0],[421,206,49,8]]
      MOVE_LIST[37] = [["Windacre Village",1111,0,0],[441,24,16,8]]
      MOVE_LIST[38] = [["Chittenango",1112,0,0],[424,10,23,8]]
      MOVE_LIST[39] = [["Fallen House",1442,0,0],[449,29,35,8]]
      MOVE_LIST[40] = [["Deep Dark",1444,0,0],[459,95,140,8]]
      MOVE_LIST[41] = [["Bottom of the Black Abyss",1438,0,0],[476,13,12,2]]




      #説明文の設定
      #EXPLAN[0～] = [説明1行目,説明2行目]
      EXPLAN[0] = ["Dreamland imitating the nostalgic library. Connected","to everything, its position remains a mystery."]
      EXPLAN[1] = ["Few of those who wander into the Wonderland fall into","this room, and, unless they are lucky, to their death."]
      EXPLAN[2] = ["Narrow passages strewn with headless corpses.","Here and there, rabbits swarm corpse-flesh."]
      EXPLAN[3] = ["A great town located at the center of the Wonderland.","All houses are stacked like piles of toy blocks."]
      EXPLAN[4] = ["A hospital to treat townsfolk who lost their sanity.","Overwhelmed by their numbers, now it's but a jail."]
      EXPLAN[5] = ["The site of the largest and most prided park of","Lutwidge. Used to be called Hyde Park in the old days."]      
      EXPLAN[6] = ["A residential area packed full of brothels.","Shrieks of women echo from the fog without end."]            
      EXPLAN[7] = ["A moonlit university. Remnants of many experiments","transcending humanity still wander its halls."] 
      EXPLAN[8] = ["The mad tea party of the Hatter, March Hare, and","Dormouse. A fine place if you want to kill time."] 
      EXPLAN[9] = ["A clock tower hidden by the university. The higher you","climb, the more the sounds of the gears drive you mad."] 
      EXPLAN[10] = ["The place where the dead are buried. For them, tonight","is a blessed time. Corpses line to embrace the living."]
      EXPLAN[11] = ["A desolate church even now preaching its God. Faith is","a way to escape reality. But here, there's no escape."]  
      EXPLAN[12] = ["A garden blooming with roses of all colors. Still,","the red roses are the Queen of the Heart's favorite."] 
      EXPLAN[13] = ["A crimson castle, the symbol of the Queen of the Heart.","Absurd trials are held daily; the accused always lose."] 
      EXPLAN[14] = ["A grand lake of blood spreading to the horizon. Here,","bloodshed is common. Hard to say whose tears these are."] 
      EXPLAN[15] = ["A forest of countless mushrooms. Do they appear so","big because of the spores infecting your brain?"]
      EXPLAN[16] = ["A village ruled by the spores. No human is left here,","only beasts serving as hosts for the mushrooms."]
      EXPLAN[17] = ["The mansion of a duchess infamous for her gluttony. All","who enter have no choice but to follow her etiquette."]
      EXPLAN[18] = ["An enormous being kept in the basement of the mansion.","Produces an inexhaustible supply of food inside itself."]
      EXPLAN[19] = ["A gloomy port town lashed by choking winds and rains.","In a sea of rotten fish, fishmen move to take the land."]
      EXPLAN[20] = ["A forest where it's brillig always and forever. The","brelting place was the old home of Wicked Jabberwock."]
      EXPLAN[21] = ["A factory for slaughter of the growing population. No","last comforts will be given here, only pain and agony."]
      EXPLAN[22] = ["A quiet beach with a somewhat grim atmosphere. ","The murmur of the waves grants a momentary respite."]
      EXPLAN[23] = ["A wretched seabed inhabited by giant mollusks. Like it","was for oysters, your curiosity will be your undoing."]
      EXPLAN[24] = ["A river polluted by factory waste.","No golden afternoons will be coming anymore."]
      EXPLAN[25] = ["An eerie, impenetrably dense forest. It's said that","it feeds upon the names of those who get lost in it."]
      EXPLAN[26] = ["A tiny station in the forest with a forgotten train.","Surrounded by mummified corpses and lumps of flesh."]
      EXPLAN[27] = ["An adult amusement park ruled by the Red Idol. Enjoy","the shows, and let the fireworks and trysts bloom."]
      EXPLAN[28] = ["A graveyard of sunken ships. As if sympathizing","with them, a giant shape blocks the sunlight."]
      EXPLAN[29] = ["The bottom of the deep sea where ominous fish lives.","There's no hope above. If there is any, it's below."]
      EXPLAN[30] = ["A room located in-between the Red and the White. In it,","the past and the future mix, and the space-time warps."]
      EXPLAN[31] = ["A world locked in a cycle of outbreaks and cures.","Here, there's a grave ready for each and every patient."]
      EXPLAN[32] = ["A dilapidated road buried under neverending snowfall.","The place where visitors begin their path."]
      EXPLAN[33] = ["A windless valley filled with the howling of the wind.","With the fitting disguise, even a god can be tricked."]
      EXPLAN[34] = ["Everyone's gone, and only a lonely castletown remains.","With the Crown on the line, white is sure to be dyed red."]
      EXPLAN[35] = ["A sacred ground surrounded by the sea.","The beautiful scenery displays the Queen's aestheticism."]
      EXPLAN[36] = ["A boundless expanse of desolate fields. The platforms along","the endless railroad may forever wait for arriving passengers."]
      EXPLAN[37] = ["A village eroded by a sudden mist. Residents whose minds","were distorted could hardly fathom this being their destined end."]
      EXPLAN[38] = ["A once-prosperous Eastern realm, destroyed by a heaven-sent madness.","Offer all to nonexistent gods; they'll answer your blind devotion."]
      EXPLAN[39] = ["A nostalgic, dilapidated house that fell from a colossal whirlwind.","Can this strange sense of familiarity revive forgotten memories?"]
      EXPLAN[40] = ["A dark subterranean space beneath the golden fields.","The shadows cast here are the ultimate nightmare at the journey's end."]
      EXPLAN[41] = ["The bottom of a black abyss, where no light can reach. The corpses,","fallen from the realm above, radiate an aura of despair and suffering."]
      #プレーヤーのアイコン(選択肢対応アイコン)
      #PLAYER_ICON[0～] = [アイコンタイプ,アイコンX,アイコンY]
      #アイコンタイプ
      # 0 → 隊列先頭のキャラクター 
      # PLAYER_ICON[0] = [0, x, y]
      #
      # 1 → 四角形
      # PLAYER_ICON[0] = [1, x, y, [size,red,green,blue]]
      #
      # 2 → 画像ファイル(Pictureフォルダに入れること)
      # PLAYER_ICON[0] = [2, x, y, filename]
      #
      
      PLAYER_ICON[0] = [0,435,50]
      PLAYER_ICON[1] = [0,180,150]
      PLAYER_ICON[2] = [0,180,150]
      PLAYER_ICON[3] = [0,190,180]
      PLAYER_ICON[4] = [0,140,180]
      PLAYER_ICON[5] = [0,210,140]
      PLAYER_ICON[6] = [0,250,120] 
      PLAYER_ICON[7] = [0,210,90]  
      PLAYER_ICON[8] = [0,300,90] 
      PLAYER_ICON[9] = [0,305,60]        
      PLAYER_ICON[10] = [0,90,175]
      PLAYER_ICON[11] = [0,90,155]
      PLAYER_ICON[12] = [0,80,135]
      PLAYER_ICON[13] = [0,85,110]
      PLAYER_ICON[14] = [0,30,150]
      PLAYER_ICON[15] = [0,40,110]
      PLAYER_ICON[16] = [0,70,45]
      PLAYER_ICON[17] = [0,20,85]
      PLAYER_ICON[18] = [0,20,85]
      PLAYER_ICON[19] = [0,240,255]
      PLAYER_ICON[20]= [0,90,240]
      PLAYER_ICON[21]= [0,200,320]
      PLAYER_ICON[22]= [0,370,210]
      PLAYER_ICON[23]= [0,370,170]
      PLAYER_ICON[24]= [0,350,325]
      PLAYER_ICON[25]= [0,120,350]
      PLAYER_ICON[26]= [0,90,330]
      PLAYER_ICON[27]= [0,30,320]
      PLAYER_ICON[28]= [0,410,180]
      PLAYER_ICON[29]= [0,420,180]
      PLAYER_ICON[30] = [0,435,50]
      PLAYER_ICON[31] = [0,435,50]
      PLAYER_ICON[32]= [0,370,355]
      PLAYER_ICON[33]= [0,440,290]
      PLAYER_ICON[34]= [0,440,260]
      PLAYER_ICON[35]= [0,440,240]
      PLAYER_ICON[36]= [0,175,50]
      PLAYER_ICON[37]= [0,175,60]
      PLAYER_ICON[38]= [0,185,65]
      PLAYER_ICON[39]= [0,185,55]
      PLAYER_ICON[40]= [0,190,55]
      PLAYER_ICON[41]= [0,190,60]
      
      
      #移動と同時に呼び出すコモンイベントのID
      #CALL_COMMON[0～] = [ID配列]
      CALL_COMMON[0] = [213]
      CALL_COMMON[1] = [2]
      CALL_COMMON[2] = [2]
      CALL_COMMON[3] = [2]
      CALL_COMMON[4] = [214]
      CALL_COMMON[5] = [2]
      CALL_COMMON[6] = [2]
      CALL_COMMON[7] = [2]
      CALL_COMMON[8] = [2]
      CALL_COMMON[9] = [2] 
      CALL_COMMON[10] = [2]
      CALL_COMMON[11] = [2]
      CALL_COMMON[12] = [2]
      CALL_COMMON[13] = [2]
      CALL_COMMON[14] = [2] 
      CALL_COMMON[15] = [2]
      CALL_COMMON[16] = [2]
      CALL_COMMON[17] = [2]
      CALL_COMMON[18] = [2]
      CALL_COMMON[19] = [2]      
      CALL_COMMON[20] = [2]     
      CALL_COMMON[21] = [2]  
      CALL_COMMON[22] = [2]  
      CALL_COMMON[23] = [2]  
      CALL_COMMON[24] = [2] 
      CALL_COMMON[25] = [2] 
      CALL_COMMON[26] = [2] 
      CALL_COMMON[27] = [2] 
      CALL_COMMON[28] = [2] 
      CALL_COMMON[29] = [2] 
      CALL_COMMON[30] = [2] 
      CALL_COMMON[31] = [2] 
      CALL_COMMON[32] = [2] 
      CALL_COMMON[33] = [2] 
      CALL_COMMON[34] = [2] 
      CALL_COMMON[35] = [2]
      CALL_COMMON[36] = [2]
      CALL_COMMON[37] = [2]
      CALL_COMMON[38] = [2]
      CALL_COMMON[39] = [2]
      CALL_COMMON[40] = [2]
      CALL_COMMON[41] = [2]
    #マップ上に表示するアイコンの設定-------------------------------------------
      #ICONLIST[0～] = [アイコンタイプ,アイコンX,アイコンY,表示スイッチ,消去スイッチ,各種設定]
      #必要な数に応じて項目を追加してください
      #アイコンタイプによる設定の違い
      # 0 → アクターを描画します
      # ICONLIST[0] = [0, x, y, switch_id, switch_id, actor_id]
      #　
      # 1 → 四角形
      # ICONLIST[1] = [1, x, y, switch_id, switch_id, [size,red,green,blue]]
      #
      # 2 → 画像ファイル(Pictureフォルダに入れること)
      # ICONLIST[1] = [2, x, y, switch_id, switch_id, filename]
      #
      

    
    #MAPDATA
    #png形式の画像データを「Picture」フォルダに入れること(380×296)
    MAPDATA = "map"
 
  end
end

#==============================================================================
# ■ Scene_ShortMove
#------------------------------------------------------------------------------
# 　キャラクターメイキングの処理を行うクラスです。
#==============================================================================
class Scene_ShortMove < Scene_MenuBase
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    create_command_window
    create_map_window
    create_icon_window
    create_info_window
    create_popup_window
    
    set_window_task
  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウの作成
  #--------------------------------------------------------------------------
  def create_command_window
    #キャラクター選択ウィンドウを作成
    @command_window = Window_k_ShortMove_Command.new(0, 0)
    @command_window.height = Graphics.height
    @command_window.activate
    #呼び出しのハンドラをセット
    @command_window.set_handler(:ok,method(:select_command))
    @command_window.set_handler(:cancel,method(:on_cancel))
  end
  #--------------------------------------------------------------------------
  # ● アイコンウィンドウの作成
  #--------------------------------------------------------------------------
  def create_icon_window    
    x = @command_window.width
    y = 0
    ww = Graphics.width - x
    wh = Graphics.height - 24 * 4
    @icon_window = Window_k_ShortMove_Icon.new(x,y,ww,wh)
    @icon_window.z += 10
    @icon_window.opacity = 0
    @icon_window.refresh
  end
  #--------------------------------------------------------------------------
  # ● マップウィンドウの作成
  #--------------------------------------------------------------------------
  def create_map_window    
    x = @command_window.width
    y = 0
    ww = Graphics.width - x
    wh = Graphics.height - 24 * 4
    @map_window = Window_k_ShortMove_Map.new(x,y,ww,wh)
    @map_window.refresh
  end
  #--------------------------------------------------------------------------
  # ● インフォメーションウィンドウの作成
  #--------------------------------------------------------------------------
  def create_info_window
    x = @command_window.width
    y = @map_window.height
    ww = Graphics.width - x
    wh = Graphics.height - y
    @info_window = Window_k_ShortMove_Info.new(x,y,ww,wh)
  end
  #--------------------------------------------------------------------------
  # ● ポップアップウィンドウの作成
  #--------------------------------------------------------------------------
  def create_popup_window
    wx = (Graphics.width - 180)/2
    wy = (Graphics.height - 180)/2
    @popup_window = Window_k_ShortMove_Pop.new(wx, wy)
    @popup_window.unselect
    @popup_window.deactivate
    @popup_window.z  += 10
    @popup_window.hide 
    #ハンドラのセット
    @popup_window.set_handler(:cancel,   method(:pop_cancel))
    @popup_window.set_handler(:ok,   method(:pop_ok)) 
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウのセッティング処理
  #--------------------------------------------------------------------------
  def set_window_task
    @command_window.info_window = @info_window
    @command_window.map_window = @map_window
    @command_window.icon_window = @icon_window
    @command_window.select(0)
    
    @info_window.refresh
  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウ[決定]
  #--------------------------------------------------------------------------
  def select_command
    pop_open
  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウ[キャンセル]
  #--------------------------------------------------------------------------
  def on_cancel
    Cache.clear
    SceneManager.return
  end 
  #--------------------------------------------------------------------------
  # ● ポップアップウィンドウ[決定]
  #--------------------------------------------------------------------------
  def pop_ok
    case @popup_window.current_ext
    when 1
      #画像キャッシュをクリアしておく
      Cache.clear
      
      move_point = @command_window.current_ext
      map_id = move_point[0][1][0]
      x = move_point[0][1][1]
      y = move_point[0][1][2]
      dir = move_point[0][1][3]
      
      fadeout_all(300)
      $game_player.reserve_transfer(map_id, x, y, dir)
      $game_player.perform_transfer
      SceneManager.call(Scene_Map)
      $game_temp.recall_map_name = 1
      $game_map.autoplay
      
      call_common(move_point[1])
    when 2
      pop_close
    end
  end
  #--------------------------------------------------------------------------
  # ● ポップアップウィンドウ[キャンセル]
  #--------------------------------------------------------------------------
  def pop_cancel
    pop_close
  end
  #--------------------------------------------------------------------------
  # ● コモンイベント呼び出し[キャンセル]
  #--------------------------------------------------------------------------
  def call_common(list)
    event = KURE::ShortMove::CALL_COMMON[list]
    event.each do |id|
      $game_temp.reserve_common_event(id)
    end
  end
  #--------------------------------------------------------------------------
  # ● ポップアップウィンドウ[開く]
  #--------------------------------------------------------------------------
  def pop_open
    @popup_window.show
    @popup_window.select(1)
    @popup_window.activate
    @command_window.deactivate
  end
  #--------------------------------------------------------------------------
  # ● ポップアップウィンドウ[閉じる]
  #--------------------------------------------------------------------------
  def pop_close
    @popup_window.hide
    @popup_window.unselect
    @popup_window.deactivate
    @command_window.activate
  end
end


#==============================================================================
# ■ Window_k_ShortMove_Command
#==============================================================================
class Window_k_ShortMove_Command < Window_Command
  attr_accessor :info_window
  attr_accessor :map_window
  attr_accessor :icon_window
  #--------------------------------------------------------------------------
  # ● ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    return 140
  end
  #--------------------------------------------------------------------------
  # ● カーソル位置の設定
  #--------------------------------------------------------------------------
  def index=(index)
    @index = index
    update_cursor
    call_update_help
    
    @info_window.select = current_ext if @info_window
    @map_window.select = current_ext if @map_window
    @icon_window.select = current_ext if @icon_window
  end
  #--------------------------------------------------------------------------
  # ● コマンドリストの作成
  #--------------------------------------------------------------------------
  def make_command_list
    master = KURE::ShortMove::MOVE_LIST
    for i in 0..master.size - 1
      if visible?(master[i])
        add_command(master[i][0][0], :ok, selectable?(master[i]), [master[i],i])
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 表示の可否
  #--------------------------------------------------------------------------
  def visible?(list)
    return false if list[0][3] != 0 && $game_switches[list[0][3]]
    if list[0][3] == 0
      return true if list[0][1] == 0
      return true if $game_switches[list[0][1]] 
      return false
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● 選択の可否
  #--------------------------------------------------------------------------
  def selectable?(list)
    return true if list[0][2] == 0
    return true if $game_switches[list[0][2]]
    return false
  end
end

#==============================================================================
# ■ Window_k_ShortMove_Map
#==============================================================================
class Window_k_ShortMove_Map < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #-------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @select = nil
  end
  #--------------------------------------------------------------------------
  # ● 選択中のMAPデータを更新
  #--------------------------------------------------------------------------
  def select=(select)
    return if @select == select
    @select = select
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    
    bitmap = Cache.picture(KURE::ShortMove::MAPDATA)
    #描画
    self.contents.blt(0, 0, bitmap, bitmap.rect)
  end
end

#==============================================================================
# ■ Window_k_ShortMove_Icon
#==============================================================================
class Window_k_ShortMove_Icon < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #-------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @select = nil
  end
  #--------------------------------------------------------------------------
  # ● 選択中のMAPデータを更新
  #--------------------------------------------------------------------------
  def select=(select)
    return if @select == select[1]
    @select = select[1]
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return unless @select
    
    draw_list = KURE::ShortMove::ICONLIST
    
    draw_list.each do |list|
      next if list == [] 
      #描画判定
      if list[3] != 0
        next unless $game_switches[list[3]]
      end
      
      if list[4] != 0
        next if $game_switches[list[4]]
      end
      
      #アイコンタイプ
      case list[0]
      #アクター描画
      when 0
        actor = $game_actors[list[5]]
        next unless actor
    
        x = list[1]
        y = list[2]
        draw_character(actor.character_name, actor.character_index , x, y)
      #四角形描画  
      when 1
        size = 7 ; size2 = 3
        red = 0 ; green = 0 ; blue = 0
        if list[5] 
          if list[5][0]
            size = list[5][0]
            size2 = (list[5][0] / 2).truncate
          end
          if list[5][1] && list[5][2] && list[5][3]
            red = list[5][1]
            green = list[5][2]
            blue = list[5][3]
          end
        end
        
        rect = Rect.new(list[1] - size2,list[2] - size2,size,size)
        color = Color.new(red, green, blue) 
        contents.fill_rect(rect, color)
      #画像描画
      when 2
        next unless list[5]
        bitmap = Cache.picture(list[5])
        self.contents.blt(list[1], list[2], bitmap, bitmap.rect) 
      end
      
    end
    
    player = KURE::ShortMove::PLAYER_ICON[@select]
    case player[0]
    #アクター描画
    when 0
      actor = $game_party.battle_members[0]
      return unless actor
    
      x = player[1]
      y = player[2]
      draw_character(actor.character_name, actor.character_index , x, y)
    #四角形
    when 1
        size = 7 ; size2 = 3
        red = 0 ; green = 0 ; blue = 0
        if player[3] 
          if player[3][0]
            size = player[3][0]
            size2 = (player[3][0] / 2).truncate
          end
          if player[3][1] && player[3][2] && player[3][3]
            red = player[3][1]
            green = player[3][2]
            blue = player[3][3]
          end
        end
        
        rect = Rect.new(player[1] - size2,player[2] - size2,size,size)
        color = Color.new(red, green, blue) 
        contents.fill_rect(rect, color)
    #画像描画
    when 2
      return unless player[3]
      bitmap = Cache.picture(player[3])
      self.contents.blt(player[1], player[2], bitmap, bitmap.rect) 
      
    end
    
  end
end

#==============================================================================
# ■ Window_k_ShortMove_Info
#==============================================================================
class Window_k_ShortMove_Info < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #-------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @select = nil
  end
  #--------------------------------------------------------------------------
  # ● 選択中のMAPデータを更新
  #--------------------------------------------------------------------------
  def select=(select)
    return if @select == select[1]
    @select = select[1]
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    return unless @select
    contents.clear
    
    title = KURE::ShortMove::MOVE_LIST[@select][0][0]
    explan = KURE::ShortMove::EXPLAN[@select]
    
    draw_text(0, 0, contents_width, line_height, title)
    
    return unless explan
      draw_text(0, line_height * 1, contents_width, line_height, explan[0]) if explan[0]
      draw_text(0, line_height * 2, contents_width, line_height, explan[1]) if explan[1]
    end
end


#==============================================================================
# ■ Window_k_ShortMove_Pop
#==============================================================================
class Window_k_ShortMove_Pop < Window_Command
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y)
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    return 180
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ高さの取得
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(visible_line_number)
  end
  #--------------------------------------------------------------------------
  # ● コマンドリストの作成
  #--------------------------------------------------------------------------
  def make_command_list
    add_command("Travel", :ok, true, 1)
    add_command("Cancel", :ok, true, 2)
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    clear_command_list
    make_command_list
    create_contents
    self.height = window_height
    select(0)
    super
  end
end

#==============================================================================
# ■ Game_Temp
#==============================================================================
class Game_Temp
  attr_accessor :recall_map_name             # 場所移動時のフェードタイプ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化(エイリアス再定義)
  #--------------------------------------------------------------------------
  alias k_before_shotmove_initialize initialize
  def initialize
    k_before_shotmove_initialize
    @recall_map_name = 0
  end
end

#==============================================================================
# ■ Scene_Map
#==============================================================================
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # ● 開始処理(エイリアス再定義)
  #--------------------------------------------------------------------------
  alias k_before_shotmove_start start
  def start
    k_before_shotmove_start
    recall_map_name_window
  end
  #--------------------------------------------------------------------------
  # ● マップ名表示処理(追加定義)
  #--------------------------------------------------------------------------
  def recall_map_name_window
    if $game_temp.recall_map_name == 1
      @map_name_window.open
      $game_temp.recall_map_name = 0
    end
  end
end