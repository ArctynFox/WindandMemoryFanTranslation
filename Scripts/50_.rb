class Game_Battler < Game_BattlerBase
  $atb_ap_gauge_color_new = true  # ここは変更しないでください
  
  #-----------------------------------------------------------------------------
  
    # color[0] :背景　color[1] :左側　color[2] :右側
  
  #-----------------------------------------------------------------------------
  
  def ap_gauge_color_nil  # 詠唱中でない時のＡＰゲージ色
    color    = []   # ここは変更しないでください
    
    # 基本色
    color[0] = Color.new( 51,  51,  51)   # text_color(19)と同じ
    color[1] = Color.new(0,  200, 0)   # text_color(30)
    color[2] = Color.new(0, 200, 0)   # text_color(31)
    
    if cst(0, 0)  # ステート27か29が付加されている
      color[1] = Color.new(240, 192,  64)
      color[2] = Color.new(255, 255,  64)
    end
    
    if cst(0)      # ステート40　狂戦士化
      color[1] = Color.new(240, 192,  64)
      color[2] = Color.new(255, 255,  64)
    elsif cst(0)   # ステート44　魔道の真髄(40が付加されていない時のみ)
      color[1] = Color.new(226, 266,   0)
      color[2] = Color.new(164, 245,   0)
    elsif cst(0)   # ステート37  スロウ(40,44が付加されていない時のみ)
      color[1] = Color.new(160, 148, 224)
      color[2] = Color.new(192, 180, 255)
    end
    # 条件分岐は if～end で１セット
    # この条件分岐を最も優先させたいので一番下に置く
    #   上のセット（ステート27など）に合致していても、
    #   それより下のセット（ここなど）に合致すれば上書きされる
    if cst(0)      # ステート39　ストーン
      color[0] = Color.new( 64,  64,  64)
      color[1] = Color.new(160, 160, 160)
      color[2] = Color.new(160, 160, 160)
    end
    
    return color  # ここは変更しないでください
  end
  
  #-----------------------------------------------------------------------------
  
  def ap_gauge_color_1  # 詠唱タイプ１の時のゲージ色
    color    = []   # ここは変更しないでください
    
    # 基本色
    color[0] = Color.new( 32,  32,  64)
    color[1] = Color.new(255, 156,  64)
    color[2] = Color.new(255,  59,   0)
    
    if cst(0, 0)  # ステート28か29
      color[1] = Color.new(226, 266,   0)
      color[2] = Color.new(164, 245,   0)
    end
    
    # ステート40（狂戦士化）の間は詠唱できないのでここに設定する必要はない
    if cst(0)        # ステート37  スロウ
      color[1] = Color.new(255, 156, 154)
      color[2] = Color.new(255,  59,  90)
    end
    if cst(0)        # ステート39　ストーン
      color[0] = Color.new( 64,  64,  64)
      color[1] = Color.new(160, 160, 160)
      color[2] = Color.new(160, 160, 160)
    end
    
    return color
  end
  
  #-----------------------------------------------------------------------------
  
  def ap_gauge_color_2  # 詠唱タイプ２の時のゲージ色
    color    = []   # ここは変更しないでください
    
    # 基本色
    color[0] = Color.new( 32,  32,  64)
    color[1] = Color.new(165, 251, 255)
    color[2] = Color.new(100, 251, 255)
    
    if cst(0, 0)  # ステート28か29
      color[1] = Color.new(226, 266,   0)
      color[2] = Color.new(164, 245,   0)
    end
    
    if cst(0)      # ステート44　魔道の真髄
      color[1] = Color.new(226, 266,   0)
      color[2] = Color.new(164, 245,   0)
    elsif cst(0)   # ステート37  スロウ
      color[1] = Color.new( 45, 255,  58)
      color[2] = Color.new( 10, 255,  58)
    end
    if cst(0)      # ステート39　ストーン
      color[0] = Color.new( 64,  64,  64)
      color[1] = Color.new(160, 160, 160)
      color[2] = Color.new(160, 160, 160)
    end
    
    return color
  end
  
  #-----------------------------------------------------------------------------
  
  def ap_gauge_color_3  # 詠唱タイプ３
    
    return ap_gauge_color_2
    # 詠唱タイプ２の時と同じ設定にしたい場合はこうする
    #   詠唱中でない時と同じ設定にするには「return ap_gauge_color_nil」
  end
  
  #-----------------------------------------------------------------------------
  
  def ap_gauge_color_4  # 詠唱タイプ４
    color    = []   # ここは変更しないでください
    
    color[0] = Color.new( 32,  32,  64)
    color[1] = Color.new(160,  96, 224)
    color[2] = Color.new(192, 128, 255)
    
    return color
  end
  
  #-----------------------------------------------------------------------------
  
  # サンプルではタイプ４まで用意していますが、
  # もっと必要ならその分増やしてください
  
end