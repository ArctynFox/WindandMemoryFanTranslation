# coding: utf-8
#===============================================================================
# ■ [hzm]ターン消費無しスキルさん＋ for RGSS3
# ※ このスクリプトには「[hzm]メモ欄拡張共通部分さん＋ for RGSS3」が必要です
#    「[hzm]メモ欄拡張共通部分 for RGSS3」では動作しません
#-------------------------------------------------------------------------------
#　2014/06/22　Ru/むっくRu
#-------------------------------------------------------------------------------
# 【機能1：ターン消費無しスキル/アイテム】
#  ターンを消費せずに，選択した瞬間に発動するスキルを設定します．
#  「データベース」の「スキル」の「メモ」欄に以下のように記述してください．
#
#  [hzm]ターン消費無し:n
#  または
#  [hzm]即発動:n
#  
#  n の部分は1以上の数値に置き換えてください（例：[hzm]ターン消費無し:1）
#  この数字の部分の回数だけ，1ターン中にこのスキルを使用することができます．
#  （:nの部分を省略した場合、:1と記述した場合と同じになります）
#
#  同様にアイテムにも設定を行うことができます．
#  「データベース」の「アイテム」の「メモ」欄に同様に記述してください．
#-------------------------------------------------------------------------------
# 【機能2：行動順序をスキルごとに反映】
#  デフォルトのシステムだと，例えば2回行動のキャラクターが
#  「通常攻撃（速度補正：0）」，「防御（速度補正：2000）」の
#  2つを選択した場合に，速度補正が低い側（通常攻撃）のほうに統一されてしまい，
#  防御がターンの最初に発動しません．
#
#  このスクリプトでは，ターンの順番をキャラクターごとではなく，
#  そのキャラクターの行動ごとに順番を設定することによって，
#  各行動ごとの速度補正を適用できるようにします．
#
#  例）
#  エリック
#    素早さ： 30　行動：通常攻撃（速度補正：0），防御（速度補正：2000）
#  スライム
#    素早さ：100　行動：通常攻撃（速度補正：0）
#
#  ・デフォルトのシステムの場合
#  スライム通常攻撃→エリック通常攻撃→エリック防御
#
#  ・このスクリプト導入後
#  エリック防御→スライム通常攻撃→エリック通常攻撃
#-------------------------------------------------------------------------------
# 【更新履歴】
# 2014/06/22 通常攻撃にも適用できるように
# 2014/06/07 次回行動アクター取得処理が正常に動いていないのを修正v2
# 2013/07/18 行動終了時に解除される行動制約ステートが解除されないのを修正
# 2013/03/17 エネミーの行動ターン数指定がおかしくなるのを修正。おまけ機能追加。
# 2013/02/16 ターン開始時に行動不能が解除された際にエラー落ちするのを修正
# 2013/01/11 コモンイベント呼び出しでアクターを離脱させるとエラー落ちしていたのを修正
# 2012/10/14 行動回数再計算ON時，エネミーが「逃げる」とエラー落ちしていたのを修正
# 2012/10/09 マップ上でアイテムを使用した際にエラー落ちしていたのを修正
# 2012/10/06 戦闘中にパーティ入れ替えを行った場合にエラー落ちしていたのを修正
#            ステータスウィンドウの更新が正常に行われていなかったのを修正
# 2012/10/05 大幅修正を行いました．
#            新メモスクリプト（[hzm]メモ欄拡張共通部分さん＋ for RGSS3）用に変更
#            行動回数の再計算機能（アクター/エネミー）を追加
#            1ターン内で使用できる回数の設定を追加
#            「各行動ごとに行動順を設定さん for RGSS3」の機能を内包
# 2012/10/03 行動回数の再計算（暫定）を追加
# 2012/06/01 エネミー用設定を追加
# 2012/04/21 複数回行動するアクターが正常に動作しない不具合を修正
# 2012/04/01 味方の行動不能状態を回復した際に強制終了する不具合を修正
# 2012/03/28 アイテムにも対応
# 2012/01/28 コモンイベント内で「戦闘行動の強制」を使用した際に強制終了するのを修正
# 2012/01/28 コモンイベントの呼び出しが正常に動作しないのを少し修正
# 2012/01/03 ぶっぱ
#-------------------------------------------------------------------------------

