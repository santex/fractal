#!/usr/bin/env lua

local lgi = require 'lgi'
local cairo = lgi.cairo
local math = require 'math'

local width = 960
local height = width
local surface = cairo.ImageSurface.create('ARGB32', width, height)
local cr = cairo.Context.create(surface)

function draw(cr)
        cr:set_source_rgba(1, 1, 1, 1)
        cr:rectangle(0,0,width,height)
        cr:fill()
        cr:set_source_rgba(0, 0, 0, 1)
        carpet(cr,0,0,width,height)
	surface:write_to_png('carpet.png')
end

function carpet(cr, sx, sy, dw, dh)
        if dw > 2 and dh > 2 then
                local lw,lh = dw/3,dh/3
                cr:rectangle(sx+lw,sy+lh,lw,lh)
                cr:fill()
                for k=0,8,1 do
                        if (k ~= 4) then
                                local i=math.floor(k/3)
                                local j=k%3
                                carpet(cr,sx+i*lw,sy+j*lh,lw,lh)
                        end
                end
        end
end

draw(cr)
