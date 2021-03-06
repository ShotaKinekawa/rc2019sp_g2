#追加
module Title
	class Director
		def initialize
			@bg_img = Image.load('images/title.png')
			@font = Font.new(48) 
		end

	def play
		Window.draw(0, 0, @bg_img)
		Window.draw_font(5, 400, 'Push Space key to start', @font, color: C_RED)
		scene_transition
	end

	private
	def scene_transition
  		Scene.move_to(:game) if Input.key_push?(K_SPACE)
	end
	end
end