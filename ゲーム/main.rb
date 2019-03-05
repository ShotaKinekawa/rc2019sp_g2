# 基本となるdxrubyとchipmunkライブラリを読み込む
require 'dxruby'
require 'chipmunk'

# chipmunkをより簡潔に使えるようにするためのラッパー（本講習独自作成）を読み込む
require_relative 'lib/cp'


# ウィンドウのサイズを設定
Window.width = 800
Window.height = 600

# ゲームウィンドウを生成し、メインループを開始する
# 本メソッド（Window.loop）は、プログラム中に1個までとする）
Window.loop do
    # ESCキー押下にてゲームを終了（メインループを抜ける）
    break if Input.key_push?(K_ESCAPE)
  
    
  end
  

