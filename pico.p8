pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

function _init()
	player = {
		sp = 1,
		x = 1,
		y = 1,
		w = 8,
		h = 8,
		flp = false,
		dx = 0,
		dy = 0,
		max_dx = 2,
		max_dy = 3,
		acc = 0.5,
		boost = 4,
		anim = 0,
		running = false,
		jumping = false,
		falling = false,
		slinding = false,
		landed = false
	}

	gravity = 0.3
	friction = 0.85
end
-->8
--update and draw
function _update()
	player_update()
	player_animate()
end

function _draw()
	cls(12)
	map(0, 0)
	spr(player.sp, player.x, player.y, 1, 1, player.flp)
end
-->8
--collisions

function collide_map(obj, aim, flag)
	--obj = tables needs x,y,w,h
	--aim = left,right,up,down

	local x = obj.x
	local y = obj.y
	local w = obj.w
	local h = obj.h

	local x1 = 0
	local y1 = 0
	local x2 = 0
	local y2 = 0

	if aim == "left" then
		x1 = x - 1 y1 = y
		x2 = x y2 = y + h - 1
	elseif aim == "riht" then
		x1 = x + w y1 = y
		x2 = x + w + 1 y2 = y + h - 1
	elseif aim == "up" then
		x1 = x + 1 y1 = y - 1
		x2 = x + w - 1 y2 = y
	elseif aim == "down" then
		x1 = x y1 = y + h
		x2 = x + w y2 = y + h
	end

	--pixels to tiles
	x1 /= 8
	y1 /= 8
	x2 /= 8
	y2 /= 8

	if fget(mget(x1, y1), flag)
			or fget(mget(x1, y2), flag)
			or fget(mget(x2, y1), flag)
			or fget(mget(x2, y2), flag) then
		return true
	else
		return false
	end
end

function player_animate()
	if player.jumping then
		player.sp = 7
	elseif player.falling then
		player.sp = 8
	elseif player.running then
		if time() - player.anim > .1 then
			player.anim = time()
			player.sp += 1
			if player.sp > 6 then
				player.sp = 3
			end
		end
	else
		--player idle
		if time() - player.anim > .3 then
			player.anim = time()
			player.sp += 1
			if player.sp > 2 then
				player.sp = 1
			end
		end
	end
end
-->8
--player

function player_update()
	--physics
	player.dy += gravity
	player.dx *= friction

	--controls
	if btn(⬅️) then
		player.dx -= player.acc
		player.running = true
		player.flp = true
	end
	if btn(➡️) then
		player.dx += player.acc
		player.running = true
		player.flp = false
	end

	--jump
	if btnp(❎)
			and player.landed then
		player.dy -= player.boost
		player.landed = false
	end

	--check colition up and down
	if player.dy > 0 then
		player.falling = true
		player.landed = false
		player.jumping = false

		if collide_map(player, "down", 0) then
			player.landed = true
			player.falling = false
			player.dy = 0
			player.y -= (player.y + player.h) % 8
		end
	elseif player.dy < 0 then
		player.jumping = true
		if collide_map(player, "up", 1) then
			player.dy = 0
		end
	end

	--check collision left and right
	if player.dx < 0 then
		if collide_map(player, "left", 1) then
			player.dx = 0
		end
	elseif player.dx > 0 then
		if collide_map(player, "right", 1) then
			player.dx = 0
		end
	end
	player.x += player.dx
	player.y += player.dy
end

__gfx__
09899900098999000009899900098999000989990009899900098999000989999009899900000000000000000000000000000000000000000000000000000000
0891f1900891f19000089f1f09089f1f00089f1f09089f1f00089f1f00089f1f99089f1f00000000000000000000000000000000000000000000000000000000
09ffff9009ffef900999fffe9099fffe0999fffe9099fffe0999fffe0999fffe0999fffe00000000000000000000000000000000000000000000000000000000
99020090990200909000220000002200900022000000220090002200900022000000220000000000000000000000000000000000000000000000000000000000
003f30000f3f3f0000f3330000f3330000f3330000f3330000f33300000333000000333000000000000000000000000000000000000000000000000000000000
0f333f00f03330f0000033000000330000003300000033000000330000f033000000330f00000000000000000000000000000000000000000000000000000000
f03330f00033300000ff0500000f500000550f00000f500000ff0500000f500000000f5000000000000000000000000000000000000000000000000000000000
00f0500000f0500000000500000f500000000f00000f50000000050000f50000000000f500000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00bbbbbbbbbbbb0000bbbb00000000000000000000000000000000000000000000000000000000000000000000000000
3bbb3bbbbbbb3bbb3b333bb3bbbbb33b0bbbb3b3bbb3bbb00bbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000
33b333b33bb33bbb33443b3433bbb343bb3b34343b3433bbbbbb3bbb000000000000000000000000000000000000000000000000000000000000000000000000
4b3444343bb343b3444443b443bb3444bbb33444434443bbbbb343bb000000000000000000000000000000000000000000000000000000000000000000000000
4b3444443b342434494443b4443b3444bb344444444a443bbb34443b000000000000000000000000000000000000000000000000000000000000000000000000
444444444344444444444b3444434424b344444d444443bbb344a443000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444d44445434449444444bb34f4444544443b34444444000000000000000000000000000000000000000000000000000000000000000000000000
4444444444944444444444444444e444334444444444444344e44544000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444444444444444444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444484444444f44944444444944000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44449444444224444444442442444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4f4444444442e2444444444444444744000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444444422444d77444444844774000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
444444444a4444444d77744444447644000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44e444644444444444ddd44444776444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4444444444f444444444444444474444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003030303030303000000000000000000030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000046000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000004452450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000445050504500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4140414042505150535042414041404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5250515050505350505050525051505200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
