

#shader "fun_step_watercell"

uniform mat4 modelview;
uniform mat4 projection;
uniform sampler2D tex_cell;
uniform vec4  map_info; /* 2,3 the map texture size*/

#ifdef VERTEX_SHADER

attribute vec3 a_vertex;
attribute vec2 a_texcoord;

varying vec2  v_texcoord;
 
void main()
{
	gl_Position = projection * vec4(a_vertex , 1.0);
	v_texcoord=a_texcoord;
}


#endif
#ifdef FRAGMENT_SHADER

#if defined(GL_FRAGMENT_PRECISION_HIGH)
precision highp float; /* really need better numbers if possible */
#endif

varying vec2  v_texcoord;


// where should the center flow to, return a single direction only
vec3 get_flow_vert(vec4 ctr,vec4 top,vec4 bot,vec4 lft,vec4 rgt)
{
	if( (ctr.a==2.0) && (bot.a==0.0) ) // water generator
	{
		if(bot.b<128.0) { return  vec3(0.0,1.0,1.0); }
	}
	else
	if( (ctr.a==0.0) && (ctr.b>=1.0) )
	{
		if( (bot.a==0.0) )
		{
			if( (ctr.b>=bot.b) || (bot.b<=8.0) ) { return vec3(0.0,1.0,1.0); } // fall
		}

		if( (top.a==0.0) && (ctr.b>8.0) )
		{
			if(ctr.b>top.b) { return vec3(0.0,-1.0,1.0); } // push up
		}

		if( (lft.a==0.0) && (rgt.a==0.0) ) // try left or right?
		{
			if( (ctr.x<=0.0) )
			{
				if(ctr.b>lft.b) { return vec3(-1.0,0.0,1.0); }
			}
			if( (ctr.x>=0.0) )
			{
				if(ctr.b>rgt.b) { return vec3( 1.0,0.0,1.0); }
			}
			if(ctr.b>lft.b) { return vec3(-1.0,0.0,1.0); }
			if(ctr.b>rgt.b) { return vec3( 1.0,0.0,1.0); }
		}
		else
		if( (lft.a==0.0) ) // try left
		{
			if(ctr.b>lft.b) { return vec3(-1.0,0.0,1.0); }
		}
		else
		if( (rgt.a==0.0) ) // try right
		{
			if(ctr.b>rgt.b) { return vec3( 1.0,0.0,1.0); }
		}


	}

	return vec3(0.0,0.0,0.0);
}

void main(void)
{
	vec4 cc[13];
	vec2 vx=vec2(1.0, 0.0)/map_info.zw;
	vec2 vy=vec2(0.0, 1.0)/map_info.zw;
	float w,w1,w2;
	vec3 fctr,ftop,fbot,flft,frgt;


	cc[0]=texture2D(tex_cell, v_texcoord-vy-vx ).rgba*255.0; // toplft
	cc[1]=texture2D(tex_cell, v_texcoord-vy    ).rgba*255.0; // top
	cc[2]=texture2D(tex_cell, v_texcoord-vy+vx ).rgba*255.0; // toprgt

	cc[3]=texture2D(tex_cell, v_texcoord-vx ).rgba*255.0; // lft
	cc[4]=texture2D(tex_cell, v_texcoord    ).rgba*255.0; // ctr
	cc[5]=texture2D(tex_cell, v_texcoord+vx ).rgba*255.0; // rgt

	cc[6]=texture2D(tex_cell, v_texcoord+vy-vx ).rgba*255.0; // botlft
	cc[7]=texture2D(tex_cell, v_texcoord+vy    ).rgba*255.0; // bot
	cc[8]=texture2D(tex_cell, v_texcoord+vy+vx ).rgba*255.0; // botrgt

	cc[9]=texture2D(tex_cell, v_texcoord-vx-vx ).rgba*255.0; // lftlft
	cc[10]=texture2D(tex_cell, v_texcoord+vx+vx ).rgba*255.0; // rgtrgt
	cc[11]=texture2D(tex_cell, v_texcoord-vy-vy ).rgba*255.0; // toptop
	cc[12]=texture2D(tex_cell, v_texcoord+vy+vy ).rgba*255.0; // botbot
		
	if(cc[4].a == 0.0) // empty
	{
		w=0.0;
		
		fctr=get_flow_vert(cc[4],cc[1],cc[7],cc[3],cc[5]);
		
		ftop=get_flow_vert(cc[1],cc[11],cc[4],cc[0],cc[2]);
		fbot=get_flow_vert(cc[7],cc[4],cc[12],cc[6],cc[8]);
		flft=get_flow_vert(cc[3],cc[0],cc[6],cc[9],cc[4]);
		frgt=get_flow_vert(cc[5],cc[2],cc[8],cc[4],cc[10]);


		w-=fctr.z;

		if(abs(fctr.x)>0.0) { cc[4].x=fctr.x; }

		if(ftop.y>0) { w+=ftop.y; if(fctr.z==0.0){cc[4].x=cc[1].x; } }
		if(fbot.y<0) { w-=fbot.y; if(fctr.z==0.0){cc[4].x=cc[7].x; } }
		if(flft.x>0) { w+=flft.x; if(fctr.z==0.0){cc[4].x=flft.x;} }
		if(frgt.x<0) { w-=frgt.x; if(fctr.z==0.0){cc[4].x=frgt.x;} }

		cc[4].b+=w;
	}
	
	gl_FragColor=cc[4]/255.0;
}

