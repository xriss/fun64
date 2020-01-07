
require("apps").default_paths() -- default search paths so things can easily be found

local utf8=require("utf8")

local wgrd=require("wetgenes.grd")
local wpack=require("wetgenes.pack")
local wstring=require("wetgenes.string")

local bitdown=require("wetgenes.gamecake.fun.bitdown")

local funfont64=require("funfont64")

-- create c files for all the funfont sizes and styles

local create_c=function( name , glyphs , xh , yh )

	
	local getbitmap=function(str)
		local ls=wstring.split(str,"\n")
		local t={}
		for x=1,xh do
			local n=0
			for y=1,yh do
				local s=ls[y] or ""
				local b=s:sub(x*2-1,x*2-1) == "7"
				n=n*2+(b and 1 or 0)
			end
			t[#t+1]=n
		end
		return t
	end
	
	local datas={}
	
	ss=""
	for idx=0,255 do
		local g = glyphs[ idx ]
		local b=getbitmap(g or "")
		local s=""
		local t={}
		if yh==8 then
			ss="char"
			for i,v in ipairs(b) do
				t[#t+1]=string.format("0x%02x",v)
			end
		elseif yh==16 then
			ss="short"
			for i,v in ipairs(b) do
				t[#t+1]=string.format("0x%04x",v)
			end
		end
		local cc="," if idx==255 then cc=" " end
		s=s..table.concat(t,",")..cc.." // "..idx.." \n"
		datas[#datas+1]=s
	end

	return "const unsigned "..ss.." "..name.."={\n"..table.concat(datas).."};\n\n"

end

local o={}

-- this font size is only possible as bold
o[#o+1]=create_c("funfont_4x8b", funfont64.data4x8   , 4 , 8  )

-- but here we have a choice
o[#o+1]=create_c("funfont_8x16b",funfont64.data8x16  , 8 , 16 )
o[#o+1]=create_c("funfont_8x16r",funfont64.data8x16r , 8 , 16 )
o[#o+1]=create_c("funfont_8x16i",funfont64.data8x16i , 8 , 16 )

local fp=io.open("./funfont.c","wb")
fp:write([[
//
// https://github.com/xriss/fun64/tree/master/art/funfont64
//
// Each glyph is in vertical slices and ISO 8859-15 order,
// so the 4x8 font is 4 bytes with the high bits at the top.
// 

]])
fp:write(table.concat(o))
fp:close()
