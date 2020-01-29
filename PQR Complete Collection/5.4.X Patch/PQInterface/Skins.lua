----[[ Ini ]]------------------------------------------------------------------------------------------------------------------
local AddOnName, Env = ...
local ADDON = Env[1] 
local D = ADDON.development
----[[ Ace Ini ]]--------------------------------------------------------------------------------------------------------------

----[[ Lua Ini ]]--------------------------------------------------------------------------------------------------------------
local select, unpack						= select, unpack
local type	 								= type
local sub, find, format 				= string.sub, string.find, string.format
local floor, ceil, min, max			= math.floor, math.ceil, math.min, math.max
----[[ WoW Ini ]]--------------------------------------------------------------------------------------------------------------
local GetSpellInfo, GetTime  = GetSpellInfo, GetTime


----[[ Locals ]]---------------------------------------------------------------------------------------------------------------
local HiddenFrame = CreateFrame("Frame")
HiddenFrame:Hide()
local function Kill(object)
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
		object:SetParent(HiddenFrame)
	else
		object.Show = object.Hide
	end
	
	object:Hide()
end
local function StripTextures(object, kill)
	for i=1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region and region:GetObjectType() == "Texture" then
			if kill and type(kill) == 'boolean' then
				Kill(region)
			elseif region:GetDrawLayer() == kill then
				region:SetTexture(nil)
			elseif kill and type(kill) == 'string' and region:GetTexture() ~= kill then
				region:SetTexture(nil)
			else
				region:SetTexture(nil)
			end
		end
	end
end

----[[ Styling Functions ]]-----------------------------------------------------------------------------------------------------
local function DrawWidgetBevel(frame,s)
	s = s or {}
	s.alpha = s.alpha or .1
	if type(s.offset) ~='table' then	
		s.offset = s.offset and {s.offset,s.offset,s.offset,s.offset} or {0,0,0,0}	
	end
	local frame = CreateFrame("Frame",nil,frame)
	frame:SetPoint("TOPLEFT", -s.offset[1]-1,s.offset[2]+1)
	frame:SetPoint("BOTTOMRIGHT", s.offset[3]+1, -s.offset[4]-1)	
	
	
	local bottom = frame:CreateTexture(nil,'BACKGROUND')
	bottom:SetPoint("BOTTOMLEFT", 3, 0)
	bottom:SetPoint("BOTTOMRIGHT", -3, 0)
	bottom:SetHeight(1)
	bottom:SetTexture(1,1,1,s.alpha)
	
	local bottomLeft = frame:CreateTexture(nil,'BACKGROUND')
	bottomLeft:SetPoint("BOTTOMLEFT", 0, 0) 
	bottomLeft:SetWidth(3)
	bottomLeft:SetHeight(1)
	bottomLeft:SetTexture(1,1,1,1)	
	bottomLeft:SetGradientAlpha('HORIZONTAL',1,1,1,s.alpha / 5,1,1,1,s.alpha)		
	
	local bottomRight = frame:CreateTexture(nil,'BACKGROUND')
	bottomRight:SetPoint("BOTTOMRIGHT", 0, 0) 
	bottomRight:SetWidth(3)
	bottomRight:SetHeight(1)
	bottomRight:SetTexture(1,1,1,1)	
	bottomRight:SetGradientAlpha('HORIZONTAL',1,1,1,s.alpha,1,1,1,s.alpha / 5)	
	
	local rightBottom = frame:CreateTexture(nil,'BACKGROUND')
	rightBottom:SetPoint("BOTTOMRIGHT", 0, 1) 
	rightBottom:SetWidth(1)	
	rightBottom:SetHeight(3)
	rightBottom:SetTexture(1,1,1,1)	
	rightBottom:SetGradientAlpha('VERTICAL',1,1,1,s.alpha/1.66,1,1,1,0) 
	
	local leftBottom = frame:CreateTexture(nil,'BACKGROUND')
	leftBottom:SetPoint("BOTTOMLEFT", 0, 1) 
	leftBottom:SetWidth(1)	
	leftBottom:SetHeight(3)
	leftBottom:SetTexture(1,1,1,1)	
	leftBottom:SetGradientAlpha('VERTICAL',1,1,1,s.alpha/1.66,1,1,1,0) 
	
