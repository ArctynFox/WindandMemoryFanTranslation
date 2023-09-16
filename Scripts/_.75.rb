#==============================================================================
# ■ VXAce-RGSS3-38 精霊システム <database>             by Claimh
#==============================================================================

#==============================================================================
# ■ Spirits
#==============================================================================
module Spirits
  #--------------------------------------------------------------------------
  # ● 精霊パートナー化
  #--------------------------------------------------------------------------
  def self.add_partner(actor_id, spirit_id)
    return unless $game_party.include_spirit?(spirit_id)
    return unless $game_actors[actor_id].can_join_partner(spirit_id)
    s_act_id = self.actor_id(spirit_id)
    return unless $game_actors[s_act_id].can_join_partner(actor_id)
    $game_actors[actor_id].add_partner(spirit_id)
    $game_actors[s_act_id].add_partner(actor_id)
  end
  #--------------------------------------------------------------------------
  # ● 精霊パートナー解消
  #--------------------------------------------------------------------------
  def self.remove_partner(actor_id, spirit_id)
    $game_actors[actor_id].remove_partner(spirit_id)
    $game_actors[self.actor_id(spirit_id)].remove_partner(actor_id)
  end
  #--------------------------------------------------------------------------
  # ● 精霊パートナー固定化
  #--------------------------------------------------------------------------
  def self.lock_partner(spirit_id)
    spirit = $game_actors[self.actor_id(spirit_id)]
    return unless spirit.has_partner?
    spirit.lock_partner
  end
  #--------------------------------------------------------------------------
  # ● 精霊パートナー固有化解除
  #--------------------------------------------------------------------------
  def self.unlock_partner(spirit_id)
    spirit = $game_actors[self.actor_id(spirit_id)]
    return unless spirit.has_partner?
    spirit.unlock_partner
  end
  #--------------------------------------------------------------------------
  # ● 精霊？
  #--------------------------------------------------------------------------
  def self.spirit?(actor_id)
    SPIRIT_ACTOR.has_value?(actor_id)
  end
  #--------------------------------------------------------------------------
  # ● 精霊ID => アクターID
  #--------------------------------------------------------------------------
  def self.actor_id(spirit_id)
    SPIRIT_ACTOR[spirit_id].nil? ? 0 : SPIRIT_ACTOR[spirit_id]
  end
  #--------------------------------------------------------------------------
  # ● アクターID => 精霊ID
  #--------------------------------------------------------------------------
  def self.spirit_id(actor_id)
    id = SPIRIT_ACTOR.index(actor_id)
    id.nil? ? 0 : id
  end
  #--------------------------------------------------------------------------
  # ● パートナー最大数
  #--------------------------------------------------------------------------
  def self.max(actor_id)
    MAX[actor_id].nil? ? MAX[0] : MAX[actor_id]
  end
  #--------------------------------------------------------------------------
  # ● 相性
  #--------------------------------------------------------------------------
  def self.affinity(actor_id, spirit_id)
    if AFNTY[actor_id].nil?
      return AFNTY[0][0]
    elsif AFNTY[actor_id][spirit_id].nil?
      return AFNTY[actor_id][0].nil? ? AFNTY[0][0] : AFNTY[actor_id][0]
    else
      return AFNTY[actor_id][spirit_id]
    end
  end
  #--------------------------------------------------------------------------
  # ● 相性計算
  #--------------------------------------------------------------------------
  def self.affinity_param(param, actor_id, spirit_id)
    prm = [0, 0.5, 0.8, 1.0, 1.2, 1.5]  # 相性補正
    n = affinity(actor_id, spirit_id)
    p "[#{actor_id}, #{spirit_id}] => #{n}" if n.nil?
    (param * prm[affinity(actor_id, spirit_id)]).truncate
  end
  #--------------------------------------------------------------------------
  # ● 有効ステータス表示
  #--------------------------------------------------------------------------
  def self.sts
    STS.select {|key, v| v}.keys
  end
  #--------------------------------------------------------------------------
  # ● 有効ステータス表示
  #--------------------------------------------------------------------------
  def self.status
    SHOW_ST.select {|key, v| v}.keys
  end
end

