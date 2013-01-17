#!/usr/bin/env lua

local function toRGB(H, S, L)
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

return {
	toRGB=toRGB,
}
