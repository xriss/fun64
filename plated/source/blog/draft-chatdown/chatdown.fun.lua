
local ls=function(t) print(require("wetgenes.string").dump(t)) end


hardware,main=system.configurator({
	mode="fun64", -- select the standard 320x240 screen using the swanky32 palette.
	update=function() update() end, -- called repeatedly to update+draw
})





local str=[[


#control.colson		Andy Colson

This fat, balding controller looks exactly like another fat, balding 
-this is a comment and will be ignored
controller you know.

-escape special chars at start of line with a hash
## hash
#- minus
#. dot
#> morethan

-- initial proxy values, can be changed by response or code.
=fruit		banana
=fruits		bananas

-- default response texts, used if no special response text is given in the dialogue tree
>exit

	Default exit request if no explicit text is given.
	
	
	Longer request text, eg the spoken response after selecting the 
	first line above as the written response.

	>welcome.1
		Restart...

.welcome

	>exit
		This is a test inheritance.

.welcome.1

	The only way to get down to the first level right now is through 
	the elevator and we can't even open the doors from up here. The 
	whole shaft is protected by {fruits}.
	
	>welcome.2
		Infrared or gas discharge?

.welcome.2

	Gas. CO2, 10,000 watts.
	
	>exit
		WOW! You boys take your elevator shafts pretty seriously.
		
	>cig
		Spare a cigarette?
		=fruit		apple
		=fruits		apples

.cig

	Oh sure.
	
	>pack
		Thank you!
	>exit

.pack

	Take the whole pack why don't ya?
	
	Want my lighter too?
	
	>exit
		No thanks, I always carry my own matches.
		

]]