#==============================================================================
# ■ Spirits::Features      : 特徴情報抽出
#==============================================================================
class Spirits::Features
  #--------------------------------------------------------------------------
  # ● 定数（特徴）
  #--------------------------------------------------------------------------
  FEATURE_ELEMENT_RATE  = 11              # 属性有効度
  FEATURE_DEBUFF_RATE   = 12              # 弱体有効度
  FEATURE_STATE_RATE    = 13              # ステート有効度
  FEATURE_STATE_RESIST  = 14              # ステート無効化
  FEATURE_PARAM         = 21              # 通常能力値
  FEATURE_XPARAM        = 22              # 追加能力値
  FEATURE_SPARAM        = 23              # 特殊能力値
  FEATURE_ATK_ELEMENT   = 31              # 攻撃時属性
  FEATURE_ATK_STATE     = 32              # 攻撃時ステート
  FEATURE_ATK_SPEED     = 33              # 攻撃速度補正
  FEATURE_ATK_TIMES     = 34              # 攻撃追加回数
  FEATURE_STYPE_ADD     = 41              # スキルタイプ追加
  FEATURE_STYPE_SEAL    = 42              # スキルタイプ封印
  FEATURE_SKILL_ADD     = 43              # スキル追加
  FEATURE_SKILL_SEAL    = 44              # スキル封印
  FEATURE_EQUIP_WTYPE   = 51              # 武器タイプ装備
  FEATURE_EQUIP_ATYPE   = 52              # 防具タイプ装備
  FEATURE_EQUIP_FIX     = 53              # 装備固定
  FEATURE_EQUIP_SEAL    = 54              # 装備封印
  FEATURE_SLOT_TYPE     = 55              # スロットタイプ
  FEATURE_ACTION_PLUS   = 61              # 行動回数追加
  FEATURE_SPECIAL_FLAG  = 62              # 特殊フラグ
  FEATURE_COLLAPSE_TYPE = 63              # 消滅エフェクト
  FEATURE_PARTY_ABILITY = 64              # パーティ能力
  #--------------------------------------------------------------------------
  # ● パーティ能力定数
  #--------------------------------------------------------------------------
  ABILITY_ENCOUNTER_HALF    = 0           # エンカウント半減
  ABILITY_ENCOUNTER_NONE    = 1           # エンカウント無効
  ABILITY_CANCEL_SURPRISE   = 2           # 不意打ち無効
  ABILITY_RAISE_PREEMPTIVE  = 3           # 先制攻撃率アップ
  ABILITY_GOLD_DOUBLE       = 4           # 獲得金額二倍
  ABILITY_DROP_ITEM_DOUBLE  = 5           # アイテム入手率二倍
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(spirit)
    @obj = spirit
  end
  #--------------------------------------------------------------------------
  # ● 属性耐性
  #--------------------------------------------------------------------------
  def element_rate
    fts = @obj.features(FEATURE_ELEMENT_RATE)
    fts.collect {|ft| ["#{$data_system.elements[ft.data_id]}属性耐性", sprintf("%d ％", ft.value)] }
  end
  #--------------------------------------------------------------------------
  # ● 弱体耐性
  #--------------------------------------------------------------------------
  def debuff_rate
    fts = @obj.features(FEATURE_DEBUFF_RATE)
    fts.collect {|ft| ["#{$data_system.terms.params[ft.data_id]}弱体耐性", sprintf("%d ％", ft.value)] }
  end
  #--------------------------------------------------------------------------
  # ● ステート耐性
  #--------------------------------------------------------------------------
  def state_rate
    fts = @obj.features(FEATURE_STATE_RATE)
    fts.collect {|ft| ["#{$data_states[ft.data_id].name}耐性", sprintf("%d ％", ft.value)] }
  end
  #--------------------------------------------------------------------------
  # ● ステート無効化
  #--------------------------------------------------------------------------
  def state_regist
    fts = @obj.features(FEATURE_STATE_RESIST)
    fts.collect {|ft| ["#{$data_states[ft.data_id].name}無効化", nil] }
  end
  #--------------------------------------------------------------------------
  # ● 耐性情報取得
  #--------------------------------------------------------------------------
  def rate
    element_rate + debuff_rate + state_rate + state_regist
  end
  #--------------------------------------------------------------------------
  # ● 通常能力情報取得
  #--------------------------------------------------------------------------
  def nparam
    fts = @obj.features(FEATURE_PARAM)
    fts.collect {|ft| ["#{$data_system.terms.params[ft.data_id]}", sprintf("%+d ％", ft.value)] }
  end
  #--------------------------------------------------------------------------
  # ● 追加能力情報取得
  #--------------------------------------------------------------------------
  def xparam
    txt = ["命中率", "回避率", "会心率", "会心回避率",
           "魔法回避率", "魔法反射率", "反撃率",
           "#{$data_system.terms.basic[2]}再生率",
           "#{$data_system.terms.basic[4]}再生率",
           "#{$data_system.terms.basic[6]}再生率"]
    fts = @obj.features(FEATURE_XPARAM)
    fts.collect {|ft| ["#{txt[ft.data_id]}", sprintf("%+d ％", ft.value)] }
  end
  #--------------------------------------------------------------------------
  # ● 特殊能力情報取得
  #--------------------------------------------------------------------------
  def sparam
    txt = ["狙われ率", "防御効果率", "回復効果率", "薬の知識",
            "#{$data_system.terms.basic[4]}消費率", 
            "#{$data_system.terms.basic[6]}チャージ率",
           "物理ダメージ率", "魔法ダメージ率", "床ダメージ率", "経験値獲得率"]
    fts = @obj.features(FEATURE_SPARAM)
    fts.collect {|ft| ["#{$data_system.terms.params[ft.data_id]}", sprintf("%+d ％", ft.value)] }
  end
  #--------------------------------------------------------------------------
  # ● 能力情報取得
  #--------------------------------------------------------------------------
  def param
    nparam + xparam + sparam
  end
  #--------------------------------------------------------------------------
  # ● 攻撃属性情報取得
  #--------------------------------------------------------------------------
  def atk_element
    fts = @obj.features(FEATURE_ATK_ELEMENT)
    fts.collect {|ft| ["攻撃時 属性", $data_system.elements[ft.data_id]] }
  end
  #--------------------------------------------------------------------------
  # ● 攻撃ステート情報取得
  #--------------------------------------------------------------------------
  def atk_state
    fts = @obj.features(FEATURE_ATK_STATE)
    fts.collect {|ft| ["攻撃時 ステート付与", $data_states[ft.data_id].name] }
  end
  #--------------------------------------------------------------------------
  # ● 攻撃速度補正情報取得
  #--------------------------------------------------------------------------
  def atk_speed
    fts = @obj.features(FEATURE_ATK_SPEED)
    fts.collect {|ft| ["攻撃速度補正", ft.value.to_s] }
  end
  #--------------------------------------------------------------------------
  # ● 攻撃回数情報取得
  #--------------------------------------------------------------------------
  def atk_times
    fts = @obj.features(FEATURE_ATK_TIMES)
    fts.collect {|ft| ["#{ft.value}回攻撃", nil] }
  end
  #--------------------------------------------------------------------------
  # ● 攻撃情報取得
  #--------------------------------------------------------------------------
  def attack
    atk_element + atk_state + atk_speed + atk_times
  end
  #--------------------------------------------------------------------------
  # ● スキルタイプ追加情報取得
  #--------------------------------------------------------------------------
  def skill_add_type
    fts = @obj.features(FEATURE_STYPE_ADD)
    fts.collect {|ft| ["タイプ「#{$data_system.skill_types[ft.data_id]}」追加", nil] }
  end
  #--------------------------------------------------------------------------
  # ● スキルタイプ封印情報取得
  #--------------------------------------------------------------------------
  def skill_seal_type
    fts = @obj.features(FEATURE_STYPE_SEAL)
    fts.collect {|ft| ["タイプ「#{$data_system.skill_types[ft.data_id]}」封印", nil] }
  end
  #--------------------------------------------------------------------------
  # ● スキル追加情報取得
  #--------------------------------------------------------------------------
  def skill_add
    fts = @obj.features(FEATURE_SKILL_ADD)
    fts.collect {|ft| ["「#{$data_skills[ft.data_id].name}」追加", nil] }
  end
  #--------------------------------------------------------------------------
  # ● スキル封印情報取得
  #--------------------------------------------------------------------------
  def skill_seal
    fts = @obj.features(FEATURE_SKILL_SEAL)
    fts.collect {|ft| ["「#{$data_skills[ft.data_id].name}」封印", nil] }
  end
  #--------------------------------------------------------------------------
  # ● スキル情報取得
  #--------------------------------------------------------------------------
  def skill
    skill_add_type + skill_seal_type # + skill_add + skill_seal
  end
  #--------------------------------------------------------------------------
  # ● 武器タイプ装備情報取得
  #--------------------------------------------------------------------------
  def equip_wtype
    fts = @obj.features(FEATURE_EQUIP_WTYPE)
    fts.collect {|ft| ["「#{$data_sytem.weapon_types[ft.data_id]}」装備", nil] }
  end
  #--------------------------------------------------------------------------
  # ● 防具タイプ装備情報取得
  #--------------------------------------------------------------------------
  def equip_atype
    fts = @obj.features(FEATURE_EQUIP_ATYPE)
    fts.collect {|ft| ["「#{$data_sytem.armor_types[ft.data_id]}」装備", nil] }
  end
  #--------------------------------------------------------------------------
  # ● 装備固定情報取得
  #--------------------------------------------------------------------------
  def equip_fix
    fts = @obj.features(FEATURE_EQUIP_FIX)
    fts.collect {|ft| ["「#{$data_sytem.terms.etypes[ft.data_id]}」装備固定化", nil] }
  end
  #--------------------------------------------------------------------------
  # ● 装備封印情報取得
  #--------------------------------------------------------------------------
  def equip_seal
    fts = @obj.features(FEATURE_EQUIP_SEAL)
    fts.collect {|ft| ["「#{$data_sytem.terms.etypes[ft.data_id]}」装備封印", nil] }
  end
  #--------------------------------------------------------------------------
  # ● 装備情報取得
  #--------------------------------------------------------------------------
  def equip
    equip_wtype + equip_atype + equip_fix + equip_seal
  end
  #--------------------------------------------------------------------------
  # ● 行動回数追加情報取得
  #--------------------------------------------------------------------------
  def action_plus
    fts = @obj.features(FEATURE_ACTION_PLUS)
    fts.collect {|ft| ["「#{[ft.value]}」回行動", nil] }
  end
  #--------------------------------------------------------------------------
  # ● 特殊フラグ情報取得
  #--------------------------------------------------------------------------
  def special_flag
    str = []
    str.push(["自動戦闘", nil]) if @obj.auto_battle?
    str.push(["自動防御", nil]) if @obj.guard?
    str.push(["身代わり", nil]) if @obj.substitute?
    str.push(["#{$data_system.terms.basic[6]}持ち越し", nil]) if @obj.substitute?
    str
  end
  #--------------------------------------------------------------------------
  # ● パーティー能力情報取得
  #--------------------------------------------------------------------------
  def party_ability
    fts = @obj.features(FEATURE_PARTY_ABILITY)
    str = []
    str.push(["エンカウント半減", nil])   if fts.any? {|ft| ft.code_id == ABILITY_ENCOUNTER_HALF }
    str.push(["エンカウント無効", nil])   if fts.any? {|ft| ft.code_id == ABILITY_ENCOUNTER_NONE }
    str.push(["不意打ち無効", nil])       if fts.any? {|ft| ft.code_id == ABILITY_CANCEL_SURPRISE }
    str.push(["先制攻撃率アップ", nil])   if fts.any? {|ft| ft.code_id == ABILITY_RAISE_PREEMPTIVE }
    str.push(["獲得金額２倍", nil])       if fts.any? {|ft| ft.code_id == ABILITY_GOLD_DOUBLE }
    str.push(["アイテム入手率２倍", nil]) if fts.any? {|ft| ft.code_id == ABILITY_DROP_ITEM_DOUBLE }
    str
  end
  #--------------------------------------------------------------------------
  # ● その他情報取得
  #--------------------------------------------------------------------------
  def other
    action_plus + special_flag + party_ability
  end
  #--------------------------------------------------------------------------
  # ● 全特徴取得
  #--------------------------------------------------------------------------
  def all
    Spirits.status.inject([]) do |r, st|
      case st
      when :rate;   r += self.rate
      when :param;  r += self.param
      when :attack; r += self.attack
      when :skill;  r += self.skill
      when :equip;  r += self.equip
      when :other;  r += self.other
      end
    end
   end
