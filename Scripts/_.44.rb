 
#==============================================================================
#                   「攻撃を受けてから反撃」(ACE) Ver.1.2
#   製作者：奈々（なな）
#   へぷたなすくろーる http://heptanas.mamagoto.com/
#
#   ◇使用規約
#   使用される場合はスクリプト作成者として「奈々」を明記して下さい。
#   スクリプトの改変は自由に行って頂いて構いませんが
#   その場合も元のスクリプトの作成者として名前を載せて下さい。
#   また配布前に必ず、ブログにある利用規約を確認して下さい。
#
#------------------------------------------------------------------------------
#   
#   デフォルトの「反撃」は相手の攻撃を無効にして反撃しますが
#   これを相手の攻撃を受けた上で反撃するように変更します。
#   
#   反撃率を上げると同時に、回避率などを上げれば元の仕様も再現できます。
#   
#   また、スキル・アイテムのメモ欄に
#   <反撃不可> <反撃可能>
#   と記述することで、命中タイプを無視して反撃の可否を設定できます。
#   
#   データベースのメモ欄に
#   <反撃スキル n>
#   と記述することで、n番のスキルで反撃を行うように設定できます。
#   複数設定されている場合は、番号が最大のものが適用されます。
#   
#   なお、全体攻撃やランダム攻撃のスキルであっても
#   反撃時には単体攻撃になる仕様です。（連続攻撃は適用される）
#   
#==============================================================================

#==============================================================================
# ■ RPG::BaseItem
#------------------------------------------------------------------------------
# 　アクター・装備・ステートなどを総括して扱うデータクラス。
#==============================================================================

class RPG::BaseItem
  #--------------------------------------------------------------------------
  # ● 反撃スキルの指定
  #--------------------------------------------------------------------------
  def cnt_atk_skill_id
    @note[/\<\s*反撃スキル\s*(\d+)\s*\>/]
    return $1 ? $1.to_i : 0
  end
end

#==============================================================================
# ■ Game_Battler
#------------------------------------------------------------------------------
# 　スプライトや行動に関するメソッドを追加したバトラーのクラスです。このクラス
# は Game_Actor クラスと Game_Enemy クラスのスーパークラスとして使用されます。
#==============================================================================

class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # ● スキル／アイテムの反撃率計算
  #--------------------------------------------------------------------------
  alias item_cnt_mod item_cnt
  def item_cnt(user, item)
    return 0 unless opposite?(user)         # 味方には反撃しない
    return 0 if item.note.include?("<反撃不可>")
    return cnt if item.note.include?("<反撃可能>")
    return item_cnt_mod(user, item)
  end
end

#==============================================================================
# ■ Game_Actor
#------------------------------------------------------------------------------
# 　アクターを扱うクラスです。このクラスは Game_Actors クラス（$game_actors）
# の内部で使用され、Game_Party クラス（$game_party）からも参照されます。
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ● 反撃のスキル ID を取得
  #--------------------------------------------------------------------------
  def cnt_atk_skill_id
    list = []
    self.states.each do |state|
      next unless state && state.cnt_atk_skill_id
      list.push(state.cnt_atk_skill_id)
    end
    self.equips.each do |equip|
      next unless equip && equip.cnt_atk_skill_id
      list.push(equip.cnt_atk_skill_id)
    end
    list.push(self.actor.cnt_atk_skill_id) if self.actor.cnt_atk_skill_id
    list.push(self.class.cnt_atk_skill_id) if self.class.cnt_atk_skill_id
    return list.sort.reverse[0] > 0 ? list.sort.reverse[0] : attack_skill_id
  end
end

#==============================================================================
# ■ Game_Enemy
#------------------------------------------------------------------------------
# 　敵キャラを扱うクラスです。このクラスは Game_Troop クラス（$game_troop）の
# 内部で使用されます。
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # ● 反撃のスキル ID を取得
  #--------------------------------------------------------------------------
  def cnt_atk_skill_id
    list = []
    self.states.each do |state|
      next unless state && state.cnt_atk_skill_id
      list.push(state.cnt_atk_skill_id)
    end
    list.push(self.enemy.cnt_atk_skill_id) if self.enemy.cnt_atk_skill_id
    return list.sort.reverse[0] > 0 ? list.sort.reverse[0] : attack_skill_id
  end
end

#==============================================================================
# ■ Scene_Battle
#------------------------------------------------------------------------------
# 　バトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● 反撃の発動
  #--------------------------------------------------------------------------
  def invoke_counter_attack(target, item)
    #反撃前に攻撃を適用
    apply_item_effects(apply_substitute(target, item), item)
    
    @log_window.display_counter(target, item)
    attack_skill = $data_skills[target.cnt_atk_skill_id]
    
    #反撃のアニメーションを追加
    show_animation_counter(target, attack_skill.animation_id)
    
    @subject.item_apply(target, attack_skill)
    refresh_status
    @log_window.display_action_results(@subject, attack_skill)
  end
  #--------------------------------------------------------------------------
  # ● 反撃用アニメーションの表示
  #--------------------------------------------------------------------------
  def show_animation_counter(target, animation_id)
    if animation_id < 0
      if target.actor?
        show_normal_animation([@subject], target.atk_animation_id1, false)
        show_normal_animation([@subject], target.atk_animation_id2, true)
      else
        Sound.play_enemy_attack
        abs_wait_short
      end
    else
      show_normal_animation([@subject], animation_id)
    end
    @log_window.wait
    wait_for_animation
  end
end