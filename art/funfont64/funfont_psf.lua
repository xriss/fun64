
require("apps").default_paths() -- default search paths so things can easily be found

local utf8=require("utf8")

local wgrd=require("wetgenes.grd")
local wpack=require("wetgenes.pack")
local wstring=require("wetgenes.string")

local bitdown=require("wetgenes.gamecake.fun.bitdown")

local funfont64=require("funfont64")

-- create psf files for all the funfont sizes and styles

--[[

#define PSF2_MAGIC0     0x72
#define PSF2_MAGIC1     0xb5
#define PSF2_MAGIC2     0x4a
#define PSF2_MAGIC3     0x86

/* bits used in flags */
#define PSF2_HAS_UNICODE_TABLE 0x01

/* max version recognized so far */
#define PSF2_MAXVERSION 0

/* UTF8 separators */
#define PSF2_SEPARATOR  0xFF
#define PSF2_STARTSEQ   0xFE

struct psf2_header {
        unsigned char magic[4];
        unsigned int version;
        unsigned int headersize;    /* offset of bitmaps in file */
        unsigned int flags;
        unsigned int length;        /* number of glyphs */
        unsigned int charsize;      /* number of bytes for each character */
        unsigned int height, width; /* max dimensions of glyphs */
        /* charsize = height * ((width + 7) / 8) */
};


]]


local create_psf=function( glyphs , xh , yh )


--	local length=0
--	for idx=0,255 do if glyphs[ idx ] then length=length+1 end end
	local length=256
	local xpad=math.floor((xh+7)/8)*8
	local bitmapsize=(xpad/8)*yh
	
	local getbitmap=function(str)
		local ls=wstring.split(str,"\n")
		local t={}
		local tx=0
		local pushend=function()
			if tx%8 ~= 0 then --pad
				t[#t]=t[#t]*(2^(8-(tx%8)))
			end
			tx=0
		end
		local pushbit=function(b)
			if tx%8==0 then
				t[#t+1]=0
			end
			t[#t]=(t[#t]*2)+(b and 1 or 0)
			tx=tx+1
		end
		
		for y=1,yh do
			local s=ls[y] or ""
			local b=0
			for x=1,xh do
				pushbit( s:sub(x*2-1,x*2-1) == "7" )
			end
			pushend()
		end

		return wpack.save_array(t,"u8")

	end
	
	local header=wpack.save_array(
		{

			0x864ab572,
			0,
			8*4,
			1,
			length,
			bitmapsize,
			yh,xh,

		},"u32")
		
	local datas={}
	local codes={}

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


	for idx=0,255 do
		local g = glyphs[ idx ]
--		if g then
			datas[#datas+1]=getbitmap(g or "")
			codes[#codes+1]=utf8.char(unimap[idx] or idx)..string.char(0xFF)
--		end
	end


	return header..table.concat(datas)..table.concat(codes)

end


local writefont=function(fname,dat,w,h)
	local fp=io.open(fname,"wb")
	local fd=create_psf( dat , w , h )
	fp:write(fd)
	fp:close()
end

-- this font size is only possible as bold
writefont("./funfont_4x8b.psf", funfont64.data4x8   , 4 , 8  )

-- but here we have a choice
writefont("./funfont_8x16b.psf",funfont64.data8x16  , 8 , 16 )
writefont("./funfont_8x16r.psf",funfont64.data8x16r , 8 , 16 )
writefont("./funfont_8x16i.psf",funfont64.data8x16i , 8 , 16 )


