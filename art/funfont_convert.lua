
require("apps").default_paths() -- default search paths so things can easily be found

local wgrd=require("wetgenes.grd")

local bitdown=require("wetgenes.gamecake.fun.bitdown")


local g=wgrd.create():load("funfont.png")

local fp=io.open("funfont.lua","w")

for f,it in ipairs{
	{hx=4,hy=8,	px=0,py=0},
	{hx=8,hy=8,	px=0,py=64},
	{hx=8,hy=16,px=0,py=128},
} do

	fp:write("local fontdata"..it.hx.."x"..it.hy.."={}\n")
	for i=32,127 do

		local s=string.char(i)
		local x=i%16
		local y=(i-x)/16
		
		p=bitdown.grd_pix_idx(g,nil,it.px+x*it.hx,it.py+y*it.hy,it.hx,it.hy)
		
		print(f,i,x,y)
		
		fp:write("fontdata"..it.hx.."x"..it.hy.."["..i.."]=[[\n"..p.."]]-- "..s.."\n")

	end

end

fp:close()


g:palette(0,2,{0,0,0,255}) -- remove transparency
local p=g:palette(0,256)
g:save("funfont_noalpha.png")

local g4x8=wgrd.create("U8_INDEXED",4*16,8*8,1)
g4x8:palette(0,256,p) -- palette
g4x8:pixels(0,0,4*16,8*8,g:pixels(0,0,4*16,8*8)) -- copy
g4x8:create_convert("U8_RGBA"):save("funfont_4x8.png")
g4x8:scale(4*16*4,8*8*4,1)
g4x8:palette(0,256,p) -- temp bugfix
g4x8:create_convert("U8_RGBA"):save("funfont_4x8.fat.png")

local g8x8=wgrd.create("U8_INDEXED",8*16,8*8,1)
g8x8:palette(0,256,p) -- palette
g8x8:pixels(0,0,8*16,8*8,g:pixels(0,64,8*16,8*8)) -- copy
g8x8:create_convert("U8_RGBA"):save("funfont_8x8.png")
g8x8:scale(8*16*4,8*8*4,1)
g8x8:palette(0,256,p) -- temp bugfix
g8x8:create_convert("U8_RGBA"):save("funfont_8x8.fat.png")

local g8x16=wgrd.create("U8_INDEXED",8*16,16*8,1)
g8x16:palette(0,256,p) -- palette
g8x16:pixels(0,0,8*16,16*8,g:pixels(0,128,8*16,16*8)) -- copy
g8x16:create_convert("U8_RGBA"):save("funfont_8x16.png")
--g8x16:create_convert("U8_RGBA"):scale(8*16,8*8,1):save("funfont_8x8_grey.png")
--g8x16:create_convert("U8_RGBA"):scale(4*16,8*8,1):save("funfont_4x8_grey.png")
g8x16:scale(8*16*4,16*8*4,1)
g8x16:palette(0,256,p) -- temp bugfix
g8x16:create_convert("U8_RGBA"):save("funfont_8x16.fat.png")


g:scale(128*4,256*4,1)
g:palette(0,256,p) -- temp bugfix
g:create_convert("U8_RGBA"):save("funfont_noalpha.fat.png")
