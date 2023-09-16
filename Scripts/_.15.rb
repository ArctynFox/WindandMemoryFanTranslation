#★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
#
#アイテム・スキル使用時のアクターウインドウの表示を変更します。
#具体的にはアクターの顔が消え、変わりに基本能力が描写されます。
#
#★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★


#==============================================================================
# ■ Window_MenuActor
#------------------------------------------------------------------------------
# 　アイテムやスキルの使用対象となるアクターを選択するウィンドウです。
#==============================================================================
module MARU_MenuActor  
S_SIMPLE_STATUS = ["ATK","DEF","MAG","MDF","SPD","LCK"]
end

class Window_MenuActor < Window_MenuStatus
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #--------------------------------------------------------------------------
  alias maru0075_draw_item draw_item
  def draw_item(index)
    actor = $game_party.members[index]
    enabled = $game_party.battle_members.include?(actor)
    rect = item_rect(index)
    draw_item_background(index)
    draw_actor_simple_status(actor, rect.x + 1, rect.y)
  end
  #--------------------------------------------------------------------------
  # ● シンプルなステータスの描画
  #--------------------------------------------------------------------------
  alias maru0075_draw_actor_simple_status draw_actor_simple_status
  def draw_actor_simple_status(actor, x, y)
    draw_actor_name(actor, x, y)
    draw_actor_level(actor, x + 164, y )
    draw_actor_icons(actor, x + 264, y )
    draw_actor_hp(actor, x + 16, y + line_height * 1)
    draw_actor_mp(actor, x + 16, y + line_height * 2)
    3.times {|i| draw_actor_param_m(actor, x + 164, y + line_height * (i + 1), i) }
    3.times {|i| draw_actor_param_m(actor, x + 264, y + line_height * (i + 1), i+3) }
  end
  #--------------------------------------------------------------------------
  # ● 能力値の描画
  #--------------------------------------------------------------------------
  def draw_actor_param_m(actor, x, y, param_id)
    change_color(system_color)
    draw_text(x, y, 120, line_height, MARU_MenuActor::S_SIMPLE_STATUS[(param_id)])
    change_color(normal_color)
    draw_text(x + 60, y, 36, line_height, actor.param(param_id + 2), 2)
  end
end