
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
	[0x7f]=0x25A0, -- black box

}

local rawpos={
	{ hx=4,hy= 8,	px=256+ 8,py= 0,   style="",   count=256, },
	{ hx=8,hy= 8,	px=256+88,py= 0,   style="",   count=256, },
	{ hx=8,hy=16,	px=256+88,py=128,  style="",   count=256, },
	{ hx=8,hy=16,	px=256+232,py=128, style="r",  count=256, },
	{ hx=8,hy=16,	px=256+376,py=128, style="i",  count=256, },
	{ hx=4,hy= 8,	px=256-72,py= 0,   style="x",  count=128, },
	{ hx=8,hy= 8,	px=40,py= 0,       style="x",  count=128, },
	{ hx=8,hy=16,	px=40,py=80,       style="x",  count=128, },
}


-- write out a lua data module using bitdown format

local g=gfun
local fp=io.open("funfont64.lua","w")

fp:write("local funfont64={}\n")

for f,it in ipairs(rawpos) do

	fp:write("local data"..it.hx.."x"..it.hy..it.style.."={}\n")
	fp:write("funfont64.data"..it.hx.."x"..it.hy..it.style.."=data"..it.hx.."x"..it.hy..it.style.."\n")
	for i=0,(it.count-1) do
		local c=unimap[i] or i
		if it.style=="x" then c=0x2500+i end -- box drawing

		if ( c<=0x1f and c>=0x00 ) or ( c<=0xbf and c>=0x80 ) then -- invalid
		
		else

			local s=utf8.char( c )
			local x=i%16
			local y=(i-x)/16
			
			if c<32 or ( c>127 and c<128+32 ) then s="" end -- bad control codes
			
			p=bitdown.grd_pix_idx(g,nil,it.px+x*it.hx,it.py+y*it.hy,it.hx,it.hy)
			
			print(f,i,x,y,c,s)
			
			fp:write("data"..it.hx.."x"..it.hy..it.style.."["..i.."]=[[\n"..p.."]]-- "..s.."\n")

		end
	end

end
fp:write("return funfont64\n")

fp:close()


local chx=16
local chy=16

local g=gfun

print("funfont_noalpha.png")

gfun:palette(0,2,{ 0,0,0,255 , 255,255,255,255 }) -- remove transparency 
local pal=gfun:palette(0,256) -- remember palette


print("funfont64_4x8b.png")

local g4x8b=wgrd.create("U8_INDEXED",4*chx,8*chy,1)
g4x8b:palette(0,256,pal) -- palette
g4x8b:pixels(0,0,4*chx,8*chy,g:pixels(rawpos[1].px,rawpos[1].py,4*chx,8*chy)) -- copy
g4x8b:create_convert("U8_RGBA"):save("funfont64_4x8b.png")


print("funfont64_8x8b.png")

local g8x8b=wgrd.create("U8_INDEXED",8*chx,8*chy,1)
g8x8b:palette(0,256,pal) -- palette
g8x8b:pixels(0,0,8*chx,8*chy,g:pixels(rawpos[2].px,rawpos[2].py,8*chx,8*chy)) -- copy
g8x8b:create_convert("U8_RGBA"):save("funfont64_8x8b.png")


print("funfont64_8x16b.png")

local g8x16b=wgrd.create("U8_INDEXED",8*chx,16*chy,1)
g8x16b:palette(0,256,pal) -- palette
g8x16b:pixels(0,0,8*chx,16*chy,g:pixels(rawpos[3].px,rawpos[3].py,8*chx,16*chy)) -- copy
g8x16b:create_convert("U8_RGBA"):save("funfont64_8x16b.png")


print("funfont64_8x16r.png")

local g8x16r=wgrd.create("U8_INDEXED",8*chx,16*chy,1)
g8x16r:palette(0,256,pal) -- palette
g8x16r:pixels(0,0,8*chx,16*chy,g:pixels(rawpos[4].px,rawpos[4].py,8*chx,16*chy)) -- copy
g8x16r:create_convert("U8_RGBA"):save("funfont64_8x16r.png")

print("funfont64_8x16r.png")

local g8x16i=wgrd.create("U8_INDEXED",8*chx,16*chy,1)
g8x16i:palette(0,256,pal) -- palette
g8x16i:pixels(0,0,8*chx,16*chy,g:pixels(rawpos[5].px,rawpos[5].py,8*chx,16*chy)) -- copy
g8x16i:create_convert("U8_RGBA"):save("funfont64_8x16i.png")