end


#==============================================================================
# ■ Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  attr_reader :max_spirits        # 最大精霊数
  attr_reader :partner_locked     # 固定パートナー
  #--------------------------------------------------------------------------
  # ● セットアップ
  #--------------------------------------------------------------------------
  alias setup_spirit setup
  def setup(actor_id)
    @partners = []
    @max_spirits = Spirits.max(actor_id)
    @parent_id = 0
    @partner_locked = false
    @is_spirit = Spirits.spirit?(actor_id)
    setup_spirit(actor_id)
  end
  #--------------------------------------------------------------------------
  # ● 精霊？
  #--------------------------------------------------------------------------
  def spirit?
    @is_spirit
  end
  #--------------------------------------------------------------------------
  # ● 最大精霊数変更
  #--------------------------------------------------------------------------
  def max_spirits=(num)
    @max_spirits = [1, num].max unless spirit?
  end
  #--------------------------------------------------------------------------
  # ● 精霊ID
  #--------------------------------------------------------------------------
  def spirit_id
    spirit? ? Spirits.spirit_id(@actor_id) : 0
  end
  #--------------------------------------------------------------------------
  # ● 精霊付与可能？
  #--------------------------------------------------------------------------
  def can_partner(spirit_id)
    spirit? ? false : (Spirits.affinity(@actor_id, spirit_id) != 0)
  end
  #--------------------------------------------------------------------------
  # ● 精霊交換可能？
  #--------------------------------------------------------------------------
  def can_change_partner(index)
    return false if spirit?
    return true  if @partners[index] == 0
    $game_actors[@partners[index]].partner_locked
  end
  #--------------------------------------------------------------------------
  # ● 精霊付与可能？
  #--------------------------------------------------------------------------
  def can_join_partner(partner_id=0)
    return (@parent_id == 0) if spirit?
    return false unless can_partner(partner_id)
    (@partners.size < @max_spirits)
  end
  #--------------------------------------------------------------------------
  # ● パートナー追加
  #--------------------------------------------------------------------------
  def add_partner(partner_id)
    if spirit?
      @parent_id = partner_id
    else
      return if @max_spirits == partner_num
      @partners.push(partner_id) unless @partners.include?(partner_id)
    end
  end
  #--------------------------------------------------------------------------
  # ● パートナー削除
  #--------------------------------------------------------------------------
  def remove_partner(partner_id)
    if spirit?
      @parent_id = 0
      unlock_partner
    else
      @partners.delete(partner_id)
    end
  end
  #--------------------------------------------------------------------------
  # ● パートナー変更
  #--------------------------------------------------------------------------
  def change_partner(partner_id, index=0)
    if spirit?
      @parent_id = partner_id
    else
      @partners[index] = partner_id
    end
  end
  #--------------------------------------------------------------------------
  # ● 仮想パートナー変更 パラメータ取得
  #--------------------------------------------------------------------------
  def v_chg_param(partner_id, index, param_id)
    return 0 if spirit?
    now_partner = @partners[index]
    change_partner(partner_id, index)
    prm = self.param(param_id)
    change_partner(now_partner, index)
    prm
  end
  #--------------------------------------------------------------------------
  # ● パートナー有り？
  #--------------------------------------------------------------------------
  def has_partner?
    spirit? ? (@parent_id != 0) : (!@partners.empty?)
  end
  def has_spirit?
    spirit? ? false : (!@partners.empty?)
  end
  #--------------------------------------------------------------------------
  # ● 精霊パートナー固定化
  #--------------------------------------------------------------------------
  def lock_partner
    return unless spirit?
    @partner_locked = true
  end
  #--------------------------------------------------------------------------
  # ● 精霊パートナー固有化解除
  #--------------------------------------------------------------------------
  def unlock_partner
    @partner_locked = false
  end
  #--------------------------------------------------------------------------
  # ● パートナー参照
  #--------------------------------------------------------------------------
  def partners
    return (has_partner? ? [$game_actors[@parent_id]] : []) if spirit?
    @partners.collect {|id| id.nil? ? nil : $game_actors[Spirits.actor_id(id)]}
  end
  def partners_objs
    partners.compact
  end
  #--------------------------------------------------------------------------
  # ● パートナー数参照
  #--------------------------------------------------------------------------
  def partner_num
    @partners.size
  end
  #--------------------------------------------------------------------------
  # ● 追加スキルの取得
  #--------------------------------------------------------------------------
  def added_skills
    has_spirit? ? partners_objs.inject(super) {|r, s| r |= s.skillids} : super
  end
  #--------------------------------------------------------------------------
  # ● スキルID郡 取得
  #--------------------------------------------------------------------------
  def skillids
    @skills
  end
  #--------------------------------------------------------------------------
  # ● 通常能力値の取得
  #--------------------------------------------------------------------------
  def param(param_id)
    super(param_id) - (spirit? ? Spirits::PRM_BASE[param_id] : 0)
  end
  alias org_param param
  def param(param_id)
    org = org_param(param_id)
    if has_spirit?
      partners_objs.each do |s|
        org += Spirits.affinity_param(s.org_param(param_id), @actor_id, s.spirit_id)
      end
    end
    org
  end
  #--------------------------------------------------------------------------
  # ● 特徴を保持する全オブジェクトの配列取得
  #--------------------------------------------------------------------------
  alias org_feature_objects feature_objects
  def feature_objects
    org = org_feature_objects
    partners_objs.collect {|s| s.org_feature_objects }.each {|obj| org += obj} if has_spirit?
    org
  end
  #--------------------------------------------------------------------------
  # ● 控えメンバーの経験獲得率を取得
  #--------------------------------------------------------------------------
  alias reserve_members_exp_rate_spirits reserve_members_exp_rate
  def reserve_members_exp_rate
    spirit? ? 1 : reserve_members_exp_rate_spirits
  end
