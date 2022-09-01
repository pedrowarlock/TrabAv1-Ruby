class Car
    attr_writer :direction

    def initialize(pos_x = 15, pos_y = 10)
      @car_position = {x: pos_x, y: pos_x}  # Posição do carro
      @objects = Array.new(0)   # todos objetos (Não players) do mapa ficará aqui
      @direction = 'right'      # direção que o carro está virado
      @explosion = true         # só para não repetir a explosão
      
      #carrega os sons
      @boom_snd = load_sound(SND_EXPLOSION)
      @up_snd = load_sound(SND_UP)
      
      #cria o carro do jogador
      @car_spr = create_new_car()

      #cria todos objetos na tela
      draw_all_map_object()
      #animação de explosão
      @anim_explosion = create_animated_explosion()
    end    
    
    def explosion
        if @explosion 
            @anim_explosion.x = @car_position[:x] * SQUARE_SIZE
            @anim_explosion.y = @car_position[:y] * SQUARE_SIZE
            @anim_explosion.play(animation: :count)
            @explosion = false
            @boom_snd.play           
        end    
    end

    def point
      @up_snd.play
    end

    def defeated
      self.explosion
      self.hide_car
    end

    def draw
      self.draw_car_facing
    end
      
    def hide_car
      @car_spr.x = -1000
      @car_spr.y = -1000
    end
    def move
      new_pos = next_position 
      @car_position[:x] = new_pos[0]
      @car_position[:y] = new_pos[1]
    end
  
    def x
      @car_position[:x].to_i
    end
  
    def y
      @car_position[:y].to_i
    end
    
    def hit_object?
        @objects.each do |object|
             if (object[0] == @car_position[:x] && object[1] == @car_position[:y]) 
                return true
             end
        end
        return false
    end

    def can_change_direction_to?(new_direction)
      case @direction
      when 'up' then new_direction != 'down'
      when 'down' then new_direction != 'up'
      when 'left' then new_direction != 'right'
      when 'right' then new_direction != 'left'
      end
    end  
    

    private

    def load_sound(snd)
      Sound.new(snd)
    end
 
    def next_position
      if @direction == 'down'
        new_coords(x, y + 1)
      elsif @direction == 'up'
        new_coords(x, y - 1)
      elsif @direction == 'left'
        new_coords(x - 1, y)
      elsif @direction == 'right'
        new_coords(x + 1, y)
      end
    end   

    def new_coords(pos_x, pos_y)
      return pos_x % GRID_WIDTH, pos_y % GRID_HEIGHT
    end 

    def get_sprite_coordinate(spr)
      return OBJ_ITEMS_MAP.find {|father| father[:sprite] == spr }
    end   
    
    def assemble_object(pos_x, pos_y, spr_obj)
      spr_map = get_sprite_coordinate(spr_obj)
      if !spr_map 
         return nil  
      end
      spr = Sprite.new(
          IMG_SPRITES,
          x: pos_x * SQUARE_SIZE,
          y: pos_y * SQUARE_SIZE,
          animations: {
          object: [
                  {
                      x: spr_map[:coordinate][:x], y: spr_map[:coordinate][:y],
                      width: spr_map[:size][:w], height: spr_map[:size][:h]
                  }
              ]
          }
          )
        @objects.push([pos_x, pos_y])
        spr.play(animation: :object, loop: true)
    end

    def create_new_car
      return Sprite.new(
        IMG_SPRITES,
        x: -1000,
        y: -1000,
        animations: {
        up: [
            {
            x: 78, y: 0,
            width: 26, height: 26
            }
        ],
        down: [
            {
            x: 26, y: 0,
            width: 26, height: 26
            }
        ],
        left: [
            {
            x:52, y: 0,
            width: 26, height: 26
            }
        ],
        right: [
            {
            x: 0, y: 0,
            width: 26, height: 26
            }
        ]
        }
    )   
    end

    def draw_car_facing
      case @direction
      when 'up' 
          @car_spr.x = x* SQUARE_SIZE
          @car_spr.y = y* SQUARE_SIZE
          @car_spr.play animation: :up
      when 'down' 
          @car_spr.x = x* SQUARE_SIZE
          @car_spr.y = y* SQUARE_SIZE
          @car_spr.play animation: :down
          
      when 'left' 
          @car_spr.x = x* SQUARE_SIZE
          @car_spr.y = y* SQUARE_SIZE
          @car_spr.play animation: :left
      when 'right' 
          @car_spr.x = x* SQUARE_SIZE
          @car_spr.y = y* SQUARE_SIZE
          @car_spr.play animation: :right
      end
    end

    def create_animated_explosion
      Sprite.new(
        IMG_SPRITES,
        x: -1000,
        y: -1000,
        animations: {
            count: [
              {
                x: 0, y: 52,
                width: 26, height: 26,
                time: 40
              },
              {
                x: 26, y: 52,
                width: 26, height: 26,
                time: 50
              },
              {
                x: 52, y: 52,
                width: 26, height: 26,
                time: 60
              },
              {
                x: 0, y: 78,
                width: 26, height: 26,
                time: 70
              },
              {
                x: 26, y: 78,
                width: 26, height: 26,
                time: 80
              }
            ]
          }
    )
    end


    def draw_all_map_object
      #cria todos objetos na tela
      OBJ_ITEMS.each do |object|
        if !assemble_object(object[:position][:x], object[:position][:y], object[:sprite])
            puts "Inexistent sprite coordinate ID:#{object[:id]}: Name:'#{object[:sprite]}'." 
        end
      end
    end
    
  end
  
  