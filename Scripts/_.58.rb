=begin
      RGSS3
      
      ★ バトルボイス ★
      
      戦闘中の行動に応じてボイスを再生します。
      
      ● 使い方 ●========================================================
      Audioフォルダ配下に「VOICE」というフォルダを作成し、
      そこにボイスファイルを保存してください。
      --------------------------------------------------------------------
      アイテム・スキルの使用前にボイスを再生する機能がありますが、
      メモ欄に「使用ボイス無し」と記述されたアイテム・スキルを使用した
      際には、その機能は無効化されます。
      ====================================================================
      
      ● イベントコマンド ●==============================================
      初期状態ではアクターにはアクターIDと等しいIDのボイス設定が適応されています。
        例) アクターIDが 2 のアクターには ボイス設定の 2 が対応
      --------------------------------------------------------------------
      イベントコマンドのスクリプトより下記のコードを実行することで、
      アクターが使用するボイス設定を任意のものに変更できます。
      --------------------------------------------------------------------
      change_voice(actor_id, voice_id)
      --------------------------------------------------------------------
      actor_id : ボイス設定を変更したいアクターID
      voice_id : 利用したいボイス設定ID
      --------------------------------------------------------------------
        例) change_voice(2, 14)
          上記スクリプトを実行すると、
          「アクターIDが 2 のアクターには ボイス設定の 14 が対応」
          といったように設定が変更されます。
      ====================================================================
      
      ● スキル別のボイス設定方法 ●======================================
      「VOICE」フォルダに [vid○_sid○] という形式の文字列が含まれた
      ファイル名のボイスファイルが存在する場合、自動的に再生されます。
      ○の部分には ボイス設定ID と スキルID を数値で指定します。
      --------------------------------------------------------------------
      この設定がされたスキルを使用した際には、
      設定箇所で設定されたスキル使用時のボイスよりも優先して再生されます。
      --------------------------------------------------------------------
        例1)
        ボイス設定ID 3 に対応するバトラーが
        スキルID 55 のスキルを使用した際に
        ボイスファイル skill_ice.wav を再生させたい場合、
        ボイスファイル名を skill_ice[vid3_sid55].wav とします。
        
        この場合 [vid3_sid55] はどの位置に含めても構いません。
        例えば skill[vid3_sid55]_ice.wav としても問題なく動作します。
      --------------------------------------------------------------------
        例2)
        skill_ice1[vid3_sid55].wav
        skill_ice2[vid3_sid55].wav
        skill_ice3[vid3_sid55].wav
        
        上記のように、同じ設定をしたボイスファイルが複数存在する場合、
        ランダムで再生されるファイルが選択されます。
      ====================================================================
      
      ● 注意 ●==========================================================
      ニューゲームから始めないとエラーを吐きます。
      ====================================================================
      
      ver1.10
      
      Last Update : 2013/06/28
      06/28 : スキル別にボイスの設定を可能に
      ----------------------2013--------------------------
      06/10 : 新規
      ----------------------2012--------------------------
      
      ろかん　　　http://kaisou-ryouiki.sakura.ne.jp/
=end