end


#==============================================================================
# ■ Game_Party
#==============================================================================
class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_spirits initialize
  def initialize
    @spirits = []
    initialize_spirits
  end
  #--------------------------------------------------------------------------
  # ● 初期パーティのセットアップ
  #--------------------------------------------------------------------------
  alias setup_starting_members_spirits setup_starting_members
  def setup_starting_members
    setup_starting_members_spirits
    setup_starting_spirits
  end
  #--------------------------------------------------------------------------
  # ● 初期パートナーのセットアップ
  #--------------------------------------------------------------------------
  def setup_starting_spirits
    remeve_all_spirit
    @spirits = Spirits::START_V
    Spirits::START_P.each_pair do |aid, sid|
      if @actors.include?(aid) and @spirits.include?(sid)
        $game_actors[aid].add_partner(sid)
        $game_actors[Spirits.actor_id(sid)].add_partner(aid)
        $game_actors[aid].recover_all
      else
        p "START_P[#{aid} => #{sid}] is bad arg."
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 精霊がいるか？
  #--------------------------------------------------------------------------
  def include_spirit?(spirit_id)
    @spirits.include?(spirit_id)
  end
  #--------------------------------------------------------------------------
  # ● 精霊を加える
  #--------------------------------------------------------------------------
  def add_spirit(spirit_id)
    @spirits.push(spirit_id) unless include_spirit?(spirit_id)
  end
  #--------------------------------------------------------------------------
  # ● 精霊を外す
  #--------------------------------------------------------------------------
  def remove_spirit(spirit_id)
    members.each {|actor| actor.remove_partner(spirit_id)}
    @spirits.delete(spirit_id)
  end
  #--------------------------------------------------------------------------
  # ● 全精霊を外す
  #--------------------------------------------------------------------------
  def remeve_all_spirit
    @spirits.each {|id| members.each {|actor| actor.remove_partner(id)}}
    @spirits = []
  end
  #--------------------------------------------------------------------------
  # ● 精霊リスト
  #--------------------------------------------------------------------------
  def spirit_members
    @spirits.collect {|id| spirit(id)}
  end
  #--------------------------------------------------------------------------
  # ● 待機 精霊リスト
  #--------------------------------------------------------------------------
  def spirit_stay_members
    spirit_members.select {|spirit| !spirit.has_partner?}
  end
  #--------------------------------------------------------------------------
  # ● 精霊数
  #--------------------------------------------------------------------------
  def spirit_num
    @spirits.size
  end
  #--------------------------------------------------------------------------
  # ● 精霊データ
  #--------------------------------------------------------------------------
  def spirit(spirit_id)
    $game_actors[Spirits.actor_id(spirit_id)]
  end
