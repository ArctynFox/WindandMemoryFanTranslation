#==============================================================================
# ■ VXAce_FP (RPGツクールVX Ace Fun Patch) 2015.03.17
#------------------------------------------------------------------------------
#   RPGツクールVX Ace のプリセットスクリプトの不都合を修正します。
#   不具合でなくとも問題のある処理は修正しています。
#   また、不具合と思える処理でも仕様と割り切れるものは修正していません。
#==============================================================================


#------------------------------------------------------------------------------
# 【はじめに】
#------------------------------------------------------------------------------
# ■ VXAce_SP1 のすぐ下に導入してください。
# ■ このスクリプトに限り、転載・再配布・改変・改変物の配布を許可しています。
#    積極的に情報を広めていただければと思います。
# ■ メソッドのマークの意味は次の通りです。
#     ● 新しく定義　○ 再定義　◎ 注意
# ■ 修正内容ごとに番号を付けていますので、スクリプトを確認したいときや
#    修正を無効にしたいときなどは、『# 番号』で検索してください。
# ■ 本スクリプト導入済みの場合は $CAO_SP が true になります。
#    この変数は、F12 リセット対策としてエイリアスの判定に使用されています。
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# 【修正内容】
#------------------------------------------------------------------------------
# [01] Viewport#disposed? を使用した際にエラーが出る不都合をなんとかしました。
# [02] Bitmap#gradient_fill_rect の引数 vertical が無視される不都合をなんとかし
#      ました。
# [03] フォントを変更すると \r が・と表示される不都合を修正しました。
# [04] イベントコマンド「画面のシェイク」で、ウェイト設定が正しく機能しない不都
#      合を修正しました。
# [05] 戦闘中のターン数がズレている不都合を修正しました。
# [06] 効果対象が味方でその対象が未設定の場合、最後尾のバトラーが対象となる不都
#      合を修正しました。(対象はランダムに決定されます。)
# [07] 戦闘終了時に表示されるべきではない敵が現れる不都合を修正しました。
# [08] Window_SaveFile#draw_playtime の引数 align が無視される不都合を修正しま
#      した。
# [09] 複数回攻撃時に、敵が戦闘不能になっても反撃してくる不都合を修正しました。
# [10] 複数回攻撃時に、反撃を受けて戦闘不能になっても攻撃し続ける不都合を修正し
#      ました。
# [11] 蘇生時の戦闘アニメが表示されない不都合を修正しました。
# [12] スキルの使用可能条件チェックで、スキルタイプが考慮されない不都合を修正し
#      ました。
# [13] 自動戦闘時の戦闘行動候補に防御行動を追加しました。
# [14] 解放されたウィンドウも自動更新する不都合を修正しました。
# [15] 選択肢内にラベルジャンプすると無限ループする不都合を修正しました。
# [16] フォロワーがジャンプに対応していない不都合を修正しました。
# [17] Sprite#angle の回転角度 0 と 360 が同じ角度になるように変更しました。
# [18] 一度でも使用したピクチャは、常に再生成される不都合を修正しました。
# [19] 定義されていない制御文字は、通常文字として表示するように変更しました。
# [20] 選択肢の幅を計算する際に制御文字とアイコンが考慮されていない不都合を修正
#      しました。ただし、文字サイズは無視されます。
# [21] イベントコマンド「敵キャラの HP 増減」で戦闘不能者がいると全体に処理が実
#      行されない不都合を修正しまいた。
#------------------------------------------------------------------------------


# 01
class Viewport
  #--------------------------------------------------------------------------
  # ● ビューポートの有無
  #--------------------------------------------------------------------------
  def disposed?
    self.visible
    return false
  rescue RGSSError
    return true
  end
end

# 02
class Bitmap
  #--------------------------------------------------------------------------
  # ○ 矩形をグラデーションで塗り潰す
  #--------------------------------------------------------------------------
  alias _cao_sp_gradient_fill_rect gradient_fill_rect unless $CAO_SP
  def gradient_fill_rect(*args)
    if (6..7) === args.size
      x, y, width, height, color1, color2, vertical = args
      rect = Rect.new(x, y, width, height)
      _cao_sp_gradient_fill_rect(rect, color1, color2, vertical)
    else
      _cao_sp_gradient_fill_rect(*args)
    end
  rescue => error
    raise error.class, error.message, caller.first
  end
end