end
local function DrawGlassFrame(frame,s)
	s = s or {}	
	if type(s.offset) ~='table' then	
		s.offset = s.offset and {s.offset,s.offset,s.offset,s.offset} or {0,0,0,0}	
	end
	
	local glassOutlineAlpha 	= s.glassOutlineAlpha 	or .1
	local shadowAlpha 			= s.shadowAlpha 			or .6
	local shadowOutlineAlpha 	= s.shadowOutlineAlpha 	or .01
	
	local frame = CreateFrame("Frame",nil,frame)
	frame:SetPoint("TOPLEFT", -s.offset[1]-1,s.offset[2]+1)
	frame:SetPoint("BOTTOMRIGHT", s.offset[3]+1, -s.offset[4]-1)	
	
	local shadow = CreateFrame("Frame",nil,frame)
	shadow:SetPoint("TOPLEFT", -18, 18)
	shadow:SetPoint("BOTTOMRIGHT", 18, -18)
	shadow:SetBackdrop({ edgeFile = ADDON.mediaPath.."PQRShadow",edgeSize = 28 })
	shadow:SetBackdropBorderColor(0,0,0,shadowAlpha)
	
	local background = frame:CreateTexture(nil,'BACKGROUND',nil,-8)
	background:SetPoint("TOPLEFT", -2,2)
	background:SetPoint("BOTTOMRIGHT", 2, -2)

	local shadowOutlineTOP = frame:CreateTexture(nil,'BACKGROUND')
	shadowOutlineTOP:SetPoint("TOPLEFT", 1, 1) shadowOutlineTOP:SetPoint("TOPRIGHT", -1, 1)
	shadowOutlineTOP:SetHeight(1)
	shadowOutlineTOP:SetTexture(0,0,0,shadowOutlineAlpha)
	local shadowOutlineBottom = frame:CreateTexture(nil,'BACKGROUND')
	shadowOutlineBottom:SetPoint("BOTTOMLEFT", 1, -1) shadowOutlineBottom:SetPoint("BOTTOMRIGHT", -1, -1)
	shadowOutlineBottom:SetHeight(1)
	shadowOutlineBottom:SetTexture(0,0,0,shadowOutlineAlpha)
	local shadowOutlineLeft = frame:CreateTexture(nil,'BACKGROUND')
	shadowOutlineLeft:SetPoint("TOPLEFT", -1, -1) shadowOutlineLeft:SetPoint("BOTTOMLEFT", -1, 1)
	shadowOutlineLeft:SetWidth(1)
	shadowOutlineLeft:SetTexture(0,0,0,shadowOutlineAlpha)
	local shadowOutlineRight = frame:CreateTexture(nil,'BACKGROUND')
	shadowOutlineRight:SetPoint("TOPRIGHT", 1,-1) shadowOutlineRight:SetPoint("BOTTOMRIGHT", 1, 1)
	shadowOutlineRight:SetWidth(1)
	shadowOutlineRight:SetTexture(0,0,0,shadowOutlineAlpha)

	local shadowOutlineTL = frame:CreateTexture(nil,'BACKGROUND')
	shadowOutlineTL:SetPoint("TOPLEFT")
	shadowOutlineTL:SetSize(1,1)
	shadowOutlineTL:SetTexture(0,0,0,shadowOutlineAlpha)
	local shadowOutlineBL = frame:CreateTexture(nil,'BACKGROUND')
	shadowOutlineBL:SetPoint("BOTTOMLEFT")
	shadowOutlineBL:SetSize(1,1)
	shadowOutlineBL:SetTexture(0,0,0,shadowOutlineAlpha)
	local shadowOutlineTR = frame:CreateTexture(nil,'BACKGROUND')
	shadowOutlineTR:SetPoint("TOPRIGHT")
	shadowOutlineTR:SetSize(1,1)
	shadowOutlineTR:SetTexture(0,0,0,shadowOutlineAlpha)
	local shadowOutlineBR = frame:CreateTexture(nil,'BACKGROUND')
	shadowOutlineBR:SetPoint("BOTTOMRIGHT")
	shadowOutlineBR:SetSize(1,1)
	shadowOutlineBR:SetTexture(0,0,0,shadowOutlineAlpha)
	
	local glassHLTOP = frame:CreateTexture(nil,'BACKGROUND')
	glassHLTOP:SetPoint("TOPLEFT", 1, 0) glassHLTOP:SetPoint("TOPRIGHT", -1, 0)
	glassHLTOP:SetHeight(1)
	glassHLTOP:SetTexture(1,1,1,glassOutlineAlpha)
	local glassHLBottom = frame:CreateTexture(nil,'BACKGROUND')
	glassHLBottom:SetPoint("BOTTOMLEFT", 1, 0) glassHLBottom:SetPoint("BOTTOMRIGHT", -1, 0)
	glassHLBottom:SetHeight(1)
	glassHLBottom:SetTexture(1,1,1,glassOutlineAlpha)
	local glassHLLeft = frame:CreateTexture(nil,'BACKGROUND')
	glassHLLeft:SetPoint("TOPLEFT", 0, -1) glassHLLeft:SetPoint("BOTTOMLEFT", 0, 1)
	glassHLLeft:SetWidth(1)
	glassHLLeft:SetTexture(1,1,1,glassOutlineAlpha)
	local glassHLRight = frame:CreateTexture(nil,'BACKGROUND')
	glassHLRight:SetPoint("TOPRIGHT", 0, -1) glassHLRight:SetPoint("BOTTOMRIGHT", 0, 1)
	glassHLRight:SetWidth(1)
	glassHLRight:SetTexture(1,1,1,glassOutlineAlpha)