#===============================================================================
# ● 設定項目
#===============================================================================
module HZM_VXA
  module QuickSkill
    # ● ターン消費無し行動後に行動回数を再計算する（上級設定）
    #   [効果]
    #   ・エネミーも（疑似的に）ターン消費無しスキルを使用可能に
    #   ・行動回数を変化させるステートを即時反映
    #   [副作用]
    #   ・50%の確率で行動回数増加などの設定が使用不可に
    #     true  : する
    #     false : しない
    CHECK_ACTION_TIMES = false

    # ● オマケ機能：敵の行動パターンのターン数の仕様をVX化
    #    1ターン目（最初のターン）に指定の行動をさせたい場合、
    #    VX Aceでは行動パターンを0ターン目に設定する必要があります。
    #    この設定方法をVX同様の仕様に変更し、
    #    1ターン目の場合は1ターン目に設定できるようにします。
    #    （上級設定に関係なく使用できます）
    #    true  : VX仕様にする
    #    false : 変更しない
    ENEMY_TURN_NORMALIZE = false
  end
end

#===============================================================================
# ↑ 　 ここまで設定 　 ↑
# ↓ 以下、スクリプト部 ↓
#===============================================================================

raise "「[hzm]メモ欄拡張共通部分さん＋ for RGSS3」を導入してください" unless defined?(HZM_VXA::Note2)
raise "「[hzm]メモ欄拡張共通部分さん＋ for RGSS3」のバージョンが一致しません" unless HZM_VXA::Note2.check_version?('3.0.0')

module HZM_VXA
  module QuickSkill
    # メモ欄から読み込む要素名の候補を設定
    QUICK_KEYS = ['ターン消費無し', '即発動',  'QuickSkill']
    #---------------------------------------------------------------------------
    # ● QuickSkill中か？
    #---------------------------------------------------------------------------
    def self.quickSkill?
      @quickSkill
    end
    #---------------------------------------------------------------------------
    # ● 即時行動開始
    #---------------------------------------------------------------------------
    def self.start
      @quickSkill = true
    end
    #---------------------------------------------------------------------------
    # ● 即時行動終了
    #---------------------------------------------------------------------------
    def self.finish
      @quickSkill = false
      # 全てのbattlerのアクションを戻す
      $game_party.hzm_vxa_quickSkill_force_action_reverse
      $game_troop.hzm_vxa_quickSkill_force_action_reverse
    end
    #---------------------------------------------------------------------------
    # ● スキル使用回数のリセット
    #---------------------------------------------------------------------------
    def self.reset_use_count
      $game_party.hzm_vxa_quickSkill_reset_use_count
      $game_troop.hzm_vxa_quickSkill_reset_use_count
    end
    # ターン消費無しアイテム管理対象
    ITEM_COUNT_PARTY = true
  end
end

module BattleManager
  #-----------------------------------------------------------------------------
  # ● 行動順序の作成（再定義）
  #-----------------------------------------------------------------------------
  def self.make_action_orders
    @action_battlers = []
    all_actions = []
    all_members = []
    all_members += $game_party.members unless @surprise
    all_members += $game_troop.members unless @preemptive
    all_members.each do |member|
      next unless member.movable?
      member.make_speed
      member.actions.each {|action| all_actions.push action }
    end
    all_actions.sort!{|a,b| b.speed - a.speed }
    all_actions.each {|action| @action_battlers.push action.subject}
  end
  #-----------------------------------------------------------------------------
  # ● 行動が未選択のアクターを先頭から探す（独自）
  #-----------------------------------------------------------------------------
  def self.hzm_vxa_quickSkill_can_action_actor_before(daemon)
    return false unless $game_party.members.index(daemon)
    for @actor_index in 0..$game_party.members.index(daemon)
      actor = $game_party.members[@actor_index]
      return true if actor.next_command
    end
    false
  end
end

