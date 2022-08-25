require 'ruby2d'

# Set the window size
set width: 300, height: 200
set title: 'Howdy', 
    background: 'navy',
    width: 800,
    height: 600

# Create a new shape
s = Square.new

# Give it some color
s.color = 'red'

# Show the window
show