require 'ruby2d'
require './car'
require './game'

set fps_cap: 7
set width: 800
set height: 600

SQUARE_SIZE   = 26
GRID_WIDTH    = Window.width / SQUARE_SIZE
GRID_HEIGHT   = Window.height / SQUARE_SIZE
IMG_SPRITES   = './imgs/sprites.png'
FONT_8BIT     = './fonts/PixeloidSans-nR3g1.ttf'
BKGROUND_IMG  = './imgs/background.png'
SND_EXPLOSION = './sounds/crash.wav'
SND_LOSE = './sounds/lose.wav'
SND_UP = './sounds/gas.wav'
CAR_START_POS = {x: 15, y:5}
OBJ_FILE = eval(File.read("./objects.rc"))

FILE_SPRITE  = File.read("./objects.rc")
FILE_OBJ_MAP = File.read("./file_sprite.rc")

OBJ_ITEMS = eval(FILE_SPRITE)
OBJ_ITEMS_MAP = eval(FILE_OBJ_MAP)


game = Game.new
car = Car.new(CAR_START_POS[:x],CAR_START_POS[:y])
update do
    
    unless game.finished?      
        car.move
        game.time_lost
    end

    game.draw
    car.draw
    
    if game.car_got_fuel?(car.x, car.y)
        game.fuel_hit
        car.point   
    #car.grow
  end

  if car.hit_object?  
    game.finish
    car.defeated
  end

   if (game.fuel? <= 0)
     game.finish
   end

end

on :key_down do |event|
  if ['up', 'down', 'left', 'right'].include?(event.key) && !game.finished?
    if car.can_change_direction_to?(event.key)
      car.direction = event.key
    end
  end
    

  if game.finished? && event.key == 'r'
    game.close_game_over_hud
    game = Game.new
    car = Car.new(CAR_START_POS[:x],CAR_START_POS[:y])
  end
end
show