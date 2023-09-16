#==============================================================================
# ■ RGSS3 戦闘中装備変更 Ver1.02 by 星潟
#------------------------------------------------------------------------------
# パーティコマンド、もしくはアクターコマンドに装備変更コマンドを追加します。
# パーティコマンドの場合は全体、アクターコマンドの場合は個別です。
#------------------------------------------------------------------------------
# ★設定例（特徴を有する項目のメモ欄を使用します）
#------------------------------------------------------------------------------
# <戦闘中装備変更>
#
# このアクターのアクターコマンドに装備変更を追加します。
# TYPEが0の場合は意味がありません。
#------------------------------------------------------------------------------
# <戦闘中装備変更禁止:4>
#
# このアクターの装備部位4を戦闘中のみ変更できなくします。
# 装備部位の対応は以下の通りです。（デフォルトの場合です）
# 0 => 武器 1 => 盾 2=> 兜 3=> 鎧 4=> 装飾品
#==============================================================================
module BATTLE_EQUIP_CHANGE
  
  #戦闘中の装備変更コマンドのコマンド名を指定します。
  
  WORD1 = "Equip"
  
  #指定した装備の種類を戦闘中装備変更不可能にします。
  #装備部位の対応は以下の通りです。（デフォルトの場合です）
  #0 => 武器 1 => 盾 2=> 兜 3=> 鎧 4=> 装飾品
  #それぞれ、数字を「,」で区切って指定して下さい。
  #例.[2,3]
  
  SEAL = [1,2,3,4]
  
  #戦闘中の装備変更タイプを指定します。
  #0の場合 パーティコマンドに無条件に追加されます。（アクターの切り替えはL・Rボタン）
  #1の場合 アクターコマンドに無条件に追加されます。（アクターの切り替え不可）
  #2の場合 戦闘中装備変更特徴があるアクターのみ
  #        アクターコマンドに追加されます。（アクターの切り替え不可）
  
  TYPE = 2
  
  #戦闘中、アクターコマンドから呼び出した場合に
  #アクター切り替えをどうするかを決定。
  #0で切り替え可能、1でコマンドウィンドウでの切り替えを禁止、
  #2で装備ウィンドウでの切り替えを禁止（素材スクリプト用）、
  #3で1と2の両方の機能を備える。
  
  ACDL = 3
  
  #TYPE = 0の場合に、必ずバトルメンバーの先頭アクターから開くようにするかを指定。
  #trueでバトルメンバーの先頭、falseで前回メニューのアクターから。
  
  BM = true
  
  #戦闘中の装備変更を可能とする特徴を作成する為の指定用キーワードを指定します。
  #TYPEが1か2の時しか意味はありません。
  
  WORD2 = "戦闘中装備変更"
  
  #部位別に戦闘中の装備変更を禁止する特徴を作成する為の
  #指定用キーワードを指定します。
  #装備変更画面以外の、イベントコマンド等での装備変更は有効です。
  
  WORD3 = "戦闘中装備変更禁止"
  
end
class Game_Temp
  attr_accessor :battle_equip
  #--------------------------------------------------------------------------
  # オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_battle_equip initialize
  def initialize
    
    #本来の処理を実行。
    
    initialize_battle_equip
    
    #装備変更関連を初期化。
    
    @battle_equip = false
    
  end