class Game_Unit
  attr_accessor :hzm_vxa_quickSkill_can_use_item
  #-----------------------------------------------------------------------------
  # ● 戦闘開始処理（エイリアス）
  #-----------------------------------------------------------------------------
  alias hzm_vxa_quickSkill_on_battle_start on_battle_start
  def on_battle_start
    hzm_vxa_quickSkill_on_battle_start
    hzm_vxa_quickSkill_reset_use_count
  end
  #-----------------------------------------------------------------------------
  # ● 戦闘行動の復元（独自）
  #-----------------------------------------------------------------------------
  def hzm_vxa_quickSkill_force_action_reverse
    members.each {|member| member.hzm_vxa_quickSkill_force_action_reverse }
  end
  #-----------------------------------------------------------------------------
  # ● スキル使用回数のリセット（独自）
  #-----------------------------------------------------------------------------
  def hzm_vxa_quickSkill_reset_use_count
    members.each {|member| member.hzm_vxa_quickSkill_reset_use_count }
    if HZM_VXA::QuickSkill::ITEM_COUNT_PARTY
      @hzm_vxa_quickSkill_can_use_item ||= []
      @hzm_vxa_quickSkill_can_use_item.clear
    end
  end
end

class Game_Battler < Game_BattlerBase
  #-----------------------------------------------------------------------------
  # ● 行動速度の決定（エイリアス）
  #-----------------------------------------------------------------------------
  alias hzm_vxa_quickSkill_make_speed make_speed
  def make_speed
    # 空行動は削除する
    @actions.reject! {|a| a == nil}
    # 元の処理
    hzm_vxa_quickSkill_make_speed
    # アクションを速度順にソート
    @actions.sort! {|a,b| b.speed - a.speed }
  end
  #-----------------------------------------------------------------------------
  # ● スキルの使用可能条件チェック（エイリアス）
  #-----------------------------------------------------------------------------
  alias hzm_vxa_quickSkill_skill_conditions_met? skill_conditions_met?
  def skill_conditions_met?(skill)
    # 元の処理
    return false unless hzm_vxa_quickSkill_skill_conditions_met?(skill)
    # 戦闘中でなければOK
    return true unless $game_party.in_battle
    # 指定回数チェック
    if data = skill.hzm_vxa_note_match(HZM_VXA::QuickSkill::QUICK_KEYS)
      cnt = data.first.to_i
      cnt = 1  unless cnt > 0
      hzm_vxa_quickSkill_reset_use_count unless @hzm_vxa_quickSkill_can_use_skill
      return false if cnt > 0 and @hzm_vxa_quickSkill_can_use_skill.count(skill.id) >= cnt
    end
    true
  end
  #-----------------------------------------------------------------------------
  # ● アイテムの使用可能条件チェック（エイリアス）
  #-----------------------------------------------------------------------------
  alias hzm_vxa_quickSkill_item_conditions_met? item_conditions_met?
  def item_conditions_met?(item)
    # 元の処理
    return false unless hzm_vxa_quickSkill_item_conditions_met?(item)
    # 戦闘中でなければOK
    return true unless $game_party.in_battle
    # 指定回数チェック
    if data = item.hzm_vxa_note_match(HZM_VXA::QuickSkill::QUICK_KEYS)
      cnt = data.first.to_i
      cnt = 1  unless cnt > 0
      if HZM_VXA::QuickSkill::ITEM_COUNT_PARTY
        return false if cnt > 0 and $game_party.hzm_vxa_quickSkill_can_use_item.count(item.id) >= cnt
      else
        return false if cnt > 0 and @hzm_vxa_quickSkill_can_use_item.count(item.id) >= cnt
      end
    end
    true
  end
  #-----------------------------------------------------------------------------
  # ● スキル使用回数リセット（独自）
  #-----------------------------------------------------------------------------
  def hzm_vxa_quickSkill_reset_use_count
      @hzm_vxa_quickSkill_can_use_skill ||= []
      @hzm_vxa_quickSkill_can_use_skill.clear
      unless HZM_VXA::QuickSkill::ITEM_COUNT_PARTY
        @hzm_vxa_quickSkill_can_use_item ||= []
        @hzm_vxa_quickSkill_can_use_item.clear
      end
  end
  #-----------------------------------------------------------------------------
  # ● 戦闘行動の強制（エイリアス）
  #-----------------------------------------------------------------------------
  alias hzm_vxa_quickSkill_force_action force_action
  def force_action(skill_id, target_index)
    @hzm_vxa_quickSkill_actions = HZM_VXA::QuickSkill.quickSkill? ? @actions.clone : nil
    hzm_vxa_quickSkill_force_action(skill_id, target_index)
  end
  #-----------------------------------------------------------------------------
  # ● 戦闘行動の復元（独自）
  #-----------------------------------------------------------------------------
  def hzm_vxa_quickSkill_force_action_reverse
    return unless @hzm_vxa_quickSkill_actions
    @actions = @hzm_vxa_quickSkill_actions
    @hzm_vxa_quickSkill_actions = nil
  end
  #-----------------------------------------------------------------------------
  # ● スキル／アイテムの使用（エイリアス）
  #-----------------------------------------------------------------------------
  alias hzm_vxa_quickSkill_use_item use_item
  def use_item(item)
    # 戦闘中かどうか？
    if $game_party.in_battle
      # カウント可能か確認
      hzm_vxa_quickSkill_reset_use_count unless @hzm_vxa_quickSkill_can_use_skill
      # スキル/アイテム使用回数カウント
      @hzm_vxa_quickSkill_can_use_skill.push(item.id) if item.is_a?(RPG::Skill)
      if HZM_VXA::QuickSkill::ITEM_COUNT_PARTY
        $game_party.hzm_vxa_quickSkill_can_use_item.push(item.id)  if item.is_a?(RPG::Item)
      else
        @hzm_vxa_quickSkill_can_use_item.push(item.id)  if item.is_a?(RPG::Item)
      end
    end
    # 元の処理
    hzm_vxa_quickSkill_use_item(item)
  end