print("funfont64_4x8x.png")

local rp=rawpos[6]
local gg=wgrd.create("U8_INDEXED",rp.hx*chx,rp.hy*chy/2,1)
gg:palette(0,256,pal) -- palette
gg:pixels(0,0,rp.hx*chx,rp.hy*chy/2,g:pixels(rp.px,rp.py,rp.hx*chx,rp.hy*chy/2)) -- copy
gg:create_convert("U8_RGBA"):save("funfont64_"..rp.hx.."x"..rp.hy.."x.png")
local g4x8x=gg

print("funfont64_8x8x.png")

local rp=rawpos[7]
local gg=wgrd.create("U8_INDEXED",rp.hx*chx,rp.hy*chy/2,1)
gg:palette(0,256,pal) -- palette
gg:pixels(0,0,rp.hx*chx,rp.hy*chy/2,g:pixels(rp.px,rp.py,rp.hx*chx,rp.hy*chy/2)) -- copy
gg:create_convert("U8_RGBA"):save("funfont64_"..rp.hx.."x"..rp.hy.."x.png")
local g8x8x=gg

print("funfont64_8x16x.png")

local rp=rawpos[8]
local gg=wgrd.create("U8_INDEXED",rp.hx*chx,rp.hy*chy/2,1)
gg:palette(0,256,pal) -- palette
gg:pixels(0,0,rp.hx*chx,rp.hy*chy/2,g:pixels(rp.px,rp.py,rp.hx*chx,rp.hy*chy/2)) -- copy
gg:create_convert("U8_RGBA"):save("funfont64_"..rp.hx.."x"..rp.hy.."x.png")
local g8x16x=gg


print("mipmaping")

local build_IEC_8859_15=function(gb,gr,gi,gs,gx,gxs)

	local gm=wgrd.create():load("funfont_mips_background.png"):convert("U8_RGBA")

	gm:pixels(16*8*0,0,gb.width,gb.height,gb:pixels(0,0,gb.width,gb.height))
	gm:pixels(16*8*1,0,gr.width,gr.height,gr:pixels(0,0,gr.width,gr.height))
	gm:pixels(16*8*2,0,gi.width,gi.height,gi:pixels(0,0,gi.width,gi.height))
	gm:pixels(16*8*3,0,gx.width,gx.height,gx:pixels(0,0,gx.width,gx.height))

	local x,y=16*4*0,16*16*1
	for i=0,6 do

		local gsb=gs:duplicate():scale(16*4/(2^i),16*8/(2^i),1):adjust_rgb(  0    ,  0    ,  0    )
		local gsr=gs:duplicate():scale(16*4/(2^i),16*8/(2^i),1):adjust_rgb( -0.5  , -0.5  , -0.5  )
		local gsi=gs:duplicate():scale(16*4/(2^i),16*8/(2^i),1):adjust_rgb( -0.25 , -0.25 , -0.25 )
		local gsx=gxs:duplicate():scale(16*4/(2^i),8*8/(2^i),1)

		gm:pixels(x+gsb.width*0,y,gsb.width,gsb.height,gsb:pixels(0,0,gsb.width,gsb.height))
		gm:pixels(x+gsb.width*1,y,gsr.width,gsr.height,gsr:pixels(0,0,gsr.width,gsr.height))
		gm:pixels(x+gsb.width*2,y,gsi.width,gsi.height,gsi:pixels(0,0,gsi.width,gsi.height))
		gm:pixels(x+gsb.width*3,y,gsx.width,gsx.height,gsx:pixels(0,0,gsx.width,gsx.height))
		
		y=y+gsb.height
	end

	return gm
end

build_IEC_8859_15(
	g8x16b:create_convert("U8_RGBA") ,
	g8x16r:create_convert("U8_RGBA") ,
	g8x16i:create_convert("U8_RGBA") ,
	g4x8b:create_convert("U8_RGBA")  ,
	g8x16x:create_convert("U8_RGBA") ,
	g4x8x:create_convert("U8_RGBA")
	):save("funfont64_mips.png")


-- create fat versions

for i,name in ipairs{

	"funfont64_mips",

} do

print("fatening "..name..".png")
	
	local g=wgrd.create():load(name..".png"):convert("U8_INDEXED")
	g:scale(g.width*4,g.width*4,1)
	g:create_convert("U8_RGBA"):save(name..".fat.png")

end

