class Game
    def initialize
      @score = 0
      @fuel_tank = 100
      @fuel_pos = {x: 10, y:10}        
      
      
      #arrumar tudo \/
      create_background_img(BKGROUND_IMG)
      @fuel = create_fuel_sprite()

      @gameover, @g_over_text, @g_over_reload = create_game_over_hud()
      
      @fuel_hud_bk, @fuel_hud_bar = create_fuel_hud()
      
      
      @text = Text.new("" , color: 'white', x: 620, y: 10, size: 15, z: 1, font: FONT_8BIT)
      @fuel_hud_gas_text = Text.new("GASOLINA" , color: 'white', x:10, y: 10, size: 15, z: 1, font: FONT_8BIT)
      #arrumar tudo /\

    end
    
    def draw
        self.update_fuel_sprite
        self.update_hud_info   
    end
      
    def car_got_fuel?(x, y)
      @fuel_pos[:x] == x && @fuel_pos[:y] == y
    end
  

    def fuel_hit
      @fuel_tank = (@fuel_tank < 74)? @fuel_tank+50: 124
      @score += 10
      @fuel_pos[:x] = rand(Window.width / SQUARE_SIZE)
      @fuel_pos[:y] = rand(Window.height / SQUARE_SIZE)
    end

    def time_lost
        @fuel_tank -=1
        @fuel_hud_bar.width = @fuel_tank
    end

    def game_over_hud_show
      #Animação de GAME OVER
      @gameover.x = Window.width/2-85
      @gameover.y = Window.height/2-60
      @gameover.play(animation: :gameover, loop: true)
      
      #Informar pontos
      @g_over_text.x = Window.width/2-75
      @g_over_text.y = Window.height/2-30
      @g_over_text.text = "PONTOS: #{score.to_s.rjust(4, "0")}"

      #Informar o reset
      @g_over_reload.x = Window.width/2-330
      @g_over_reload.y = Window.height-45
      @g_over_reload.text = "Aperte R para reiniciar o jogo"
    end

    def game_objects_hide
      @text.text = ""
      @fuel_hud_gas_text.text = ""
      @fuel.x = -1000
      @fuel.y = -1000
      self.fuel_hud_bar_hide
    end


    def finish
      self.game_objects_hide  #esconde os objetos do jogo
      self.game_over_hud_show #mostra as informações de game over
      @finished = true
    end
  
    def close_game_over_hud
      @g_over_text.x = -1000
      @g_over_text.y = -1000
      @g_over_reload.x = -1000
      @g_over_reload.y = -1000
    end

    def finished?
      @finished
    end

    def score(point = 0)
        @score += point
    end
  
      def fuel?
        @fuel_tank
      end
    private



    def create_fuel_sprite
      return Sprite.new(
        IMG_SPRITES,
        x: -1000,
        y: -1000,
        animations: {
        fuel: [
                {
                    x: 0, y: 26,
                    width: 26, height: 26
                }
              ]
           }
        )  
    end

    def create_fuel_hud
      spr1 = Sprite.new(
        IMG_SPRITES,
        x: 10,
        y: 30,
        animations: {
          fuelbk: [
                {
                    x: 0, y: 156,
                    width: 124, height: 6
                }
              ]
           }
        ) 
        spr2 = Sprite.new(
          IMG_SPRITES,
          x: 10,
          y: 30,
          animations: {
          fuelhud: [
                  {
                      x: 0, y: 163,
                      width: 124, height: 6
                  }
                ]
             }
          ) 
          
          spr2.play(animation: :fuelhud, loop: true)        
          spr1.play(animation: :fuelbk, loop: true)

        return spr1, spr2
    end

    def create_game_over_hud
      spr1 = Sprite.new(
         IMG_SPRITES,
         x: -1000,
         y: -1000,
         animations: {
         gameover: [
                 {
                     x: 0, y: 104,
                     width: 165, height: 26,
                     time: 500
                 },
                 {
                     x: 0, y: 130,
                     width: 165, height: 26,
                     time: 500
                 }
               ]
            }
         ) 

      spr2 = self.create_game_text
      spr3 = self.create_game_text("", -1000,-1000, 40)
      return spr1, spr2, spr3
    end

    def update_fuel_sprite
      @fuel.x = @fuel_pos[:x] * SQUARE_SIZE
      @fuel.y = @fuel_pos[:y] * SQUARE_SIZE
      @fuel.play animation: :fuel       
    end

    def update_hud_info
      @text.text = "PONTOS: #{score.to_s.rjust(4, "0")}"
    end
    
    def create_game_text(text = "", x = -1000, y = -1000, size = 20, color = 'white')
      return Text.new(text , color: color,x: x,y: y, size: size, z: 1, font: FONT_8BIT)
    end

    def fuel_hud_bar_hide
      @fuel_hud_bk.x = -1000
      @fuel_hud_bar.x= -1000
    end

    def create_background_img(img)
      Image.new(img)
    end

  end