end

class Game_Actor < Game_Battler
  #-----------------------------------------------------------------------------
  # ● アクションを先頭に入れ替え（独自）
  #-----------------------------------------------------------------------------
  def hzm_vxa_quickSkill_swapAction
    tmp = @actions[0]
    @actions[0] = @actions[@action_input_index]
    @actions[@action_input_index] = tmp
  end
end

class Game_Action
  #-----------------------------------------------------------------------------
  # ● 行動速度の計算（エイリアス）
  #-----------------------------------------------------------------------------
  alias hzm_vxa_quickSkillEnemy_speed speed
  def speed
    # ターン消費無し行動の行動速度を最速化
    item.speed = 999999 if item and item.hzm_vxa_note_match(HZM_VXA::QuickSkill::QUICK_KEYS)
    # 元の処理
    hzm_vxa_quickSkillEnemy_speed
  end
end

class Scene_Battle < Scene_Base
  #-----------------------------------------------------------------------------
  # ● 情報表示ビューポートの更新（エイリアス）
  #-----------------------------------------------------------------------------
  alias hzm_vxa_quickSkill_update_info_viewport update_info_viewport
  def update_info_viewport
    # 元の処理
    hzm_vxa_quickSkill_update_info_viewport
    # ターン消費無し行動中は非表示に
    move_info_viewport(64)   if @hzm_vxa_quickSkill_active
  end
  #-----------------------------------------------------------------------------
  # ● 次のコマンド入力へ（エイリアス）
  #-----------------------------------------------------------------------------
  alias hzm_vxa_quickSkill_next_command next_command
  def next_command
    # ターン消費無し行動が選択されているか確認・実行
    if @hzm_vxa_quickSkill_skill and 
       @hzm_vxa_quickSkill_skill.hzm_vxa_note_match(HZM_VXA::QuickSkill::QUICK_KEYS)
      # ターン消費無し行動の実行
      hzm_vxa_quickSkill_run
      # 行動を再選択
      if BattleManager.hzm_vxa_quickSkill_can_action_actor_before(@subject) or
          @subject.inputable?
        @subject.prior_command
        return start_actor_command_selection
      end
    end
    # 元の処理
    hzm_vxa_quickSkill_next_command
  end
  #-----------------------------------------------------------------------------
  # ● コマンド［攻撃］（エイリアス）
  #-----------------------------------------------------------------------------
  alias hzm_vxa_quickSkill_command_attack command_attack
  def command_attack
    @hzm_vxa_quickSkill_skill = $data_skills[BattleManager.actor.attack_skill_id]
    hzm_vxa_quickSkill_command_attack
  end
  #-----------------------------------------------------------------------------
  # ● スキル［決定］（エイリアス）
  #-----------------------------------------------------------------------------
  alias hzm_vxa_quickSkill_on_skill_ok on_skill_ok
  def on_skill_ok
    @hzm_vxa_quickSkill_skill = @skill_window.item
    hzm_vxa_quickSkill_on_skill_ok
  end
  #-----------------------------------------------------------------------------
  # ● スキル［キャンセル］（エイリアス）
  #-----------------------------------------------------------------------------
  alias hzm_vxa_quickSkill_on_skill_cancel on_skill_cancel
  def on_skill_cancel
    @hzm_vxa_quickSkill_skill = nil
    hzm_vxa_quickSkill_on_skill_cancel
  end
  #-----------------------------------------------------------------------------
  # ● アイテム［決定］（エイリアス）
  #-----------------------------------------------------------------------------
  alias hzm_vxa_quickSkill_on_item_ok on_item_ok
  def on_item_ok
    @hzm_vxa_quickSkill_skill = @item_window.item
    hzm_vxa_quickSkill_on_item_ok
  end
  #-----------------------------------------------------------------------------
  # ● アイテム［キャンセル］（エイリアス）
  #-----------------------------------------------------------------------------
  alias hzm_vxa_quickSkill_on_item_cancel on_item_cancel
  def on_item_cancel
    @hzm_vxa_quickSkill_skill = nil
    hzm_vxa_quickSkill_on_item_cancel
  end
  #-----------------------------------------------------------------------------
  # ● アクターコマンド選択の開始（エイリアス）
  #-----------------------------------------------------------------------------
  alias hzm_vxa_quickSkill_start_actor_command_selection start_actor_command_selection
  def start_actor_command_selection
    hzm_vxa_quickSkill_start_actor_command_selection
    BattleManager.actor.make_actions unless BattleManager.actor.input
  end
  #--------------------------------------------------------------------------
  # ● 強制された戦闘行動の処理（エイリアス）
  #--------------------------------------------------------------------------
  alias hzm_vxa_quickSkill_process_forced_action process_forced_action
  def process_forced_action
    @hzm_vxa_quickSkill_force_action = BattleManager.action_forced?

    # 元の処理
    hzm_vxa_quickSkill_process_forced_action

    @hzm_vxa_quickSkill_force_action = nil
  end
  #-----------------------------------------------------------------------------
  # ● 戦闘行動の処理（再定義）
  #-----------------------------------------------------------------------------
  def process_action
    return if scene_changing?

    # 強制行動の場合は次回アクターを計算しない
    unless @hzm_vxa_quickSkill_force_action
      if HZM_VXA::QuickSkill::CHECK_ACTION_TIMES
        HZM_VXA::QuickSkill.re_action_times if @hzm_vxa_quickSkill_re_action_times_flag
        @hzm_vxa_quickSkill_re_action_times_flag = false
      end

      BattleManager.make_action_orders
      @subject = BattleManager.next_subject
    end

    return turn_end unless @subject
    if @subject.current_action
      @subject.current_action.prepare
      if @subject.current_action.valid?
        @status_window.open
        execute_action
      end
      @subject.remove_current_action
    end
    process_action_end unless @subject.current_action
  end

  #-----------------------------------------------------------------------------
  # ● ターン消費無し行動の実行（独自）
  #-----------------------------------------------------------------------------
  def hzm_vxa_quickSkill_run
    return unless @hzm_vxa_quickSkill_skill
    @hzm_vxa_quickSkill_skill = nil
    # 行動の開始
    HZM_VXA::QuickSkill::start
    @actor_command_window.close if @actor_command_window
    @hzm_vxa_quickSkill_active = true
    # 行動アクター，行動内容の設定
    @subject = BattleManager.actor
    @subject.hzm_vxa_quickSkill_swapAction # 選んだ行動を先頭に引きずり出す
    # 行動
    execute_action
    # イベント処理
    process_event
    # おわり
    @subject.hzm_vxa_quickSkill_swapAction # 元の位置に戻す
    HZM_VXA::QuickSkill::finish
    # ウィンドウを戻す
    refresh_status
    @hzm_vxa_quickSkill_active = false
    @actor_command_window.open if @actor_command_window
    @status_window.open if @status_window
    # 行動回数の再計算
    HZM_VXA::QuickSkill.re_action_times if HZM_VXA::QuickSkill::CHECK_ACTION_TIMES
  end