#===========================================
#   設定箇所
#===========================================
module BattleVoice
#-----------------------------------------------------------------------------
# 各戦闘行動に対してボイスを設定してください。
# 設定のないバトラーのボイスは再生されません。
# 設定の基本形式は以下のとおりです。
#【形式】
# ① => ["②", "②", "②".....],
#   ① ボイス設定ID(数値)
#      初期状態ではこの値はアクターID もしくは エネミーIDに対応しています。
#      エネミーのボイスを設定する場合には ID を"負の値にして"設定してください。
#      例) IDが 4 のエネミーを設定する場合、-4 とする。
#
#   ② ボイスファイル名(文字列,拡張子不要)
#      同キャラクターに複数のボイスが設定されている場合、
#      ランダムで再生されるファイルが選択されます。
#-----------------------------------------------------------------------------
VOICE_LIST = {
  :battle_start_normal => {
  # ◆ 戦闘開始時:通常(生存メンバーからランダムで一人選んで再生されます)
  # エネミー未対応
    1 => [],
  },
  
  :battle_start_pinch => {
  # ◆ 戦闘開始時:ピンチ(生存メンバーからランダムで一人選んで再生されます)
  # 戦闘開始時に戦闘不能のメンバーが一人でもいる場合に再生
  # エネミー未対応
    1 => [],
  },
  
  :battle_start_surprise => {
  # ◆ 戦闘開始時:不意打ち(生存メンバーからランダムで一人選んで再生されます)
  # ピンチよりも優先されます。
  # エネミー未対応
    1 => [],
  },
  
  :battle_start_preemptive => {
  # ◆ 戦闘開始時:先制攻撃(生存メンバーからランダムで一人選んで再生されます)
  # ピンチよりも優先されます。
  # エネミー未対応
    1 => [],
  },
  
  :attack => {
  # ◆ 通常攻撃
    1 => [],
  },
  
  :guard => {
  # ◆ 防御
    1 => [],
  },
  
  :damage => {
  # ◆ 被ダメージ
    1 => [],
  },
  
  :evasion => {
  # ◆ 回避
    1 => [],
  },
  
  :miss => {
  # ◆ ミス
    1 => [],
  },
  
  :use_item => {
  # ◆ アイテム使用
  # エネミー未対応
    1 => [],
  },
  
  :use_skill => {
  # ◆ スキル使用
  # 個別にボイスの設定がされていないスキルを使用した際に再生されます。
    1 => [],
  },
  
  :dead => {
  # ◆ 戦闘不能
    2 => ["主人公死ぬ"],
    3 => ["主人公死ぬ"],
    4 => ["主人公死ぬ"],
    5 => ["主人公死ぬ"],
    6 => ["主人公死ぬ"],
    7 => ["主人公死ぬ"],
    8 => ["主人公死ぬ"],
    9 => ["主人公死ぬ"],
    11 => ["主人公死ぬ"],
  },
  
  :recovery => {
  # ◆ 自分以外の仲間からの回復
  # HP の回復, バッドステートの解除
    1 => [],
  },
  
  :support_state => {
  # ◆ 自分以外の仲間からのサポートステート付加
    1 => [],
  },
  
  :bad_state => {
  # ◆ バッドステートが付加
  # バッドステート解除、サポートステート付加よりも優先されます。
    1 => [],
  },
  
  :victory_normal => {
  # ◆ 勝利:通常(生存メンバーからランダムで一人選んで再生されます)
  # エネミー未対応
    1 => [],
  },
  
  :victory_pinch => {
  # ◆ 勝利:ピンチ(生存メンバーからランダムで一人選んで再生されます)
  # 勝利時にピ戦闘不能のメンバーが一人でもいる場合に再生
  # エネミー未対応
    1 => [],
  },
  
  :victory_perfect => {
  # ◆ 勝利:ノーダメージ(生存メンバーからランダムで一人選んで再生されます)
  # ピンチよりも優先されます。
  # エネミー未対応
    1 => [],
  },
  
  :escape => {
  # ◆ 逃走(アクター側は生存メンバーからランダムで一人選んで再生されます)
    1 => [],
  },
}

# ◆ 沈黙ステートID
# ここに登録されたステートが付加しているキャラクターのボイスは
# 再生されなくなります。(沈黙や睡眠など....)
SILENT_STATES = []

# ◆ ボイス再生を無効化するスイッチ番号
# ここで指定したスイッチが ON の場合、全てのボイスが再生されなくなります。
SILENT_SWITCH = 522

# ◆ ボイスの音量
VOICE_VOLUME = 90

# ◆ ボイス再生直後に挟むウェイト
# ボイスファイルの頭に無音帯がある等の理由で
# タイミングが合わない場合に利用してください(0～15程度が無難)。
# 必要ない場合は 0 に。
VOICE_WAIT = 10

end
class Window_BattleLog < Window_Selectable
# ◆ サポートステート定義 (パラメーター上昇系など....)
SUPPORT_STATES = [14, 15, 16, 21, 22, 23]
 
# ◆ バッドステート定義 (毒や麻痺など....)
BAD_STATES = [2, 3, 4, 5, 6, 7, 8]

end
#===========================================
#   ここまで
#===========================================

$rsi ||= {}
$rsi["バトルボイス"] = true

class RPG::UsableItem < RPG::BaseItem
  def play_voice?
    !@note.include?("使用ボイス無し")
  end
end

