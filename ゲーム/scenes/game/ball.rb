# 操作対象となるプレイヤーキャラクタ
class Ball < CPCircle
    # 衝突判定区分を設定
    COLLISION_TYPE = 1
   def initialize(x, y, r, mass, color, image = nil, e = 0.7, u = 0.3)
        @x = x
        @y = y
        @r = r
        super
    end
    # 1フレーム分の移動ロジック
    # キーボードの左右とスペースキーを受け付け、それぞれの方向に加速度を与える
    # 左右キーは押しっ放しに対応する。
    # スペースキーは押下時のみ反応
    def move
    end
  

end