end

# 行動回数の再計算用 & エネミー行動ターン数正常化 共通処理
if HZM_VXA::QuickSkill::CHECK_ACTION_TIMES or HZM_VXA::QuickSkill::ENEMY_TURN_NORMALIZE
  class << BattleManager
    #---------------------------------------------------------------------------
    # ● ターン終了（エイリアス）
    #---------------------------------------------------------------------------
    alias hzm_vxa_quickSkill_turn_end turn_end
    def turn_end
      hzm_vxa_quickSkill_turn_end
      $game_troop.hzm_vxa_quickSkill_increase_turn2
    end
  end

  class Game_Troop < Game_Unit
    attr_reader :hzm_vxa_quickSkill_turn_count
    #---------------------------------------------------------------------------
    # ● クリア（エイリアス）
    #---------------------------------------------------------------------------
    alias hzm_vxa_quickSkill_clear clear
    def clear
      hzm_vxa_quickSkill_clear
      @hzm_vxa_quickSkill_turn_count = HZM_VXA::QuickSkill::ENEMY_TURN_NORMALIZE ? 1 : 0
    end
    #---------------------------------------------------------------------------
    # ● クリア（独自）
    #---------------------------------------------------------------------------
    def hzm_vxa_quickSkill_increase_turn2
      @hzm_vxa_quickSkill_turn_count += 1
    end
  end

  class Game_Enemy < Game_Battler
    #--------------------------------------------------------------------------
    # ● 行動条件合致判定［ターン数］（再定義）
    #--------------------------------------------------------------------------
    def conditions_met_turns?(param1, param2)
      n = $game_troop.hzm_vxa_quickSkill_turn_count
      if param2 == 0
        n == param1
      else
        n > 0 && n >= param1 && n % param2 == param1 % param2
      end
    end
  end
