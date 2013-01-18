#!/usr/bin/env lua

local lgi = require 'lgi'
local cairo = lgi.cairo
local HSLtoRGB = require("hsltorgb").toRGB

local width = 960
local height = width
local surface = cairo.ImageSurface.create('ARGB32', width, height)
local cr = cairo.Context.create(surface)

local offs = 257

function draw(cr)
	local cos60 = 0.5
	local sin60 = math.sqrt(3)/2
	local H,S,L=1,1,0.5
        local r,g,b = HSLtoRGB(H,S,L)
        cr:set_source_rgba(r, g, b, 1)
        cr:rectangle(0,0,width,height)
        cr:fill()
	H=H+offs
	local r,g,b = HSLtoRGB(H,S,L)
        cr:set_source_rgba(r, g, b, 1)
	local x1,y1 = 0.5*width,0.95*height 				--bottom tip
	local x2,y2 = (0.5+cos60*0.75)*width,(0.95-sin60*0.75)*height	--right tip
	local x3,y3 = (0.5-cos60*0.75)*width,(0.95-sin60*0.75)*height	--left tip
	cr:move_to(x1,y1)
	cr:line_to(x2,y2)
	cr:line_to(x3,y3)
	cr:close_path()
	cr:fill()
	H=H+offs
        koch(cr,x1,y1,x2,y2,H,S,L)
	koch(cr,x2,y2,x3,y3,H,S,L)
	koch(cr,x3,y3,x1,y1,H,S,L)
	surface:write_to_png('koch.png')
end

function koch(cr,x1,y1,x2,y2,H,S,L)
	local H,S,L = H,S,L
	local dx = x2-x1
	local dy = y2-y1
	local dlen = math.sqrt(dx^2+dy^2)
	if dlen > 3  then
		local nH=H+offs
		local r,g,b = HSLtoRGB(H,S,L)
		cr:set_source_rgba(r,g,b,1)
		local angle = math.atan(dy/math.abs(dx))
		if math.floor(angle+0.5) == 0 and x1 > x2 then
			angle = angle + math.pi
		elseif x1 > x2 then
			if y1 > y2 then
				angle = angle - 1.047
			elseif y1 < y2 then
				angle = angle + 1.047
			end
		end
		print(angle)
		local h = math.sqrt(3)/2*dlen/3
		local s = {
			{x = x1, y= y1},
			{x = x1+dx/3, y= y1+dy/3},
			{x = x1+dx/2+math.sin(angle+math.pi)*h, y = y1+dy/2+math.cos(angle)*h},
			{x = x1+2*dx/3, y = y1+2*dy/3},
			{x = x2, y = y2},
		}
		cr:move_to(s[2].x, s[2].y)
		cr:line_to(s[3].x, s[3].y)
		cr:line_to(s[4].x, s[4].y)
		cr:close_path()
		cr:fill()
		for k=2,#s,1 do
			koch(cr, s[k-1].x, s[k-1].y, s[k].x, s[k].y, nH, S, L)
		end
	end
end

draw(cr)
