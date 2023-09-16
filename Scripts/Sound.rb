#==============================================================================
# ■ Sound
#------------------------------------------------------------------------------
# 　効果音を演奏するモジュールです。グローバル変数 $data_system からデータベー
# スで設定された SE の内容を取得し、演奏します。
#==============================================================================

module Sound

  # システム効果音
  def self.play_system_sound(n)
    $data_system.sounds[n].play
  end

  # カーソル移動
  def self.play_cursor
    play_system_sound(0)
  end

  # 決定
  def self.play_ok
    play_system_sound(1)
  end

  # キャンセル
  def self.play_cancel
    play_system_sound(2)
  end

  # ブザー
  def self.play_buzzer
    play_system_sound(3)
  end

  # 装備
  def self.play_equip
    play_system_sound(4)
  end

  # セーブ
  def self.play_save
    play_system_sound(5)
  end

  # ロード
  def self.play_load
    play_system_sound(6)
  end

  # 戦闘開始
  def self.play_battle_start
    play_system_sound(7)
  end

  # 逃走
  def self.play_escape
    play_system_sound(8)
  end

  # 敵の通常攻撃
  def self.play_enemy_attack
    play_system_sound(9)
  end

  # 敵ダメージ
  def self.play_enemy_damage
    play_system_sound(10)
  end

  # 敵消滅
  def self.play_enemy_collapse
    play_system_sound(11)
  end

  # ボス消滅 1
  def self.play_boss_collapse1
    play_system_sound(12)
  end

  # ボス消滅 2
  def self.play_boss_collapse2
    play_system_sound(13)
  end

  # 味方ダメージ
  def self.play_actor_damage
    play_system_sound(14)
  end

  # 味方戦闘不能
  def self.play_actor_collapse
    play_system_sound(15)
  end

  # 回復
  def self.play_recovery
    play_system_sound(16)
  end

  # ミス
  def self.play_miss
    play_system_sound(17)
  end

  # 攻撃回避
  def self.play_evasion
    play_system_sound(18)
  end

  # 魔法回避
  def self.play_magic_evasion
    play_system_sound(19)
  end

  # 魔法反射
  def self.play_reflection
    play_system_sound(20)
  end

  # ショップ
  def self.play_shop
    play_system_sound(21)
  end

  # アイテム使用
  def self.play_use_item
    play_system_sound(22)
  end

  # スキル使用
  def self.play_use_skill
    play_system_sound(23)
  end

end
