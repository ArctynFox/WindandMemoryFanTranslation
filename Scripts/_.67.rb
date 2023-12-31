#==============================================================================
# ■ RGSS3 ステート解除時ステート Ver2.02 by 星潟
#------------------------------------------------------------------------------
# 特定のステート解除時に、自動的に付与されるステートを作成します。
#------------------------------------------------------------------------------
# ★設定例
#------------------------------------------------------------------------------
# <解除時ステート:2,3>
# このステートが解除された際、ステート2と3にかかる。
# この効果は有効度が0の場合とステート無効の場合は無効となる。
# （有効度が1以上99以下であっても、0以外の場合は無視する）
#------------------------------------------------------------------------------
# <強制解除時ステート:2,3>
# このステートが解除された際、ステート2と3にかかる。
# このステート付与は有効度の影響を受けない。
# （ステート無効の影響は受ける）
#------------------------------------------------------------------------------
# <自然解除時ステート:2,3>
# このステートがターン経過・歩数によって解除された際、ステート2と3にかかる。
# この効果は有効度が0の場合とステート無効の場合は無効となる。
# （有効度が1以上99以下であっても、0以外の場合は無視する）
#------------------------------------------------------------------------------
# <強制自然解除時ステート:2,3>
# このステートがターン経過・歩数によって解除された際、ステート2と3にかかる。
# このステート付与は有効度の影響を受けない。
# （ステート無効の影響は受ける）
#------------------------------------------------------------------------------
# <戦闘終了時解除付与有効>
# 通常、このスクリプトの効果は戦闘終了時の解除には効果がありませんが
# このキーワードが指定されたステートについては戦闘終了時の解除時も影響します。
# （ただし、処理が繰り返されないので、これによって付与されたステートも
#   戦闘終了時に解除されるステートだった場合は、そちらは解除されません）
#==============================================================================
# Ver1.01
# 該当ステートがかかっていない状態でも、そのステートを解除しようとした際に
# ステート解除時ステートの効果が発動してしまう不具合を修正しました。
# Ver1.02
# 複数ステート指定時、正常に機能しない不具合を修正しました。
# Ver1.03
# キャッシュ化等による処理高速化を行いました。
# Ver1.04
# 自然解除時用の処理を追加しました。
# 解除時の物と違い、ステートの効果時間が切れた際にのみ新規ステートが付与されます。
# Ver1.05
# 記述ミスを修正。
# Ver2.00
# 更に処理を効率化。
# 戦闘終了時のステート解除時には解除時ステート判定を行わないように変更。
# これに併せて、戦闘終了時のステート解除時にも解除時ステート判定を
# 行うようにするステートの設定機能を追加。
# Ver2.01
# キャッシュ化に失敗している箇所があったので修正。
#==============================================================================
module RST_STATE
  
  Word = []
  
  #解除時ステート（有効度判定有り）設定用キーワードを指定します。
  
  Word[0] = "解除時ステート"
  
  #解除時ステート（有効度判定無し）設定用キーワードを指定します。
  
  Word[1] = "強制解除時ステート"
  
  #自然解除時ステート（有効度判定有り）設定用キーワードを指定します。
  
  Word[2] = "自然解除時ステート"
  
  #自然解除時ステート（有効度判定無し）設定用キーワードを指定します。
  
  Word[3] = "強制自然解除時ステート"
  
  #戦闘終了時のステート解除でも解除時ステート判定を行うようにするステートの
  #設定用キーワードを指定します。
  
  Word[4] = "戦闘終了時解除付与有効"
  
end

class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # ステート自動解除
  #--------------------------------------------------------------------------
  alias remove_states_rst_state remove_states_auto
  def remove_states_auto(timing)
    @auto_remove_time_flag = true
    remove_states_rst_state(timing)
    @auto_remove_time_flag = nil
  end
  #--------------------------------------------------------------------------
  # ステートの解除
  #--------------------------------------------------------------------------
  alias remove_state_rst_state remove_state
  def remove_state(state_id)
    return unless state?(state_id)
    state_add_state(state_id)
    remove_state_rst_state(state_id)
  end
  def state_add_state(state_id)
    s = $data_states[state_id]
    return if @bers_flag && !s.battle_end_rst_state
    s.rst_state(0).each {|i| add_state(i)  if state_rate(i) > 0}
    s.rst_state(1).each {|i| add_state(i)}
    return if @auto_remove_time_flag == nil
    s.rst_state(2).each {|i| add_state(i)  if state_rate(i) > 0}
    s.rst_state(3).each {|i| add_state(i)}
  end
  #--------------------------------------------------------------------------
  # 戦闘用ステートの解除
  #--------------------------------------------------------------------------
  alias remove_battle_states_rst_state remove_battle_states
  def remove_battle_states
    @bers_flag = true
    remove_battle_states_rst_state
    @bers_flag = false
  end
end
class RPG::State < RPG::BaseItem
  #--------------------------------------------------------------------------
  # 解除時ステートデータまとめ
  #--------------------------------------------------------------------------
  def rst_state(type)
    @rst_state ||= {}
    @rst_state[type] ||= rst_state_make(type)
  end
  #--------------------------------------------------------------------------
  # 解除時ステートデータ作成
  #--------------------------------------------------------------------------
  def rst_state_make(type)
    /<#{RST_STATE::Word[type]}[：:](\S+)>/ =~ note ? $1.to_s.split(/\s*,\s*/).inject([]) {|r,i| r.push(i.to_i)} : []
  end
  #--------------------------------------------------------------------------
  # 戦闘終了時のステート解除でも解除判定を行うか？
  #--------------------------------------------------------------------------
  def battle_end_rst_state
    (@battle_end_rst_state ||= /<#{RST_STATE::Word[4]}>/ =~ note ? 1 : 0) == 1
  end
end