end
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # 装備変更コマンドの追加可否
  #--------------------------------------------------------------------------
  def equip_command_usable
    
    #特徴の中に装備変更コマンド追加特徴があればtrueを返す。
    
    feature_objects.each {|f| return true if f.equip_command_usable}
    
    #falseを返す。
    
    false
    
  end
  #--------------------------------------------------------------------------
  # 装備変更コマンドの追加可否
  #--------------------------------------------------------------------------
  def equip_command_seal
    
    #空の配列を作成。
    
    array = []
    
    #特徴で戦闘中の装備変更禁止箇所が指定されている場合
    #その箇所の値を配列に加える。
    
    feature_objects.each {|f| array += f.equip_command_seal}
    
    #配列を返す。
    
    array
    
  end
  #--------------------------------------------------------------------------
  # 装備変更の可能判定
  #     slot_id : 装備スロット ID
  #--------------------------------------------------------------------------
  alias equip_change_ok_battle_equip? equip_change_ok?
  def equip_change_ok?(slot_id)
    
    #戦闘中の装備変更であり戦闘中の装備変更禁止箇所に含まれている場合はfalseを返す。
    
    return false if battle_equip_seal.include?(equip_slots[slot_id]) if $game_temp.battle_equip
    
    #本来の処理を実行する。
    
    equip_change_ok_battle_equip?(slot_id)
    
  end
  #--------------------------------------------------------------------------
  # 戦闘中の装備変更禁止箇所
  #--------------------------------------------------------------------------
  def battle_equip_seal
    
    #設定で指定した装備禁止箇所と
    #アクター個別に設定された装備箇所を合わせ
    #重複分を削除して返す。
    
    (BATTLE_EQUIP_CHANGE::SEAL + equip_command_seal).uniq
    
  end
end
class RPG::BaseItem
  #--------------------------------------------------------------------------
  # 装備変更コマンドの追加可否
  #--------------------------------------------------------------------------
  def equip_command_usable
    
    #キャッシュが存在する場合はキャッシュを返す。
    
    (@equip_command_usable ||= self.note.include?("<" + BATTLE_EQUIP_CHANGE::WORD2 + ">") ? 1 : 0) == 1
    
  end
  #--------------------------------------------------------------------------
  # 装備変更コマンド封印判定
  #--------------------------------------------------------------------------
  def equip_command_seal
    
    #キャッシュが存在する場合はキャッシュを返す。
    
    @equip_command_seal ||= create_equip_command_seal
    
  end
  #--------------------------------------------------------------------------
  # 装備変更コマンド封印判定作成
  #--------------------------------------------------------------------------
  def create_equip_command_seal
    
    #メモ欄からデータを取得。
    
    /<#{BATTLE_EQUIP_CHANGE::WORD3}[：:](\S+)>/ =~ note ? $1.to_s.split(/\s*,\s*/).inject([]) {|r,i| r.push(i.to_i)} : []
    
  end
end

#タイプ別に処理を分ける。

case BATTLE_EQUIP_CHANGE::TYPE

#パーティコマンドに追加する場合

when 0
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # 戦闘開始
  #--------------------------------------------------------------------------
  alias battle_start_equip battle_start
  def battle_start
    
    #装備変更から戻ってきた場合は行動を作成し直し
    #パーティコマンドの選択から開始する。
    #そうでない場合は、通常の処理を行う。
    
    if $game_temp.battle_equip
      $game_party.make_actions
      start_party_command_selection
    else
      battle_start_equip
    end
    
    #戦闘中装備変更フラグを初期化する。
    
    $game_temp.battle_equip = false
    
  end
  #--------------------------------------------------------------------------
  # パーティコマンドウィンドウの作成
  #--------------------------------------------------------------------------
  alias create_party_command_window_equip create_party_command_window
  def create_party_command_window
    
    #本来の処理を実行。
    
    create_party_command_window_equip
    
    #装備変更コマンド用と命令を関連付ける。
    
    @party_command_window.set_handler(:equip_change,  method(:command_equip_change))
    
  end
  #--------------------------------------------------------------------------
  # コマンド［装備変更］
  #--------------------------------------------------------------------------
  def command_equip_change
    
    #戦闘中装備変更フラグを立てる。
    
    $game_temp.battle_equip = true
    
    #対象を戦闘メンバーの先頭にするか？
    
    $game_party.menu_actor = $game_party.battle_members[0] if BATTLE_EQUIP_CHANGE::BM
    
    #Scene_Equipを呼び出す。
    
    SceneManager.call(Scene_Equip)
    
  end