# 03
class Window_Base
  #--------------------------------------------------------------------------
  # ○ 制御文字の事前変換
  #--------------------------------------------------------------------------
  def convert_escape_characters(text)
    result = text.to_s.clone
    result.gsub!(/\r\n/)          { "\n" }
    result.gsub!(/\\/)            { "\e" }
    result.gsub!(/\e\e/)          { "\\" }
    result.gsub!(/\eV\[(\d+)\]/i) { $game_variables[$1.to_i] }
    result.gsub!(/\eV\[(\d+)\]/i) { $game_variables[$1.to_i] }
    result.gsub!(/\eN\[(\d+)\]/i) { actor_name($1.to_i) }
    result.gsub!(/\eP\[(\d+)\]/i) { party_member_name($1.to_i) }
    result.gsub!(/\eG/i)          { Vocab::currency_unit }
    result
  end
end

# 04
class Game_Interpreter
  #--------------------------------------------------------------------------
  # ○ 画面のシェイク
  #--------------------------------------------------------------------------
  def command_225
    screen.start_shake(@params[0], @params[1], @params[2])
    wait(@params[2]) if @params[3]
  end
end

# 05
class Game_Enemy
  #--------------------------------------------------------------------------
  # ○ 行動条件合致判定［ターン数］
  #--------------------------------------------------------------------------
  def conditions_met_turns?(param1, param2)
    n = $game_troop.turn_count + 1
    if param2 == 0
      n == param1
    else
      n > 0 && n >= param1 && n % param2 == param1 % param2
    end
  end
end

# 06
class Game_Action
  #--------------------------------------------------------------------------
  # ○ 味方に対するターゲット
  #--------------------------------------------------------------------------
  def targets_for_friends
    if item.for_user?
      return [subject]
    elsif item.for_dead_friend?
      return friends_unit.dead_members unless item.for_one?
      return [friends_unit.random_dead_target] if @target_index < 0
      return [friends_unit.smooth_dead_target(@target_index)]
    elsif item.for_friend?
      return friends_unit.alive_members unless item.for_one?
      return [friends_unit.random_target] if @target_index < 0
      return [friends_unit.smooth_target(@target_index)]
    end
  end
end

# 07
class Game_Enemy
  #--------------------------------------------------------------------------
  # ○ 戦闘終了処理
  #--------------------------------------------------------------------------
  def on_battle_end
    # Do Nothing
  end
end

# 08
class Window_SaveFile
  #--------------------------------------------------------------------------
  # ○ プレイ時間の描画
  #--------------------------------------------------------------------------
  def draw_playtime(x, y, width, align)
    header = DataManager.load_header(@file_index)
    return unless header
    draw_text(x, y, width, line_height, header[:playtime_s], align)
  end
end

# 09
class Game_Battler
  #--------------------------------------------------------------------------
  # ○ スキル／アイテムの反撃率計算
  #--------------------------------------------------------------------------
  def item_cnt(user, item)
    return 0 unless self.alive?             # 自身が戦闘不能
    return 0 unless item.physical?          # 命中タイプが物理ではない
    return 0 unless opposite?(user)         # 味方には反撃しない
    return cnt                              # 反撃率を返す
  end
  #--------------------------------------------------------------------------
  # ○ スキル／アイテムの反射率計算
  #--------------------------------------------------------------------------
  def item_mrf(user, item)
    return 0 unless self.alive?             # 自身が戦闘不能
    return 0 unless item.magical?           # 魔法攻撃ではない
    return mrf                              # 魔法反射率を返す
  end
end

# 10
class Scene_Battle
  #--------------------------------------------------------------------------
  # ○ スキル／アイテムの発動
  #--------------------------------------------------------------------------
  alias _cao_sp_invoke_item invoke_item
  def invoke_item(target, item)
    return if @subject.dead?
    _cao_sp_invoke_item(target, item)
  end
end

