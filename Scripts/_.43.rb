#==============================================================================
# ■ RGSS3 オートリザレクション特徴 Ver2.00 by 星潟
#------------------------------------------------------------------------------
# 戦闘不能に陥った際、一定確率で自動回復する特徴を作成します。
# 著しくゲームバランスを損ねる場合がありますので、ご利用は計画的に。
# なお、イベントコマンドのHP増減による戦闘不能や
# ステート付与による戦闘不能では動作しないようにしています。
#
# また、自動蘇生効果発動時に破損する装備品や
# 解除するステートを作成することもできます。
# （特に素材を導入していない限りは、戦闘不能時にステートは自動消滅します。
#   戦闘不能時にステートが解除されないような素材を導入されている場合のみ
#   解除するステート設定は有効です）
#==============================================================================
# ★自動蘇生特徴設定例（アクター・装備品・ステート・エネミー用）
#------------------------------------------------------------------------------
# <自動蘇生:500,42,25>
#
# 戦闘不能になった際、アニメーションID42を再生しつつ
# 25％の確率でHP500の状態で蘇生します。
#------------------------------------------------------------------------------
# <自動蘇生:self.mhp*3/4,0>
#
# 戦闘不能になった際、アニメーションは表示せず
# 100％の確率でHPが最大HPの75％の状態で蘇生します。
#==============================================================================
# ★自動蘇生破損特徴設定例（装備品・ステート用）
#------------------------------------------------------------------------------
# <自動蘇生破損:75>
#
# この装備・ステートで自動蘇生が発動した際
# 75％の確率で破壊/解除されます。
#------------------------------------------------------------------------------
# <自動蘇生破損:$game_variables[1]>
#
# この装備・ステートで自動蘇生が発動した際
# 変数1の値分の確率で破壊/解除されます。
#------------------------------------------------------------------------------
# Ver1.01
# オートリザレクションを特徴化。
# Ver2.00
# 注釈を全面的に追加。
# キャッシュ化による軽量化を実施。
# HP回復量・発動確率にスクリプトによる計算を行えるように変更。
# 装備・ステートに対し、自動蘇生発動時に破壊/解除される確率を
# 指定できるように機能を拡張。
#==============================================================================
module A_Resurrection
  
  #死亡時自動蘇生の設定用キーワードを指定。
  
  WORD1    = "自動蘇生"
  
  #死亡時自動蘇生が発動した際の破壊/解除率設定用キーワードを指定。
  
  WORD2    = "自動蘇生破損"
  
  #自動回復させる場合にHP回復量を表示するか否かを指定。
  #true …… 表示する false ……表示しない
  
  RE_HPDIS = true
  
  #スリップダメージによる戦闘不能でも自動回復するか否かを指定。
  #true …… する false ……しない
  
  SLIP_REC = true
  
  #死亡時自動蘇生時に装備品が破壊された場合のキーワードを指定。
  
  TEXT = " shattered!"
  
  #装備品が破壊された場合のSEを指定。
  #指定順は[SE名,音量,ピッチ]。
  
  SE       = ["Crash",80,100]
  
end
class Game_ActionResult
  attr_accessor :a_resurrection
  #--------------------------------------------------------------------------
  # ダメージ値のクリア
  #--------------------------------------------------------------------------
  alias clear_damage_values_a_resurrection clear_damage_values
  def clear_damage_values
    
    #本来の処理を実行。
    
    clear_damage_values_a_resurrection
    
    #自動蘇生データを初期化する。
    
    a_resurrection_clear
  end
  #--------------------------------------------------------------------------
  # 自動蘇生データを初期化
  #--------------------------------------------------------------------------
  def a_resurrection_clear
    @a_resurrection = [0,0,nil]
  end
end
module BattleManager
  #--------------------------------------------------------------------------
  # 蘇生可能タイミングかどうかを判定。
  #--------------------------------------------------------------------------
  def self.resurrection
    
    #ターン中、もしくはターン終了時はtrue、そうでない場合はfalse
    
    @phase == :turn or @phase == :turn_end
    
  end
