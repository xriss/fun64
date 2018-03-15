
local chatdown=require("wetgenes.gamecake.fun.chatdown")

hardware,main=system.configurator({
	mode="fun64", -- select the standard 320x240 screen using the swanky32 palette.
	update=function() update() end, -- called repeatedly to update+draw
})

-- debug text dump
local ls=function(t) print(require("wetgenes.string").dump(t)) end



local chat_text=[[
- This is a single line comment
-- This is the start of a multi-line comment

All lines are now comment lines until we see a line that begins with a 
control character leading white space is ignored. If for some reason 
you need to start a text line with a special character then it can be 
escaped by preceding it with a #

What follows is a list of these characters and a brief description 
about the parser state they switch to.

	1. - (text to ignore)
	
		A single line comment that does not change parser state and 
		only this line will be ignored so it can be inserted inside 
		other chunks without losing our place.

	2. -- (text to ignore)
	
		Begin a comment chunk, this line and all lines that follow this 
		line will be considered comments and ignored until we switch to 
		a new parser state.

	3. #chat_name (short description)

		Begin a new chat chunk, all future chunks will belong to this chat.
		
		The rest of the text on the same line is the short description 
		intended for use inside menus.
		
		The text that follows this until the next chunk is the longer 
		description for when you examine the character and need to 
		display a long description.

	4. >topic_name
	
		Begin a topic chunk, the lines that follow are how the 
		character responds when questioned about this topic followed by 
		one or more gotos as possible responses.
		
	5. <goto_topic_name
	
		Begin a goto chunk, this is probably best thought of as a 
		question that will get a reply from the character. This is a 
		choice made by the player that causes a logical jump to another 
		topic.
		
		Essentially this means GOTO another topic and there will be 
		multiple GOTO options associated with each topic.
		
	6. =set_variable_name to this value
	
		Begin a variable chunk, the rest of this line and all following 
		lines will be assigned to the named variable.
		
		This assignment can happen at various places, for instance if 
		it is part of the long description then it will be the starting 
		value for a variable but if it is linked to a topic or goto 
		then it will be a change to this variable as the conversation 
		happens.
		
		Variables can be used inside text chunks or even GOTO labels by 
		tightly wrapping with {} eg {name} would be replaced with the 
		value of name.
		
		Because this is a parser state change and the value may span 
		multiple lines these assignment chunks must be placed at the 
		end of the CHAT , TOPIC or GOTO chunks that they are to be 
		associated with.
		

The hierarchy of these chunks can be expressed by indentation as all 
white space is ignored and combined into a single space. Each CHAT will 
have multiple TOPICs associated with it and each TOPIC will have 
multiple GOTOs as options to jump between TOPICs. SETs can be 
associated with any of these 3 levels and will be evaluated as the 
conversation flows through these points.


#example Conversation NPC

	A rare bread of NPC who will fulfil all your conversational desires for 
	a very good price.

	=sir sir/madam

	>convo

		Is this the right room for a conversation?
		
	>welcome
	
		...ERROR...EOF...PLEASE...RESTART...

<welcome

	Good Morning {sir},
	
	>morning

		Good morning to you too.

	>afternoon

		I think you will find it is now afternoon.

	>sir

		How dare you call me {sir}!

<sir

	My apologies, I am afraid that I am but an NPC with very little 
	brain, how might I address you?
	
	>welcome.1?sir!=madam

		You may address me as Madam.

		=sir madam

	>welcome.2?sir!=God

		You may address me as God.

		=sir God

	>welcome.3?sir!=sir

		You may address me as Sir.

		=sir sir

<afternoon
	
	Then good afternoon {sir},
	
	>convo

<morning
	
	and how may I help {sir} today?
	
	>convo


<convo

	Indeed it is, would you like the full conversation or just the quick natter?

	>convo_full
	
		How long is the full conversation?

	>convo_quick

		A quick natter sounds just perfect.

<convo_full

	The full conversation is very full and long so much so that you 
	will have to page through many pages before you get to make a 
	decision
	
	>
		Like this?
	<
	
	Yes just like this. In fact I think you can see that we are already 
	doing it.
			
	
	>welcome

<convo_quick

	...
	
	>welcome

]]


-----------------------------------------------------------------------------
--[[#setup_menu

	menu = setup_menu()

Create a displayable and controllable menu system that can be fed chat 
data for user display.

After setup, provide it with menu items to display using 
menu.show(items) then call update and draw each frame.


]]
-----------------------------------------------------------------------------
function setup_menu(items)

	local wstr=require("wetgenes.string")

	local menu={}

	menu.stack={}

	menu.width=80-4
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
					local prefix=""--(i>1 and " " or "")
					if item.cursor then prefix=" " end -- indent decisions
					menu.lines[#menu.lines+1]={s=prefix..ls[i],idx=idx,item=item,cursor=item.cursor,color=item.color}
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
			tprint(v.s,menu.cx+4,menu.cy+i+1,v.color or 31,1)
		end
		
		local it=nil
		for i=1,#menu.lines do
			if it~=menu.lines[i].item then -- first line only
				it=menu.lines[i].item
				if it.cursor == menu.cursor then
					tprint(">",menu.cx+4,menu.cy+i+1,31,1)
				end
			end
		end

		system.components.text.dirty(true)

	end
	

	if items then menu.show(items) end	
	return menu
end


-----------------------------------------------------------------------------
--[[#update

	update()

Update and draw loop, called every frame.

]]
-----------------------------------------------------------------------------
update=function()

	if not setup_done then
		chats=chatdown.setup(chat_text)
		menu=setup_menu( chats.get_menu_items("example") )
		setup_done=true
	end
	
	menu.update()
	menu.draw()
	
end
