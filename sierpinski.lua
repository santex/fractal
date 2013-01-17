#!/usr/bin/env lua

local lgi = require 'lgi'
local cairo = lgi.cairo
local math = require 'math'
require("hsltorgb")

local width = 960
local height = width
local surface = cairo.ImageSurface.create('ARGB32', width, height)
local cr = cairo.Context.create(surface)

local triargs={
	{lx=0, ly=0.5},
	{lx=0.5, ly=0.5},
	{lx=0.25, ly=0},
}

local offs = 257

function draw(cr)
	local H,S,L=1,1,0.5
        local r,g,b = HSLtoRGB(H,S,L)
        cr:set_source_rgba(r, g, b, 1)
        cr:rectangle(0,0,width,height)
        cr:fill()
        cr:set_source_rgba(0, 0, 0, 1)
	cr:move_to(0,height)
	cr:line_to(0.5*width,0)
	cr:line_to(width,height)
	cr:close_path()
	cr:fill()
	H=H+offs
        sierpinski(cr,0,0,width,height,H,S,L)
	surface:write_to_png('sierpinski.png')
end

function sierpinski(cr,sx,sy,dw,dh,H,S,L)
	local H,S,L = H,S,L
	if dw > 3 and dh > 3 then
		cr:move_to(sx+0.25*dw,sy+0.5*dh)
		cr:line_to(sx+0.5*dw,sy+dh)
		cr:line_to(sx+0.75*dw,sy+0.5*dh)
		cr:close_path()
		local r,g,b = HSLtoRGB(H,S,L)
		--print("r,b,g:",r,g,b)
		cr:set_source_rgba(r,g,b,1)
		cr:fill()
		H=H+offs
		for k=1,#triargs,1 do
			local v = triargs[k]
			local nx= sx+dw*v.lx
			local ny= sy+dh*v.ly
			local nw= 0.5*dw
			local nh= 0.5*dh
			sierpinski(cr, nx, ny, nw, nh, H, S, L)
		end
	end
end

draw(cr)