end
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # ステート付与
  #--------------------------------------------------------------------------
  alias add_state_a_resurrection add_state
  def add_state(state_id)
    
    #ステートIDが死亡ステートでなく
    #蘇生可能なタイミングであり
    #なおかつまだ死亡していない場合は分岐。
    
    if state_id == death_state_id && BattleManager.resurrection && !state?(death_state_id)
      
      #自動蘇生データを取得。
      
      data = a_resurrection_check(state_id)
      
      #本来の処理を実行。
      
      add_state_a_resurrection(state_id)
      
      #自動蘇生データのHP回復量が0以上の場合は行動結果に反映。
      
      @result.a_resurrection = data if data[0] > 0
      
    else
      
      #本来の処理を実行。
      
      add_state_a_resurrection(state_id)
      
    end
  end
  #--------------------------------------------------------------------------
  # 自動蘇生データ生成
  #--------------------------------------------------------------------------
  def a_resurrection_check(state_id, regenerate = false)
    
    #自動回復処理中でなく、なおかつHPが0でなく、戦闘不能状態でもない場合は
    #デフォルトの配列を返す。
    
    return [0,0,nil] if !regenerate && (self.hp != 0 or state_id != death_state_id)
    
    #特徴別に判定。
    
    feature_objects.each {|f| hash = f.a_resurrection
    
    #特徴の自動蘇生データのハッシュから発動率を計算する。
    
    hash.each_value {|value| next unless eval(value[2]) > rand(100)
    
    #HP回復量を計算。
    
    data = eval(value[0]).to_i
    
    #HP回復量が0以上の場合のみ続行。
    
    next unless data > 0
    
    #HP回復量、アニメーションID、特徴データを返す。
    
    return [data, value[1],f]}}
    
    #デフォルトの配列を返す。
    
    [0,0,nil]
    
  end
  #--------------------------------------------------------------------------
  # 自動蘇生データ
  #--------------------------------------------------------------------------
  def a_resurrection
    
    #自動蘇生データを返す。
    
    @result.a_resurrection
    
  end
  #--------------------------------------------------------------------------
  # ターン終了
  #--------------------------------------------------------------------------
  alias regenerate_hp_a_resurrection regenerate_hp
  def regenerate_hp
    
    #スリップダメージによる死亡からの自動蘇生を行う場合
    #自動蘇生データを取得し、そうでない場合はデフォルトの配列を返す。
    
    @result.a_resurrection = A_Resurrection::SLIP_REC ? a_resurrection_check(death_state_id, true) : [0,0]
    
    #本来の処理を実行。
    
    regenerate_hp_a_resurrection
    
    #本来の処理を行った上でHPが0でないか死亡していない場合は
    #デフォルトの配列を返す。
    
    @result.a_resurrection = [0,0,nil] if self.hp != 0 or !state?(death_state_id)
    
  end
  #--------------------------------------------------------------------------
  # 破損率確率の計算
  #--------------------------------------------------------------------------
  def a_r_break_rate(f)
    eval(f.a_r_break_rate)
  end
end
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # スキル／アイテムの効果を適用
  #--------------------------------------------------------------------------
  alias apply_item_effects_a_resurrection apply_item_effects
  def apply_item_effects(target, item)
    
    #本来の処理を実行。
    
    apply_item_effects_a_resurrection(target, item)
    
    #自動蘇生データを取得。
    
    data = target.a_resurrection
    
    #HP回復量が0より大きい場合は処理を続行。
    
    return unless data[0] > 0
    
    #ログウィンドウをクリア。
    
    @log_window.clear
    
    #指定したアニメーションを再生。ID0の場合は再生しない。
    
    show_animation([target], data[1]) if data[1] > 0
    
    #対象のHPを回復。
    
    target.hp = data[0]
    
    #ステータスウィンドウの更新。
    
    refresh_status
    
    #自動蘇生を表示。
    
    @log_window.display_a_resurrection(target)
    
    #自動蘇生による破損の表示。
    
    @log_window.display_a_r_break(target, data[2])
    
  end
  #--------------------------------------------------------------------------
  # ターン終了
  #--------------------------------------------------------------------------
  alias turn_end_a_resurrection turn_end
  def turn_end
    
    #スリップダメージによる死亡からの蘇生フラグを取得。
    
    @te_a_resurrection = A_Resurrection::SLIP_REC
    
    #本来の処理を実行。
    
    turn_end_a_resurrection
    
    #スリップダメージによる死亡からの蘇生フラグを消去。
    
    @te_a_resurrection = nil
    
  end
  #--------------------------------------------------------------------------
  # イベント処理
  #--------------------------------------------------------------------------
  alias process_event_te_a_resurrection process_event
  def process_event
    
    #スリップダメージによる死亡からの蘇生フラグが有効な場合
    #ここで蘇生処理を実行する。
    
    te_a_resurrection_execute if @te_a_resurrection
    process_event_te_a_resurrection
  end
  def te_a_resurrection_execute
    
    #全ての戦闘メンバー別に処理。
    
    all_battle_members.each do |battler|
      
      #自動蘇生のデータを取得。
      
      data = battler.result.a_resurrection
      
      #自動蘇生のHP回復量が0より大きい場合
      
      if data[0] > 0
        
        #ログウィンドウをクリア。
        
        @log_window.clear
        
        #指定したアニメーションを再生。ID0の場合は再生しない。
        
        show_animation([battler], data[1]) if data[1] > 0
        
        #対象のHPを回復。
        
        battler.hp = data[0]
        
        #ステータスウィンドウの更新。
        
        refresh_status
        
        #自動蘇生の表示。
        
        @log_window.display_a_resurrection(battler)
        
        #ログウィンドウのクリア。
        
        @log_window.wait_and_clear
        
        #自動蘇生による破損の表示。
        
        @log_window.display_a_r_break(battler,data[2])
        
      end
    end
  end