module BattleVoice
  module_function
  #--------------------------------------------------------------------------
  # ● 生存しておりボイス再生可能なメンバーからランダムで取得
  #--------------------------------------------------------------------------
  def get_rand_member_id(scene_symbol)
    battler = $game_party.alive_members.select{|member|
      if !VOICE_LIST[scene_symbol].has_key?(member.voice_id)
        false
      elsif SILENT_STATES.empty?
        true
      else
        !silent_battler?(member)
      end
    }.sample
    battler ? battler.voice_id : 0
  end
  #--------------------------------------------------------------------------
  # ● ボイス再生不可判定
  #--------------------------------------------------------------------------
  def silent_battler?(battler)
    SILENT_STATES.any?{|state_id| battler.state?(state_id)}
  end
  #--------------------------------------------------------------------------
  # ● 再生するファイル名の取得(nilが返る場合は再生されません)
  #--------------------------------------------------------------------------
  def get_filename(scene_symbol, key)
    VOICE_LIST[scene_symbol][key].sample if VOICE_LIST[scene_symbol][key]
  end
  #--------------------------------------------------------------------------
  # ● 使用スキル専用のボイスが用意されている場合にそのファイル名を取得
  #--------------------------------------------------------------------------
  def get_skill_filename(key, skill_id)
    filename = Dir::glob("Audio/VOICE/*\\[vid#{key}_sid#{skill_id}\\]*").sample
    File.basename(filename) if filename
  end
  #--------------------------------------------------------------------------
  # ● バトルボイスの再生
  #--------------------------------------------------------------------------
  def play(scene_symbol, battler = nil)
    unless $game_switches[SILENT_SWITCH]
      if battler
        key = battler.actor? ? battler.voice_id : (battler.enemy_id * -1)
        return if silent_battler?(battler)
        filename = get_skill_filename(key, battler.current_action.item.id) if scene_symbol == :use_skill
      else
        key = get_rand_member_id(scene_symbol)
      end
      filename = get_filename(scene_symbol, key) unless filename
      if filename
        Audio.se_play('Audio/VOICE/' + filename, VOICE_VOLUME, 100)
        wait(VOICE_WAIT)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ウェイト
  #--------------------------------------------------------------------------
  def wait(duration)
    SceneManager.scene.wait(duration)
  end
end

class << BattleManager
  #--------------------------------------------------------------------------
  # ● 戦闘開始
  #--------------------------------------------------------------------------
  alias battle_start_voice_plus battle_start
  def battle_start
    $game_temp.no_damage = true
    $game_party.on_battle_start
    if @preemptive
      BattleVoice.play(:battle_start_preemptive)
    elsif @surprise
      BattleVoice.play(:battle_start_surprise)
    elsif $game_party.pinch?
      BattleVoice.play(:battle_start_pinch)
    else
      BattleVoice.play(:battle_start_normal)
    end
    battle_start_voice_plus
  end
  #--------------------------------------------------------------------------
  # ● 勝利の処理
  #--------------------------------------------------------------------------
  alias process_victory_voice_plus process_victory
  def process_victory
    if $game_temp.no_damage
      BattleVoice.play(:victory_perfect)
    elsif $game_party.pinch?
      BattleVoice.play(:victory_pinch)
    else
      BattleVoice.play(:victory_normal)
    end
    process_victory_voice_plus
  end
  #--------------------------------------------------------------------------
  # ● 逃走の処理　　　※再定義
  #--------------------------------------------------------------------------
  def process_escape
    $game_message.add(sprintf(Vocab::EscapeStart, $game_party.name))
    success = @preemptive ? true : (rand < @escape_ratio)
    Sound.play_escape
    if success
      BattleVoice.play(:escape)
      process_abort
    else
      @escape_ratio += 0.1
      $game_message.add('\.' + Vocab::EscapeFailure)
      $game_party.clear_actions
    end
    wait_for_message
    return success
  end
end

class Game_Temp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :no_damage  # 戦闘中ノーダメージフラグ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_voice_plus initialize
  def initialize
    initialize_voice_plus
    @no_damage = true
  end
end

class Game_Action
  #--------------------------------------------------------------------------
  # ● 防御判定
  #--------------------------------------------------------------------------
  def guard?
    item == $data_skills[subject.guard_skill_id]
  end
end

class Game_ActionResult
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :added_new_states
  #--------------------------------------------------------------------------
  # ● ステータス効果のクリア
  #--------------------------------------------------------------------------
  alias clear_status_effects_voice_plus clear_status_effects
  def clear_status_effects
    @added_new_states = []
    clear_status_effects_voice_plus
  end
end

class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # ● 新しいステートの付加
  #--------------------------------------------------------------------------
  alias add_new_state_voice_plus add_new_state
  def add_new_state(state_id)
    @result.added_new_states.push(state_id).uniq!
    add_new_state_voice_plus(state_id)
  end
