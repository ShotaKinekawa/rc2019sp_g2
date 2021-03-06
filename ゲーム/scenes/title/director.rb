#追加
module Title
	class Director
		def initialize
			@bg_img = Image.load('images/title.png')
			@font = Font.new(48) 
			@font_ruby = Font.new(20)
			@sound = Sound.new("BGM/main-theme02 (online-audio-converter.com).wav")
			@start = 0
		end

	def play
		Window.draw(0, 0, @bg_img)
		Window.draw_font(5, 400, 'Push Space key to start', @font, color: C_RED)
		Window.draw_font(260, 627, 'RubyCamp 2019 Spring CIS', @font_ruby, color: C_RED)
		scene_transition
	end

	private
	def scene_transition


		if @start == 0
			@sound.set_volume(255.0)
			@sound.play
			@start += 1
		end
		@sound.stop if Input.key_push?(K_SPACE)
  		Scene.move_to(:game) if Input.key_push?(K_SPACE)
	end
	end
end