end
local function DrawTexture(frame,s)	
	--s.offset			( offset|{Left, Top, Right, Bottom})
	--s.color			( Red, Green, Blue) [0-255]
	--s.gradient		( VERTICAL|HORIZONTAL )
	--s.texture			( texture file )	
	--s.tile				( true|false )	
	--s.pointLeft 		( xOffset )
	--s.pointTop 		( yOffset )
	--s.pointRight 	( xOffset )
	--s.pointBottom 	( yOffset )
	--s.width			( width )
	--s.height			( height )
	s = s or {}
	---- Settings ------------------------------------------------------		
	s.alpha 			= s.alpha 		or 1
	s.alphaTo		= s.alphaTo 	or s.alpha 
	s.layer 			= s.layer 		or 'BACKGROUND'	
	s.subLevel 		= s.subLevel 	or -8		
	if not s.texture then 
		s.colorTo 		= s.colorTo		or ADDON:TableCopy(s.color)
		s.color[1] 		= s.color[1] 	/ 255			-- Red
		s.color[2] 		= s.color[2] 	/ 255			-- Green
		s.color[3] 		= s.color[3] 	/ 255			-- Blue	
		s.colorTo[1] 	= s.colorTo[1] / 255			-- Red
		s.colorTo[2] 	= s.colorTo[2] / 255			-- Green
		s.colorTo[3] 	= s.colorTo[3] / 255			-- Blue	
	end
	if type(s.offset) ~='table' then	
		s.offset = s.offset and {s.offset,s.offset,s.offset,s.offset} or {0,0,0,0}	-- Left, Top, Right, Bottom 
	end
	
	s.PointSet = s.pointLeft or s.pointTop or s.pointRight or s.pointBottom 	
	---- Constructor ---------------------------------------------------
	local texture = frame:CreateTexture(nil,s.layer,nil,s.subLevel)
	
	if s.PointSet then
		if s.pointLeft 	then texture:SetPoint("LEFT", 0,s.pointLeft) 		end
		if s.pointTop 		then texture:SetPoint("TOP", s.pointTop,0)	 		end
		if s.pointRight 	then texture:SetPoint("RIGHT", 0,s.pointRight) 		end
		if s.pointBottom 	then texture:SetPoint("BOTTOM", s.pointBottom,0) 	end
		if s.width 	then texture:SetWidth(s.width) 	end
		if s.height	then texture:SetHeight(s.height) end
	else
		texture:SetPoint("TOPLEFT", -s.offset[1],s.offset[2])
		texture:SetPoint("BOTTOMRIGHT", s.offset[3],-s.offset[4])	
	end	
	if s.texture then 
		texture:SetTexture(s.texture,s.tile)
		texture:SetAlpha(s.alpha)
		texture:SetHorizTile(s.tile)
		texture:SetVertTile(s.tile)		
	else		
		texture:SetTexture(s.color[1],s.color[2],s.color[3],s.alpha)	
	end
	if s.gradient then
		texture:SetTexture(1,1,1,1)
		texture:SetGradientAlpha(s.gradient,s.color[1],s.color[2],s.color[3],s.alpha,s.colorTo[1],s.colorTo[2],s.colorTo[3],s.alphaTo)		
	end	
	
	return texture
