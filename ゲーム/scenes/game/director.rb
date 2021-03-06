# 同じディレクトリにある「Ball.rb」「trigger.rb」を読み込む
# 結果、それらの中に定義されているBallクラス・triggerクラスがこのプログラム内で使えるようになる
require_relative 'ball'
require_relative 'trigger'
require_relative 'block'
require_relative '../../lib/cp'
require_relative 'strike'

BLOCK_ROW   = 12
BROCK_LINE  = 7

# ゲームの進行を司るクラスを定義する
# main.rbを無暗に長くしたくないので、ゲームにまつわる複雑な部分はこのクラスで吸収・隠ぺいする。
module Game
  class Director
    def initialize
      # 物理演算空間を作成
      @space = CP::Space.new
      # 物理演算空間に重力を設定（鉛直方向に強さ500）
      @space.gravity = CP::Vec2.new(0, 500)

     # 衝突時に表示する画像を読み込み、画像中の白色を透明色に設定
      star_img = Image.load('images/star.png')
      star_img.set_color_key(C_WHITE)
    
     
			@cnt = 0
			@restart = 0
			@clear_flg = false
			@font = Font.new(25)
			@font_ruby = Font.new(20)

			@stage_cnt = 1

			@restart_time = Time.now
			@start_time = Time.now
			@elapsed_time = 0


      @ball = Ball.new(200, 450, 13, 0.1, C_BLUE)
      @objects = [@ball]
      

      @sound = Sound.new("BGM/PerituneMaterial_Demise.wav")
      @sound.loop_count = -1
      @start = 0
      

      @space.add(@ball)
      

      grand = Grand.new(1, 648, 500, 650)
      grand.shape.e = 0
      grand.shape.u = 0
      @space.add(grand)
      @objects << grand
      
      # ブロックの初期化
      @block_num = 0
      @clear_reset_times = 0
      @deleting_blocks = []
        BLOCK_ROW.times do |i|
          BROCK_LINE.times do |j|
            next if (i + j) % 2 == 0 && j > @clear_reset_times
            block = Block.new(50 + (Block::WIDTH + 5) * i,
                                100 + (Block::HIGHT + 5)* j,

                                0.8,
                                0.8)
            @objects << block
            @space.add(block)
            @block_num += 1
          end
        end


      # オブジェクトがウィンドウの描画範囲を逸脱しないよう、描画範囲のすぐ外側の4方向に固定の壁
      # を設置する。
      CPBase.generate_walls(@space)
      # プレイヤーオブジェクト（円オブジェクト）作成
      # プレイヤーオブジェクトを物理演算空間に登録

      # ゲーム世界に登場する全てのオブジェクトを格納する配列を定義
     
     
      # ゲーム世界に障害物となる静的BOXを追加
      # block = CPStaticBox.new(200, 350, 600, 400)
      # @space.add(block)
      # @objects << block

      #弾かない箱を2つ生成して、物理演算空間に登録＆@objecctsに格納
    
      e = Trigger.new(-27 , 500 , 200, 50, Float::INFINITY, 30)
      @space.add(e)
      @objects << e
      e = Trigger.new(320 , 500 , 200, 50, Float::INFINITY, 150)
      @space.add(e)
      @objects << e
  
      #弾く箱を2つ生成して，物理演算空間に登録＆@objecctsに格納
      st = Strike.new(160, 580, 70, 17, 10, 30)
      @space.add(st)
      @objects << st
      st = Strike.new(264, 580, 70, 17, 10, 150)
      @space.add(st)
      @objects << st

      # プレイヤーオブジェクトと敵オブジェクトが衝突した際の振る舞いを定義する
      # 以下の定義にて、プレイヤーと敵が衝突した際に、自動的にブロックの内容が実行される。
      # ブロック引数の意味はそれぞれ以下の通り。
      # a: 衝突元（この場合はプレイヤー）のshapeオブジェクト
      # b: 衝突先（この場合は敵）のshapeオブジェクト
      # arb: 衝突情報を保持するArbiterオブジェクト
      # ※ 本プログラムでは、各shapeにattr_accessorでparent_objを定義してある。
      # 　 例えば、ballオブジェクトを得る場合は a.parent_obj のようにすると取得できる
      @space.add_collision_handler(Ball::COLLISION_TYPE, Trigger::COLLISION_TYPE) do |a, b, arb|
       # 衝突個所（arb.points配列）から、先頭の1つを取得（複数個所ぶつかるケースもあり得るため配列になっている）
        pos = arb.points.first.point
       # 衝突個所の座標に絵を表示（1フレームで消える点に留意）
        Window.draw(pos.x, pos.y, star_img)
      end
      @space.add_collision_handler(Ball::COLLISION_TYPE, Block::COLLISION_TYPE) do |a, b, arb|
				@cnt += 1
        @deleting_blocks << b.parent_obj
      end

      @space.add_collision_handler(Ball::COLLISION_TYPE, Strike::COLLISION_TYPE) do |a,b, arb|
        	sound = Sound.new("BGM/se_maoudamashii_battle10.wav")
        	sound.set_volume(200.0)
        	sound.play
      end

      @space.add_collision_handler(Ball::COLLISION_TYPE, 
        Grand::COLLISION_TYPE) do |a,b, arb|
        @elapsed_time += (@now_time - @start_time).to_i
        sound = Sound.new("BGM/se_maoudamashii_explosion05.wav")
        sound.set_volume(255.0)
        sound.play
	      scene_transition_collision
	    end
    end
  
      def reset
				
        @space.remove(@ball)
        @objects.delete(@ball)
        @ball = Ball.new(200, 450, 13, 0.1, C_BLUE)
        @space.add(@ball)
        @objects << @ball

        @start_time = Time.now
        
      #   if @start == 0
      #     @sound.play
      #     @start += 1
      #  end

        
        if @clear_flg == true
          @sound.set_volume(255.0)
          @sound.play

          #ブロックの再構築
          @block_num = 0
          @clear_reset_times += 1
					BLOCK_ROW.times do |i|
            BROCK_LINE.times do |j|
              next if (i + j) % 2 == 1 && j > @clear_reset_times

							block = Block.new(50 + (Block::WIDTH + 5) * i,
											100 + (Block::HIGHT + 5)* j,
											0.8,
											0.8)
							@objects << block
              @space.add(block)
              @block_num += 1
						end
					end
						@cnt = 0
						@elapsed_time = 0
						@restart = 0
						@clear_flg = false
						@stage_cnt += 1
				end
      end


  	#追加
    def premove
      reset
    end

