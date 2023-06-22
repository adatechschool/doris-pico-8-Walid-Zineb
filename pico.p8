pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

function _init()
	player = {
		sp = 1,
		x = 56,
		y = 85,
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
	
	--simple camera
	cam_x=0
	
	--map limits
	map_start=0
	map_end=1024
end
-->8
--update and draw
function _update()
	player_update()
	player_animate()
	sfx(01,02,03,04)
	
	--simple camera
	cam_x=player.x-64+(player.w/2)
	if cam_x<map_start then
		cam_x=map_start
	end
	if cam_x>map_end-128 then
		cam_x=map_end-128
	end
	camera(cam_x,0)
end

function _draw()
	cls(12)
	map(0,0)
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


-->8
--player

function player_update()
	--physics
	player.dy+=gravity
	player.dx*=friction

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
	
	--slide
	if player.running
	and not btn(⬅️)
	and not btn(➡️)
	and not player.falling
	and not player.jumping then
			player.running=false
			player.sliding=true
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
		if collide_map(player, "right", 0) then
			player.dx = 0
		end
	end
	player.x += player.dx
	player.y += player.dy
	
	--limit player to map
	if player.x<map_start then
		player.x=map_start
	end
	if player.x>map_end-player.w then
		player.x=map_end-player.w
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
			player.sp += 0
			if player.sp > 2 then
				player.sp = 1
			end
		end
	end
end

	
-->8
--obstacles
-->8
--monsters
-->8
--items
-->8
--prince
__gfx__
09899900098999000009899900098999000989990009899900098999000989999009899900000000000000000000000000000000000000000000000000000000
0891f1900891f19000089f1f09089f1f00089f1f09089f1f00089f1f00089f1f99089f1f00000000000000000000000000000000000000000000000000000000
09ffff9009ffef900999fffe9099fffe0999fffe9099fffe0999fffe0999fffe0999fffe00000000000000000000000000000000000000000000000000000000
99020090990200909000220000002200900022000000220090002200900022000000220000000000000000000000000000000000000000000000000000000000
00eee0000feeef0000feee0000feee0000feee0000feee0000feee00000eee000000eee000000000000000000000000000000000000000000000000000000000
0feeef00f0eee0f00000ee000000ee000000ee000000ee000000ee0000f0ee000000ee0f00000000000000000000000000000000000000000000000000000000
feeeeef00eeeee0000ff0500000f500000550f00000f500000ff0500000f500000000f5000000000000000000000000000000000000000000000000000000000
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
3bbb3bbbbbbb3bbb3b333bb3bbbbb33b0bbbb3b3bbb3bbb00bbbbbb0f4444f440000000000000000000000000000000000000000000000000000000000000000
33b333b33bb33bbb33443b3433bbb343bb3b34343b3433bbbbbb3bbbf4444f440000000000000000000000000000000000000000000000000000000000000000
4b3444343bb343b3444443b443bb3444bbb33444434443bbbbb343bbffffffff0000000000000000000000000000000000000000000000000000000000000000
4b3444443b342434494443b4443b3444bb344444444a443bbb34443b44f4444f0000000000000000000000000000000000000000000000000000000000000000
444444444344444444444b3444434424b344444d444443bbb344a44344f4444f0000000000000000000000000000000000000000000000000000000000000000
44444444444444d44445434449444444bb34f4444544443b34444444ffffffff0000000000000000000000000000000000000000000000000000000000000000
4444444444944444444444444444e444334444444444444344e44544000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444444444444444444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444484444444f44944444444944000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44449444444224444444442442444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4f4444444442e2444444444444444744000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444444422444d77444444844774000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
444444444a4444444d77744444447644000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44e444644444444444ddd44444776444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4444444444f444444444444444474444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00700000a000000a00088800ed0000000000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0777070000aaaa00008e8e80230000de000fef000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7777777009aaaaa00088e88000300032000eee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7777777709aaaaa00008880000300300bb0eee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6666666609aaaaa00000b0300003030003b030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000770009aaaaa00030b33000bb3b00003b30bb0600060000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077770009999000033b300bb33b3bb00b33b306060606000000000000000000000000000000000000000000000000000000000000000000000000000000000
00666666a000000a0003300033033b330003b3000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003030303030303010000000000000000030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000080000000000000000000000000008000
0000008100000000000000000000000000000000000000000000000000000000000080000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000000000800000000000000000000000800000000000000000000000
0000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0080000000000000000080000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000008000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000800000000000000000000000000000000000
0000000000000000000000000000000000800000000000004747474700000080000000000000000000000000800000000000474747000000000000000000000000000000000080000000000000000000800000000000000000000000000000800000000000004747000000000000000000000000000000000000000000000000
0000000000000000000000474747000000000000474700000000000000474700000000004747470000000000000047470000000000000000000000000000000000000000004747000000000000000000000000000000000000474700000000000047474700000000000000000000000000008000004747000080000000008000
0000000000000046830000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004747474700000000000000000000000000000000005400004747000047474700000000000000000000000000000000800000474700000000000000005400000000000000000000000000
0000000000824452450000000000000047470000000000470000000000000000474700000000000000474747000000000000000000000000000000000047470000000000000000000047474700000000000000000000474700000000004747000000000000000000000000000047474700004747470000000000000000000000
8400000000445050504500820000000084000083000082000000008300000000840000000000008200000000008300000000840000000000008200008300008400474747000082008300000084000000820000830000840000000000820083000084000082000000830084000082000000830000008400000082008300840000
4140414042505150535042414041404043414241434140434342404243404342434142414341404343424042434043424341424143414043434240424340434243414241434140434342404243404342434142414341404343424042434043424341424143414043434240424340434243414241434140434342404243404342
5250515050505350505050525051505250505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000028335283350000028335000002433528335000002b3350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001e3251e325000001e325000001e3251e32500000233250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000e1350e135000000e135000000e1350e13500000131350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000003c61500000000000000018610000003c61500000000000000018610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 01020304