end
local function DrawOutline(frame,s)
	
	s.alpha 			= s.alpha 		or 3
	s.layer 			= s.layer 		or 'BORDER'	
	s.subLevel 		= s.subLevel 	or -8	
	s.color[1] 		= s.color[1] 	/ 255			-- Red
	s.color[2] 		= s.color[2] 	/ 255			-- Green
	s.color[3] 		= s.color[3] 	/ 255			-- Blue	
	s.anchor			= s.anchor or frame
	if type(s.offset) ~='table' then	
		s.offset = s.offset and {s.offset,s.offset,s.offset,s.offset} or {0,0,0,0}	-- Left, Top, Right, Bottom 
	end
		
	local outlineTop = frame:CreateTexture(nil,s.layer,nil,subLevel)
	outlineTop:SetPoint("TOPLEFT",s.anchor,"TOPLEFT", -s.offset[1]+1,s.offset[2]) 
	outlineTop:SetPoint("TOPRIGHT",s.anchor,"TOPRIGHT", s.offset[3]-1,s.offset[2])
	outlineTop:SetHeight(1)
	outlineTop:SetTexture(s.color[1],s.color[2],s.color[3],s.alpha)
	local outlineBottom = frame:CreateTexture(nil,s.layer,nil,s.subLevel)
	outlineBottom:SetPoint("BOTTOMLEFT",s.anchor,"BOTTOMLEFT",-s.offset[1]+1,-s.offset[4])
	outlineBottom:SetPoint("BOTTOMRIGHT",s.anchor,"BOTTOMRIGHT", s.offset[3]-1,-s.offset[4])
	outlineBottom:SetHeight(1)
	outlineBottom:SetTexture(s.color[1],s.color[2],s.color[3],s.alpha)
	local outlineLeft = frame:CreateTexture(nil,s.layer,nil,s.subLevel)
	outlineLeft:SetPoint("TOPLEFT",-s.offset[1],s.offset[2])
	outlineLeft:SetPoint("BOTTOMLEFT", -s.offset[1],-s.offset[4])
	outlineLeft:SetWidth(1)
	outlineLeft:SetTexture(s.color[1],s.color[2],s.color[3],s.alpha)		
	local outlineRight = frame:CreateTexture(nil,s.layer,nil,s.subLevel)
	outlineRight:SetPoint("TOPRIGHT",s.anchor,"TOPRIGHT", s.offset[3],s.offset[2])
	outlineRight:SetPoint("BOTTOMRIGHT",s.anchor,"BOTTOMRIGHT",s.offset[3],-s.offset[4])
	outlineRight:SetWidth(1)
	outlineRight:SetTexture(s.color[1],s.color[2],s.color[3],s.alpha)

	return outlineLeft ,outlineTop, outlineRight, outlineBottom
end
----[[ Skins ]]----------------------------------------------------------------------------------------------------------------
function ADDON:SkinInterface(interface)

	DrawGlassFrame(interface)
	DrawTexture(interface,{		
		color 	= {1,1,1},		
	})
	
	DrawTexture(interface,{
		color 	= {255,255,255},
		alpha 	= .05,
		alphaTo	= .15,
		gradient	= 'VERTICAL',
		offset 	= {-1,-20,-1,-1},
		subLevel = 0,
	})	
	DrawOutline(interface,{
		color 	= {255,255,255},		
		alpha 	= .05,
		offset 	= {-1,-20,-1,-1},
	})		
	DrawOutline(interface.statusBar,{
		color 	= {255,255,255},		
		alpha 	= .10,
		offset 	= {-20,-1,-20,-1},
	})	
	DrawTexture(interface.statusBar,{
		color 	= {255,255,255},
		alpha 	= .1,
		alphaTo	= .2,
		gradient	= 'VERTICAL',
		offset 	= {-20,-1,-20,-10},
		subLevel = 0,
	})	
	
	DrawOutline(interface.interrupt,{
		color 	= {255,255,255},		
		alpha 	= .1,
		offset 	= {0,0,0,0},
		subLevel = 0,
	})	
	DrawTexture(interface.interrupt,{
		color 	= {255,255,255},
		alpha 	= .1,
		alphaTo	= .2,
		gradient	= 'VERTICAL',
		offset 	= {0,0,0,-9},
		subLevel = 0,
	})	
	
