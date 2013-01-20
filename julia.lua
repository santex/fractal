#!/usr/bin/env lua

local lgi = require 'lgi'
local cairo = lgi.cairo
local get_opts = require('alt_getopt').get_opts
local HSLtoRGB = require("hsltorgb").toRGB

local sh_opts = "w:h:R:I:x:X:ni:s:"

local long_opts ={
	width = 1,
	height = 1,
	real = 1,
	imaginary = 1,
	xmin = 1,
	xmax = 1,
	negative = 0,
	iterations = 1,
	startangle = 1,
}

local width = 640
local height = 480

local iter = 360 -- Max iterations. The higher, the more accurate, the slower.
local startangle = 270
local c = {
	re = -0.4,
	im = 0.6,
}
local xres = 1/width -- viva la resolution
local yres = 1/height

local borders = {
	x = {
		min = -1.6,
		max = 1.6,
	},
}

local colorizer = 0

function recolor()
	colorizer = 360 / iter
end

local retargs,ind = get_opts(arg, sh_opts, long_opts)
for k,v in pairs(retargs) do
	if k == "w" or k == "width" then
		width = v
	elseif k == "h" or k == "height" then
		height = v
	elseif k == "R" or k == "real" then
		c.re = v
	elseif k == "I" or k == "imaginary" then
		c.im = v
	elseif k == "x" or k == "xmin" then
		borders.x.min = v
	elseif k == "X" or k == "xmax" then
		borders.x.max = v
	elseif k == "n" or k == "negative" then
		recolor()
		colorizer = - colorizer
	elseif k == "i" or k == "iterations" then
		iter = v
		recolor()
	elseif k == "s" or k == "startangle" then
		startangle = v
	end
end

local bymin = borders.x.min * height / width
local bymax = borders.x.max * height / width

borders.y = {}
borders.y.min = bymin
borders.y.max = bymax

local surface = cairo.ImageSurface.create('ARGB32', width, height)
local cr = cairo.Context.create(surface)

function draw(cr)
	local H,S,L = 180,1,0.5
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
			local H = startangle - colorizer * num
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
