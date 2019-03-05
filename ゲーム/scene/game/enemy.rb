# 空中に漂う四角形の物体（敵キャラ的位置づけ）
class Enemy < CPBox
  # 衝突判定区分を設定
  COLLISION_TYPE = 2

  # 1フレーム毎の移動ロジック
  # 重力に逆らう方向に1フレーム分の加速度を与える
  def move
    apply_force(0, -83)
  end
end