end
function ADDON:SkinAblityLog(abilityLog)	
	
	DrawGlassFrame(abilityLog.frame)
	DrawTexture(abilityLog.frame,{		
		color 	= {1,1,1},		
	})		
	DrawOutline(abilityLog,{
		color 	= {255,255,255},		
		alpha 	= .10,
		offset 	= -1,
	})
	DrawTexture(abilityLog,{		
		color 	= {255,255,255},
		alpha 	= .1,
		alphaTo	= .2,
		gradient	= 'VERTICAL',
		offset 	= {-1,-1,-1,-10},
		subLevel = 0,
	})			
	DrawTexture(abilityLog.content,{
		texture 	= ADDON.mediaPath.."Background",
		tile 		= true,
		alpha 	= .7,	
	})			
	DrawOutline(abilityLog.content,{	
		color 	= {255,255,255},	
		alpha 	= .05,
		offset 	= 0,
	})	
end
function ADDON:SkinRotationConfig(rotationConfig)	
	
	DrawGlassFrame(rotationConfig.frame)
	DrawTexture(rotationConfig.frame,{		
		color 	= {1,1,1},		
	})			
	DrawOutline(rotationConfig,{		
		color 	= {255,255,255},
		alpha 	= .10,
		offset 	= -1,
	})
	DrawTexture(rotationConfig,{
		color 	= {255,255,255},
		alpha 	= .1,
		alphaTo	= .2,
		gradient	= 'VERTICAL',
		offset 	= {-1,-1,-1,-11},
		subLevel = 0,
	})	
		
	DrawTexture(rotationConfig.hotkeyContainer,{
		color			= {30,30,32},		
	})			
	DrawOutline(rotationConfig.hotkeyContainer,{		
		color 	= {255,255,255},
		alpha 	= .05,		
	})
	
	DrawTexture(rotationConfig.footer,{
		color			= {30,30,32},	
	})			
	DrawOutline(rotationConfig.footer,{		
		color 	= {255,255,255},
		alpha 	= .05,		
	})
	
	
	DrawGlassFrame(rotationConfig.codeWindow)
	DrawTexture(rotationConfig.codeWindow,{		
		color 	= {1,1,1},		
	})
	
	DrawOutline(rotationConfig.codeWindow.title,{		
		color 	= {255,255,255},
		alpha 	= .10,
		offset 	= -1,
	})
	DrawTexture(rotationConfig.codeWindow.title,{
		color 	= {255,255,255},
		alpha 	= .1,
		alphaTo	= .2,
		gradient	= 'VERTICAL',
		offset 	= {-1,-1,-1,-11},
		subLevel = 0,
	})	
			
	DrawTexture(rotationConfig.codeWindow.scrollArea,{		
		texture 	= ADDON.mediaPath.."Background",
		tile 		= true,
		alpha 	= .2,	
		offset 	= {0,7,3,10},
	})			
	DrawOutline(rotationConfig.codeWindow.scrollArea,{		
		color 	= {255,255,255},
		alpha 	= .05,
		offset 	= {0,7,3,10},		
	})	
		
end

function ADDON:SkinRow(row)
	if row.even then		
		DrawTexture(row,{	
		color 	= {1,1,1},		
		alpha 	= .2,		
		offset 	= {0,0,0,1},		
	})	
	end
end
function ADDON:SkinEditBox(editBox)
	DrawWidgetBevel(editBox)
	DrawTexture(editBox,{		
		color 	= {1,1,1},		
	})
	DrawTexture(editBox,{
		color 	= {255,255,255},
		alpha 	= 0,
		alphaTo	= .1,
		gradient	= 'VERTICAL',
		offset 	= -1,
		subLevel = 0,
	})		
	
	local left,top,right,bottom = DrawOutline(editBox,{		
		color		= {0,168,255},
		alpha 	= .8,
		offset 	= 0,		
	})
	
	left:Hide()	top:Hide() right:Hide()	bottom:Hide()
	
	editBox:HookScript("OnEnter", function(self)
		left:Show()	top:Show() right:Show()	bottom:Show()
	end) 
	editBox:HookScript("OnLeave", function(self)
		left:Hide()	top:Hide() right:Hide()	bottom:Hide()
	end)		
		
