class Block < CPStaticBox
  WIDTH = 30
  HIGHT = 30
  COLLISION_TYPE = 99999
  def initialize( x, y, e = 1.0, u = 0.2)
    @x = x
    @y = y
    super(x, y,  x + WIDTH, y + HIGHT, nil, e, u)
    #@image = Image.load('images/block.jpg',0,0,WIDTH,HIGHT)
  end
  def move
  end

end