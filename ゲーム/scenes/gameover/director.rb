#追加
module Gameover
	class Director
		def initialize
			@bg_img = Image.load('images/gameover.png')
			@font = Font.new(50)
			@font_ruby = Font.new(20)
		end

		def play
			Window.draw(0, 0, @bg_img)
			Window.draw_font(45, 400, 'Push "R" to restart', @font, color: C_RED)
			Window.draw_font(260, 627, 'RubyCamp 2019 Spring CIS', @font_ruby, color: C_RED)
			scene_transition
		end

		def scene_transition
	  		Scene.move_to(:game) if Input.key_push?(K_R)
		end
	end
end