end
function ADDON:SkinNumBox(numBox)
	DrawWidgetBevel(numBox.frame)
	DrawTexture(numBox.frame,{		
		color 	= {1,1,1},		
	})
	DrawTexture(numBox.frame,{
		color 	= {255,255,255},
		alpha 	= 0,
		alphaTo	= .1,
		gradient	= 'VERTICAL',
		offset 	= -1,
		subLevel = 0,
	})	
	
	DrawTexture(numBox.bar,{		
		colorTo 	= {0,76,114},
		color 	= {0,34,51},
		alpha 	= 1,
		alphaTo	= 1,
		gradient	= 'VERTICAL',		
		subLevel = 0,
	})	
	
	local left,top,right,bottom = DrawOutline(numBox.editBox,{		
		color		= {0,168,255},
		alpha 	= .8,
		offset 	= 0,		
	})
	
	left:Hide()	top:Hide() right:Hide()	bottom:Hide()
	
	numBox.editBox:HookScript("OnEnter", function(self)
		left:Show()	top:Show() right:Show()	bottom:Show()
	end) 
	numBox.editBox:HookScript("OnLeave", function(self)
		left:Hide()	top:Hide() right:Hide()	bottom:Hide()
	end)		
		
end

function ADDON:SkinSection(section)
	
	DrawTexture(section,{
		color			= {30,30,32},
		--texture 	= ADDON.mediaPath.."Background",
		--tile 		= true,
		--alpha 	= .75,			
	})			
	DrawOutline(section,{		
		color 	= {255,255,255},
		alpha 	= .05,			
	})		
	
	
	
end
function ADDON:SkinSelect(select)	
	
	DrawTexture(select.frame,{		
		color 	= {1,1,1},		
	})	
	DrawWidgetBevel(select.frame)	
	
	DrawTexture(select.pullout,{		
		color 	= {1,1,1},		
	})	
		
	DrawOutline(select.pullout,{		
		color 	= {255,255,255},
		alpha 	= .05,
		offset 	= -1,
	})	
	
	local left,top,right,bottom = DrawOutline(select.button,{		
		color		= {0,168,255},
		alpha 	= .5,
		offset 	= -1,		
	})	
	left:Hide()	top:Hide() right:Hide()	bottom:Hide()	
	select.button:HookScript("OnEnter", function(self)
		left:Show()	top:Show() right:Show()	bottom:Show()
	end) 
	select.button:HookScript("OnLeave", function(self)
		left:Hide()	top:Hide() right:Hide()	bottom:Hide()
	end) 
	
	local left,top,right,bottom = DrawOutline(select.frame,{		
		color		= {0,168,255},
		alpha 	= .5,
		offset 	= {-1,-1,-16,-1},		
	})	
	left:Hide()	top:Hide() right:Hide()	bottom:Hide()
	select.frame:HookScript("OnEnter", function(self)
		left:Show()	top:Show() right:Show()	bottom:Show()
	end) 
	select.frame:HookScript("OnLeave", function(self)
		left:Hide()	top:Hide() right:Hide()	bottom:Hide()
	end) 
	
end
function ADDON:SkinSetSelect(select)	
	
	DrawTexture(select.button,{		
		color 	= {1,1,1},
		alpha 	= .10,
		offset 	= -1,
	})	
	DrawOutline(select.button,{			
		color 	= {0,0,0},			
	})		
	DrawTexture(select.button,{
		color 	= {255,255,255},
		alpha 	= .15,
		alphaTo	= .25,
		gradient	= 'VERTICAL',
		offset 	= -1,
		subLevel = 0,
	})		
	DrawTexture(select.frame,{
		color 	= {255,255,255},
		alpha 	= 0,
		alphaTo	= .1,
		gradient	= 'VERTICAL',
		offset 	= -1,
		subLevel = 0,
	})		
	DrawGlassFrame(select.pullout)	
	
	local icon = select.button:CreateTexture(nil, 'ARTWORK')
	icon:SetSize(7,12)
	icon:SetPoint('TOPRIGHT',-4,-3)
	icon:SetVertexColor(1,1,1)
	icon:SetTexture([[Interface\Buttons\SquareButtonTextures]])
	icon:SetTexCoord(0.01562500, 0.20312500, 0.01562500, 0.20312500)
	--icon:SetVertexColor(1,1,1)
	select.button.icon = icon
	SquareButton_SetIcon(select.button, 'DOWN')	
	
	ADDON:SkinSelect(select)