local parse_chats=function(str)

	local function text_to_trimed_lines(str)

		local lines={}
		local i=1
		
		for s in string.gmatch(str, "([^\n]*)\n?") do
			s=s:match("^%s*(.-)%s*$")
			lines[i]=s
			i=i+1
		end
				
		return lines
	end


	local lines=text_to_trimed_lines(str)

	local text={}

	local chats={}
	local chat={}

	local requests={}
	local request={}

	local responces={}
	local responce={}

	local proxies={}
	local proxy={}

	for i,v in ipairs(lines) do

		local name

		local code=v:sub(1,1)

		if code=="#" then -- #description

			local c=v:sub(2,2)
			
			if c=="#" or c=="." or c=="=" or c==">" or c=="-" then -- escape codes

				v=v:sub(2) -- just remove hash from start of line
			
			else

				name,v=v:match("%#(%S*)%s*(.*)$")
				
				text={}
				requests={}
				responses={}
				proxies={}
				chat={text=text,requests=requests,proxies=proxies,responses=responses}
				
				
				chat.name=name
				chat.text=text

				if name~="" then -- ignore empty names
				
					assert( not chats[name] , "description name used twice on line "..i.." : "..name )
					chats[name]=chat
				
				end
				
			end

		elseif code==">" then -- >request
		
			name,v=v:match("%>(%S*)%s*(.*)$")
		
			text={}
			request={text=text,name=name}

			requests[#requests+1]=request

		elseif code=="." then -- .response

			name,v=v:match("%.(%S*)%s*(.*)$")

			text={}
			requests={}
			proxies={}
			response={text=text,requests=requests,proxies=proxies}

			if name~="" then -- ignore empty names
			
				assert( not responses[name] , "response name used twice on line "..i.." : "..name )
				responses[name]=response
			
			end

		elseif code=="=" then -- =proxy
		
			name,v=v:match("%=(%S*)%s*(.*)$")

			text={}
			proxy=text

			if name~="" then -- ignore empty names
			
				assert( not proxies[name] , "proxy name used twice on line "..i.." : "..name )
				proxies[name]=proxy
			
			end
			
		elseif code=="-" then -- -comment
		
			v=nil

		end
		
		if v then

			text[#text+1]=v

		end

		
	end

	-- cleanup output

	local cleanup_proxies=function(proxies)

		local empty=true
		for n,v in pairs(proxies) do
			empty=false
			proxies[n]=table.concat(v,"\n"):match("^%s*(.-)%s*$")
		end
		if empty then return end

		return proxies
	end

	local cleanup_text=function(text)

		local t={""}

		for i,v in ipairs(text) do
			if v=="" then
				if t[#t]~="" then t[#t+1]="" end -- start a new string?
			else
				t[#t]=(t[#t].." "..v):match("^%s*(.-)%s*$")
			end
		end
		
		while t[1]=="" do table.remove(t,1) end
		while t[#t]=="" do table.remove(t,#t) end
		
		if not t[1] then return nil end -- empty text
		if t[2] then return t end -- return an array
		return t[1] -- just the first line
	end


	for name,chat in pairs(chats) do

		chat.text=cleanup_text(chat.text)
		chat.proxies=cleanup_proxies(chat.proxies)

		for id,request in pairs(chat.requests) do

			request.text=cleanup_text(request.text)
		end

		for id,response in pairs(chat.responses) do

			response.text=cleanup_text(response.text)
			response.proxies=cleanup_proxies(response.proxies)

			for id,request in pairs(response.requests) do

				request.text=cleanup_text(request.text)
			end
		end

	end

	return chats

end

local dotnames=function(name)
	local n,r=name,name
	local f=function(a,b)
		r=n -- start with the full string
		n=n and n:match("^(.+)(%..+)$") -- prepare the parent string
		return r
	end
	return f
end
--for n in dotnames("control.colson.2") do print(n) end

local init_chat=function(chats,chat_name,response_name)

	local chat={}
	
	chat.chats=chats
	chat.proxies={}
	
	chat.gui={}
    	
	chat.set_description=function(name)
	
		chat.description_name=name	
		chat.description=chat.chats[name]
		chat.responses=chat.description.responses

	end

	chat.set_response=function(name)
	
		chat.response_name=name
		chat.response=chat.responses[name]
		chat.requests=chat.response and chat.response.requests
	end

	
	chat.set_description(chat_name)
	chat.set_response(response_name)
	
	chat.get_display_list=function()
		local items={cursor=1,cursor_max=0}
		
		items.title=chat.description_name
		
		local ss=chat.response and chat.response.text or {} if type(ss)=="string" then ss={ss} end
		for i,v in ipairs(ss) do
			if i>1 then
				items[#items+1]={text="",chat=chat} -- blank line
			end
			items[#items+1]={text=v,chat=chat}
		end

		for i,v in ipairs(chat.response and chat.response.requests or {}) do

			items[#items+1]={text="",chat=chat} -- blank line before each request

			local ss=v and v.text or {} if type(ss)=="string" then ss={ss} end

			local f=function(item,menu)

				print(item.text)

				if item.request and item.request.name then

					chat.set_response(item.request.name)

					menu.show(chat.get_display_list())

				end
			end
			items[#items+1]={text=ss[1],chat=chat,request=v,cursor=i,call=f} -- only show first line
			items.cursor_max=i
		end

		return items
	end

	return chat
end


-- manage a menu
function setup_menu()

	local wstr=require("wetgenes.string")

	local menu={}

	menu.stack={}

	menu.width=64
	menu.cursor=0
	menu.cx=math.floor((80-menu.width)/2)
	menu.cy=0
	
	function menu.show(items)

		if items.call then items.call(items,menu) end -- refresh
		
		menu.items=items
		menu.cursor=items.cursor or 1
		
		menu.lines={}
		for idx=1,#items do
			local item=items[idx]
			local text=item.text
			if text then
				local ls=wstr.smart_wrap(text,menu.width-8)
				if #ls==0 then ls={""} end -- blank line
				for i=1,#ls do
					local prefix=(i>1 and " " or "")
					if not item.cursor then prefix="" end -- do not indent or allow selection
					menu.lines[#menu.lines+1]={s=prefix..ls[i],idx=idx,item=item,cursor=item.cursor}
				end
			end
		end

	end


	
	menu.update=function()
	
		if not menu.items then return end

		local bfire,bup,bdown,bleft,bright
		
		for i=0,5 do -- any player, press a button, to control menu
			local up=ups(i)
			if up then
				bfire =bfire  or up.button("fire_clr")
				bup   =bup    or up.button("up_set")
				bdown =bdown  or up.button("down_set")
				bleft =bleft  or up.button("left_set")
				bright=bright or up.button("right_set")
			end
		end
		

		if bfire then

			for i,item in ipairs(menu.items) do
			
				if item.cursor==menu.cursor then
			
					if item.call then -- do this
					
						item.call( item , menu )
											
					end
					
					break
				end
			end
		end
		
		if bleft or bup then
		
			menu.cursor=menu.cursor-1
			if menu.cursor<1 then menu.cursor=menu.items.cursor_max end

		end
		
		if bright or bdown then
			
			menu.cursor=menu.cursor+1
			if menu.cursor>menu.items.cursor_max then menu.cursor=1 end
		
		end
	
	end
	
	menu.draw=function()

		local tprint=system.components.text.text_print
		local tgrd=system.components.text.tilemap_grd

		if not menu.lines then return end
		
		menu.cy=math.floor((30-(#menu.lines+4))/2)
		
		tgrd:clip(menu.cx,menu.cy,0,menu.width,#menu.lines+4,1):clear(0x02000000)
		tgrd:clip(menu.cx+2,menu.cy+1,0,menu.width-4,#menu.lines+4-2,1):clear(0x01000000)
		
		if menu.items.title then
			local title=" "..(menu.items.title).." "
			local wo2=math.floor(#title/2)
			tprint(title,menu.cx+(menu.width/2)-wo2,menu.cy+0,31,2)
		end
		
		for i,v in ipairs(menu.lines) do
			tprint(v.s,menu.cx+4,menu.cy+i+1,31,1)
		end
		
		local it=nil
		for i=1,#menu.lines do
			if it~=menu.lines[i].item then -- first line only
				it=menu.lines[i].item
				if it.cursor == menu.cursor then
					tprint(">",menu.cx+3,menu.cy+i+1,31,1)
				else
--					tprint(".",menu.cx+3,menu.cy+i+1,31,1)
				end
			end
		end

		system.components.text.dirty(true)

	end
	
	return menu
end


setup=function()
	if setup_done then return else setup_done=true end

	menu=setup_menu()
	chats=parse_chats(str)
	chat=init_chat(chats,"control.colson","welcome.1")


	--print(require("wetgenes.string").dump(chats))
	--menu.show{items={s="sometext"}}

	menu.show(chat.get_display_list())

end

-- updates are run at 60fps
update=function()

	setup()
	
	menu.update()
	menu.draw()

--	system.components.text.text_print("Hello World!",5,2,31,0) -- (text,x,y,color,background)
	
end
