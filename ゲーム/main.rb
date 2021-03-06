require 'dxruby'
require 'chipmunk'

require_relative 'lib/cp'

require_relative 'scene'
require_relative 'scenes/title/director'
require_relative 'scenes/clear/director'
require_relative 'scenes/gameover/director'
require_relative 'scenes/gameend/director'

require_relative 'scenes/game/director'
require_relative 'scenes/game/ball.rb'
require_relative 'scenes/game/trigger'
require_relative 'scenes/game/block'
require_relative 'scenes/game/grand'



Window.width = 500
Window.height = 650

Scene.add(Title::Director.new, :title)
Scene.add(Game::Director.new, :game)
Scene.add(Clear::Director.new, :clear)
Scene.add(Gameover::Director.new, :gameover)
Scene.add(Gameend::Director.new, :gameend)
Scene.move_to :title

Window.loop do
  break if Input.key_push?(K_ESCAPE)
  Scene.play
end