end

# 行動回数の再計算用
if HZM_VXA::QuickSkill::CHECK_ACTION_TIMES
  module HZM_VXA
    module QuickSkill
      #-------------------------------------------------------------------------
      # ● 行動回数の再計算
      #-------------------------------------------------------------------------
      if CHECK_ACTION_TIMES
        def self.re_action_times
          $game_party.hzm_vxa_quickSkill_re_action_times
          $game_troop.hzm_vxa_quickSkill_re_action_times
        end
      end
    end
  end

  class Game_Unit
    #---------------------------------------------------------------------------
    # ● 行動回数の再計算（独自）
    #---------------------------------------------------------------------------
    def hzm_vxa_quickSkill_re_action_times
      members.each {|member| member.hzm_vxa_quickSkill_re_action_times }
    end
  end
 
  class Game_Actor < Game_Battler
    #---------------------------------------------------------------------------
    # ● 行動回数の再計算
    #---------------------------------------------------------------------------
    if HZM_VXA::QuickSkill::CHECK_ACTION_TIMES
      def hzm_vxa_quickSkill_re_action_times
        action_cnt = make_action_times
        @actions.push Game_Action.new(self) while @actions.size < action_cnt
        @actions.pop while @actions.size > action_cnt
      end
    end
  end
  
  class Game_Enemy < Game_Battler
    #---------------------------------------------------------------------------
    # ● 行動回数の再計算（独自）
    #---------------------------------------------------------------------------
    def hzm_vxa_quickSkill_re_action_times
      action_cnt = make_action_times
      make_actions if @actions.size < action_cnt
      @actions.pop while @actions.size > action_cnt
    end
  end
  
  class Scene_Battle < Scene_Base
    #---------------------------------------------------------------------------
    # ● スキル／アイテムの使用（エイリアス）
    #---------------------------------------------------------------------------
    alias hzm_vxa_quickSkill_use_item use_item
    def use_item
      # 元の処理
      hzm_vxa_quickSkill_use_item
      # 行動回数の再計算フラグ（エネミーの場合）
      item = (@subject.enemy? and @subject.current_action) ?
        @subject.current_action.item : nil
      @hzm_vxa_quickSkill_re_action_times_flag = 
        (item and item.hzm_vxa_note_match(HZM_VXA::QuickSkill::QUICK_KEYS))
    end
  end
end