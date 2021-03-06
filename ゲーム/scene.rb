class Scene
  @@scenes = {}

  @@current = nil

  def self.add(director, title)
    @@scenes[title.to_sym] = director
  end


  def self.move_to(title , min=nil , sec=nil , restart=nil)
    @@current = title.to_sym
    @@scenes[@@current].premove if @@scenes[@@current].respond_to?(:premove)
		if min && sec && restart
			@@scenes[@@current].min = min
			@@scenes[@@current].sec = sec
			@@scenes[@@current].restart = restart
		end
  end


  def self.play
    @@scenes[@@current].play
  end
end