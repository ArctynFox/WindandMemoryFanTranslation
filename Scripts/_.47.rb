#==============================================================================
# ■ RGSS3 移動可否判定リージョン Ver1.01 by 星潟
#------------------------------------------------------------------------------
# 指定した場所のリージョンIDが特定の値である場合
# タイルによる移動判定を無視して移動可否を決定します。
# これにより、プレイヤーは通行できるがイベントが通行できない座標や
# 逆にイベントが通行できるがプレイヤーは通行できない座標が作成出来ます。
#==============================================================================
# イベントの名前欄に指定
#------------------------------------------------------------------------------
# <POKR:59>
# 
# このイベントはEOKの設定に加え、リージョンID59も移動可能になる。
#------------------------------------------------------------------------------
# <POKR:58,59>
# 
# このイベントはEOKの設定に加え、リージョンID58・59も移動可能になる。
#------------------------------------------------------------------------------
# <PNGR:59>
# 
# このイベントはENGの設定に加え、リージョンID59も移動不可になる。
#------------------------------------------------------------------------------
# <PNGR:58,59>
# 
# このイベントはENGの設定に加え、リージョンID58・59も移動不可になる。
#==============================================================================
module SuperPassableRegion
  
  Word1 = "POKR"
  
  Word2 = "PNGR"
  
  #イベントの通行可リージョンIDの配列を設定。「,」で区切って複数設定可能。
  #名前欄の設定に自動的に追加されます。
  
  EOK = [50]
  
  #イベントの通行不可リージョンIDの配列を設定。「,」で区切って複数設定可能。
  #名前欄の設定に自動的に追加されます。
  
  ENG = []
  
  #プレイヤーの通行可リージョンIDの配列を設定。「,」で区切って複数設定可能。
  
  POK = []
  
  #プレイヤーの通行不可リージョンIDの配列を設定。「,」で区切って複数設定可能。
  
  PNG = [50]
  
end
class Game_CharacterBase
  #--------------------------------------------------------------------------
  # マップ通行可能判定
  #--------------------------------------------------------------------------
  alias map_passable_super_passable_region? map_passable?
  def map_passable?(x, y, d)
    case super_passable_region?(x, y)
    when 1;return true
    when 2;return false
    end
    map_passable_super_passable_region?(x, y, d)
  end
  #--------------------------------------------------------------------------
  # リージョンによる通行可否判定
  #--------------------------------------------------------------------------
  def super_passable_region?(x, y)
    0
  end
end
class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # リージョンによる通行可否判定
  #--------------------------------------------------------------------------
  def super_passable_region?(x, y)
    r = $game_map.region_id(x, y)
    return 1 if @event.super_passable_region[:ok].include?(r)
    return 2 if @event.super_passable_region[:ng].include?(r)
    0
  end
end
class RPG::Event
  #--------------------------------------------------------------------------
  # リージョンによる通行可否
  #--------------------------------------------------------------------------
  def super_passable_region
    @super_passable_region ||= create_super_passable_region
  end
  #--------------------------------------------------------------------------
  # リージョンによる通行可否データの作成
  #--------------------------------------------------------------------------
  def create_super_passable_region
    h = {:ok => SuperPassableRegion::EOK.clone,:ng => SuperPassableRegion::ENG.clone}
    $1.to_s.split(/\s*,\s*/).each {|i| h[:ok].push(i.to_i)} if /<#{SuperPassableRegion::Word1}[:：](\S+)>/ =~ name
    $1.to_s.split(/\s*,\s*/).each {|i| h[:ng].push(i.to_i)} if /<#{SuperPassableRegion::Word2}[:：](\S+)>/ =~ name
    h
  end
end
class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # リージョンによる通行可否判定
  #--------------------------------------------------------------------------
  def super_passable_region?(x, y)
    r = $game_map.region_id(x, y)
    return 1 if SuperPassableRegion::POK.include?(r)
    return 2 if SuperPassableRegion::PNG.include?(r)
    0
  end
end