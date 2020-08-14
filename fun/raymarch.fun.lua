
local wstr=require("wetgenes.string")
local wgrd=require("wetgenes.grd")
local tardis=require("wetgenes.tardis")	-- matrix/vector math

local bitdown=require("wetgenes.gamecake.fun.bitdown")
local bitdown_font_4x8=require("wetgenes.gamecake.fun.bitdown_font_4x8")


--
-- This is fun64 code, you can copy paste it into https://xriss.github.io/fun64/pad/ to run it.
--
hardware,main=system.configurator({
	mode="fun64", -- select the standard 320x240 screen using the swanky32 palette.
	update=function() update() end, -- called repeatedly to update+draw
})




-- define all graphics in this global, we will convert and upload to tiles at setup
-- although you can change tiles during a game, we try and only upload graphics
-- during initial setup so we have a nice looking sprite sheet to be edited by artists

graphics={

{0x0100,"",[[
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
]]},
{0x0101,"",[[
1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 
1 1 1 1 1 1 1 1 
]]},
{0x0102,"",[[
2 2 2 2 2 2 2 2 
2 2 2 2 2 2 2 2 
2 2 2 2 2 2 2 2 
2 2 2 2 2 2 2 2 
2 2 2 2 2 2 2 2 
2 2 2 2 2 2 2 2 
2 2 2 2 2 2 2 2 
2 2 2 2 2 2 2 2 
]]},
{0x0103,"",[[
7 7 7 7 7 7 7 7 
7 0 0 0 0 0 0 7 
7 0 0 0 0 0 0 7 
7 0 0 0 0 0 0 7 
7 0 0 0 0 0 0 7 
7 0 0 0 0 0 0 7 
7 0 0 0 0 0 0 7 
7 7 7 7 7 7 7 7 
]]},

{0x0200,"sprite_test",[[
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
. . . . . . . 7 7 . . . . . . 7 7 . . . . . . . 
]]},
}

local maps={}

local tilemap={
	[0]={0,0,0,0},

	[". "]={  0,  1, 31,  0},
	["1 "]={  1,  1, 31,  0},
	["2 "]={  2,  1, 31,  0},
	["3 "]={  3,  1, 31,  0},
	["4 "]={  4,  1, 31,  0},
	["5 "]={  5,  1, 31,  0},
	["6 "]={  6,  1, 31,  0},
	["7 "]={  7,  1, 31,  0},
	["8 "]={  8,  1, 31,  0},
	["9 "]={  9,  1, 31,  0},
	["A "]={ 10,  1, 31,  0},
	["B "]={ 11,  1, 31,  0},
	["C "]={ 12,  1, 31,  0},
	["D "]={ 13,  1, 31,  0},
	["E "]={ 14,  1, 31,  0},
	["F "]={ 15,  1, 31,  0},
}

maps[0]=[[
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
]]



-- we will call this once in the update function
setup=function()

--    system.components.screen.bloom=0
--    system.components.screen.filter=nil
--    system.components.screen.shadow=nil
    
	system.components.copper.shader_name="fun_copper_raymarch"

-- copy font data tiles into top line
	system.components.tiles.bitmap_grd:pixels(0,0,128*4,8, bitdown_font_4x8.grd_mask:pixels(0,0,128*4,8,"") )

-- upload graphics
	system.components.tiles.upload_tiles( graphics )

-- screen
	bitdown.pix_grd(    maps[0],  tilemap,      system.components.map.tilemap_grd  )--,0,0,48,32)

    print("Setup complete!")

end


-- updates are run at 60fps
update=function()
    
    if setup then setup() setup=nil end

	local names=system.components.tiles.names

-- test text
--[=[
	local tx=[[
    Fun is the enjoyment of pleasure, particularly in leisure activities. Fun is an experience - short-term, often unexpected, informal, not cerebral and generally purposeless. It is an enjoyable distraction, diverting the mind and body from any serious task or contributing an extra dimension to it. Although particularly associated with recreation and play, fun may be encountered during work, social functions, and even seemingly mundane activities of daily living. It may often have little to no logical basis, and opinions on whether or not an activity is fun may differ. A distinction between enjoyment and fun is difficult but possible to articulate, fun being a more spontaneous, playful, or active event. There are psychological and physiological implications to the experience of fun.]]
	local tl=wstr.smart_wrap(tx,system.components.text.text_hx)
	for i=0,system.components.text.tilemap_hy-1 do
		local t=tl[i+1]
		if not t then break end
		system.components.text.text_print(t,0,i)
	end

	system.components.text.px=(system.components.text.px+1)%system.components.screen.hx -- scroll text position
]=]

	
--	system.components.sprites.list_reset()

--	system.components.sprites.list_add({t=names.sprite_test.idx,h=24,px=100,py=100,rz=360*system.components.text.px/system.components.screen.hx})

end




