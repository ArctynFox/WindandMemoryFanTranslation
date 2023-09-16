#==============================================================================
# ■ RGSS3 戦闘背景変更の戦闘中反映 Ver1.03　by 星潟
#------------------------------------------------------------------------------
# イベントコマンド「戦闘背景変更」を戦闘中に使用した場合、
# 本来はその次の戦闘から背景変更が適用され、その戦闘中の背景は変わりませんが
# このスクリプトを導入している場合、その戦闘中に変更が反映されます。
#==============================================================================
# 戦闘中に戦闘背景変更のイベントコマンドを実行する際、コマンド前に
# イベントコマンドのスクリプトで「present_battlebackchange」(鍵括弧は除く)と
# 記入すると、戦闘終了後に、戦闘背景変更前の設定に元に戻ります。
#------------------------------------------------------------------------------
# Ver1.01  その戦闘中での変更に限定させる機能を追加。
# Ver1.02  戦闘中での使用とそれ以外の使用での処理の違いを厳格化。
# Ver1.02a 誤字修正。
# Ver1.03  背景が存在しない状態から変更を行った際の処理を修正。
#          戦闘テストでも動作するように処理を変更。
#==============================================================================
class Game_Temp
  attr_accessor :present_battleback
  attr_accessor :present_battlechange
end
class Game_Map
  #--------------------------------------------------------------------------
  # 戦闘背景の変更
  #--------------------------------------------------------------------------
  alias change_battleback_in_battle change_battleback
  def change_battleback(battleback1_name, battleback2_name)
    flag1 = SceneManager.scene_is?(Scene_Battle)
    flag2 = $game_temp.present_battlechange
    flag3 = $game_temp.present_battleback
    if flag1
      if flag2
        $game_temp.present_battleback = [@battleback1_name,@battleback2_name] if !flag3
      else
        $game_temp.present_battleback = nil
      end
    end
    if $BTEST
      $data_system.battleback1_name = battleback1_name
      $data_system.battleback2_name = battleback2_name
    else
      change_battleback_in_battle(battleback1_name, battleback2_name)
    end
    SceneManager.scene.apply_change_battleback if flag1
    $game_temp.present_battlechange = nil
  end
end
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # 戦闘背景変更の適用
  #--------------------------------------------------------------------------
  def apply_change_battleback
    @spriteset.apply_change_battleback
  end
  #--------------------------------------------------------------------------
  # 終了処理
  #--------------------------------------------------------------------------
  alias terminate_battleback_change terminate
  def terminate
    terminate_battleback_change
    array = $game_temp.present_battleback
    return unless array
    $game_map.change_battleback(array[0],array[1])
    $game_temp.present_battleback = nil
  end
end
class Spriteset_Battle
  #--------------------------------------------------------------------------
  # 戦闘背景変更の適用
  #--------------------------------------------------------------------------
  def apply_change_battleback
    r = @back1_sprite.bitmap.rect
    @back1_sprite.bitmap.dispose if r.width + r.height == 2
    @back1_sprite.bitmap = battleback1_bitmap
    r = @back2_sprite.bitmap.rect
    @back2_sprite.bitmap.dispose if r.width + r.height == 2
    @back2_sprite.bitmap = battleback2_bitmap
  end
end
class Game_Interpreter
  #--------------------------------------------------------------------------
  # 現在の戦闘背景のみを変更
  #--------------------------------------------------------------------------
  def present_battlebackchange
    $game_temp.present_battlechange = true
  end
end