
require("apps").default_paths() -- default search paths so things can easily be found

local utf8=require("utf8")

local wgrd=require("wetgenes.grd")

local bitdown=require("wetgenes.gamecake.fun.bitdown")


local gfun=wgrd.create():load("funfont.png")

-- font is drawn as ISO 8859-15 , so this maps us back to unicode , may need to add in more chars?
local unimap={
	[0xa4]=0x20ac,
	[0xa6]=0x0160,
	[0xa8]=0x0161,
	[0xb4]=0x017d,
	[0xb8]=0x017e,
	[0xbc]=0x0152,
	[0xbd]=0x0153,
	[0xbe]=0x0178,
}

local rawpos={
	{ hx=4,hy= 8,	px= 16,py= 0,  style="", },
	{ hx=8,hy= 8,	px=112,py= 0,  style="", },
	{ hx=8,hy=16,	px=112,py=128, style="", },
	{ hx=8,hy=16,	px=272,py=128, style="r", },
}


-- write out a lua data module using bitdown format

local g=gfun
local fp=io.open("funfont64.lua","w")

fp:write("local funfont64={}\n")

for f,it in ipairs(rawpos) do

	fp:write("local data"..it.hx.."x"..it.hy..it.style.."={}\n")
	fp:write("funfont64.data"..it.hx.."x"..it.hy..it.style.."=data"..it.hx.."x"..it.hy..it.style.."\n")
	for i=0,255 do
		if ( i>=0x20 and i<=0x7e ) or ( i>=0xa0 and i<=0xff ) then -- valid

			local s=utf8.char( unimap[i] or i )
			local x=i%16
			local y=(i-x)/16
			
			p=bitdown.grd_pix_idx(g,nil,it.px+x*it.hx,it.py+y*it.hy,it.hx,it.hy)
			
			print(f,i,x,y)
			
			fp:write("data"..it.hx.."x"..it.hy..it.style.."["..i.."]=[[\n"..p.."]]-- "..s.."\n")

		end
	end

end
fp:write("return funfont64\n")

fp:close()



local mips={}

local g=gfun

g:palette(0,2,{0,0,0,255}) -- remove transparency
local p=g:palette(0,256)
g:save("funfont_noalpha.png")

local chx=16
local chy=16

local g4x8=wgrd.create("U8_INDEXED",4*chx,8*chy,1)
g4x8:palette(0,256,p) -- palette
g4x8:pixels(0,0,4*chx,8*chy,g:pixels(rawpos[1].px,rawpos[1].py,4*chx,8*chy)) -- copy
mips[2]=g4x8:create_convert("U8_RGBA")
g4x8:create_convert("U8_RGBA"):save("funfont64_4x8.png")
g4x8:scale(4*chx*4,8*chy*4,1)
g4x8:palette(0,256,p) -- temp bugfix
g4x8:create_convert("U8_RGBA"):save("funfont64_4x8.fat.png")

local g8x8=wgrd.create("U8_INDEXED",8*chx,8*chy,1)
g8x8:palette(0,256,p) -- palette
g8x8:pixels(0,0,8*chx,8*chy,g:pixels(rawpos[2].px,rawpos[2].py,8*chx,8*chy)) -- copy
g8x8:create_convert("U8_RGBA"):save("funfont64_8x8.png")
g8x8:scale(8*chx*4,8*chy*4,1)
g8x8:palette(0,256,p) -- temp bugfix
g8x8:create_convert("U8_RGBA"):save("funfont64_8x8.fat.png")

local g8x16=wgrd.create("U8_INDEXED",8*chx,16*chy,1)
g8x16:palette(0,256,p) -- palette
g8x16:pixels(0,0,8*chx,16*chy,g:pixels(rawpos[3].px,rawpos[3].py,8*chx,16*chy)) -- copy
mips[1]=g8x16:create_convert("U8_RGBA")
g8x16:create_convert("U8_RGBA"):save("funfont64_8x16.png")
--g8x16:create_convert("U8_RGBA"):scale(8*16,8*8,1):save("funfont_8x8_grey.png")
--g8x16:create_convert("U8_RGBA"):scale(4*16,8*8,1):save("funfont_4x8_grey.png")
g8x16:scale(8*chx*4,16*chy*4,1)
g8x16:palette(0,256,p) -- temp bugfix
g8x16:create_convert("U8_RGBA"):save("funfont64_8x16.fat.png")


local g=gfun
local g8x16r=wgrd.create("U8_INDEXED",8*chx,16*chy,1)
g8x16r:palette(0,256,p) -- palette
g8x16r:pixels(0,0,8*chx,16*chy,g:pixels(rawpos[4].px,rawpos[4].py,8*chx,16*chy)) -- copy
g8x16r:create_convert("U8_RGBA"):save("funfont64_8x16r.png")
g8x16r:scale(8*chx*4,16*chy*4,1)
g8x16r:palette(0,256,p) -- temp bugfix
g8x16r:create_convert("U8_RGBA"):save("funfont64_8x16r.fat.png")


g:scale(g.width*4,g.height*4,1)
g:palette(0,256,p) -- temp bugfix
g:create_convert("U8_RGBA"):save("funfont64_noalpha.fat.png")


mips[3]=mips[2]:duplicate():scale(4*chx/ 2,8*chy/ 2,1)
mips[4]=mips[2]:duplicate():scale(4*chx/ 4,8*chy/ 4,1)
mips[5]=mips[2]:duplicate():scale(4*chx/ 8,8*chy/ 8,1)
mips[6]=mips[2]:duplicate():scale(4*chx/16,8*chy/16,1)
mips[7]=mips[2]:duplicate():scale(4*chx/32,8*chy/32,1)
mips[8]=mips[2]:duplicate():scale(4*chx/64,8*chy/64,1)

local gmip=wgrd.create():load("funfont_mips_background.png"):convert("U8_RGBA") -- ,8*16,16*8*1.5,1)
local g=mips[1]
gmip:pixels(0,0,g.width,g.height,g:pixels(0,0,g.width,g.height))
local x=g.width
local y=0
for i=2,8 do
	local g=mips[i]
	gmip:pixels(x,y,g.width,g.height,g:pixels(0,0,g.width,g.height))
	y=y+g.height
end
gmip:save("funfont64_mips.png")
gmip:convert("U8_INDEXED")
local p2=gmip:palette(0,256)
gmip:scale(gmip.width*4,gmip.height*4,1)
gmip:palette(0,256,p2) -- temp bugfix
gmip:convert("U8_RGBA"):save("funfont64_mips.fat.png")


