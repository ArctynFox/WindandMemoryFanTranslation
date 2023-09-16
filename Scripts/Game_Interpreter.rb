#==============================================================================
# ■ Game_Interpreter
#------------------------------------------------------------------------------
# 　イベントコマンドを実行するインタプリタです。このクラスは Game_Map クラス、
# Game_Troop クラス、Game_Event クラスの内部で使用されます。
#==============================================================================

class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :map_id             # マップ ID
  attr_reader   :event_id           # イベント ID（通常イベントのみ）
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     depth : ネストの深さ
  #--------------------------------------------------------------------------
  def initialize(depth = 0)
    @depth = depth
    check_overflow
    clear
  end
  #--------------------------------------------------------------------------
  # ● オーバーフローのチェック
  #    通常の使用で深さが 100 以上になることはない。再帰的なイベント呼び出し
  #    による無限ループの可能性が高いので、100 で打ち切ってエラーにする。
  #--------------------------------------------------------------------------
  def check_overflow
    if @depth >= 100
      msgbox(Vocab::EventOverflow)
      exit
    end
  end
  #--------------------------------------------------------------------------
  # ● クリア
  #--------------------------------------------------------------------------
  def clear
    @map_id = 0
    @event_id = 0
    @list = nil                       # 実行内容
    @index = 0                        # インデックス
    @branch = {}                      # 分岐データ
    @fiber = nil                      # ファイバー
  end
  #--------------------------------------------------------------------------
  # ● イベントのセットアップ
  #--------------------------------------------------------------------------
  def setup(list, event_id = 0)
    clear
    @map_id = $game_map.map_id
    @event_id = event_id
    @list = list
    create_fiber
  end
  #--------------------------------------------------------------------------
  # ● ファイバーの作成
  #--------------------------------------------------------------------------
  def create_fiber
    @fiber = Fiber.new { run } if @list
  end
  #--------------------------------------------------------------------------
  # ● オブジェクトのダンプ
  #    ファイバーは Marshal に対応していないため自前で定義する。
  #    イベントの実行位置は一つ進めて保存する。
  #--------------------------------------------------------------------------
  def marshal_dump
    [@depth, @map_id, @event_id, @list, @index + 1, @branch]
  end
  #--------------------------------------------------------------------------
  # ● オブジェクトのロード
  #     obj : marshal_dump でダンプされたオブジェクト（配列）
  #    多重代入でデータを復帰し、必要ならファイバーを再作成する。
  #--------------------------------------------------------------------------
  def marshal_load(obj)
    @depth, @map_id, @event_id, @list, @index, @branch = obj
    create_fiber
  end
  #--------------------------------------------------------------------------
  # ● イベント起動時のマップと同じか判定
  #--------------------------------------------------------------------------
  def same_map?
    @map_id == $game_map.map_id
  end
  #--------------------------------------------------------------------------
  # ● 呼び出し予約されたコモンイベントを検出／セットアップ
  #--------------------------------------------------------------------------
  def setup_reserved_common_event
    if $game_temp.common_event_reserved?
      setup($game_temp.reserved_common_event.list)
      $game_temp.clear_common_event
      true
    else
      false
    end
  end
  #--------------------------------------------------------------------------
  # ● 実行
  #--------------------------------------------------------------------------
  def run
    wait_for_message
    while @list[@index] do
      execute_command
      @index += 1
    end
    Fiber.yield
    @fiber = nil
  end
  #--------------------------------------------------------------------------
  # ● 実行中判定
  #--------------------------------------------------------------------------
  def running?
    @fiber != nil
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    @fiber.resume if @fiber
  end
  #--------------------------------------------------------------------------
  # ● アクター用イテレータ（ID）
  #     param : 1 以上なら ID、0 なら全体
  #--------------------------------------------------------------------------
  def iterate_actor_id(param)
    if param == 0
      $game_party.members.each {|actor| yield actor }
    else
      actor = $game_actors[param]
      yield actor if actor
    end
  end
  #--------------------------------------------------------------------------
  # ● アクター用イテレータ（可変）
  #     param1 : 0 なら固定、1 なら変数で指定
  #     param2 : アクターまたは変数 ID
  #--------------------------------------------------------------------------
  def iterate_actor_var(param1, param2)
    if param1 == 0
      iterate_actor_id(param2) {|actor| yield actor }
    else
      iterate_actor_id($game_variables[param2]) {|actor| yield actor }
    end
  end
  #--------------------------------------------------------------------------
  # ● アクター用イテレータ（インデックス）
  #     param : 0 以上ならインデックス、-1 なら全体
  #--------------------------------------------------------------------------
  def iterate_actor_index(param)
    if param < 0
      $game_party.members.each {|actor| yield actor }
    else
      actor = $game_party.members[param]
      yield actor if actor
    end
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラ用イテレータ（インデックス）
  #     param : 0 以上ならインデックス、-1 なら全体
  #--------------------------------------------------------------------------
  def iterate_enemy_index(param)
    if param < 0
      $game_troop.members.each {|enemy| yield enemy }
    else
      enemy = $game_troop.members[param]
      yield enemy if enemy
    end
  end
  #--------------------------------------------------------------------------
  # ● バトラー用イテレータ（敵グループ全体、パーティ全体を考慮）
  #     param1 : 0 なら敵キャラ、1 ならアクター
  #     param2 : 敵キャラならインデックス、アクターなら ID
  #--------------------------------------------------------------------------
  def iterate_battler(param1, param2)
    if $game_party.in_battle
      if param1 == 0
        iterate_enemy_index(param2) {|enemy| yield enemy }
      else
        iterate_actor_id(param2) {|actor| yield actor }
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 画面系コマンドの対象を取得
  #--------------------------------------------------------------------------
  def screen
    $game_party.in_battle ? $game_troop.screen : $game_map.screen
  end
  #--------------------------------------------------------------------------
  # ● イベントコマンドの実行
  #--------------------------------------------------------------------------
  def execute_command
    command = @list[@index]
    @params = command.parameters
    @indent = command.indent
    method_name = "command_#{command.code}"
    send(method_name) if respond_to?(method_name)
  end
  #--------------------------------------------------------------------------
  # ● コマンドスキップ
  #    現在のインデントより深いコマンドを飛ばしてインデックスを進める。
  #--------------------------------------------------------------------------
  def command_skip
    @index += 1 while @list[@index + 1].indent > @indent
  end
  #--------------------------------------------------------------------------
  # ● 次のイベントコマンドのコードを取得
  #--------------------------------------------------------------------------
  def next_event_code
    @list[@index + 1].code
  end
  #--------------------------------------------------------------------------
  # ● キャラクターの取得
  #     param : -1 ならプレイヤー、0 ならこのイベント、それ以外はイベント ID
  #--------------------------------------------------------------------------
  def get_character(param)
    if $game_party.in_battle
      nil
    elsif param < 0
      $game_player
    else
      events = same_map? ? $game_map.events : {}
      events[param > 0 ? param : @event_id]
    end
  end
  #--------------------------------------------------------------------------
  # ● 操作する値の計算
  #     operation    : 操作（0:増やす 1:減らす）
  #     operand_type : オペランドタイプ（0:定数 1:変数）
  #     operand      : オペランド（数値または変数 ID）
  #--------------------------------------------------------------------------
  def operate_value(operation, operand_type, operand)
    value = operand_type == 0 ? operand : $game_variables[operand]
    operation == 0 ? value : -value
  end
  #--------------------------------------------------------------------------
  # ● ウェイト
  #--------------------------------------------------------------------------
  def wait(duration)
    duration.times { Fiber.yield }
  end
  #--------------------------------------------------------------------------
  # ● メッセージ表示がビジー状態の間ウェイト
  #--------------------------------------------------------------------------
  def wait_for_message
    Fiber.yield while $game_message.busy?
  end
  #--------------------------------------------------------------------------
  # ● 文章の表示
  #--------------------------------------------------------------------------
  def command_101
    wait_for_message
    $game_message.face_name = @params[0]
    $game_message.face_index = @params[1]
    $game_message.background = @params[2]
    $game_message.position = @params[3]
    while next_event_code == 401       # 文章データ
      @index += 1
      $game_message.add(@list[@index].parameters[0])
    end
    case next_event_code
    when 102  # 選択肢の表示
      @index += 1
      setup_choices(@list[@index].parameters)
    when 103  # 数値入力の処理
      @index += 1
      setup_num_input(@list[@index].parameters)
    when 104  # アイテム選択の処理
      @index += 1
      setup_item_choice(@list[@index].parameters)
    end
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # ● 選択肢の表示
  #--------------------------------------------------------------------------
  def command_102
    wait_for_message
    setup_choices(@params)
    Fiber.yield while $game_message.choice?
  end
  #--------------------------------------------------------------------------
  # ● 選択肢のセットアップ
  #--------------------------------------------------------------------------
  def setup_choices(params)
    params[0].each {|s| $game_message.choices.push(s) }
    $game_message.choice_cancel_type = params[1]
    $game_message.choice_proc = Proc.new {|n| @branch[@indent] = n }
  end
  #--------------------------------------------------------------------------
  # ● [**] の場合
  #--------------------------------------------------------------------------
  def command_402
    command_skip if @branch[@indent] != @params[0]
  end
  #--------------------------------------------------------------------------
  # ● キャンセルの場合
  #--------------------------------------------------------------------------
  def command_403
    command_skip if @branch[@indent] != 4
  end
  #--------------------------------------------------------------------------
  # ● 数値入力の処理
  #--------------------------------------------------------------------------
  def command_103
    wait_for_message
    setup_num_input(@params)
    Fiber.yield while $game_message.num_input?
  end
  #--------------------------------------------------------------------------
  # ● 数値入力のセットアップ
  #--------------------------------------------------------------------------
  def setup_num_input(params)
    $game_message.num_input_variable_id = params[0]
    $game_message.num_input_digits_max = params[1]
  end
  #--------------------------------------------------------------------------
  # ● アイテム選択の処理
  #--------------------------------------------------------------------------
  def command_104
    wait_for_message
    setup_item_choice(@params)
    Fiber.yield while $game_message.item_choice?
  end
  #--------------------------------------------------------------------------
  # ● アイテム選択のセットアップ
  #--------------------------------------------------------------------------
  def setup_item_choice(params)
    $game_message.item_choice_variable_id = params[0]
  end
  #--------------------------------------------------------------------------
  # ● スクロール文章の表示
  #--------------------------------------------------------------------------
  def command_105
    Fiber.yield while $game_message.visible
    $game_message.scroll_mode = true
    $game_message.scroll_speed = @params[0]
    $game_message.scroll_no_fast = @params[1]
    while next_event_code == 405
      @index += 1
      $game_message.add(@list[@index].parameters[0])
    end
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # ● 注釈
  #--------------------------------------------------------------------------
  def command_108
    @comments = [@params[0]]
    while next_event_code == 408
      @index += 1
      @comments.push(@list[@index].parameters[0])
    end
  end
  #--------------------------------------------------------------------------
  # ● 条件分岐
  #--------------------------------------------------------------------------
  def command_111
    result = false
    case @params[0]
    when 0  # スイッチ
      result = ($game_switches[@params[1]] == (@params[2] == 0))
    when 1  # 変数
      value1 = $game_variables[@params[1]]
      if @params[2] == 0
        value2 = @params[3]
      else
        value2 = $game_variables[@params[3]]
      end
      case @params[4]
      when 0  # と同値
        result = (value1 == value2)
      when 1  # 以上
        result = (value1 >= value2)
      when 2  # 以下
        result = (value1 <= value2)
      when 3  # 超
        result = (value1 > value2)
      when 4  # 未満
        result = (value1 < value2)
      when 5  # 以外
        result = (value1 != value2)
      end
    when 2  # セルフスイッチ
      if @event_id > 0
        key = [@map_id, @event_id, @params[1]]
        result = ($game_self_switches[key] == (@params[2] == 0))
      end
    when 3  # タイマー
      if $game_timer.working?
        if @params[2] == 0
          result = ($game_timer.sec >= @params[1])
        else
          result = ($game_timer.sec <= @params[1])
        end
      end
    when 4  # アクター
      actor = $game_actors[@params[1]]
      if actor
        case @params[2]
        when 0  # パーティにいる
          result = ($game_party.members.include?(actor))
        when 1  # 名前
          result = (actor.name == @params[3])
        when 2  # 職業
          result = (actor.class_id == @params[3])
        when 3  # スキル
          result = (actor.skill_learn?($data_skills[@params[3]]))
        when 4  # 武器
          result = (actor.weapons.include?($data_weapons[@params[3]]))
        when 5  # 防具
          result = (actor.armors.include?($data_armors[@params[3]]))
        when 6  # ステート
          result = (actor.state?(@params[3]))
        end
      end
    when 5  # 敵キャラ
      enemy = $game_troop.members[@params[1]]
      if enemy
        case @params[2]
        when 0  # 出現している
          result = (enemy.alive?)
        when 1  # ステート
          result = (enemy.state?(@params[3]))
        end
      end
    when 6  # キャラクター
      character = get_character(@params[1])
      if character
        result = (character.direction == @params[2])
      end
    when 7  # ゴールド
      case @params[2]
      when 0  # 以上
        result = ($game_party.gold >= @params[1])
      when 1  # 以下
        result = ($game_party.gold <= @params[1])
      when 2  # 未満
        result = ($game_party.gold < @params[1])
      end
    when 8  # アイテム
      result = $game_party.has_item?($data_items[@params[1]])
    when 9  # 武器
      result = $game_party.has_item?($data_weapons[@params[1]], @params[2])
    when 10  # 防具
      result = $game_party.has_item?($data_armors[@params[1]], @params[2])
    when 11  # ボタン
      result = Input.press?(@params[1])
    when 12  # スクリプト
      result = eval(@params[1])
    when 13  # 乗り物
      result = ($game_player.vehicle == $game_map.vehicles[@params[1]])
    end
    @branch[@indent] = result
    command_skip if !@branch[@indent]
  end
  #--------------------------------------------------------------------------
  # ● それ以外の場合
  #--------------------------------------------------------------------------
  def command_411
    command_skip if @branch[@indent]
  end
  #--------------------------------------------------------------------------
  # ● ループ
  #--------------------------------------------------------------------------
  def command_112
  end
  #--------------------------------------------------------------------------
  # ● 以上繰り返し
  #--------------------------------------------------------------------------
  def command_413
    begin
      @index -= 1
    end until @list[@index].indent == @indent
  end
  #--------------------------------------------------------------------------
  # ● ループの中断
  #--------------------------------------------------------------------------
  def command_113
    loop do
      @index += 1
      return if @index >= @list.size - 1
      return if @list[@index].code == 413 && @list[@index].indent < @indent
    end
  end
  #--------------------------------------------------------------------------
  # ● イベント処理の中断
  #--------------------------------------------------------------------------
  def command_115
    @index = @list.size
  end
  #--------------------------------------------------------------------------
  # ● コモンイベント
  #--------------------------------------------------------------------------
  def command_117
    common_event = $data_common_events[@params[0]]
    if common_event
      child = Game_Interpreter.new(@depth + 1)
      child.setup(common_event.list, same_map? ? @event_id : 0)
      child.run
    end
  end
  #--------------------------------------------------------------------------
  # ● ラベル
  #--------------------------------------------------------------------------
  def command_118
  end
  #--------------------------------------------------------------------------
  # ● ラベルジャンプ
  #--------------------------------------------------------------------------
  def command_119
    label_name = @params[0]
    @list.size.times do |i|
      if @list[i].code == 118 && @list[i].parameters[0] == label_name
        @index = i
        return
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● スイッチの操作
  #--------------------------------------------------------------------------
  def command_121
    (@params[0]..@params[1]).each do |i|
      $game_switches[i] = (@params[2] == 0)
    end
  end
  #--------------------------------------------------------------------------
  # ● 変数の操作
  #--------------------------------------------------------------------------
  def command_122
    value = 0
    case @params[3]  # オペランド
    when 0  # 定数
      value = @params[4]
    when 1  # 変数
      value = $game_variables[@params[4]]
    when 2  # 乱数
      value = @params[4] + rand(@params[5] - @params[4] + 1)
    when 3  # ゲームデータ
      value = game_data_operand(@params[4], @params[5], @params[6])
    when 4  # スクリプト
      value = eval(@params[4])
    end
    (@params[0]..@params[1]).each do |i|
      operate_variable(i, @params[2], value)
    end
  end
  #--------------------------------------------------------------------------
  # ● 変数オペランド用ゲームデータの取得
  #--------------------------------------------------------------------------
  def game_data_operand(type, param1, param2)
    case type
    when 0  # アイテム
      return $game_party.item_number($data_items[param1])
    when 1  # 武器
      return $game_party.item_number($data_weapons[param1])
    when 2  # 防具
      return $game_party.item_number($data_armors[param1])
    when 3  # アクター
      actor = $game_actors[param1]
      if actor
        case param2
        when 0      # レベル
          return actor.level
        when 1      # 経験値
          return actor.exp
        when 2      # HP
          return actor.hp
        when 3      # MP
          return actor.mp
        when 4..11  # 通常能力値
          return actor.param(param2 - 4)
        end
      end
    when 4  # 敵キャラ
      enemy = $game_troop.members[param1]
      if enemy
        case param2
        when 0      # HP
          return enemy.hp
        when 1      # MP
          return enemy.mp
        when 2..9   # 通常能力値
          return enemy.param(param2 - 2)
        end
      end
    when 5  # キャラクター
      character = get_character(param1)
      if character
        case param2
        when 0  # X 座標
          return character.x
        when 1  # Y 座標
          return character.y
        when 2  # 向き
          return character.direction
        when 3  # 画面 X 座標
          return character.screen_x
        when 4  # 画面 Y 座標
          return character.screen_y
        end
      end
    when 6  # パーティ
      actor = $game_party.members[param1]
      return actor ? actor.id : 0
    when 7  # その他
      case param1
      when 0  # マップ ID
        return $game_map.map_id
      when 1  # パーティ人数
        return $game_party.members.size
      when 2  # ゴールド
        return $game_party.gold
      when 3  # 歩数
        return $game_party.steps
      when 4  # プレイ時間
        return Graphics.frame_count / Graphics.frame_rate
      when 5  # タイマー
        return $game_timer.sec
      when 6  # セーブ回数
        return $game_system.save_count
      when 7  # 戦闘回数
        return $game_system.battle_count
      end
    end
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 変数の操作を実行
  #--------------------------------------------------------------------------
  def operate_variable(variable_id, operation_type, value)
    begin
      case operation_type
      when 0  # 代入
        $game_variables[variable_id] = value
      when 1  # 加算
        $game_variables[variable_id] += value
      when 2  # 減算
        $game_variables[variable_id] -= value
      when 3  # 乗算
        $game_variables[variable_id] *= value
      when 4  # 除算
        $game_variables[variable_id] /= value
      when 5  # 剰余
        $game_variables[variable_id] %= value
      end
    rescue
      $game_variables[variable_id] = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● セルフスイッチの操作
  #--------------------------------------------------------------------------
  def command_123
    if @event_id > 0
      key = [@map_id, @event_id, @params[0]]
      $game_self_switches[key] = (@params[1] == 0)
    end
  end
  #--------------------------------------------------------------------------
  # ● タイマーの操作
  #--------------------------------------------------------------------------
  def command_124
    if @params[0] == 0  # 始動
      $game_timer.start(@params[1] * Graphics.frame_rate)
    else                # 停止
      $game_timer.stop
    end
  end
  #--------------------------------------------------------------------------
  # ● 所持金の増減
  #--------------------------------------------------------------------------
  def command_125
    value = operate_value(@params[0], @params[1], @params[2])
    $game_party.gain_gold(value)
  end
  #--------------------------------------------------------------------------
  # ● アイテムの増減
  #--------------------------------------------------------------------------
  def command_126
    value = operate_value(@params[1], @params[2], @params[3])
    $game_party.gain_item($data_items[@params[0]], value)
  end
  #--------------------------------------------------------------------------
  # ● 武器の増減
  #--------------------------------------------------------------------------
  def command_127
    value = operate_value(@params[1], @params[2], @params[3])
    $game_party.gain_item($data_weapons[@params[0]], value, @params[4])
  end
  #--------------------------------------------------------------------------
  # ● 防具の増減
  #--------------------------------------------------------------------------
  def command_128
    value = operate_value(@params[1], @params[2], @params[3])
    $game_party.gain_item($data_armors[@params[0]], value, @params[4])
  end
  #--------------------------------------------------------------------------
  # ● メンバーの入れ替え
  #--------------------------------------------------------------------------
  def command_129
    actor = $game_actors[@params[0]]
    if actor
      if @params[1] == 0    # 加える
        if @params[2] == 1  # 初期化
          $game_actors[@params[0]].setup(@params[0])
        end
        $game_party.add_actor(@params[0])
      else                  # 外す
        $game_party.remove_actor(@params[0])
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘 BGM の変更
  #--------------------------------------------------------------------------
  def command_132
    $game_system.battle_bgm = @params[0]
  end
  #--------------------------------------------------------------------------
  # ● 戦闘終了 ME の変更
  #--------------------------------------------------------------------------
  def command_133
    $game_system.battle_end_me = @params[0]
  end
  #--------------------------------------------------------------------------
  # ● セーブ禁止の変更
  #--------------------------------------------------------------------------
  def command_134
    $game_system.save_disabled = (@params[0] == 0)
  end
  #--------------------------------------------------------------------------
  # ● メニュー禁止の変更
  #--------------------------------------------------------------------------
  def command_135
    $game_system.menu_disabled = (@params[0] == 0)
  end
  #--------------------------------------------------------------------------
  # ● エンカウント禁止の変更
  #--------------------------------------------------------------------------
  def command_136
    $game_system.encounter_disabled = (@params[0] == 0)
    $game_player.make_encounter_count
  end
  #--------------------------------------------------------------------------
  # ● 並び替え禁止の変更
  #--------------------------------------------------------------------------
  def command_137
    $game_system.formation_disabled = (@params[0] == 0)
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウカラーの変更
  #--------------------------------------------------------------------------
  def command_138
    $game_system.window_tone = @params[0]
  end
  #--------------------------------------------------------------------------
  # ● 場所移動
  #--------------------------------------------------------------------------
  def command_201
    return if $game_party.in_battle
    Fiber.yield while $game_player.transfer? || $game_message.visible
    if @params[0] == 0                      # 直接指定
      map_id = @params[1]
      x = @params[2]
      y = @params[3]
    else                                    # 変数で指定
      map_id = $game_variables[@params[1]]
      x = $game_variables[@params[2]]
      y = $game_variables[@params[3]]
    end
    $game_player.reserve_transfer(map_id, x, y, @params[4])
    $game_temp.fade_type = @params[5]
    Fiber.yield while $game_player.transfer?
  end
  #--------------------------------------------------------------------------
  # ● 乗り物の位置設定
  #--------------------------------------------------------------------------
  def command_202
    if @params[1] == 0                      # 直接指定
      map_id = @params[2]
      x = @params[3]
      y = @params[4]
    else                                    # 変数で指定
      map_id = $game_variables[@params[2]]
      x = $game_variables[@params[3]]
      y = $game_variables[@params[4]]
    end
    vehicle = $game_map.vehicles[@params[0]]
    vehicle.set_location(map_id, x, y) if vehicle
  end
  #--------------------------------------------------------------------------
  # ● イベントの位置設定
  #--------------------------------------------------------------------------
  def command_203
    character = get_character(@params[0])
    if character
      if @params[1] == 0                      # 直接指定
        character.moveto(@params[2], @params[3])
      elsif @params[1] == 1                   # 変数で指定
        new_x = $game_variables[@params[2]]
        new_y = $game_variables[@params[3]]
        character.moveto(new_x, new_y)
      else                                    # 他のイベントと交換
        character2 = get_character(@params[2])
        character.swap(character2) if character2
      end
      character.set_direction(@params[4]) if @params[4] > 0
    end
  end
  #--------------------------------------------------------------------------
  # ● マップのスクロール
  #--------------------------------------------------------------------------
  def command_204
    return if $game_party.in_battle
    Fiber.yield while $game_map.scrolling?
    $game_map.start_scroll(@params[0], @params[1], @params[2])
  end
  #--------------------------------------------------------------------------
  # ● 移動ルートの設定
  #--------------------------------------------------------------------------
  def command_205
    $game_map.refresh if $game_map.need_refresh
    character = get_character(@params[0])
    if character
      character.force_move_route(@params[1])
      Fiber.yield while character.move_route_forcing if @params[1].wait
    end
  end
  #--------------------------------------------------------------------------
  # ● 乗り物の乗降
  #--------------------------------------------------------------------------
  def command_206
    $game_player.get_on_off_vehicle
  end
  #--------------------------------------------------------------------------
  # ● 透明状態の変更
  #--------------------------------------------------------------------------
  def command_211
    $game_player.transparent = (@params[0] == 0)
  end
  #--------------------------------------------------------------------------
  # ● アニメーションの表示
  #--------------------------------------------------------------------------
  def command_212
    character = get_character(@params[0])
    if character
      character.animation_id = @params[1]
      Fiber.yield while character.animation_id > 0 if @params[2]
    end
  end
  #--------------------------------------------------------------------------
  # ● フキダシアイコンの表示
  #--------------------------------------------------------------------------
  def command_213
    character = get_character(@params[0])
    if character
      character.balloon_id = @params[1]
      Fiber.yield while character.balloon_id > 0 if @params[2]
    end
  end
  #--------------------------------------------------------------------------
  # ● イベントの一時消去
  #--------------------------------------------------------------------------
  def command_214
    $game_map.events[@event_id].erase if same_map? && @event_id > 0
  end
  #--------------------------------------------------------------------------
  # ● 隊列歩行の変更
  #--------------------------------------------------------------------------
  def command_216
    $game_player.followers.visible = (@params[0] == 0)
    $game_player.refresh
  end
  #--------------------------------------------------------------------------
  # ● 隊列メンバーの集合
  #--------------------------------------------------------------------------
  def command_217
    return if $game_party.in_battle
    $game_player.followers.gather
    Fiber.yield until $game_player.followers.gather?
  end
  #--------------------------------------------------------------------------
  # ● 画面のフェードアウト
  #--------------------------------------------------------------------------
  def command_221
    Fiber.yield while $game_message.visible
    screen.start_fadeout(30)
    wait(30)
  end
  #--------------------------------------------------------------------------
  # ● 画面のフェードイン
  #--------------------------------------------------------------------------
  def command_222
    Fiber.yield while $game_message.visible
    screen.start_fadein(30)
    wait(30)
  end
  #--------------------------------------------------------------------------
  # ● 画面の色調変更
  #--------------------------------------------------------------------------
  def command_223
    screen.start_tone_change(@params[0], @params[1])
    wait(@params[1]) if @params[2]
  end
  #--------------------------------------------------------------------------
  # ● 画面のフラッシュ
  #--------------------------------------------------------------------------
  def command_224
    screen.start_flash(@params[0], @params[1])
    wait(@params[1]) if @params[2]
  end
  #--------------------------------------------------------------------------
  # ● 画面のシェイク
  #--------------------------------------------------------------------------
  def command_225
    screen.start_shake(@params[0], @params[1], @params[2])
    wait(@params[1]) if @params[2]
  end
  #--------------------------------------------------------------------------
  # ● ウェイト
  #--------------------------------------------------------------------------
  def command_230
    wait(@params[0])
  end
  #--------------------------------------------------------------------------
  # ● ピクチャの表示
  #--------------------------------------------------------------------------
  def command_231
    if @params[3] == 0    # 直接指定
      x = @params[4]
      y = @params[5]
    else                  # 変数で指定
      x = $game_variables[@params[4]]
      y = $game_variables[@params[5]]
    end
    screen.pictures[@params[0]].show(@params[1], @params[2],
      x, y, @params[6], @params[7], @params[8], @params[9])
  end
  #--------------------------------------------------------------------------
  # ● ピクチャの移動
  #--------------------------------------------------------------------------
  def command_232
    if @params[3] == 0    # 直接指定
      x = @params[4]
      y = @params[5]
    else                  # 変数で指定
      x = $game_variables[@params[4]]
      y = $game_variables[@params[5]]
    end
    screen.pictures[@params[0]].move(@params[2], x, y, @params[6],
      @params[7], @params[8], @params[9], @params[10])
    wait(@params[10]) if @params[11]
  end
  #--------------------------------------------------------------------------
  # ● ピクチャの回転
  #--------------------------------------------------------------------------
  def command_233
    screen.pictures[@params[0]].rotate(@params[1])
  end
  #--------------------------------------------------------------------------
  # ● ピクチャの色調変更
  #--------------------------------------------------------------------------
  def command_234
    screen.pictures[@params[0]].start_tone_change(@params[1], @params[2])
    wait(@params[2]) if @params[3]
  end
  #--------------------------------------------------------------------------
  # ● ピクチャの消去
  #--------------------------------------------------------------------------
  def command_235
    screen.pictures[@params[0]].erase
  end
  #--------------------------------------------------------------------------
  # ● 天候の設定
  #--------------------------------------------------------------------------
  def command_236
    return if $game_party.in_battle
    screen.change_weather(@params[0], @params[1], @params[2])
    wait(@params[2]) if @params[3]
  end
  #--------------------------------------------------------------------------
  # ● BGM の演奏
  #--------------------------------------------------------------------------
  def command_241
    @params[0].play
  end
  #--------------------------------------------------------------------------
  # ● BGM のフェードアウト
  #--------------------------------------------------------------------------
  def command_242
    RPG::BGM.fade(@params[0] * 1000)
  end
  #--------------------------------------------------------------------------
  # ● BGM の保存
  #--------------------------------------------------------------------------
  def command_243
    $game_system.save_bgm
  end
  #--------------------------------------------------------------------------
  # ● BGM の再開
  #--------------------------------------------------------------------------
  def command_244
    $game_system.replay_bgm
  end
  #--------------------------------------------------------------------------
  # ● BGS の演奏
  #--------------------------------------------------------------------------
  def command_245
    @params[0].play
  end
  #--------------------------------------------------------------------------
  # ● BGS のフェードアウト
  #--------------------------------------------------------------------------
  def command_246
    RPG::BGS.fade(@params[0] * 1000)
  end
  #--------------------------------------------------------------------------
  # ● ME の演奏
  #--------------------------------------------------------------------------
  def command_249
    @params[0].play
  end
  #--------------------------------------------------------------------------
  # ● SE の演奏
  #--------------------------------------------------------------------------
  def command_250
    @params[0].play
  end
  #--------------------------------------------------------------------------
  # ● SE の停止
  #--------------------------------------------------------------------------
  def command_251
    RPG::SE.stop
  end
  #--------------------------------------------------------------------------
  # ● ムービーの再生
  #--------------------------------------------------------------------------
  def command_261
    Fiber.yield while $game_message.visible
    Fiber.yield
    name = @params[0]
    Graphics.play_movie('Movies/' + name) unless name.empty?
  end
  #--------------------------------------------------------------------------
  # ● マップ名表示の変更
  #--------------------------------------------------------------------------
  def command_281
    $game_map.name_display = (@params[0] == 0)
  end
  #--------------------------------------------------------------------------
  # ● タイルセットの変更
  #--------------------------------------------------------------------------
  def command_282
    $game_map.change_tileset(@params[0])
  end
  #--------------------------------------------------------------------------
  # ● 戦闘背景の変更
  #--------------------------------------------------------------------------
  def command_283
    $game_map.change_battleback(@params[0], @params[1])
  end
  #--------------------------------------------------------------------------
  # ● 遠景の変更
  #--------------------------------------------------------------------------
  def command_284
    $game_map.change_parallax(@params[0], @params[1], @params[2],
                              @params[3], @params[4])
  end
  #--------------------------------------------------------------------------
  # ● 指定位置の情報取得
  #--------------------------------------------------------------------------
  def command_285
    if @params[2] == 0      # 直接指定
      x = @params[3]
      y = @params[4]
    else                    # 変数で指定
      x = $game_variables[@params[3]]
      y = $game_variables[@params[4]]
    end
    case @params[1]
    when 0      # 地形タグ
      value = $game_map.terrain_tag(x, y)
    when 1      # イベント ID
      value = $game_map.event_id_xy(x, y)
    when 2..4   # タイル ID
      value = $game_map.tile_id(x, y, @params[1] - 2)
    else        # リージョン ID
      value = $game_map.region_id(x, y)
    end
    $game_variables[@params[0]] = value
  end
  #--------------------------------------------------------------------------
  # ● バトルの処理
  #--------------------------------------------------------------------------
  def command_301
    return if $game_party.in_battle
    if @params[0] == 0                      # 直接指定
      troop_id = @params[1]
    elsif @params[0] == 1                   # 変数で指定
      troop_id = $game_variables[@params[1]]
    else                                    # マップ指定の敵グループ
      troop_id = $game_player.make_encounter_troop_id
    end
    if $data_troops[troop_id]
      BattleManager.setup(troop_id, @params[2], @params[3])
      BattleManager.event_proc = Proc.new {|n| @branch[@indent] = n }
      $game_player.make_encounter_count
      SceneManager.call(Scene_Battle)
    end
    Fiber.yield
  end
  #--------------------------------------------------------------------------
  # ● 勝った場合
  #--------------------------------------------------------------------------
  def command_601
    command_skip if @branch[@indent] != 0
  end
  #--------------------------------------------------------------------------
  # ● 逃げた場合
  #--------------------------------------------------------------------------
  def command_602
    command_skip if @branch[@indent] != 1
  end
  #--------------------------------------------------------------------------
  # ● 負けた場合
  #--------------------------------------------------------------------------
  def command_603
    command_skip if @branch[@indent] != 2
  end
  #--------------------------------------------------------------------------
  # ● ショップの処理
  #--------------------------------------------------------------------------
  def command_302
    return if $game_party.in_battle
    goods = [@params]
    while next_event_code == 605
      @index += 1
      goods.push(@list[@index].parameters)
    end
    SceneManager.call(Scene_Shop)
    SceneManager.scene.prepare(goods, @params[4])
    Fiber.yield
  end
  #--------------------------------------------------------------------------
  # ● 名前入力の処理
  #--------------------------------------------------------------------------
  def command_303
    return if $game_party.in_battle
    if $data_actors[@params[0]]
      SceneManager.call(Scene_Name)
      SceneManager.scene.prepare(@params[0], @params[1])
      Fiber.yield
    end
  end
  #--------------------------------------------------------------------------
  # ● HP の増減
  #--------------------------------------------------------------------------
  def command_311
    value = operate_value(@params[2], @params[3], @params[4])
    iterate_actor_var(@params[0], @params[1]) do |actor|
      next if actor.dead?
      actor.change_hp(value, @params[5])
      actor.perform_collapse_effect if actor.dead?
    end
    SceneManager.goto(Scene_Gameover) if $game_party.all_dead?
  end
  #--------------------------------------------------------------------------
  # ● MP の増減
  #--------------------------------------------------------------------------
  def command_312
    value = operate_value(@params[2], @params[3], @params[4])
    iterate_actor_var(@params[0], @params[1]) do |actor|
      actor.mp += value
    end
  end
  #--------------------------------------------------------------------------
  # ● ステートの変更
  #--------------------------------------------------------------------------
  def command_313
    iterate_actor_var(@params[0], @params[1]) do |actor|
      already_dead = actor.dead?
      if @params[2] == 0
        actor.add_state(@params[3])
      else
        actor.remove_state(@params[3])
      end
      actor.perform_collapse_effect if actor.dead? && !already_dead
    end
  end
  #--------------------------------------------------------------------------
  # ● 全回復
  #--------------------------------------------------------------------------
  def command_314
    iterate_actor_var(@params[0], @params[1]) do |actor|
      actor.recover_all
    end
  end
  #--------------------------------------------------------------------------
  # ● 経験値の増減
  #--------------------------------------------------------------------------
  def command_315
    value = operate_value(@params[2], @params[3], @params[4])
    iterate_actor_var(@params[0], @params[1]) do |actor|
      actor.change_exp(actor.exp + value, @params[5])
    end
  end
  #--------------------------------------------------------------------------
  # ● レベルの増減
  #--------------------------------------------------------------------------
  def command_316
    value = operate_value(@params[2], @params[3], @params[4])
    iterate_actor_var(@params[0], @params[1]) do |actor|
      actor.change_level(actor.level + value, @params[5])
    end
  end
  #--------------------------------------------------------------------------
  # ● 能力値の増減
  #--------------------------------------------------------------------------
  def command_317
    value = operate_value(@params[3], @params[4], @params[5])
    iterate_actor_var(@params[0], @params[1]) do |actor|
      actor.add_param(@params[2], value)
    end
  end
  #--------------------------------------------------------------------------
  # ● スキルの増減
  #--------------------------------------------------------------------------
  def command_318
    iterate_actor_var(@params[0], @params[1]) do |actor|
      if @params[2] == 0
        actor.learn_skill(@params[3])
      else
        actor.forget_skill(@params[3])
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 装備の変更
  #--------------------------------------------------------------------------
  def command_319
    actor = $game_actors[@params[0]]
    actor.change_equip_by_id(@params[1], @params[2]) if actor
  end
  #--------------------------------------------------------------------------
  # ● 名前の変更
  #--------------------------------------------------------------------------
  def command_320
    actor = $game_actors[@params[0]]
    actor.name = @params[1] if actor
  end
  #--------------------------------------------------------------------------
  # ● 職業の変更
  #--------------------------------------------------------------------------
  def command_321
    actor = $game_actors[@params[0]]
    actor.change_class(@params[1]) if actor && $data_classes[@params[1]]
  end
  #--------------------------------------------------------------------------
  # ● アクターのグラフィック変更
  #--------------------------------------------------------------------------
  def command_322
    actor = $game_actors[@params[0]]
    if actor
      actor.set_graphic(@params[1], @params[2], @params[3], @params[4])
    end
    $game_player.refresh
  end
  #--------------------------------------------------------------------------
  # ● 乗り物のグラフィック変更
  #--------------------------------------------------------------------------
  def command_323
    vehicle = $game_map.vehicles[@params[0]]
    vehicle.set_graphic(@params[1], @params[2]) if vehicle
  end
  #--------------------------------------------------------------------------
  # ● 二つ名の変更
  #--------------------------------------------------------------------------
  def command_324
    actor = $game_actors[@params[0]]
    actor.nickname = @params[1] if actor
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラの HP 増減
  #--------------------------------------------------------------------------
  def command_331
    value = operate_value(@params[1], @params[2], @params[3])
    iterate_enemy_index(@params[0]) do |enemy|
      return if enemy.dead?
      enemy.change_hp(value, @params[4])
      enemy.perform_collapse_effect if enemy.dead?
    end
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラの MP 増減
  #--------------------------------------------------------------------------
  def command_332
    value = operate_value(@params[1], @params[2], @params[3])
    iterate_enemy_index(@params[0]) do |enemy|
      enemy.mp += value
    end
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラのステート変更
  #--------------------------------------------------------------------------
  def command_333
    iterate_enemy_index(@params[0]) do |enemy|
      already_dead = enemy.dead?
      if @params[1] == 0
        enemy.add_state(@params[2])
      else
        enemy.remove_state(@params[2])
      end
      enemy.perform_collapse_effect if enemy.dead? && !already_dead
    end
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラの全回復
  #--------------------------------------------------------------------------
  def command_334
    iterate_enemy_index(@params[0]) do |enemy|
      enemy.recover_all
    end
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラの出現
  #--------------------------------------------------------------------------
  def command_335
    iterate_enemy_index(@params[0]) do |enemy|
      enemy.appear
      $game_troop.make_unique_names
    end
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラの変身
  #--------------------------------------------------------------------------
  def command_336
    iterate_enemy_index(@params[0]) do |enemy|
      enemy.transform(@params[1])
      $game_troop.make_unique_names
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘アニメーションの表示
  #--------------------------------------------------------------------------
  def command_337
    iterate_enemy_index(@params[0]) do |enemy|
      enemy.animation_id = @params[1] if enemy.alive?
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の強制
  #--------------------------------------------------------------------------
  def command_339
    iterate_battler(@params[0], @params[1]) do |battler|
      next if battler.death_state?
      battler.force_action(@params[2], @params[3])
      BattleManager.force_action(battler)
      Fiber.yield while BattleManager.action_forced?
    end
  end
  #--------------------------------------------------------------------------
  # ● バトルの中断
  #--------------------------------------------------------------------------
  def command_340
    BattleManager.abort
    Fiber.yield
  end
  #--------------------------------------------------------------------------
  # ● メニュー画面を開く
  #--------------------------------------------------------------------------
  def command_351
    return if $game_party.in_battle
    SceneManager.call(Scene_Menu)
    Window_MenuCommand::init_command_position
    Fiber.yield
  end
  #--------------------------------------------------------------------------
  # ● セーブ画面を開く
  #--------------------------------------------------------------------------
  def command_352
    return if $game_party.in_battle
    SceneManager.call(Scene_Save)
    Fiber.yield
  end
  #--------------------------------------------------------------------------
  # ● ゲームオーバー
  #--------------------------------------------------------------------------
  def command_353
    SceneManager.goto(Scene_Gameover)
    Fiber.yield
  end
  #--------------------------------------------------------------------------
  # ● タイトル画面に戻す
  #--------------------------------------------------------------------------
  def command_354
    SceneManager.goto(Scene_Title)
    Fiber.yield
  end
  #--------------------------------------------------------------------------
  # ● スクリプト
  #--------------------------------------------------------------------------
  def command_355
    script = @list[@index].parameters[0] + "\n"
    while next_event_code == 655
      @index += 1
      script += @list[@index].parameters[0] + "\n"
    end
    eval(script)
  end
end