end
class Window_PartyCommand < Window_Command
  #--------------------------------------------------------------------------
  # コマンドリストの作成
  #--------------------------------------------------------------------------
  alias make_command_list_equip make_command_list
  def make_command_list
    
    #本来の処理を実行。
    
    make_command_list_equip
    
    #装備変更コマンドを追加する。
    
    add_command(BATTLE_EQUIP_CHANGE::WORD1,  :equip_change)
    
  end
end

#アクターコマンドに追加する場合

when 1..2
class Game_BattlerBase
  def equip_command_usable
    
    #戦闘中装備変更特徴の有無をチェックする。
    
    feature_objects.each {|f| return true if f.equip_command_usable}
    
    false
    
  end
end
class Scene_Equip < Scene_MenuBase
  #--------------------------------------------------------------------------
  # 開始処理
  #--------------------------------------------------------------------------
  alias start_battle_equip start
  def start
    
    #本来の処理を実行。
    
    start_battle_equip
    
    #戦闘中装備変更の場合、装備コマンドウィンドウから
    #アクター切り替えの機能を削除する。
    
    if $game_temp.battle_equip
      
      acdl = BATTLE_EQUIP_CHANGE::ACDL
      @command_window.battle_command_seal if acdl % 2 == 1
      @slot_window.battle_command_seal if acdl > 1
    
    end
  end
end
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # 戦闘開始
  #--------------------------------------------------------------------------
  alias battle_start_equip battle_start
  def battle_start
    
    #戦闘中装備変更から戻った場合ではない場合
    
    if !$game_temp.battle_equip
      
      #本来の処理を実行。
      
      battle_start_equip
    else
      
      #そうでない場合は、ステータスをリフレッシュし
      #ステータスウィンドウを開く。
      
      refresh_status
      @status_window.unselect
      @status_window.open
      
      #アクターが操作不能に陥っている場合は、行動内容を作成して
      #次のアクターにコマンド選択を移す。
      
      if BattleManager.actor && !BattleManager.actor.inputable?
        BattleManager.actor.make_auto_battle_actions
        BattleManager.next_command
      end
      
      #アクターコマンドの選択を開始する。
      
      BattleManager.actor ? start_actor_command_selection : next_command
      
    end
    
    #戦闘中装備変更フラグを初期化する。
    
    $game_temp.battle_equip = false
  end
  #--------------------------------------------------------------------------
  # アクターコマンドウィンドウの作成
  #--------------------------------------------------------------------------
  alias create_actor_command_window_equip create_actor_command_window
  def create_actor_command_window
    
    #本来の処理を実行。
    
    create_actor_command_window_equip
    
    #装備変更コマンド用と命令を関連付ける。
    
    @actor_command_window.set_handler(:equip_change, method(:command_equip_change))
  end
  #--------------------------------------------------------------------------
  # コマンド［装備変更］
  #--------------------------------------------------------------------------
  def command_equip_change
    
    #戦闘中装備変更フラグを立てる。
    
    $game_temp.battle_equip = true
    
    #メニューアクターを行動選択中のアクターにする。
    
    $game_party.menu_actor = BattleManager.actor
    
    #装備画面を開く。
    
    SceneManager.call(Scene_Equip)
    
  end
end
class Window_ActorCommand < Window_Command
  #--------------------------------------------------------------------------
  # コマンドリストの作成
  #--------------------------------------------------------------------------
  alias make_command_list_equip make_command_list
  def make_command_list
    
    #本来の処理を実行。
    
    make_command_list_equip
    
    #アクターが存在しない場合は処理を飛ばす。
    
    return unless @actor
    
    #タイプ1の場合は無条件で追加する。
    #タイプ2の場合は戦闘中装備変更特徴がある場合に追加する。
    
    par = [BATTLE_EQUIP_CHANGE::WORD1, nil]
add_command(par,:equip_change) if BATTLE_EQUIP_CHANGE::TYPE == 1 or @actor.equip_command_usable
    
  end
end
class Window_Selectable < Window_Base
  def battle_command_seal
    
    #アクター切り替えの機能を削除する。
    
    @handler.delete(:pageup)
    @handler.delete(:pagedown)
    
  end
end
end