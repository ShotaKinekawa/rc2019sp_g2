#追加
module Clear
    class Director
		attr_accessor:min , :sec , :restart
        def initialize
            @bg_img = Image.load('images/clear.png')
						@font = Font.new(50)
						@font_score = Font.new(45)
						@font_ruby = Font.new(20)

			@sound = Sound.new("BGM/game_maoudamashii_9_jingle05 (online-audio-converter.com).wav")	
			@sound.loop_count = -1
			@start = 0
        end
        def play
			Window.draw(0, 0, @bg_img)
			if @start == 0
				@sound.set_volume(255.0)
				@sound.play
				@start += 1
			end

						Window.draw_font(45, 400, 'Push "R" to restart', @font, color: C_RED)
						if @restart <= 9
		 					Window.draw_font(140, 285, "Restart    #{@restart}", @font_score, color: C_WHITE)
						else
							Window.draw_font(140, 285, "Restart  #{@restart}", @font_score, color: C_WHITE)
		 				end

						if @min <=9 && @sec <=9
							 Window.draw_font(140, 330, "Time  0#{@min}:0#{@sec}", @font_score ,color: C_WHITE) 
						elsif @min >= 10 && @sec >= 10
							Window.draw_font(140, 330, "Time  #{@min}:#{@sec}", @font_score ,color: C_WHITE)
						elsif @min <= 9 && @sec >= 10
							Window.draw_font(140, 330, "Time  0#{@min}:#{@sec}", @font_score ,color: C_WHITE)
						elsif @min >= 10 && @sec <= 9
							Window.draw_font(140, 330, "Time  #{@min}:0#{@sec}", @font_score ,color: C_WHITE)
						end

						Window.draw_font(260, 627, 'RubyCamp 2019 Spring CIS', @font_ruby, color: C_RED)

            scene_transition
        end
		def scene_transition
			@sound.stop if Input.key_push?(K_R)
			@start = 0 if Input.key_push?(K_R)
			
            Scene.move_to(:game) if Input.key_push?(K_R)
        end
    end
end