# main.rb側のWindow.loop内で呼ばれるメソッド
    def play
      Window.draw_font(260, 627, 'RubyCamp 2019 Spring CIS', @font_ruby , color: C_RED)

      #イベントハンドラーの中で削除するとエラーが出たのでこのタイミングで削除する
      @deleting_blocks.each do |block|
        @objects.delete(block)
      	@space.remove(block)
      end
    
      # ゲーム空間に配置された全てのオブジェクトに対して同じ処理を実施して回る
      
      @objects.each do |obj|
        obj.move  # 1フレーム分の移動処理
        obj.draw  # 1フレーム分の描画処理
      end

     #BGM
     if @start == 0
        @sound.set_volume(255.0)
				@sound.play
        @start += 1
     end
     #p @start
		 #リスタート数の表示
		 if @restart <= 9
		 	Window.draw_font(365, 5, "Restart    #{@restart}", @font, color: C_WHITE)
		 else
			Window.draw_font(365, 5, "Restart  #{@restart}", @font, color: C_WHITE)
		 end

		 Window.draw_font(10, 10, "STAGE: #{@stage_cnt}", @font, color: C_WHITE)


		@now_time = Time.now
 		@diff_time = @elapsed_time + (@now_time - @start_time).to_i
		@min = @diff_time / 60
		@sec = @diff_time % 60
		if @min <=9 && @sec <=9
	 		Window.draw_font(365, 30, "Time  0#{@min}:0#{@sec}", @font ,color: C_WHITE) 
		elsif @min >= 10 && @sec >= 10
			Window.draw_font(365, 30, "Time  #{@min}:#{@sec}", @font ,color: C_WHITE)
		elsif @min <= 9 && @sec >= 10
			Window.draw_font(365, 30, "Time  0#{@min}:#{@sec}", @font ,color: C_WHITE)
		elsif @min >= 10 && @sec <= 9
			Window.draw_font(365, 30, "Time  #{@min}:0#{@sec}", @font ,color: C_WHITE)
		end

		
    # 物理演算空間内の時間を1/60秒進める（1フレーム分の時間進行）
      @space.step(1 / 60.0)


				if @cnt >= @block_num
					@clear_flg = true
						if @stage_cnt == 7
							scene_transition_end
						else
							scene_transition_clear
						end
				end

    end
    def scene_transition_clear
      @cnt = 0
      @sound.stop unless @current
  	  Scene.move_to(:clear , @min , @sec , @restart) unless @current
	end
	def scene_transition_collision
      sound1 = Sound.new("BGM/se_maoudamashii_explosion05.wav")
      sound1.play unless @current
     
			if @restart < 99
						@restart += 1
			end
      Scene.move_to(:gameover) unless @current
	end
	def scene_transition_end
      @sound.stop unless @current
  	  Scene.move_to(:gameend, @min , @sec , @restart) unless @current
	end
  end
end