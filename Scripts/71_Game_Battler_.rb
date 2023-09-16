ATB.ver(:Game_Battler2_frame_update, 1.71)

#==============================================================================
# ■ Game_Battler
#==============================================================================
class Game_Battler < Game_BattlerBase
  def frame_update
    ap_update
    state_frame_update
  end
  
  def ap_update
    point = ap_gain_point * ATB::REFRESH_FRAME
    if chanting?
      @chant_count += point
    else
      @ap += point
    end
  end
  
  def ap_gain_point
    result =  agi
    result += (chanting? ? gain_plus_agi_chant : gain_plus_agi_ap)
    result *= (chanting? ? gain_rate_agi_chant : gain_rate_agi_ap)
    result =  ATB::GAUGE_GAIN_MIN if result < ATB::GAUGE_GAIN_MIN
    result += ATB::FRAME_AP_GAIN
    result *= frame_rate_all
    result *= (chanting? ? frame_rate_chant : frame_rate_ap)
    return result
  end
  
  def frame_rate_all
    return fos.inject(1.0) {|r, obj| r * obj.frame_rate_all(nil) }
  end
  def frame_rate_ap
    return fos.inject(1.0) {|r, obj| r * obj.frame_rate_ap(nil) }
  end
  def frame_rate_chant
    return fos.inject(1.0) {|r, obj| r * obj.frame_rate_chant(@chant_type) }
  end
  def gain_plus_agi_ap
    return fos.inject(0.0) {|r, obj| r + obj.gain_plus_agi_ap(nil) }
  end
  def gain_rate_agi_ap
    return fos.inject(1.0) {|r, obj| r * obj.gain_rate_agi_ap(nil) }
  end
  def gain_plus_agi_chant
    return fos.inject(0.0) {|r, obj| r + obj.gain_plus_agi_chant(@chant_type) }
  end
  def gain_rate_agi_chant
    return fos.inject(1.0) {|r, obj| r * obj.gain_rate_agi_chant(@chant_type) }
  end
  def fos
    return feature_objects
  end
  
end

class RPG::BaseItem
  def self.eval_define_atb_speed(name, pattern, default, rate)
    eval <<-EOS
      def #{name}(type)
        return #{default} if type and !gain_agi_chant_type_include?(type)
        unless @#{name}
          @#{name} = @note =~ #{pattern} ? ($1.to_i * #{rate}) : #{default}
        end
        return @#{name}
      end
    EOS
  end
  eval_define_atb_speed('frame_rate_all',       '/<フレーム速度=(\d+)>/', '1.0', '0.01')
  eval_define_atb_speed('frame_rate_ap',    '/<ＡＰフレーム速度=(\d+)>/', '1.0', '0.01')
  eval_define_atb_speed('frame_rate_chant', '/<詠唱フレーム速度=(\d+)>/', '1.0', '0.01')
  eval_define_atb_speed('gain_plus_agi_ap',      '/<ＡＰ敏捷=(\-*\d+)>/', '0.0', '1.0')
  eval_define_atb_speed('gain_rate_agi_ap',      '/<ＡＰ敏捷率=(\d+)>/' , '1.0', '0.01')
  eval_define_atb_speed('gain_plus_agi_chant',   '/<詠唱敏捷=(\-*\d+)>/', '0.0', '1.0')
  eval_define_atb_speed('gain_rate_agi_chant',   '/<詠唱敏捷率=(\d+)>/' , '1.0', '0.01')
  
  def gain_agi_chant_type_include?(type)
    unless @gain_agi_chant_type
      @gain_agi_chant_type =
        @note =~ /<詠唱敏捷タイプ=(\[[\d,]+\])>/ ? eval($1) : []
    end
    return true if @gain_agi_chant_type.empty?
    return @gain_agi_chant_type.include?(type)
  end
end