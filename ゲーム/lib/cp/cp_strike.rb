class CPStrike < CPBase

    
    def initialize(x, y, width, height, mass, degree = 0, color = C_RED, image = nil, e = 0.3, u = 0.9)
        verts = [CP::Vec2.new(-width/2, -height/2),
                 CP::Vec2.new(-width/2, height/2),
                 CP::Vec2.new(width/2, height/2),
                 CP::Vec2.new(width/2, -height/2)]
        moment = CP::moment_for_box(mass, width, height)
        @body = CP::Body.new(mass, moment)
        @body.p = CP::Vec2.new(x + width / 2, y + height / 2)
        @body.a = degree * Math::PI / 180

        if degree > 90
            @rorl =  K_RIGHT
            @force = 1
            @max_angle = (degree + 60) * Math::PI / 180.0
            @min_angle = degree * Math::PI / 180.0
        else
            @rorl =  K_LEFT
            @force = -1
            @max_angle =  (degree - 60) * Math::PI / 180.0
            @min_angle =  degree * Math::PI / 180.0       
        end

        @body.v_limit = 0
        @shape = CP::Shape::Poly.new(@body, verts, CP::Vec2.new(0, 0))
        @shape.collision_type = self.class::COLLISION_TYPE
        @shape.parent_obj = self
        @image = image || Image.new(width, height, color)
        @x, @y = x, y
        @width, @height = width, height
       
        @shape.e = e
        @shape.u = u
    end
    
    def move
        if  @rorl == K_LEFT
            if  Input.key_down?(@rorl)
            apply_force(0, @force)
                if @body.a <= @max_angle
                    @body.w = 0.0
                    @body.a = @max_angle
                end
            else
                apply_force(0, -@force)
                if @body.a >= @min_angle 
                    @body.w = 0.0
                    @body.a = @min_angle 
                   # puts "#{@body.a * 180 / Math::PI}"
                end
            end
        elsif @rorl == K_RIGHT
            if  Input.key_down?(@rorl)
                apply_force(0, @force)
                    if @body.a >= @max_angle
                        @body.w = 0.0
                        @body.a = @max_angle
                    end
                else
                    apply_force(0, -@force)
                    if @body.a <= @min_angle 
                        @body.w = 0.0
                        @body.a = @min_angle
                    end
                end
        end
        @body.v = CP::Vec2.new(0.0, 0.0)
    end

    def draw
        Window.draw_rot(@body.p.x - @width / 2, @body.p.y - @height / 2, @image, @body.a * 180.0 / Math::PI)
    end
    

    private

    def apply_force(x, y)
      body.apply_impulse(CP::Vec2.new(x, y), CP::Vec2.new(45000, 0))
    end

  

end