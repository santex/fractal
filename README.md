fractal
=======

fractal rendering with lua and cairo.
requires `lua-lgi` and `alt-getopt`.


Invocation: lua5.1 NAME.lua.   
Generates NAME.png as output file in the same folder.

julia.lua takes these arguments:

+ -w, --width *width*
	+ Defines the width of the output image. Default: 640
+ -h, --height *height*
	+ Defines the height of the output image. Default: 480
+ -R, --real *R*
	+ Defines the real part of the complex constant of the julia set. Default: -0.4
+ -I, --imaginary *I*
	+ Defines the imaginary part of the complex constant of the julia set. Default: 0.6
+ -x, --xmin *xmin*
	+ Defines lower border of the render range. Default: -1.6	
+ -X, --xmax *xmax
	+ Defines upper border of the render range. Default: 1.6
+ -n, --negative
	+ Toggles whether the color hue changes negative hue angle in the HSL colorset. Is off by default.
+ -i, --iterations *iterations*
	+ Defines max number of iterations over one point in the julia set. Also sets the number of individual colors. Should be somewhere between 0 and 360. Default: 360
+ -s, --startangle *angle*
	+ Angle in degrees. Defines the starting color hue in the HSL colorset.
