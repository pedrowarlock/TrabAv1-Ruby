require 'ruby2d'

# Set the window size
set width: 300, height: 200
set title: 'Snake (Jogo da cobrinha)',         # Titulo da janela
    background: 'navy',     # Cor de fundo
    width: 800,             # Largura
    height: 600             # Altura

# Cria uma nova forma geométrica (Quadrado).
s = Square.new

# Define a cor da cobra
s.color = 'red'

# Mostra a janela
show