pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

function _init()
    p = { x = 60, y = 90, speed = 4 }
end

function _update60()
    if (btn(➡️)) p.x += 1
    if (btn(⬅️)) p.x -= 1
    if (btn(⬆️)) p.y -= 1
    if (btn(⬇️)) p.y += 1
end

function _draw()
    cls()
    spr(1, p.x, p.y)
end
