  class Block < CPStaticBox
  WIDTH = 50
  HIGHT = 50
  COLLISION_TYPE = 99999

  def initialize(x, y, e = 0.8, u = 0.8)
    @x = x
    @y = y
    super(x, y,  x + WIDTH, y + HIGHT, nil, e, u)
    #@image = Image.load('images/block.jpg',0,0,WIDTH,HIGHT)
  end
  def move
  end

end