#==============================================================================
# ■ Window_BattleLog
#------------------------------------------------------------------------------
# 　戦闘の進行を実況表示するウィンドウです。枠は表示しませんが、便宜上ウィンド
# ウとして扱います。
#==============================================================================

class Window_BattleLog < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, window_width, window_height)
    self.z = 200
    self.opacity = 0
    @lines = []
    @num_wait = 0
    create_back_bitmap
    create_back_sprite
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    super
    dispose_back_bitmap
    dispose_back_sprite
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ高さの取得
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(max_line_number)
  end
  #--------------------------------------------------------------------------
  # ● 最大行数の取得
  #--------------------------------------------------------------------------
  def max_line_number
    return 6
  end
  #--------------------------------------------------------------------------
  # ● 背景ビットマップの作成
  #--------------------------------------------------------------------------
  def create_back_bitmap
    @back_bitmap = Bitmap.new(width, height)
  end
  #--------------------------------------------------------------------------
  # ● 背景スプライトの作成
  #--------------------------------------------------------------------------
  def create_back_sprite
    @back_sprite = Sprite.new
    @back_sprite.bitmap = @back_bitmap
    @back_sprite.y = y
    @back_sprite.z = z - 1
  end
  #--------------------------------------------------------------------------
  # ● 背景ビットマップの解放
  #--------------------------------------------------------------------------
  def dispose_back_bitmap
    @back_bitmap.dispose
  end
  #--------------------------------------------------------------------------
  # ● 背景スプライトの解放
  #--------------------------------------------------------------------------
  def dispose_back_sprite
    @back_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # ● クリア
  #--------------------------------------------------------------------------
  def clear
    @num_wait = 0
    @lines.clear
    refresh
  end
  #--------------------------------------------------------------------------
  # ● データ行数の取得
  #--------------------------------------------------------------------------
  def line_number
    @lines.size
  end
  #--------------------------------------------------------------------------
  # ● 一行戻る
  #--------------------------------------------------------------------------
  def back_one
    @lines.pop
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 指定した行に戻る
  #--------------------------------------------------------------------------
  def back_to(line_number)
    @lines.pop while @lines.size > line_number
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 文章の追加
  #--------------------------------------------------------------------------
  def add_text(text)
    @lines.push(text)
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 文章の置き換え
  #    最下行を別の文章に置き換える。
  #--------------------------------------------------------------------------
  def replace_text(text)
    @lines.pop
    @lines.push(text)
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 最下行の文章の取得
  #--------------------------------------------------------------------------
  def last_text
    @lines[-1]
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    draw_background
    contents.clear
    @lines.size.times {|i| draw_line(i) }
  end
  #--------------------------------------------------------------------------
  # ● 背景の描画
  #--------------------------------------------------------------------------
  def draw_background
    @back_bitmap.clear
    @back_bitmap.fill_rect(back_rect, back_color)
  end
  #--------------------------------------------------------------------------
  # ● 背景の矩形を取得
  #--------------------------------------------------------------------------
  def back_rect
    Rect.new(0, padding, width, line_number * line_height)
  end
  #--------------------------------------------------------------------------
  # ● 背景色の取得
  #--------------------------------------------------------------------------
  def back_color
    Color.new(0, 0, 0, back_opacity)
  end
  #--------------------------------------------------------------------------
  # ● 背景の不透明度を取得
  #--------------------------------------------------------------------------
  def back_opacity
    return 64
  end
  #--------------------------------------------------------------------------
  # ● 行の描画
  #--------------------------------------------------------------------------
  def draw_line(line_number)
    rect = item_rect_for_text(line_number)
    contents.clear_rect(rect)
    draw_text_ex(rect.x, rect.y, @lines[line_number])
  end
  #--------------------------------------------------------------------------
  # ● ウェイト用メソッドの設定
  #--------------------------------------------------------------------------
  def method_wait=(method)
    @method_wait = method
  end
  #--------------------------------------------------------------------------
  # ● エフェクト実行のウェイト用メソッドの設定
  #--------------------------------------------------------------------------
  def method_wait_for_effect=(method)
    @method_wait_for_effect = method
  end
  #--------------------------------------------------------------------------
  # ● ウェイト
  #--------------------------------------------------------------------------
  def wait
    @num_wait += 1
    @method_wait.call(message_speed) if @method_wait
  end
  #--------------------------------------------------------------------------
  # ● エフェクト実行が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_effect
    @method_wait_for_effect.call if @method_wait_for_effect
  end
  #--------------------------------------------------------------------------
  # ● メッセージ速度の取得
  #--------------------------------------------------------------------------
  def message_speed
    return 20
  end
  #--------------------------------------------------------------------------
  # ● ウェイトとクリア
  #    メッセージが読める最低限のウェイトを入れた後クリアする。
  #--------------------------------------------------------------------------
  def wait_and_clear
    wait while @num_wait < 2 if line_number > 0
    clear
  end
  #--------------------------------------------------------------------------
  # ● 現在のステートの表示
  #--------------------------------------------------------------------------
  def display_current_state(subject)
    unless subject.most_important_state_text.empty?
      add_text(subject.name + subject.most_important_state_text)
      wait
    end
  end
  #--------------------------------------------------------------------------
  # ● スキル／アイテム使用の表示
  #--------------------------------------------------------------------------
  def display_use_item(subject, item)
    if item.is_a?(RPG::Skill)
      add_text(subject.name + item.message1)
      unless item.message2.empty?
        wait
        add_text(item.message2)
      end
    else
      add_text(sprintf(Vocab::UseItem, subject.name, item.name))
    end
  end
  #--------------------------------------------------------------------------
  # ● 反撃の表示
  #--------------------------------------------------------------------------
  def display_counter(target, item)
    Sound.play_evasion
    add_text(sprintf(Vocab::CounterAttack, target.name))
    wait
    back_one
  end
  #--------------------------------------------------------------------------
  # ● 反射の表示
  #--------------------------------------------------------------------------
  def display_reflection(target, item)
    Sound.play_reflection
    add_text(sprintf(Vocab::MagicReflection, target.name))
    wait
    back_one
  end
  #--------------------------------------------------------------------------
  # ● 身代わりの表示
  #--------------------------------------------------------------------------
  def display_substitute(substitute, target)
    add_text(sprintf(Vocab::Substitute, substitute.name, target.name))
    wait
    back_one
  end
  #--------------------------------------------------------------------------
  # ● 行動結果の表示
  #--------------------------------------------------------------------------
  def display_action_results(target, item)
    if target.result.used
      last_line_number = line_number
      display_critical(target, item)
      display_damage(target, item)
      display_affected_status(target, item)
      display_failure(target, item)
      wait if line_number > last_line_number
      back_to(last_line_number)
    end
  end
  #--------------------------------------------------------------------------
  # ● 失敗の表示
  #--------------------------------------------------------------------------
  def display_failure(target, item)
    if target.result.hit? && !target.result.success
      add_text(sprintf(Vocab::ActionFailure, target.name))
      wait
    end
  end
  #--------------------------------------------------------------------------
  # ● クリティカルヒットの表示
  #--------------------------------------------------------------------------
  def display_critical(target, item)
    if target.result.critical
      text = target.actor? ? Vocab::CriticalToActor : Vocab::CriticalToEnemy
      add_text(text)
      wait
    end
  end
  #--------------------------------------------------------------------------
  # ● ダメージの表示
  #--------------------------------------------------------------------------
  def display_damage(target, item)
    if target.result.missed
      display_miss(target, item)
    elsif target.result.evaded
      display_evasion(target, item)
    else
      display_hp_damage(target, item)
      display_mp_damage(target, item)
      display_tp_damage(target, item)
    end
  end
  #--------------------------------------------------------------------------
  # ● ミスの表示
  #--------------------------------------------------------------------------
  def display_miss(target, item)
    if !item || item.physical?
      fmt = target.actor? ? Vocab::ActorNoHit : Vocab::EnemyNoHit
      Sound.play_miss
    else
      fmt = Vocab::ActionFailure
    end
    add_text(sprintf(fmt, target.name))
    wait
  end
  #--------------------------------------------------------------------------
  # ● 回避の表示
  #--------------------------------------------------------------------------
  def display_evasion(target, item)
    if !item || item.physical?
      fmt = Vocab::Evasion
      Sound.play_evasion
    else
      fmt = Vocab::MagicEvasion
      Sound.play_magic_evasion
    end
    add_text(sprintf(fmt, target.name))
    wait
  end
  #--------------------------------------------------------------------------
  # ● HP ダメージ表示
  #--------------------------------------------------------------------------
  def display_hp_damage(target, item)
    return if target.result.hp_damage == 0 && item && !item.damage.to_hp?
    if target.result.hp_damage > 0 && target.result.hp_drain == 0
      target.perform_damage_effect
    end
    Sound.play_recovery if target.result.hp_damage < 0
    add_text(target.result.hp_damage_text)
    wait
  end
  #--------------------------------------------------------------------------
  # ● MP ダメージ表示
  #--------------------------------------------------------------------------
  def display_mp_damage(target, item)
    return if target.dead? || target.result.mp_damage == 0
    Sound.play_recovery if target.result.mp_damage < 0
    add_text(target.result.mp_damage_text)
    wait
  end
  #--------------------------------------------------------------------------
  # ● TP ダメージ表示
  #--------------------------------------------------------------------------
  def display_tp_damage(target, item)
    return if target.dead? || target.result.tp_damage == 0
    Sound.play_recovery if target.result.tp_damage < 0
    add_text(target.result.tp_damage_text)
    wait
  end
  #--------------------------------------------------------------------------
  # ● 影響を受けたステータスの表示
  #--------------------------------------------------------------------------
  def display_affected_status(target, item)
    if target.result.status_affected?
      add_text("") if line_number < max_line_number
      display_changed_states(target)
      display_changed_buffs(target)
      back_one if last_text.empty?
    end
  end
  #--------------------------------------------------------------------------
  # ● 自動で影響を受けたステータスの表示
  #--------------------------------------------------------------------------
  def display_auto_affected_status(target)
    if target.result.status_affected?
      display_affected_status(target, nil)
      wait if line_number > 0
    end
  end
  #--------------------------------------------------------------------------
  # ● ステート付加／解除の表示
  #--------------------------------------------------------------------------
  def display_changed_states(target)
    display_added_states(target)
    display_removed_states(target)
  end
  #--------------------------------------------------------------------------
  # ● ステート付加の表示
  #--------------------------------------------------------------------------
  def display_added_states(target)
    target.result.added_state_objects.each do |state|
      state_msg = target.actor? ? state.message1 : state.message2
      target.perform_collapse_effect if state.id == target.death_state_id
      next if state_msg.empty?
      replace_text(target.name + state_msg)
      wait
      wait_for_effect
    end
  end
  #--------------------------------------------------------------------------
  # ● ステート解除の表示
  #--------------------------------------------------------------------------
  def display_removed_states(target)
    target.result.removed_state_objects.each do |state|
      next if state.message4.empty?
      replace_text(target.name + state.message4)
      wait
    end
  end
  #--------------------------------------------------------------------------
  # ● 能力強化／弱体の表示
  #--------------------------------------------------------------------------
  def display_changed_buffs(target)
    display_buffs(target, target.result.added_buffs, Vocab::BuffAdd)
    display_buffs(target, target.result.added_debuffs, Vocab::DebuffAdd)
    display_buffs(target, target.result.removed_buffs, Vocab::BuffRemove)
  end
  #--------------------------------------------------------------------------
  # ● 能力強化／弱体の表示（個別）
  #--------------------------------------------------------------------------
  def display_buffs(target, buffs, fmt)
    buffs.each do |param_id|
      replace_text(sprintf(fmt, target.name, Vocab::param(param_id)))
      wait
    end
  end
end