end



#==============================================================================
# ■ Window_Base
#==============================================================================
class Window_Base < Window
  #--------------------------------------------------------------------------
  # ● 歩行グラフィックの描画
  #--------------------------------------------------------------------------
  def draw_line_character(character_name, character_index, x, y, enabled=true)
    return unless character_name
    bitmap = Cache.character(character_name)
    sign = character_name[/^[\!\$]./]
    if sign && sign.include?('$')
      cw = bitmap.width / 3
      ch = bitmap.height / 4
    else
      cw = bitmap.width / 12
      ch = bitmap.height / 8
    end
    y += (line_height - ch) / 2 if ch < line_height
    n = character_index
    src_rect = Rect.new((n%4*3+1)*cw, (n/4*4)*ch, cw, [ch, line_height].min)
    contents.blt(x, y, bitmap, src_rect, enabled ? 255 : translucent_alpha)
    cw
  end
  #--------------------------------------------------------------------------
  # ● アクターの歩行グラフィック描画
  #--------------------------------------------------------------------------
  def draw_actor_line_graphic(actor, x, y, enabled=true)
    draw_line_character(actor.character_name, actor.character_index, x, y, enabled)
  end
  #--------------------------------------------------------------------------
  # ● パートナー名描画
  #--------------------------------------------------------------------------
  def draw_partner_name(actor, x, y)
    change_color(system_color)
    draw_text(x, y, contents_width, line_height, actor.spirit? ? "パートナー" : "Covenant")
    x += 100
    change_color(normal_color)
    if actor.has_partner?
      actor.partners.each_with_index {|s, i| draw_actor_line_graphic(s, x + 48 * i, y)}
    else
      draw_text(x, y, contents_width, line_height, "―――")
    end
  end
  #--------------------------------------------------------------------------
  # ● 名前の描画
  #--------------------------------------------------------------------------
  def draw_spirit_name(actor, x, y, enabled=true, width = 112)
    change_color(normal_color, enabled)
    draw_text(x, y, width, line_height, actor.name)
  end
  #--------------------------------------------------------------------------
  # ● 能力値の描画
  #--------------------------------------------------------------------------
  def draw_spirit_param(actor, x, y, param_id)
    change_color(system_color)
    draw_text(x, y, 120, line_height, Vocab::param(param_id))
    prm = actor.param(param_id)
    change_color(param_change_color(prm))
    if prm == 0
      draw_text(x + 100, y, 56, line_height, "----", 2)
    else
      draw_text(x + 100, y, 56, line_height, sprintf("%+d", prm), 2)
    end
  end