# 11
class Sprite_Base
  #--------------------------------------------------------------------------
  # ○ アニメーションスプライトの設定
  #     frame : フレームデータ（RPG::Animation::Frame）
  #--------------------------------------------------------------------------
  def animation_set_sprites(frame)
    cell_data = frame.cell_data
    @ani_sprites.each_with_index do |sprite, i|
      next unless sprite
      pattern = cell_data[i, 0]
      if !pattern || pattern < 0
        sprite.visible = false
        next
      end
      sprite.bitmap = pattern < 100 ? @ani_bitmap1 : @ani_bitmap2
      sprite.visible = true
      sprite.src_rect.set(pattern % 5 * 192,
        pattern % 100 / 5 * 192, 192, 192)
      if @ani_mirror
        sprite.x = @ani_ox - cell_data[i, 1]
        sprite.y = @ani_oy + cell_data[i, 2]
        sprite.angle = (360 - cell_data[i, 4])
        sprite.mirror = (cell_data[i, 5] == 0)
      else
        sprite.x = @ani_ox + cell_data[i, 1]
        sprite.y = @ani_oy + cell_data[i, 2]
        sprite.angle = cell_data[i, 4]
        sprite.mirror = (cell_data[i, 5] == 1)
      end
      sprite.z = self.z + 300 + i
      sprite.ox = 96
      sprite.oy = 96
      sprite.zoom_x = cell_data[i, 3] / 100.0
      sprite.zoom_y = cell_data[i, 3] / 100.0
      sprite.opacity = cell_data[i, 6]
      sprite.blend_type = cell_data[i, 7]
    end
  end
end

# 12
#~ class Game_BattlerBase  # すべてのバトラーに適用
#~   #--------------------------------------------------------------------------
#~   # ○ スキルの使用可能条件チェック
#~   #--------------------------------------------------------------------------
#~   alias _cao_sp_skill_conditions_met? skill_conditions_met?
#~   def skill_conditions_met?(skill)
#~     return false unless _cao_sp_skill_conditions_met?(skill)
#~     return false unless ([0] + added_skill_types).include?(skill.stype_id)
#~     return true
#~   end
#~ end
class Game_Actor        # アクターのみに適用
  #--------------------------------------------------------------------------
  # ● スキルの使用可能条件チェック
  #--------------------------------------------------------------------------
  def skill_conditions_met?(skill)
    return false unless super
    return false unless ([0] + added_skill_types).include?(skill.stype_id)
    return true
  end
end

# 13
class Game_Action
  #--------------------------------------------------------------------------
  # ● 防御判定
  #--------------------------------------------------------------------------
  def guard?
    return item == $data_skills[subject.guard_skill_id]
  end
  #--------------------------------------------------------------------------
  # ○ スキル／アイテムの評価
  #--------------------------------------------------------------------------
  alias _cao_sp_evaluate_item evaluate_item
  def evaluate_item
    if guard?
      @value = 0.01
    else
      _cao_sp_evaluate_item
    end
  end
end
class Game_Actor
  #--------------------------------------------------------------------------
  # ○ 自動戦闘用の行動候補リストを作成
  #--------------------------------------------------------------------------
  def make_action_list
    list = []
    list.push(Game_Action.new(self).set_attack.evaluate)
    list.push(Game_Action.new(self).set_guard.evaluate)
    usable_skills.each do |skill|
      list.push(Game_Action.new(self).set_skill(skill.id).evaluate)
    end
    list
  end
end

# 14
class Scene_Base
  #--------------------------------------------------------------------------
  # ○ 全ウィンドウの更新
  #--------------------------------------------------------------------------
  def update_all_windows
    instance_variables.each do |varname|
      ivar = instance_variable_get(varname)
      ivar.update if ivar.is_a?(Window) && !ivar.disposed?
    end
  end
end

# 15
class Game_Interpreter
  #--------------------------------------------------------------------------
  # ○ [**] の場合
  #--------------------------------------------------------------------------
  def command_402
    if @branch[@indent] == @params[0]
      @branch.delete(@indent)
    else
      command_skip
    end
  end
  #--------------------------------------------------------------------------
  # ○ キャンセルの場合
  #--------------------------------------------------------------------------
  def command_403
    if @branch[@indent] == 4
      @branch.delete(@indent)
    else
      command_skip
    end
  end
end

# 16
class Game_Player
  #--------------------------------------------------------------------------
  # ● ジャンプ
  #     x_plus : X 座標加算値
  #     y_plus : Y 座標加算値
  #--------------------------------------------------------------------------
  def jump(x_plus, y_plus)
    @followers.reserve_jump(x, y, x_plus, y_plus)
    super
  end
  #--------------------------------------------------------------------------
  # ● ジャンプの予約数
  #--------------------------------------------------------------------------
  def reserved_jump_count
    0
  end
