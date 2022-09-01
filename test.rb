require 'ruby2d'
IMG_SPRITES  = './imgs/sprites.png'


FILE_SPRITE  = File.read("./objects.rc")
FILE_OBJ_MAP = File.read("./file_sprite.rc")

OBJ_ITEMS = eval(FILE_SPRITE)
OBJ_ITEMS_MAP = eval(FILE_OBJ_MAP)


#Retorna o mapa da sprite no arquivo PNG
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
        x: pos_x,
        y: pos_y,
        animations: {
        object: [
                {
                    x: spr_map[:position][:x], y: spr_map[:position][:y],
                    width: spr_map[:size][:w], height: spr_map[:size][:h]
                }
            ]
        }
        )  
    spr.play(animation: :object, loop: true)
end


OBJ_ITEMS.each do |object|
    if !assemble_object(object[:position][:x], object[:position][:y], object[:sprite])
        puts "Inexistent sprite coordinate ID:#{object[:id]}: Name:'#{object[:sprite]}'." 
    end
end



show