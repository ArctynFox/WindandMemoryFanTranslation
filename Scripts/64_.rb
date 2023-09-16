ATB.ver(:atb_window_setting, 1.64)

module ATB
  #--------------------------------------------------------------------------
  # ● 設定項目
  #--------------------------------------------------------------------------  
  
  # 軽量化設定
  # ＡＰ増加処理を頻繁に行うと動作環境によっては処理落ちする
  # REFRESH_FRAMEの値を大きくすると、ＡＰ増加処理の間隔を長くして処理を軽くする
  
  # ＡＰ増加処理の間隔　3にすると3フレームに一回処理を行う
  REFRESH_FRAME = 3
  
  
  
  # 味方ＡＰ情報に"AP"の文字を表示するか
  AP_GAUGE_NAME = true
  AP_GAUGE_NAME_TEXT_COLOR = Color.new(132, 170, 255)   #文字色
  
  # 味方ＡＰ情報にＡＰの溜まり具合（パーセンテージ）を表示するか
  AP_GAUGE_PERCENT = true
  # AP_GAUGE_PERCENTをtrueにした場合のみ　ＡＰの溜まり具合に"%"を付けるかどうか
  AP_GAUGE_SIGN = true
  AP_GAUGE_MAIN_TEXT_COLOR = Color.new(255, 255, 255)  #文字色
  
  
  
  # 敵ゲージの不透明度　255で完全に不透明　0で透明
  ENEMY_AP_GAUGE_ALPHA = 128
  # メモ欄で指定されていない場合、敵ゲージを敵画像より手前に表示するかどうか
  # trueなら手前 falseなら奥
  ENEMY_GAUGE_FRONT = false
  
  # 敵ゲージの設定　       [ ＨＰ,  ＭＰ,  ＴＰ,  ＡＰ]　の順番
  ENEMY_GAUGE_DRAW_DATA  = [false, false, false,  true]  # 表示するかどうか
  ENEMY_GAUGE_POS_DATA   = [  -18,    -2,     8,   0]  # y座標(縦の位置)補正値
  ENEMY_GAUGE_WIDTH_DATA = [  100,   100,    80,   100]  # 長さデフォルト値
  
  
  
  # 敵ＨＰ、ＭＰ、ＴＰゲージの色　[背景,左側,右側]
  ENEMY_HP_GAUGE_COLOR = [Color.new( 32,  32,  64),   # text_color(19)と同じ
                          Color.new(224, 128,  64),   # text_color(20)
                          Color.new(240, 192,  64)]   # text_color(21)
  ENEMY_MP_GAUGE_COLOR = [Color.new( 32,  32,  64),   # text_color(19)
                          Color.new( 64, 128, 192),   # text_color(22)
                          Color.new( 64, 192, 240)]   # text_color(23)
  ENEMY_TP_GAUGE_COLOR = [Color.new( 32,  32,  64),   # text_color(19)
                          Color.new(  0, 160,  64),   # text_color(28)
                          Color.new(  0, 224,  96)]   # text_color(29)
  
  
  # 敵ゲージ非表示設定
  ENEMY_AP_GAUGE_HIDE_SWITCH = 5      # スイッチがオンになっている間
  ENEMY_AP_GAUGE_HIDE_IN_TURN = false # ターン中
  ENEMY_AP_GAUGE_HIDE_ANIMATION =     # アニメーション表示中
  [0,] # 7：斬撃/物理　13：刺突/物理
  
end

module ATB_STATUS
  
  # 味方ステータスウインドウの各項目の、位置やゲージ長さなどを調整
  # 
  #   x座標       この値だけ右にずれる　    マイナスの値を指定すると左にずれる
  #   名前幅      この値だけ右に広くなる　　マイナスの値を指定すると狭くなる
  #   個数        この値だけ個数が増える　  マイナスの値を指定すると減る
  #   ゲージ長さ  この値だけ右に長くなる 　 マイナスの値を指定すると短くなる
  # 
  # 参考：画面は横幅544 　全角１文字は幅18　アイコン幅24　標準ゲージ長さ70～90
  # 　　　長すぎる名前は潰れて表示されるが、名前幅を広くすれば潰れない
  # 
  # 注意：個数とゲージ長さは、小さくしすぎるとエラーになる
  
  ATBS = {
    :nax     =>     0,    # アクター名　　　　x座標
    :naw     =>     0,    # アクター名　　　　名前幅
    :stx     =>     0,    # ステートアイコン　x座標
    :stw     =>     0,    # ステートアイコン　個数
    :hpx     =>     0,    # ＨＰゲージ　　　　x座標
    :hpw     =>     0,    # ＨＰゲージ　　　　ゲージ長さ
    :mpx     =>     0,    # ＭＰゲージ　　　　x座標
    :mpw     =>     0,    # ＭＰゲージ　　　　ゲージ長さ
    :tpx     =>     0,    # ＴＰゲージ　　　　x座標
    :tpw     =>     0,    # ＴＰゲージ　　　　ゲージ長さ
    :apx     =>     0,    # ＡＰゲージ　　　　x座標
    :apx     =>     0,    # ＡＰゲージ　　　　x座標
    :apw     =>     0,    # ＡＰゲージ　　　　ゲージ長さ
  }
  
end
