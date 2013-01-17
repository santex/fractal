#!/usr/bin/env lua

local lgi = require 'lgi'
local cairo = lgi.cairo
local math = require 'math'

local width = 960
local height = width
local surface = cairo.ImageSurface.create('ARGB32', width, height)
local cr = cairo.Context.create(surface)

local triargs={
	{lx=0, ly=0.5},
	{lx=0.5, ly=0.5},
	{lx=0.25, ly=0},
}

local offs = 333

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
		print("r,b,g:",r,g,b)
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

function HSLtoRGB(H, S, L)
	local H,S,L = H,S,L
	while H > 360 do
		H=H-360
	end
	local c = (1-math.abs(2*L-1))*S
	local h = H/60
	local x = c*(1-math.abs(h%2-1))
	local m = L-c*0.5
	if 0 < h and h < 1 then
		r1,g1,b1 = c,x,0
	elseif 1 < h and h < 2 then
		r1,g1,b1 = x,c,0
	elseif 2 < h and h < 3 then
		r1,g1,b1 = 0,c,x
	elseif 3 < h and h < 4 then
		r1,g1,b1 = 0,x,c
	elseif 4 < h and h < 5 then
		r1,g1,b1 = x,0,c
	elseif 4 < h and h < 6 then
		r1,g1,b1 = c,0,x
	else
		r1,g1,b1 = 1,0,0
	end
	local r,g,b = r1+m,g1+m,b1+m
	return r,g,b
end


draw(cr)
