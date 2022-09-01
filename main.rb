require 'ruby2d'
require './car'
require './game'

set fps_cap: 7
set width: 800      #Define a largura e a altura do jogo na tela
set height: 600

SQUARE_SIZE   = 26  # Tamanho de cada quadrado na tela
GRID_WIDTH    = Window.width / SQUARE_SIZE
GRID_HEIGHT   = Window.height / SQUARE_SIZE
IMG_SPRITES   = './imgs/sprites.png'                #Sprite de imagens do jogo
FONT_8BIT     = './fonts/PixeloidSans-nR3g1.ttf'    #Fonte de texto que será usada no jogo
BKGROUND_IMG  = './imgs/background.png'             #Imagem de fundo da fase
SND_EXPLOSION = './sounds/crash.wav'                #Alguns sons de derrota e de up
SND_LOSE = './sounds/lose.wav'
SND_UP = './sounds/gas.wav'
CAR_START_POS = {x: 15, y:5}                        #Posição inicial do carro, onde ele nasce     

FILE_SPRITE  = File.read("./objects.rc")            #Arquivo de objetos do mapa
FILE_OBJ_MAP = File.read("./file_sprite.rc")

OBJ_ITEMS = eval(FILE_SPRITE)                       #Transforma os objetos em vetores com Hash
OBJ_ITEMS_MAP = eval(FILE_OBJ_MAP)

#inicia o jogo e cria o carro
game = Game.new
car = Car.new(CAR_START_POS[:x],CAR_START_POS[:y])

update do    
    unless game.finished?  # Enquanto o jogo não acaba, atualiza a posição do carro na tela e diminui o combustivel    
        car.move
        game.time_lost
    end
    
    #desenha o mapa e o carro na tela
    game.draw
    car.draw
    
    if game.car_got_fuel?(car.x, car.y) # Sempre que o carro pega o combustivel
        game.fuel_hit                   # informa que ele pegou
        car.point                       # Executa um metodo que avisa que o carro pontuou, no caso ele executa um som
    end

    if car.hit_object?                    # Verifica se o carro bateu em algo
      game.finish                         # Finaliza o jogo
      car.defeated                        # Execta a ação no carro de explosão
    end

    if (game.fuel? <= 0)                 # Se acabar a gasolina / Fim de jogo
      game.finish
    end
end

on :key_down do |event|
  if ['up', 'down', 'left', 'right'].include?(event.key) && !game.finished? #include? pergunta se o evento.key está contido no vetor em questão
    if car.can_change_direction_to?(event.key) # Em Ruby todas funções ou metodos que tenha um "?" no final, returna um boleano
      car.direction = event.key
    end
  end
    

  if game.finished? && event.key == 'r' # Se o game já acabou e o jogar apertar R, ele será reiniciado
    game.close_game_over_hud
    game = Game.new
    car = Car.new(CAR_START_POS[:x],CAR_START_POS[:y])
  end
end
show