end

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :voice_id
  #--------------------------------------------------------------------------
  # ● セットアップ
  #--------------------------------------------------------------------------
  alias setup_voice_plus setup
  def setup(actor_id)
    setup_voice_plus(actor_id)
    @voice_id = @actor_id
  end
  #--------------------------------------------------------------------------
  # ● 被ダメージ時の処理
  #--------------------------------------------------------------------------
  def on_damage(value)
    super(value)
    $game_temp.no_damage = false
  end
  #--------------------------------------------------------------------------
  # ● ダメージ効果の実行
  #--------------------------------------------------------------------------
  alias perform_damage_effect_voice_plus perform_damage_effect
  def perform_damage_effect
    BattleVoice.play(:damage, self) unless dead?
    perform_damage_effect_voice_plus
  end
  #--------------------------------------------------------------------------
  # ● HP の再生
  #--------------------------------------------------------------------------
  def regenerate_hp
    super
    $game_temp.no_damage = false if @result.hp_damage > 0
  end
  #--------------------------------------------------------------------------
  # ● コラプス効果の実行
  #--------------------------------------------------------------------------
  alias perform_collapse_effect_voice_plus perform_collapse_effect
  def perform_collapse_effect
    perform_collapse_effect_voice_plus
    BattleVoice.play(:dead, self) if $game_party.in_battle
  end
end

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # ● ダメージ効果の実行
  #--------------------------------------------------------------------------
  alias perform_damage_effect_voice_plus perform_damage_effect
  def perform_damage_effect
    BattleVoice.play(:damage, self) unless dead?
    perform_damage_effect_voice_plus
  end
  #--------------------------------------------------------------------------
  # ● コラプス効果の実行
  #--------------------------------------------------------------------------
  alias perform_collapse_effect_voice_plus perform_collapse_effect
  def perform_collapse_effect
    perform_collapse_effect_voice_plus
    BattleVoice.play(:dead, self)
  end
  #--------------------------------------------------------------------------
  # ● 逃げる
  #--------------------------------------------------------------------------
  def escape
    BattleVoice.play(:escape, self)
    super
  end
end

class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # ● ピンチ状態判定
  #--------------------------------------------------------------------------
  def pinch?
    !dead_members.empty?
  end
end

class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● アクターのボイス変更
  #--------------------------------------------------------------------------
  def change_voice(actor_id, voice_id)
    $game_actors[actor_id].voice_id = voice_id
  end
end

class Window_BattleLog < Window_Selectable  
  #--------------------------------------------------------------------------
  # ● ダメージの表示
  #--------------------------------------------------------------------------
  alias display_damage_voice_plus display_damage
  def display_damage(target, item)
    subject = SceneManager.scene.subject
    if target.result.missed
      BattleVoice.play(:miss, subject)
    elsif target.result.evaded
      BattleVoice.play(:evasion, target)
    else
      if subject != target && subject.actor? == target.actor? && !target.dead? &&
        (target.result.hp_damage < 0 || target.result.mp_damage < 0 || target.result.tp_damage < 0)
        BattleVoice.play(:recovery, target)
      end
    end
    display_damage_voice_plus(target, item)
  end
  #--------------------------------------------------------------------------
  # ● 影響を受けたステータスの表示
  #--------------------------------------------------------------------------
  alias display_affected_status_voice_plus display_affected_status
  def display_affected_status(target, item)
    if item && target.result.status_affected?
      subject = SceneManager.scene.subject
      if subject != target
        if target.result.added_new_states.any?{|id| BAD_STATES.include?(id)}
          BattleVoice.play(:bad_state, target)
        elsif subject.actor? == target.actor?
          if target.result.removed_states.any?{|id| BAD_STATES.include?(id)}
            BattleVoice.play(:recovery, target)
          elsif target.result.added_new_states.any?{|id| SUPPORT_STATES.include?(id)}
            BattleVoice.play(:support_state, target)
          end
        end
      end
    end
    display_affected_status_voice_plus(target, item)
  end
end

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :subject
  #--------------------------------------------------------------------------
  # ● スキル／アイテムの使用
  #--------------------------------------------------------------------------
  alias use_item_voice_plus use_item
  def use_item
    if @subject.current_action.attack?
      BattleVoice.play(:attack, @subject)
    elsif @subject.current_action.guard?
      BattleVoice.play(:guard, @subject)
    else
      if @subject.current_action.item.play_voice?
        case @subject.current_action.item
        when RPG::Item
          BattleVoice.play(:use_item, @subject)
        when RPG::Skill
          BattleVoice.play(:use_skill, @subject)
        end
      end
    end
    use_item_voice_plus
  end
end