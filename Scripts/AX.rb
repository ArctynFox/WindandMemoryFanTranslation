############################################################################
# RM内存自动清理脚本（XP&VX） v 1.00
# 作者：精灵使者 创意：夏娜 各种压力的猫君
# 按惯例，此类脚本应该放在最上面，就会自动工作。
# 使用方法：直接插入脚本的最上面即可
# 如果感觉卡机，请修改GC_FREQ
############################################################################
  #--------------------------------------------------------------------------
  # ● 设定部分
  #--------------------------------------------------------------------------
module GC_CLEAR
 GC_FREQ = 20 #清理内存的频率（如果卡机，请调大清理频率，默认1秒整理1次）
 GC_TRANSITION = true #场景变换的时候是否立即清理，默认开启
end
  #--------------------------------------------------------------------------
  # ● 创建自动清理线程
  #--------------------------------------------------------------------------
if @gc_thread.nil?
 @gc_thread = Thread.new{loop{GC.start;sleep(GC_CLEAR::GC_FREQ)}}
end
  #--------------------------------------------------------------------------
  # ● 场景变换时清理部分
  #--------------------------------------------------------------------------
class << Graphics
alias origin_transition transition unless method_defined? :origin_transition
alias origin_freeze freeze unless method_defined? :origin_freeze

def transition(*args)
  origin_transition(*args)
  GC.start if GC_CLEAR::GC_TRANSITION
end
def freeze
  origin_freeze
  GC.start if GC_CLEAR::GC_TRANSITION
end
end