end
function ADDON:SkinWidgetSelect(select)		
	
		DrawTexture(select.frame,{		
			color 	= {1,1,1},
			alpha 	= .10,
			offset 	= -1,
		})		
		DrawTexture(select.frame,{
			color 	= {255,255,255},
			alpha 	= .15,
			alphaTo	= .25,
			gradient	= 'VERTICAL',
			offset 	= -1,
			subLevel = 0,
		})
		DrawGlassFrame(select.pullout,{
		glassOutlineAlpha	 =0,		
		offset 	= -1,
	})			
	
	local icon = select.button:CreateTexture(nil, 'ARTWORK')
	icon:SetSize(5,9)
	icon:SetPoint('TOPRIGHT',-4,-1)
	icon:SetVertexColor(1,1,1)
	icon:SetTexture([[Interface\Buttons\SquareButtonTextures]])
	icon:SetTexCoord(0.01562500, 0.20312500, 0.01562500, 0.20312500)
	--icon:SetVertexColor(1,1,1)
	select.button.icon = icon
	SquareButton_SetIcon(select.button, 'UP')
	
	local button = CreateFrame("Button",nil,select.button)
	button:EnableMouse(false)
	button:SetAllPoints()	
	local icon = button:CreateTexture(nil, 'ARTWORK')
	icon:SetSize(5,9)
	icon:SetPoint('TOPRIGHT',-4,-6)
	icon:SetVertexColor(1,1,1)
	icon:SetTexture([[Interface\Buttons\SquareButtonTextures]])
	icon:SetTexCoord(0.01562500, 0.20312500, 0.01562500, 0.20312500)
	--icon:SetVertexColor(1,1,1)
	button.icon = icon
	SquareButton_SetIcon(button, 'DOWN')
		
	ADDON:SkinSelect(select)
end



function ADDON:SkinButton(button) 
	
	button.background = DrawTexture(button,{		
		color 	= {1,1,1},		
	})	
	DrawOutline(button,{		
		color 	= {1,1,1},	
	})
	DrawOutline(button,{		
		color 	= {255,255,255},
		alpha 	= .10,
		offset 	= -1,
	})
	DrawTexture(button,{
		color 	= {255,255,255},
		alpha 	= .1,
		alphaTo	= .2,
		gradient	= 'VERTICAL',
		offset 	= {-1,-1,-1,-11},
		subLevel = 0,
	})	
	
	
	local left,top,right,bottom = DrawOutline(button,{		
		color		= {0,168,255},
		alpha 	= .5,
		offset 	= -1,		
	})		
	left:Hide()	top:Hide() right:Hide()	bottom:Hide()	
	button:HookScript("OnEnter", function(self)
		left:Show()	top:Show() right:Show()	bottom:Show()
	end) 
	button:HookScript("OnLeave", function(self)
		left:Hide()	top:Hide() right:Hide()	bottom:Hide()
	end) 	
		
end
function ADDON:SkinButtonLock(button) 
	
	button.icon = DrawTexture(button,{		
		texture 	= ADDON.mediaPath.."icons16x64",
		offset 	= 0,			
	})	
	--button.icon:SetTexCoord(0,.25,0,.25)
	
	local left,top,right,bottom = DrawOutline(button,{		
		color		= {0,168,255},
		alpha 	= .5,
		offset 	= -1,		
	})		
	left:Hide()	top:Hide() right:Hide()	bottom:Hide()	
	button:HookScript("OnEnter", function(self)
		left:Show()	top:Show() right:Show()	bottom:Show()
	end) 
	button:HookScript("OnLeave", function(self)
		left:Hide()	top:Hide() right:Hide()	bottom:Hide()
	end) 
		
end
function ADDON:SkinMenu(menu)	
	DrawGlassFrame(menu)
	DrawTexture(menu,{		
		color 	= {1,1,1},		
	})		
	DrawOutline(menu,{		
		color 	= {255,255,255},
		alpha 	= .05,
		offset 	= -1,
	})	
end
function ADDON:Outline(f)
	DrawOutline(f,{			
		color 	= {255,255,255},
		alpha 	= .05,		
	})
end



