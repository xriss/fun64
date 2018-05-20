
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
