# 同じディレクトリにある「player.rb」「enemy.rb」を読み込む
# 結果、それらの中に定義されているPlayerクラス・Enemyクラスがこのプログラム内で使えるようになる
require_relative 'player'
require_relative 'enemy'

# ゲームの進行を司るクラスを定義する
# main.rbを無暗に長くしたくないので、ゲームにまつわる複雑な部分はこのクラスで吸収・隠ぺいする。
class Director
  def initialize
    # 物理演算空間を作成
    @space = CP::Space.new
    # 物理演算空間に重力を設定（鉛直方向に強さ500）
    @space.gravity = CP::Vec2.new(0, 500)

    # 衝突時に表示する画像を読み込み、画像中の白色を透明色に設定
    star_img = Image.load('images/star.png')
    star_img.set_color_key(C_WHITE)

    # オブジェクトがウィンドウの描画範囲を逸脱しないよう、描画範囲のすぐ外側の4方向に固定の壁
    # を設置する。
    CPBase.generate_walls(@space)
    # プレイヤーオブジェクト（円オブジェクト）作成
    player = Player.new(21, 300, 20, 1, C_BLUE)
    # プレイヤーオブジェクトを物理演算空間に登録
    @space.add(player)

    # ゲーム世界に登場する全てのオブジェクトを格納する配列を定義
    @objects = [player]

    # ゲーム世界に障害物となる静的BOXを追加
    block = CPStaticBox.new(200, 350, 600, 400)
    @space.add(block)
    @objects << block

    # 敵キャラクタ（四角形）を10個ほど生成して、物理演算空間に登録＆@objecctsに格納
    10.times do
      e = Enemy.new(100 + rand(500), 100 + rand(300), 30, 30, 10, C_RED)
      @space.add(e)
      @objects << e
    end

    # プレイヤーオブジェクトと敵オブジェクトが衝突した際の振る舞いを定義する
    # 以下の定義にて、プレイヤーと敵が衝突した際に、自動的にブロックの内容が実行される。
    # ブロック引数の意味はそれぞれ以下の通り。
    # a: 衝突元（この場合はプレイヤー）のshapeオブジェクト
    # b: 衝突先（この場合は敵）のshapeオブジェクト
    # arb: 衝突情報を保持するArbiterオブジェクト
    # ※ 本プログラムでは、各shapeにattr_accessorでparent_objを定義してある。
    # 　 例えば、playerオブジェクトを得る場合は a.parent_obj のようにすると取得できる
    @space.add_collision_handler(Player::COLLISION_TYPE, Enemy::COLLISION_TYPE) do |a, b, arb|
      # 衝突個所（arb.points配列）から、先頭の1つを取得（複数個所ぶつかるケースもあり得るため配列になっている）
      pos = arb.points.first.point
      # 衝突個所の座標に絵を表示（1フレームで消える点に留意）
      Window.draw(pos.x, pos.y, star_img)
    end
  end

  # main.rb側のWindow.loop内で呼ばれるメソッド
  def play
    # ゲーム空間に配置された全てのオブジェクトに対して同じ処理を実施して回る
    @objects.each do |obj|
      obj.move  # 1フレーム分の移動処理
      obj.draw  # 1フレーム分の描画処理
    end

    # 物理演算空間内の時間を1/60秒進める（1フレーム分の時間進行）
    @space.step(1 / 60.0)
  end
end
