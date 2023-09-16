#==============================================================================
# ■ Game_Character
#------------------------------------------------------------------------------
# 　主に移動ルートなどの処理を追加したキャラクターのクラスです。Game_Player、
# Game_Follower、GameVehicle、Game_Event のスーパークラスとして使用されます。
#==============================================================================

class Game_Character < Game_CharacterBase
  #--------------------------------------------------------------------------
  # ● 定数
  #--------------------------------------------------------------------------
  ROUTE_END               = 0             # 移動ルートの終端
  ROUTE_MOVE_DOWN         = 1             # 下に移動
  ROUTE_MOVE_LEFT         = 2             # 左に移動
  ROUTE_MOVE_RIGHT        = 3             # 右に移動
  ROUTE_MOVE_UP           = 4             # 上に移動
  ROUTE_MOVE_LOWER_L      = 5             # 左下に移動
  ROUTE_MOVE_LOWER_R      = 6             # 右下に移動
  ROUTE_MOVE_UPPER_L      = 7             # 左上に移動
  ROUTE_MOVE_UPPER_R      = 8             # 右上に移動
  ROUTE_MOVE_RANDOM       = 9             # ランダムに移動
  ROUTE_MOVE_TOWARD       = 10            # プレイヤーに近づく
  ROUTE_MOVE_AWAY         = 11            # プレイヤーから遠ざかる
  ROUTE_MOVE_FORWARD      = 12            # 一歩前進
  ROUTE_MOVE_BACKWARD     = 13            # 一歩後退
  ROUTE_JUMP              = 14            # ジャンプ
  ROUTE_WAIT              = 15            # ウェイト
  ROUTE_TURN_DOWN         = 16            # 下を向く
  ROUTE_TURN_LEFT         = 17            # 左を向く
  ROUTE_TURN_RIGHT        = 18            # 右を向く
  ROUTE_TURN_UP           = 19            # 上を向く
  ROUTE_TURN_90D_R        = 20            # 右に 90 度回転
  ROUTE_TURN_90D_L        = 21            # 左に 90 度回転
  ROUTE_TURN_180D         = 22            # 180 度回転
  ROUTE_TURN_90D_R_L      = 23            # 右か左に 90 度回転
  ROUTE_TURN_RANDOM       = 24            # ランダムに方向転換
  ROUTE_TURN_TOWARD       = 25            # プレイヤーの方を向く
  ROUTE_TURN_AWAY         = 26            # プレイヤーの逆を向く
  ROUTE_SWITCH_ON         = 27            # スイッチ ON
  ROUTE_SWITCH_OFF        = 28            # スイッチ OFF
  ROUTE_CHANGE_SPEED      = 29            # 移動速度の変更
  ROUTE_CHANGE_FREQ       = 30            # 移動頻度の変更
  ROUTE_WALK_ANIME_ON     = 31            # 歩行アニメ ON
  ROUTE_WALK_ANIME_OFF    = 32            # 歩行アニメ OFF
  ROUTE_STEP_ANIME_ON     = 33            # 足踏みアニメ ON
  ROUTE_STEP_ANIME_OFF    = 34            # 足踏みアニメ OFF
  ROUTE_DIR_FIX_ON        = 35            # 向き固定 ON
  ROUTE_DIR_FIX_OFF       = 36            # 向き固定 OFF
  ROUTE_THROUGH_ON        = 37            # すり抜け ON
  ROUTE_THROUGH_OFF       = 38            # すり抜け OFF
  ROUTE_TRANSPARENT_ON    = 39            # 透明化 ON
  ROUTE_TRANSPARENT_OFF   = 40            # 透明化 OFF
  ROUTE_CHANGE_GRAPHIC    = 41            # グラフィック変更
  ROUTE_CHANGE_OPACITY    = 42            # 不透明度の変更
  ROUTE_CHANGE_BLENDING   = 43            # 合成方法の変更
  ROUTE_PLAY_SE           = 44            # SE の演奏
  ROUTE_SCRIPT            = 45            # スクリプト
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :move_route_forcing       # 移動ルート強制フラグ
  #--------------------------------------------------------------------------
  # ● 公開メンバ変数の初期化
  #--------------------------------------------------------------------------
  def init_public_members
    super
    @move_route_forcing = false
  end
  #--------------------------------------------------------------------------
  # ● 非公開メンバ変数の初期化
  #--------------------------------------------------------------------------
  def init_private_members
    super
    @move_route = nil                     # 移動ルート
    @move_route_index = 0                 # 移動ルートの実行位置
    @original_move_route = nil            # 元の移動ルート
    @original_move_route_index = 0        # 元の移動ルートの実行位置
    @wait_count = 0                       # ウェイトカウント
  end
  #--------------------------------------------------------------------------
  # ● 移動ルートの記憶
  #--------------------------------------------------------------------------
  def memorize_move_route
    @original_move_route        = @move_route
    @original_move_route_index  = @move_route_index
  end
  #--------------------------------------------------------------------------
  # ● 移動ルートの復帰
  #--------------------------------------------------------------------------
  def restore_move_route
    @move_route           = @original_move_route
    @move_route_index     = @original_move_route_index
    @original_move_route  = nil
  end
  #--------------------------------------------------------------------------
  # ● 移動ルートの強制
  #--------------------------------------------------------------------------
  def force_move_route(move_route)
    memorize_move_route unless @original_move_route
    @move_route = move_route
    @move_route_index = 0
    @move_route_forcing = true
    @prelock_direction = 0
    @wait_count = 0
  end
  #--------------------------------------------------------------------------
  # ● 停止時の更新
  #--------------------------------------------------------------------------
  def update_stop
    super
    update_routine_move if @move_route_forcing
  end
  #--------------------------------------------------------------------------
  # ● ルートに沿った移動の更新
  #--------------------------------------------------------------------------
  def update_routine_move
    if @wait_count > 0
      @wait_count -= 1
    else
      @move_succeed = true
      command = @move_route.list[@move_route_index]
      if command
        process_move_command(command)
        advance_move_route_index
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 移動コマンドの処理
  #--------------------------------------------------------------------------
  def process_move_command(command)
    params = command.parameters
    case command.code
    when ROUTE_END;               process_route_end
    when ROUTE_MOVE_DOWN;         move_straight(2)
    when ROUTE_MOVE_LEFT;         move_straight(4)
    when ROUTE_MOVE_RIGHT;        move_straight(6)
    when ROUTE_MOVE_UP;           move_straight(8)
    when ROUTE_MOVE_LOWER_L;      move_diagonal(4, 2)
    when ROUTE_MOVE_LOWER_R;      move_diagonal(6, 2)
    when ROUTE_MOVE_UPPER_L;      move_diagonal(4, 8)
    when ROUTE_MOVE_UPPER_R;      move_diagonal(6, 8)
    when ROUTE_MOVE_RANDOM;       move_random
    when ROUTE_MOVE_TOWARD;       move_toward_player
    when ROUTE_MOVE_AWAY;         move_away_from_player
    when ROUTE_MOVE_FORWARD;      move_forward
    when ROUTE_MOVE_BACKWARD;     move_backward
    when ROUTE_JUMP;              jump(params[0], params[1])
    when ROUTE_WAIT;              @wait_count = params[0] - 1
    when ROUTE_TURN_DOWN;         set_direction(2)
    when ROUTE_TURN_LEFT;         set_direction(4)
    when ROUTE_TURN_RIGHT;        set_direction(6)
    when ROUTE_TURN_UP;           set_direction(8)
    when ROUTE_TURN_90D_R;        turn_right_90
    when ROUTE_TURN_90D_L;        turn_left_90
    when ROUTE_TURN_180D;         turn_180
    when ROUTE_TURN_90D_R_L;      turn_right_or_left_90
    when ROUTE_TURN_RANDOM;       turn_random
    when ROUTE_TURN_TOWARD;       turn_toward_player
    when ROUTE_TURN_AWAY;         turn_away_from_player
    when ROUTE_SWITCH_ON;         $game_switches[params[0]] = true
    when ROUTE_SWITCH_OFF;        $game_switches[params[0]] = false
    when ROUTE_CHANGE_SPEED;      @move_speed = params[0]
    when ROUTE_CHANGE_FREQ;       @move_frequency = params[0]
    when ROUTE_WALK_ANIME_ON;     @walk_anime = true
    when ROUTE_WALK_ANIME_OFF;    @walk_anime = false
    when ROUTE_STEP_ANIME_ON;     @step_anime = true
    when ROUTE_STEP_ANIME_OFF;    @step_anime = false
    when ROUTE_DIR_FIX_ON;        @direction_fix = true
    when ROUTE_DIR_FIX_OFF;       @direction_fix = false
    when ROUTE_THROUGH_ON;        @through = true
    when ROUTE_THROUGH_OFF;       @through = false
    when ROUTE_TRANSPARENT_ON;    @transparent = true
    when ROUTE_TRANSPARENT_OFF;   @transparent = false
    when ROUTE_CHANGE_GRAPHIC;    set_graphic(params[0], params[1])
    when ROUTE_CHANGE_OPACITY;    @opacity = params[0]
    when ROUTE_CHANGE_BLENDING;   @blend_type = params[0]
    when ROUTE_PLAY_SE;           params[0].play
    when ROUTE_SCRIPT;            eval(params[0])
    end
  end
  #--------------------------------------------------------------------------
  # ● X 方向の距離計算
  #--------------------------------------------------------------------------
  def distance_x_from(x)
    result = @x - x
    if $game_map.loop_horizontal? && result.abs > $game_map.width / 2
      if result < 0
        result += $game_map.width
      else
        result -= $game_map.width
      end
    end
    result
  end
  #--------------------------------------------------------------------------
  # ● Y 方向の距離計算
  #--------------------------------------------------------------------------
  def distance_y_from(y)
    result = @y - y
    if $game_map.loop_vertical? && result.abs > $game_map.height / 2
      if result < 0
        result += $game_map.height
      else
        result -= $game_map.height
      end
    end
    result
  end
  #--------------------------------------------------------------------------
  # ● ランダムに移動
  #--------------------------------------------------------------------------
  def move_random
    move_straight(2 + rand(4) * 2, false)
  end
  #--------------------------------------------------------------------------
  # ● キャラクターに近づく
  #--------------------------------------------------------------------------
  def move_toward_character(character)
    sx = distance_x_from(character.x)
    sy = distance_y_from(character.y)
    if sx.abs > sy.abs
      move_straight(sx > 0 ? 4 : 6)
      move_straight(sy > 0 ? 8 : 2) if !@move_succeed && sy != 0
    elsif sy != 0
      move_straight(sy > 0 ? 8 : 2)
      move_straight(sx > 0 ? 4 : 6) if !@move_succeed && sx != 0
    end
  end
  #--------------------------------------------------------------------------
  # ● キャラクターから遠ざかる
  #--------------------------------------------------------------------------
  def move_away_from_character(character)
    sx = distance_x_from(character.x)
    sy = distance_y_from(character.y)
    if sx.abs > sy.abs
      move_straight(sx > 0 ? 6 : 4)
      move_straight(sy > 0 ? 2 : 8) if !@move_succeed && sy != 0
    elsif sy != 0
      move_straight(sy > 0 ? 2 : 8)
      move_straight(sx > 0 ? 6 : 4) if !@move_succeed && sx != 0
    end
  end
  #--------------------------------------------------------------------------
  # ● キャラクターの方を向く
  #--------------------------------------------------------------------------
  def turn_toward_character(character)
    sx = distance_x_from(character.x)
    sy = distance_y_from(character.y)
    if sx.abs > sy.abs
      set_direction(sx > 0 ? 4 : 6)
    elsif sy != 0
      set_direction(sy > 0 ? 8 : 2)
    end
  end
  #--------------------------------------------------------------------------
  # ● キャラクターの逆を向く
  #--------------------------------------------------------------------------
  def turn_away_from_character(character)
    sx = distance_x_from(character.x)
    sy = distance_y_from(character.y)
    if sx.abs > sy.abs
      set_direction(sx > 0 ? 6 : 4)
    elsif sy != 0
      set_direction(sy > 0 ? 2 : 8)
    end
  end
  #--------------------------------------------------------------------------
  # ● プレイヤーの方を向く
  #--------------------------------------------------------------------------
  def turn_toward_player
    turn_toward_character($game_player)
  end
  #--------------------------------------------------------------------------
  # ● プレイヤーの逆を向く
  #--------------------------------------------------------------------------
  def turn_away_from_player
    turn_away_from_character($game_player)
  end
  #--------------------------------------------------------------------------
  # ● プレイヤーに近づく
  #--------------------------------------------------------------------------
  def move_toward_player
    move_toward_character($game_player)
  end
  #--------------------------------------------------------------------------
  # ● プレイヤーから遠ざかる
  #--------------------------------------------------------------------------
  def move_away_from_player
    move_away_from_character($game_player)
  end
  #--------------------------------------------------------------------------
  # ● 一歩前進
  #--------------------------------------------------------------------------
  def move_forward
    move_straight(@direction)
  end
  #--------------------------------------------------------------------------
  # ● 一歩後退
  #--------------------------------------------------------------------------
  def move_backward
    last_direction_fix = @direction_fix
    @direction_fix = true
    move_straight(reverse_dir(@direction), false)
    @direction_fix = last_direction_fix
  end
  #--------------------------------------------------------------------------
  # ● ジャンプ
  #     x_plus : X 座標加算値
  #     y_plus : Y 座標加算値
  #--------------------------------------------------------------------------
  def jump(x_plus, y_plus)
    if x_plus.abs > y_plus.abs
      set_direction(x_plus < 0 ? 4 : 6) if x_plus != 0
    else
      set_direction(y_plus < 0 ? 8 : 2) if y_plus != 0
    end
    @x += x_plus
    @y += y_plus
    distance = Math.sqrt(x_plus * x_plus + y_plus * y_plus).round
    @jump_peak = 10 + distance - @move_speed
    @jump_count = @jump_peak * 2
    @stop_count = 0
    straighten
  end
  #--------------------------------------------------------------------------
  # ● 移動ルート終端の処理
  #--------------------------------------------------------------------------
  def process_route_end
    if @move_route.repeat
      @move_route_index = -1
    elsif @move_route_forcing
      @move_route_forcing = false
      restore_move_route
    end
  end
  #--------------------------------------------------------------------------
  # ● 移動ルートの実行位置を進める
  #--------------------------------------------------------------------------
  def advance_move_route_index
    @move_route_index += 1 if @move_succeed || @move_route.skippable
  end
  #--------------------------------------------------------------------------
  # ● 右に 90 度回転
  #--------------------------------------------------------------------------
  def turn_right_90
    case @direction
    when 2;  set_direction(4)
    when 4;  set_direction(8)
    when 6;  set_direction(2)
    when 8;  set_direction(6)
    end
  end
  #--------------------------------------------------------------------------
  # ● 左に 90 度回転
  #--------------------------------------------------------------------------
  def turn_left_90
    case @direction
    when 2;  set_direction(6)
    when 4;  set_direction(2)
    when 6;  set_direction(8)
    when 8;  set_direction(4)
    end
  end
  #--------------------------------------------------------------------------
  # ● 180 度回転
  #--------------------------------------------------------------------------
  def turn_180
    set_direction(reverse_dir(@direction))
  end
  #--------------------------------------------------------------------------
  # ● 右か左に 90 度回転
  #--------------------------------------------------------------------------
  def turn_right_or_left_90
    case rand(2)
    when 0;  turn_right_90
    when 1;  turn_left_90
    end
  end
  #--------------------------------------------------------------------------
  # ● ランダムに方向転換
  #--------------------------------------------------------------------------
  def turn_random
    set_direction(2 + rand(4) * 2)
  end
  #--------------------------------------------------------------------------
  # ● キャラクターの位置を交換
  #--------------------------------------------------------------------------
  def swap(character)
    new_x = character.x
    new_y = character.y
    character.moveto(x, y)
    moveto(new_x, new_y)
  end
end
