#==============================================================================
# RGSS3 変数表示ウィンドウ(メニュー画面追加) Ver1.00
#==============================================================================
=begin
  Author:ぷり娘
web site:Sister's Eternal 4th(Ancient)
     URL:http://pricono.whitesnow.jp/
使用許可:特に必要ありませんが、ゲーム内やReadmeなどに
　　　　 名前を記載してくれるとうれしいです。

データベースの変数を表示できるウィンドウを追加します。
使用方法は、このスクリプトを追加するだけです。

設定項目に従い、色々と設定してください。

2012.12.06  Ver1.00　とりあえず公開
=end

module Prico

  #表示用スイッチ番号(指定したスイッチがONになったら表示されます)
  #0を指定すると無条件で表示します。
  Disp_SW = 0

  # 表示する変数の番号。0は禁止
  Var_Num = 38

  # ウィンドウのタイトル文字列(半角で15文字以下にすること)
  Var_Prefix = "Sen"

  # 単位(半角で13文字以下にすること)。不要ならnil
  Var_Suffix = nil
  
  # 数値表示位置(X:横座標)補正
  # (Var_Suffixで指定した文字列で計算してね)
  # 半角文字:10(9)、全角文字:20(18) * 文字数
  # 例: "Point"の場合は50(45)、"メダル"の場合は60(54)などなど
  Num_Adj = 9

  #ウィンドウの位置補正(Y:縦座標)
  #所持金ウィンドウのすぐ上に表示するときは305で。
  WindowY = 370

end


class Window_Var < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    if Prico::Disp_SW == 0 || $game_switches[Prico::Disp_SW] == true
      super(0, 0, 160,fitting_height(2) - 8)
      self.contents = Bitmap.new(width - 24, height - 24)# - 32)
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    text = $game_variables[Prico::Var_Num]
    self.contents.font.color = system_color
    self.contents.draw_text(0, -2, width + 28,line_height,Prico::Var_Prefix,0)
    self.contents.draw_text(0,line_height - 4, 138,line_height,Prico::Var_Suffix,2)
    self.contents.font.color = normal_color
    self.contents.draw_text(0,line_height - 4, 128 - Prico::Num_Adj, line_height, text, 2)
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    refresh
  end
end

class Scene_Menu
  alias var_start start
  def start
    var_start
    if Prico::Disp_SW == 0 || $game_switches[Prico::Disp_SW] == true
      @Var_window = Window_Var.new
      @Var_window.x = 0
      @Var_window.y = Prico::WindowY
    end
  end
end