end
class Game_Follower
  #--------------------------------------------------------------------------
  # ● ジャンプの予約
  #--------------------------------------------------------------------------
  def reserve_jump(x, y, x_plus, y_plus)
    @jump_route = (@jump_route || []) << [x, y, x_plus, y_plus]
  end
  #--------------------------------------------------------------------------
  # ● ジャンプの予約数
  #--------------------------------------------------------------------------
  def reserved_jump_count
    return @jump_route ? @jump_route.size : 0
  end
  #--------------------------------------------------------------------------
  # ● ジャンプポイントか判定
  #--------------------------------------------------------------------------
  def jump_point?
    return false if @jump_route == nil
    return false if @jump_route.empty?
    return false if @jump_route.first[0] != @x
    return false if @jump_route.first[1] != @y
    return true
  end
  #--------------------------------------------------------------------------
  # ○ 先導キャラクターを追う
  #--------------------------------------------------------------------------
  def chase_preceding_character
    return unless stopping?
    if jump_point?
      jump(@jump_route.first[2], @jump_route.first[3])
      @jump_route.shift
    else
      if @preceding_character.reserved_jump_count < self.reserved_jump_count
        sx = distance_x_from(@jump_route.first[0])
        sy = distance_y_from(@jump_route.first[1])
      else
        sx = distance_x_from(@preceding_character.x)
        sy = distance_y_from(@preceding_character.y)
      end
      if sx != 0 && sy != 0
        move_diagonal(sx > 0 ? 4 : 6, sy > 0 ? 8 : 2)
      elsif sx != 0
        move_straight(sx > 0 ? 4 : 6)
      elsif sy != 0
        move_straight(sy > 0 ? 8 : 2)
      end
     end
  end
end
class Game_Followers
  #--------------------------------------------------------------------------
  # ● ジャンプの予約
  #--------------------------------------------------------------------------
  def reserve_jump(x, y, x_plus, y_plus)
    move
    @data.each_with_index do |follower,index|
      follower.reserve_jump(x, y, x_plus, y_plus)
    end
  end
end

# 17
class Sprite
  #--------------------------------------------------------------------------
  # ○ 回転角度の設定
  #--------------------------------------------------------------------------
  alias _cao_sp_angle= angle= unless $CAO_SP
  def angle=(value)
    self._cao_sp_angle = value % 360
  end
end

# 18
class Sprite_Picture
  #--------------------------------------------------------------------------
  # ○ 解放
  #--------------------------------------------------------------------------
  alias _cao_sp_dispose dispose
  def dispose
    if @picture.name.empty?
      screen = ($game_party.in_battle ? $game_troop : $game_map).screen
      pictures = screen.instance_variable_get(:@pictures)
      pictures.instance_variable_get(:@data)[@picture.number] = nil
    end
    _cao_sp_dispose
  end
end

# 19
class Window_Base
  #--------------------------------------------------------------------------
  # ◎ 制御文字の本体を破壊的に取得    ※ 戻り値を変更 ※
  #--------------------------------------------------------------------------
  def obtain_escape_code(text)
    text.slice!(/^[\$\.\|\^!><\{\}\\]|^[A-Z]+/i) || ""
  end
end

# 20
class Window_Base
  #--------------------------------------------------------------------------
  # ● 制御文字を破壊的に削除
  #--------------------------------------------------------------------------
  def delete_special_characters(text)
    text.gsub!(/\e[\$\.\|\^!><\{\}\\]/i, "")
    text.gsub!(/\e[A-Z](?:\[.*?\])?/i, "")
    text.delete!("\e")
  end
end
class Window_ChoiceList
  #--------------------------------------------------------------------------
  # ○ 選択肢の最大幅を取得
  #--------------------------------------------------------------------------
  def max_choice_width
    $game_message.choices.collect do |text|
      text = convert_escape_characters(text)
      width = text.scan(/\eI\[\d+\]/i).size * 24
      delete_special_characters(text)
      width += text_size(text).width
    end.max
  end
end

# 21
class Game_Interpreter
  #--------------------------------------------------------------------------
  # ○ 敵キャラの HP 増減
  #--------------------------------------------------------------------------
  def command_331
    value = operate_value(@params[1], @params[2], @params[3])
    iterate_enemy_index(@params[0]) do |enemy|
      next if enemy.dead?
      enemy.change_hp(value, @params[4])
      enemy.perform_collapse_effect if enemy.dead?
    end
  end
end


# CAO_SP 導入フラグ
$CAO_SP = true