-- Include GLSL code inside a comment
-- The GLSL handler will pickup the #shader directive and use all the code following it until the next #shader directive.
--[=[


#shader "fun_copper_raymarch"

#ifdef VERTEX_SHADER

uniform mat4 modelview;
uniform mat4 projection;
uniform vec4 color;

attribute vec3 a_vertex;
attribute vec2 a_texcoord;

varying vec2  v_texcoord;
varying vec4  v_color;
 
void main()
{
    gl_Position = projection * vec4(a_vertex, 1.0);
	v_texcoord=a_texcoord;
	v_color=color;
}


#endif
#ifdef FRAGMENT_SHADER

#if defined(GL_FRAGMENT_PRECISION_HIGH)
precision highp float; /* really need better numbers if possible */
#endif


varying vec2  v_texcoord;
varying vec4  v_color;


uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform float     iGlobalTime;           // shader playback time (in seconds)
uniform float     iTimeDelta;            // render time (in seconds)
uniform int       iFrame;                // shader playback frame
uniform float     iChannelTime[4];       // channel playback time (in seconds)
uniform vec3      iChannelResolution[4]; // channel resolution (in pixels)
uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
uniform sampler2D iChannel0;             // input channel. XX = 2D/Cube
uniform vec4      iDate;                 // (year, month, day, time in seconds)
uniform float     iSampleRate;           // sound sample rate (i.e., 44100)

const vec4 ZEROS = vec4( 0.0 , 1.0 , -1.0 , 1.0/32.0 );

const float MIN_DISTANCE = 1.0/1024.0;
const float MAX_DISTANCE = 1024.0;
const int MAX_STEPS = 32;



vec4 scene_floor_cheque( vec4 best, vec4 pos , vec4 a,vec4 b,vec4 c,vec4 d)
{
	vec3 cheque=floor( (pos.xyz-b.xyz)/a.w );
	vec4 try=vec4( mix( a.xyz , d.xyz , mod(cheque.x+cheque.z,2.0) ) ,
		dot((pos.xyz-b.xyz),c.xyz) );
	if(try.w<best.w) { return try; } else { return best; }
}

vec4 scene_floor( vec4 best, vec4 pos , vec4 a,vec4 b,vec4 c)
{
	vec4 try=vec4( a.xyz, dot((pos.xyz-b.xyz),c.xyz) );
	if(try.w<best.w) { return try; } else { return best; }
}

vec4 scene_ball( vec4 best, vec4 pos , vec4 a,vec4 b)
{
	vec4 try=vec4( a.xyz, length(pos.xyz-b.xyz)-a.w );
	if(try.w<best.w) { return try; } else { return best; }
}

vec4 scene(vec4 pos)
{
	float t=iGlobalTime;
	
	vec4 best=vec4( 0.0, 0.0, 0.0, MAX_DISTANCE );
	
	best=scene_ball( best, pos , vec4( 1.0, 0.0, 0.0, 64.0+sin(t*1.3)*16.0 ), vec4( 0.0, 0.0, 512.0+sin(t*5.0)*64.0, 0.0 ) );
	best=scene_ball( best, pos , vec4( 0.0, 1.0, 0.0, 64.0+sin(t*1.7)*16.0 ), vec4( 128.0*cos(t), 128.0*sin(t), 512.0+sin(t*7.0)*64.0, 0.0 ) );
	best=scene_ball( best, pos , vec4( 0.0, 0.0, 1.0, 64.0+sin(t*1.9)*16.0 ), vec4( -64.0*cos(t*1.5), -64.0*sin(t*1.5), 512.0+sin(t*9.0)*64.0, 0.0 ) );

	best=scene_floor_cheque( best, pos , vec4( 1.0, 1.0, 1.0, 32.0 ), vec4( 0.0, 160.0+sin(t)*16.0, 0.0, 0.0 ), normalize( vec4( 0.1, -1.0, -0.1, 0.0 ) ) , vec4(1.0,0.0,0.0,0.0) );
	
	return best;
}

vec4 hit_normal(vec4 position)
{
    float base = scene(position).w;
	return normalize(
		vec4(
			base-scene(position-ZEROS.wxxx).w,
			base-scene(position-ZEROS.xwxx).w,
			base-scene(position-ZEROS.xxwx).w,
			0.0
		)
	);
}

vec4 march(vec4 position, vec4 direction)
{

	float distance = 0.0;
	vec4 hit;

	for( int i=0; i<MAX_STEPS; i++ )
	{
		vec4 pos = position + distance * direction;

		vec4 hit = scene(vec4(pos.xyz,distance));

		if (hit.w < MIN_DISTANCE)
		{
			return vec4( hit.xyz, distance );
		}

		distance += hit.w;

		if(distance >= MAX_DISTANCE)
		{
			return vec4( 0.0, 0.0, 0.0, MAX_DISTANCE );
		}
	}

	return vec4( hit.xyz, distance );
}


void main(void)
{
    vec2 uv=2.0/iResolution.y*(v_texcoord-(iResolution.xy*0.5));

	vec4 position=vec4( 0, 0, 0, 0.0 );
	vec4 direction=normalize( vec4( uv , 2.0, 0.0 ) );
	
	vec4 hit=march(position,direction);
	vec4 pos=position + hit.w * direction;
	vec4 nrm=hit_normal(pos);

	vec4 dir2=vec4(reflect(direction.xyz,nrm.xyz),0.0);
	vec4 hit2=march(pos+dir2*1.0,dir2);

//	vec4 pos2=pos + hit2.w * dir2;
//	vec4 nrm2=hit_normal(pos2);
//	vec4 dir3=vec4(reflect(dir2.xyz,nrm2.xyz),0.0);
//	vec4 hit3=march(pos2+dir3*1.0,dir3);

	gl_FragColor=mix( vec4( hit.rgb*0.5, 1.0) , vec4( hit.rgb, 1.0) , pow(-nrm.z,4.0) );

	gl_FragColor+=vec4( hit2.rgb*0.125, 1.0);
//	gl_FragColor+=vec4( hit3.rgb*0.125, 1.0);
	
	gl_FragColor=mix( gl_FragColor , vec4( 0.2, 0.2, 0.4, 1.0) , clamp( hit.w/MAX_DISTANCE*1.0 , 0.25 , 1.0) );

}




#endif



#shader

This text will be ignored

//]=]
