#==============================================================================
# ■ RGSS3 スキル整理 Ver1.03　by 星潟
#------------------------------------------------------------------------------
# 非戦闘中のスキル画面でスキルにカーソルを合わせた状態で特定のキーを押す事で
# 該当するスキルをスキルウィンドウから消去します。
# また、戦闘中にそのスキルを表示・使用することができなくなります。
#
# 消去中のスキルウィンドウは新たに追加されている
# 「整理済」のスキルタイプから確認する事が出来ます
# また、「整理済」のスキルウィンドウで、スキルにカーソルを合わせた状態で
# 特定のキーを押す事で、そのスキルを元のスキルタイプウィンドウに復帰させます。
#
# スキル整理の対象外にしたいスキルがある場合は
# そのスキルのメモ欄に「<整理禁止スキル>」（鍵括弧なし）と記入することで
# 整理用のキーを押してもブザーが鳴るだけで、整理されなくなります。
#
# 当方の「スキルタイプ選択コマンド消去スクリプト」導入時は
# 本スクリプトは正常に機能しません。
#==============================================================================
module AB_SSS2
  
  #スキル整理時のキー
  #デフォルトでは:Aとしてありますが
  #これはキーボード上のAではなく内部のコマンド処理上のA、です。
  #ゲームパッド設定時に出てくるものですね。
  #
  #キーボード上でのキーはSHIFTキーとなります。
  
  KEY   = :A
  
  #忘れたスキルが装備等でも追加されていない場合（完全に消滅している場合）
  #整理済み状態から自動的に除外するかを指定。
  
  FS    = true
  
  #整理中スキルの一覧を表示するスキルタイプの名前を決定します。
  
  NAME1   = "Skill Storage"
  
  #整理禁止スキルのメモ欄に記入するキーワードを指定します。
  
  NAME2   = "<整理禁止スキル>"
  
  #便宜上、整理済の項目の為のスキルタイプIDを指定します。
  
  STI = 10001
  
  #指定したスキルタイプを整理済み禁止にします。
  #例.SSTI = [2,10000]
  #この場合、スキルタイプIDが2か10000の場合は
  #整理機能が働かなくなります。
  
  SSTI = []
  
end
class Window_SkillCommand < Window_Command
  #--------------------------------------------------------------------------
  # コマンドリストの作成
  #--------------------------------------------------------------------------
  alias make_command_list_skill_seal2 make_command_list
  def make_command_list
    make_command_list_skill_seal2
    add_command(AB_SSS2::NAME1, :skill, true, AB_SSS2::STI)
  end
end
class Window_SkillList < Window_Selectable
  #--------------------------------------------------------------------------
  # 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader :actor                     # アクター
  #--------------------------------------------------------------------------
  # スキルをリストに含めるかどうか
  #--------------------------------------------------------------------------
  alias include_skill_seal2? include?
  def include?(item)
    if !@actor.skill_seal.include?(item.id)
      return include_skill_seal2?(item)
    elsif @actor.skill_seal.include?(item.id) && @stype_id == AB_SSS2::STI
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # 決定やキャンセルなどのハンドリング処理
  #--------------------------------------------------------------------------
  unless method_defined?(:process_handling_skill_seal2)
  alias process_handling_skill_seal2 process_handling
  def process_handling
    process_handling_skill_seal2
    return if AB_SSS2::SSTI.include?(@stype_id)
    return unless open? && active
    return call_handler(:sh_pss2) if ok_enabled? && Input.trigger?(AB_SSS2::KEY)
  end
  end
end
class Scene_Skill < Scene_ItemBase
  #--------------------------------------------------------------------------
  # アイテムウィンドウの作成
  #--------------------------------------------------------------------------
  alias create_item_window_skill_seal2 create_item_window
  def create_item_window
    create_item_window_skill_seal2
    @item_window.set_handler(:sh_pss2, method(:pss2))
  end
  #--------------------------------------------------------------------------
  # スキル整理
  #--------------------------------------------------------------------------
  def pss2
    return if item == nil
    return Sound.play_buzzer if item.seal_seal?
    Sound.play_ok
    s_id = item.id
    if @actor.skill_seal.include?(s_id)
      @actor.skill_seal.delete(s_id)
    else
      @actor.skill_seal.push(s_id)
    end
    @item_window.refresh
    @item_window.index -= 1 if item == nil
    @item_window.index = 0 if @item_window.index < 0
    @help_window.set_item(item)
    @help_window.refresh
  end
end
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :skill_seal
  #--------------------------------------------------------------------------
  # セットアップ
  #--------------------------------------------------------------------------
  alias setup_skill_seal2 setup
  def setup(actor_id)
    setup_skill_seal2(actor_id)
    @skill_seal = []
  end
  #--------------------------------------------------------------------------
  # スキル封印の配列を取得
  #--------------------------------------------------------------------------
  def skill_seal
    @skill_seal ||= []
  end
  #--------------------------------------------------------------------------
  # スキルを忘れる
  #--------------------------------------------------------------------------
  alias forget_skill_skill_seal forget_skill
  def forget_skill(skill_id)
    forget_skill_skill_seal(skill_id)
    skill_seal.delete(skill_id) if AB_SSS2::FS && !skills.include?($data_skills[skill_id])
  end
end
class Game_Action
  #--------------------------------------------------------------------------
  # 行動の価値評価（自動戦闘用）
  #--------------------------------------------------------------------------
  alias evaluate_skill_seal2 evaluate
  def evaluate
    if @subject.actor? && !@subject.skill_seal.empty? &&
      @subject.skill_seal.include?(item.id)
      @value = 0
      return self
    end
    evaluate_skill_seal2
  end
end
class RPG::Skill < RPG::UsableItem
  #--------------------------------------------------------------------------
  # スキル整理の禁止フラグ
  #--------------------------------------------------------------------------
  def seal_seal?
    (@seal_seal ||= @note.include?(AB_SSS2::NAME2) ? 1 : 0) == 1
  end
end