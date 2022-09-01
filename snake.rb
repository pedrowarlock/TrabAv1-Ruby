require 'ruby2d'
class Snake
    attr_writer :direction
  
    def initialize
      @positions = [[0, 10], [1, 10], [2, 10], [3 ,10]]
      @direction = 'right'
      @growing = false
    end
  
    


    def draw
        atlas = Sprite.new(
                './imgs/car.png',
                x: @positions[-1][0]* SQUARE_SIZE,
                y: @positions[-1][1]* SQUARE_SIZE,
                animations: {
                up: [
                    {
                    x: 225, y: 0,
                    width: 75, height: 75
                    }
                ],
                down: [
                    {
                    x: 75, y: 0,
                    width: 75, height: 75
                    }
                ],
                left: [
                    {
                    x:150, y: 0,
                    width: 75, height: 75
                    }
                ],
                right: [
                    {
                    x: 0, y: 0,
                    width: 75, height: 75
                    }
                ]
                }
            )   
            
            case @direction
                when 'up' 
                    atlas.play animation: :up, loop: true
                when 'down' 
                    atlas.play animation: :down, loop: true
                when 'left' 
                    atlas.play animation: :left, loop: true
                when 'right' 
                    atlas.play animation: :right, loop: true
            end
    #   @positions.each do |position|
    #     Square.new(x: position[0] * SQUARE_SIZE, y: position[1] * SQUARE_SIZE, size: SQUARE_SIZE - 1, color: 'white')
    #   end
    end
    
 

    def grow
      @growing = true
    end
  
    def move
      if !@growing
        @positions.shift
      end
  
      @positions.push(next_position)
      @growing = false
    end
  
    def can_change_direction_to?(new_direction)
      case @direction
      when 'up' then new_direction != 'down'
      when 'down' then new_direction != 'up'
      when 'left' then new_direction != 'right'
      when 'right' then new_direction != 'left'
      end
    end
  
    def x
      head[0]
    end
  
    def y
      head[1]
    end
  
    def next_position
      if @direction == 'down'
        new_coords(head[0], head[1] + 1)
      elsif @direction == 'up'
        new_coords(head[0], head[1] - 1)
      elsif @direction == 'left'
        new_coords(head[0] - 1, head[1])
      elsif @direction == 'right'
        new_coords(head[0] + 1, head[1])
      end
    end
  
    def hit_itself?
      @positions.uniq.length != @positions.length
    end
  
    private
  
    def new_coords(x, y)
      [x % GRID_WIDTH, y % GRID_HEIGHT]
    end
  
    def head
      @positions.last
    end
  end
  
  