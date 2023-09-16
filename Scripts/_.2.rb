#==============================================================================
# ★ RGSS3_使用者効果 Ver1.01
#==============================================================================
=begin

作者：tomoaky
webサイト：ひきも記は閉鎖しました。 (http://hikimoki.sakura.ne.jp/)

スキルやアイテムに、対象への効果とは別に使用者への効果を追加できます

スキル（アイテム）のメモ欄に <使用者効果 2> と書くことで
指定した番号のスキル効果が使用者に適用されます

2015/09/17  Ver1.01
・敵が逃げるとエラー落ちする不具合を修正

2013/06/18  Ver1.0
公開

=end

#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● スキル／アイテムの使用
  #--------------------------------------------------------------------------
  alias tmusereff_scene_battle_use_item use_item
  def use_item
    tmusereff_scene_battle_use_item
    return unless @subject.current_action
    item = @subject.current_action.item
    if item.is_a?(RPG::UsableItem) && /<使用者効果\s*(\d+)\s*>/ =~ item.note
      reaction_skill = $data_skills[$1.to_i]
      @subject.item_apply(@subject, reaction_skill)
      refresh_status
      @log_window.display_action_results(@subject, reaction_skill)
    end
  end
end

