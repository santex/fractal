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

function draw(cr)
	local H,S,L = 1,1,0.5
	local r,g,b = HSLtoRGB(H,S,L)
        cr:set_source_rgba(r, g, b, 1)
        cr:rectangle(0,0,width,height)
        cr:fill()
	H=H+offs
        carpet(cr,0,0,width,height,H,S,L)
	surface:write_to_png('carpet.png')
end

function carpet(cr, sx, sy, dw, dh, H, S, L)
        if dw > 2 and dh > 2 then
		local H,S,L = H,S,L
                local lw,lh = dw/3,dh/3
		local r,g,b=HSLtoRGB(H,S,L)
		cr:set_source_rgba(r,g,b,1)
                cr:rectangle(sx+lw,sy+lh,lw,lh)
                cr:fill()
		H=H+offs
                for k=0,8,1 do
                        if (k ~= 4) then
                                local i=math.floor(k/3)
                                local j=k%3
                                carpet(cr,sx+i*lw,sy+j*lh,lw,lh,H,S,L)
                        end
                end
        end
end

draw(cr)