end
class Window_BattleLog < Window_Selectable
  #--------------------------------------------------------------------------
  # 自動蘇生時のHP回復表示
  #--------------------------------------------------------------------------
  def a_resurrection_hp_recovery(target)
    
    #回復ではなくダメージである場合や
    #回復量を表示しない設定である場合は処理しない。
    
    return unless target.result.hp_damage > 0 or A_Resurrection::RE_HPDIS
    
    #回復SEを実行。
    
    Sound.play_recovery
    
    #回復メッセージを表示。
    
    add_text(target.result.hp_damage_text)
    
    #ウェイトを実行。
    
    wait
    
  end
  #--------------------------------------------------------------------------
  # 自動蘇生の表示
  #--------------------------------------------------------------------------
  def display_a_resurrection(target)
    
    #結果を書き換える。
    
    target.result.used = true
    target.result.critical = false
    target.result.success = true
    target.result.hp_damage = -target.result.a_resurrection[0]
    
    #死亡ステートデータを取得。
    
    state = $data_states[target.death_state_id]
    
    #最終行を取得。
    
    last_line_number = line_number
    
    #自動蘇生時のHP回復表示。
    
    a_resurrection_hp_recovery(target)
    
    #戦闘不能ステート解除メッセージを表示。
    
    add_text(target.name + state.message4) unless state.message4.empty?
    
    #ウェイトを実行。
    
    wait if line_number > last_line_number
    
    #行を戻す。
    
    back_to(last_line_number)
    
  end
  #--------------------------------------------------------------------------
  # 自動蘇生破損の表示
  #--------------------------------------------------------------------------
  def display_a_r_break(target, feature)
    
    #該当する特徴の破損判定を実行。
    
    return unless target.a_r_break_rate(feature) > rand(100)
    
    #最終行を取得。
    
    last_line_number = line_number
    
    #特徴が装備品である場合
    
    if feature.is_a?(RPG::EquipItem)
      
      #なんらかの原因で既に装備解除されている状況を考え
      #装備品別に自動蘇生に用いた装備品を装備しているか否かを判定。
      
      return unless target.equips.include?(feature)
      
      #ウェイトを実行。
      
      wait
      
      #該当する装備を破棄。
      
      target.discard_equip(feature)
      
      #SEの配列を用意。
      
      array = A_Resurrection::SE
      
      #SEを演奏。
      
      RPG::SE.new(array[0],array[1],array[2]).play
      
      #設定に応じてメッセージを表示。
      
      add_text(feature.name + A_Resurrection::TEXT) unless A_Resurrection::TEXT.empty?
      
      #ウェイトを実行。
      
      wait
      
      #行を戻す。
      
      back_to(last_line_number)
      
    #対象がステートである場合
      
    elsif feature.is_a?(RPG::State)
      
      #そのステートが付与されていない場合は飛ばす。
      
      return unless target.state?(feature.id)
      
      #ウェイトを実行。
      
      wait
      
      #該当するステートを解除。
      
      target.remove_state(feature.id)
      
      #ステート解除メッセージを表示。
      
      add_text(target.name + feature.message4) unless feature.message4.empty?
      
      #ウェイトを実行。
      
      wait
      
      #行を戻す。
      
      back_to(last_line_number)
      
    end
  end
end
class RPG::BaseItem
  #--------------------------------------------------------------------------
  # 自動蘇生データ
  #--------------------------------------------------------------------------
  def a_resurrection
    
    #キャッシュが存在する場合はキャッシュを返す。
    
    return @a_resurrection if @a_resurrection
    
    #ハッシュを作成。
    
    @a_resurrection = {}
    
    #メモ欄からデータを取得する。
    
    @note.each_line {|l|
    
    memo = l.scan(/<#{A_Resurrection::WORD1}[：:](\S+)>/).flatten
    
    #正常なデータを取得できた場合はそのデータを分解する。
    
    if memo != nil && !memo.empty?
    
      data = memo[0].split(/\s*,\s*/)
      
      #要素数が決定的に足りない場合は飛ばす。
      
      next if data.size < 2
      
      #要素が1足りない場合は確率の省略とみなし、文字列の100を代入。
      
      data.push("100") if data.size < 3
      
      #アニメーションIDは整数とする。
      
      data[1] = data[1].to_i
      
      #ハッシュにデータを関連付ける。
      
      @a_resurrection[@a_resurrection.size] = data
    
    end
    
    }
    
    #データを返す。
    
    @a_resurrection
    
  end
  #--------------------------------------------------------------------------
  # 自動蘇生時破損確率
  #--------------------------------------------------------------------------
  def a_r_break_rate
    
    #キャッシュが存在する場合はキャッシュを返す。
    
    return @a_r_break if @a_r_break
    
    #メモ欄からデータを取得する。
    
    memo = @note.scan(/<#{A_Resurrection::WORD2}[：:](\S+)>/).flatten
    
    #正常なデータを取得できた場合はそのデータを。そうでない場合は"0"とする。
    
    @a_r_break = memo != nil && !memo.empty? ? memo[0] : "0"
    
    #データを返す。
    
    @a_r_break
    
  end
end