#!/usr/bin/env lua

local lgi = require 'lgi'
local cairo = lgi.cairo
local math = require 'math'
local HSLtoRGB = require("hsltorgb").toRGB

local width = 960
local height = width
local surface = cairo.ImageSurface.create('ARGB32', width, height)
local cr = cairo.Context.create(surface)

local offs = 257
local iter = 36 -- Max iterations. The higher, the more accurate, the slower.
local c = {
	re = -0.8,
	im = 0.156,
}
local xres = 1/width -- viva la resolution
local yres = 1/height

local borders = {
	x = {
		min = -2,
		max = 2,
	},
	y = {
		min = -2,
		max = 2,
	},
}

function draw(cr)
	local H,S,L = 1,1,0.5
	local r,g,b = HSLtoRGB(H,S,L)
	cr:set_source_rgba(r, g, b, 1)
	--cr:rectangle(0,0,width,height)
	--cr:fill()
	--cr:set_line_width(2)
	--cr:set_line_cap("CAIRO_LINE_CAP_SQUARE")
	julia(cr, width, height, iter, c)
	surface:write_to_png('julia.png')
end

function julia(cr, width, height, iter, c)
	local deltax = (borders.x.max - borders.x.min) * xres
	local deltay = (borders.y.max - borders.y.min) * yres
	local rangex = (borders.x.max - borders.x.min)
	local rangey = (borders.y.max - borders.y.min)
	for i=0, rangex, deltax do
		for j=0, rangey, deltay do
			local x,y = i + borders.x.min, j + borders.y.min
			local num = 1
			for n=1,iter,1 do
				local test = x^2 + y^2
				if test < 4 then
					num = num+1
					local new_x = x^2 - y^2 + c.re
					local new_y = 2*x*y + c.im
					x,y = new_x, new_y
				else
					break
				end
			end
			local H = 10 * num
			local r,g,b = HSLtoRGB(H,1,0.5)
			cr:set_source_rgba(r,g,b,1)
			local dx,dy = i * width / rangex, j * height / rangey
			local dresx = 1 -- former: res / width
			local dresy = 1
			cr:rectangle(dx, dy, dx+dresx, dy+dresy)
			cr:fill()
		end
	end
end

draw(cr)