end


class << BattleManager
  #--------------------------------------------------------------------------
  # ● 経験値の獲得とレベルアップの表示
  #--------------------------------------------------------------------------
  alias gain_exp_spirits gain_exp
  def gain_exp
    gain_exp_spirits
    gain_spirit_exp if Spirits::USE_LV
  end
  #--------------------------------------------------------------------------
  # ● 精霊の経験値獲得
  #--------------------------------------------------------------------------
  def gain_spirit_exp
    case Spirits::EXP_TARGET
    when 0
      $game_party.battle_members.each do |actor|
        actor.partners.compact.each do |spirit|
          spirit.gain_exp(spirit_exp)
        end
      end
    when 1
      $game_party.all_members.each do |actor|
        actor.partners.compact.each do |spirit|
          spirit.gain_exp(spirit_exp)
        end
      end
    when 2
      $game_party.spirit_members.each do |spirit|
        spirit.gain_exp(spirit_exp)
      end
    end
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # ● 精霊用経験値
  #--------------------------------------------------------------------------
  def spirit_exp
    Spirits::EXP_TYPE == 0 ? 1 : $game_troop.exp_total
  end
end


if defined?(BtlrFv)
class << BattleManager
  #--------------------------------------------------------------------------
  # ● 獲得した経験値の表示
  #--------------------------------------------------------------------------
  alias display_result_spirit display_result
  def display_result
    display_result_spirit
    gain_spirit_exp if Spirits::USE_LV
  end
end
end # BtlrFv