#endif

#shader "fun_draw_watercell"

uniform mat4 modelview;
uniform mat4 projection;
uniform vec4 color;
uniform sampler2D tex_cmap;
uniform sampler2D tex_tile;
uniform sampler2D tex_map;
uniform vec4  tile_info; /* 0,1 tile size eg 8x8 and 2,3 the font texture size*/
uniform vec4  map_info; /* 0,1 just add this to texcoord and 2,3 the map texture size*/


#ifdef VERTEX_SHADER

attribute vec3 a_vertex;
attribute vec2 a_texcoord;

varying vec2  v_texcoord;
varying vec4  v_color;
 
void main()
{
    gl_Position = projection * modelview * vec4(a_vertex.xy, 0.0 , 1.0);
    gl_Position.z+=a_vertex.z;
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


void main(void)
{
	vec2 vy=vec2(0.0, 1.0)/map_info.zw;

	vec4 bg,fg; // colors
	vec4 c;
	vec4 cc,cb;
	vec4 d;
	vec2 uv=v_texcoord.xy+map_info.xy;		// base uv
	vec2 tc=fract(uv);						// tile uv
	vec2 tm=(floor(mod(uv,map_info.zw))+vec2(0.5,0.5))/map_info.zw;			// map uv
	
	cc=texture2D(tex_map, tm).rgba*255.0;
	cb=texture2D(tex_map, tm+vy).rgba*255.0;
	
	d=vec4( 0.0 /255.0, 2.0 /255.0, 31.0 /255.0, 0.0 /255.0); // default to nothing

	if(cc.a == 0.0) // empty
	{

		if( (cb.a != 0.0) || (cb.b>=8) )// solid
		{
			d.r=(16.0+min(cc.b,8.0))/255.0;
			if(cc.b>=8.0) // some water
			{
				d.b=( 31.0-min((cc.b-8.0)/2.0,6.0) )/255.0;
			}
		}
		else
		{
			if(cc.b>=4.0) // some water
			{
				d.r=4.0/255.0;
			}
			else
			if(cc.b>=3.0) // some water
			{
				d.r=3.0/255.0;
			}
			else
			if(cc.b>=2.0) // some water
			{
				d.r=2.0/255.0;
			}
			else
			if(cc.b>=1.0) // some water
			{
				d.r=1.0/255.0;
			}
		}
	}
	else
	if(cc.a == 1.0) // solid
	{
	}
	else
	if(cc.a == 2.0) // water generator
	{
			d.r=4.0/255.0;
	}

//	d.r=4.0/255.0;
//	d.g=1.0/255.0;
//	d.b=31.0/255.0;
//	d.a=0.0/255.0;
	
	c=texture2D(tex_tile, (((d.rg*vec2(255.0,255.0))+tc)*tile_info.xy)/tile_info.zw ).rgba;
	fg=texture2D(tex_cmap, vec2( d.b,0.5) ).rgba;
	bg=texture2D(tex_cmap, vec2( d.a,0.5) ).rgba;

	c*=fg; // forground tint, can adjust its alpha
	c=((bg*(1.0-c.a))+c)* v_color; // background color mixed with pre-multiplied foreground and then finally tint all of it by the main color
 
	gl_FragColor=c;

}

#endif

