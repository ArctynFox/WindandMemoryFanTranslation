


module ATB
  #--------------------------------------------------------------------------
  # ● 設定項目
  #--------------------------------------------------------------------------
  
  # 行動に必要なＡＰ
  MAX_AP = 4000
  
  # １フレーム（60分の1秒）ごとに「敏捷性にこの値を加算した値」だけＡＰが増える
  FRAME_AP_GAIN = 10
  
  # 戦闘開始時の初期ＡＰのパーセンテージ基本値
  # [30,40]なら30%～70%
  START_AP_RATE_PREEMPTIVE =  [40, 30] #先制
  START_AP_RATE_NORMAL     =  [30, 40] #通常
  START_AP_RATE_SURPRISE   =  [ 0, 10] #不意打ち
  # 逃走失敗時のＡＰのパーセンテージ基本値
  ESCAPE_FAILED_AP_RATE = [0, 10]
  
  
  
  # 「能力強化」のターン数減少と自動解除のタイミング
  #  1ならそのキャラクターの行動時　2なら全てのキャラクターの行動時
  BUFF_TURN_COUNT = 1
  # 自動解除のタイミングが「行動終了時」のステート（設定によっては能力強化も）の
  # 残りターン数の減少を、詠唱開始時も行うか
  CHANT_STATE_TURN_COUNT = false
  
  
  # 逃走失敗時に全味方のステートの残りターン数を減少させるか
  ESCAPE_FAILED_STATE_COUNT_1 = true #条件：行動終了時
  ESCAPE_FAILED_STATE_COUNT_2 = true #条件：ターン終了時
  ESCAPE_FAILED_STATE_COUNT_3 = true #条件：一定フレーム経過
  
  
  
  # 以下「再生」とはＨＰ、ＭＰ、ＴＰの「再生、スリップダメージ」を指す
  # 再生には２種類ある
  #   行動ごと(VXAceデフォルト)の再生
  #   ターンフレームステートによる再生
  
  # 行動ごとの再生を、詠唱時も行うか
  # ここが  false だと
  #   REGENERATE_TIMING_AFTERが true(行動後再生):詠唱開始した直後は再生しない
  #   REGENERATE_TIMING_AFTERがfalse(行動前再生):詠唱完了して発動直前は再生しない
  # ここが  true だと
  #   上記のタイミングでも再生する
  CHANT_REGENERATE = false
  
  # 行動ごとの再生のタイミング
  # true: 行動後(VXAceデフォルトと同じ) false: 行動選択直前
  REGENERATE_TIMING_AFTER = false
  
  # 再生時に、メッセージを表示するかどうか
  #   [HP回復, HPダメージ, MP回復, MPダメージ, TP回復, TPダメージ]の順番
  #   true: 表示する false: 表示しない
  # 
  # 行動ごとの再生（VXAceデフォルトの再生）
  #                         H回復  Hダメ  M回復  Mダメ  T回復  Tダメ
  REGENERATE_SHOW_NORMAL = [ true,  true,  true,  true,  true,  true]
  # ターンフレームステートによる再生
  #                         H回復  Hダメ  M回復  Mダメ  T回復  Tダメ
  REGENERATE_SHOW_FRAME  = [ true,  true,  true,  true,  true,  true]
  
  # 味方の再生メッセージのみ表示し、敵については表示しない設定
  # true: 味方と敵の両方で表示する false: 味方のみ表示する
  ENEMY_REGENERATE_SHOW  = true
  
  
  
  # ゲージ増加速度の最低値（ステートのフレーム速度の乗算が入る前の最低値）
  GAUGE_GAIN_MIN = 5
  
  # 初ターンのみ、ゲージ増加の前にウェイトするフレーム数
  BATTLE_START_WAIT = 30
  # 初ターン以外でゲージ増加の前にウェイトするフレーム数
  GAUGE_START_WAIT = 0
  
  # 詠唱開始時に再生するアニメID
  # スキルのメモ欄に指定がない場合、ここから取得する
  #  [タイプ0, タイプ1, タイプ2, タイプ3, ...]
  CHANT_START_ANIMATION_DEFAULT = [0, 81, 44]
  
  
end




module ATB
  
  # ここは変更しないでください
  $cwinter_script_atb = true
  $cwinter_script_atb_version = {}
  
  def self.xp_style?
    return ($lnx_include != nil and $lnx_include[:lnx11a] != nil)
  end
  
  def self.xp_style_default?
    return (self.xp_style? and $lnx_include[:lnx11b] == nil)
  end
  def self.xp_style_reform?
    return (self.xp_style? and $lnx_include[:lnx11b] != nil)
  end
  
  def self.sideview?
    begin
      N03::ACTOR_POSITION
      return true
    rescue
      return false
    end
  end
  
  def self.ver(symbol, version)
    $cwinter_script_atb_version[symbol] = version
  end
  
end

