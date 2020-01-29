-- $Id: TableExplorer.lua 16 2014-02-24 05:55:58Z diesal2010 $

-- | Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools 	= LibStub("DiesalTools-1.0")
local DiesalStyle 	= LibStub("DiesalStyle-1.0")
local DiesalGUI 		= LibStub("DiesalGUI-1.0")
local DiesalMenu 		= LibStub('DiesalMenu-1.0')
-- | Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local print, type, select, tostring, tonumber	= print, type, select, tostring, tonumber
local sub, format, match, lower								= string.sub, string.format, string.match, string.lower
local table_sort															= table.sort
local abs																			= math.abs
-- | WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- | TableExplorer |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Type = "TableExplorer"
local Version = 3
-- | StyleSheets |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local windowStyleSheet = {	
	['content-background'] = {
		type			= 'texture',		
		color			= '131517',		
	},	
}

local expandButtonStyle = {
	type			= 'texture',
	texFile		= 'DiesalGUIcons',
	texCoord		= {1,6,16,256,128},
	alpha 		= .7,
	offset		= {-2,nil,-2,nil},
	width			= 16,
	height		= 16,
}
local expandButtonNormal = {
	type			= 'texture',
	texColor		= 'ffffff',
	alpha 		= .7,
}
local expandButtonOver = {
	type			= 'texture',
	alpha 		= 1,
}
local expandButtonDisabled = {
	type			= 'texture',
	alpha 		= .3,
}
local collapseButtonStyle = {
	type			= 'texture',
	texFile		='DiesalGUIcons',
	texCoord		= {2,6,16,256,128},
	alpha 		= .7,
	offset		= {-2,nil,-2,nil},
	width			= 16,
	height		= 16,
}
local collapseButtonNormal = {
	type			= 'texture',
	alpha 		= .7,
}
local collapseButtonOver = {
	type			= 'texture',
	alpha 		= 1,
}
local collapseButtonDisabled = {
	type			= 'texture',
	alpha 		= .3,
}
local refreshButtonStyle = {
	type			= 'texture',
	texFile		='DiesalGUIcons',
	texCoord		= {3,5,16,256,128},
	alpha 		= .7,
	offset		= {-2,nil,-2,nil},
	width			= 16,
	height		= 16,
}
local refreshButtonNormal = {
	type			= 'texture',
	alpha 		= .7,
}
local refreshButtonOver = {
	type			= 'texture',
	alpha 		= 1,
}
local refreshButtonDisabled = {
	type			= 'texture',
	alpha 		= .3,
}
local homeButtonStyle = {
	type			= 'texture',
	texFile		='DiesalGUIcons',
	texCoord		= {4,5,16,256,128},
	alpha 		= .7,
	offset		= {-2,nil,-2,nil},
	width			= 16,
	height		= 16,
}
local homeButtonNormal = {
	type			= 'texture',
	alpha 		= .7,
}
local homeButtonOver = {
	type			= 'texture',
	alpha 		= 1,
}
local homeButtonDisabled = {
	type			= 'texture',
	alpha 		= .3,
}
-- | Local Constants |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local blue				= DiesalTools:GetTxtColor('00aaff')
local darkBlue		= DiesalTools:GetTxtColor('004466')
local orange			= DiesalTools:GetTxtColor('ffaa00')
local darkOrange	= DiesalTools:GetTxtColor('4c3300')
local grey				= DiesalTools:GetTxtColor('7f7f7f')
local darkGrey		= DiesalTools:GetTxtColor('414141')
local white				= DiesalTools:GetTxtColor('e6e6e6')
local red					= DiesalTools:GetTxtColor('ff0000')
local green				= DiesalTools:GetTxtColor('00ff2b')
local yellow			= DiesalTools:GetTxtColor('ffff00')
local lightYellow	= DiesalTools:GetTxtColor('ffea7f')
-- | local Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function compare(a,b)
	if a[1] == b[1] then
		local typeA, typeB = type(a[2]), type(b[2])
		if typeA ~= typeB then
			return typeA < typeB
		elseif (typeA == "number" and typeB == "number") or (typeA == "string" and typeB == "string") then
			return a[2] < b[2]
		elseif a[2] == "boolean" and b[2] == "boolean" then
			return a[2] == true
		else
			return tostring(a[2]) < tostring(b[2])
		end
	else return a[1] <  b[1] end
end
local function sortByType(value)
	if type(value) == 'table' then return 1 end
	if type(value) == 'function' then return 2 end
	return 3
end
local function sortTable(t)
	local sortedTable = {}
	for key, value in pairs(t) do
		sortedTable[#sortedTable + 1] = {sortByType(value),key}
	end
	table_sort(sortedTable, compare)
	return sortedTable
end
-- |  Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local methods = {
	['OnAcquire'] = function(self)
		self.settings = DiesalTools:TableCopy( self.defaults )
		self:ApplySettings()
		self:Show()
	end,
	['OnRelease'] = function(self)
		self.scrollFrame:SetContentHeight(10)
		self.tree:ReleaseChildren()
	end,
	['ApplySettings'] = function(self)

	end,
	['SetTable'] = function(self,tname,t,maxDepth,timeout)
		if type(t) ~='table' then print('table dosnt exist') return end
		-- set defaults
		maxDepth = maxDepth or self.defaults.maxDepth
		timeout = timeout or self.defaults.timeout
		self:SetSettings({
			timeout					= timeout,
			maxDepth				= maxDepth,
			homeTable 			= t,
			homeTableName		= tname,
		})
		self.depthSpinner:SetNumber(maxDepth)
		self.timeSpinner:SetNumber(timeout)
		-- set window Title
		self.window:SetTitle('|cffffaa00Table Explorer',tname or '')
		-- Build tree
		self:BuildTree(tname,t)
	end,
	['BuildTree'] = function(self,tname,t)
		local tree = self.tree
		local settings = self.settings
		-- reset tree
		self.statusText:SetText('')
		tree:ReleaseChildren()
		-- setup tree
		settings.endtime						= time() + self.settings.timeout
		settings.exploredTableName	= tname or settings.exploredTableName
		settings.exploredTable			= t or settings.exploredTable
		if next(settings.exploredTable) == nil then
			tree:UpdateHeight()
			self.statusText:SetText('|cffff0000Table is empty.')
		return end
		-- sort tree table
		local sortedTable = sortTable(settings.exploredTable)
		-- build Tree Branches
		for position, key in ipairs(sortedTable) do
			if self.settings.endtime <= time() then	self:Timeout() return end
			self:BuildBranch(self.tree,key[2],settings.exploredTable[key[2]],position,1,position == #sortedTable)
		end
	end,
	['BuildBranch'] = function(self,parent,key,value,position,depth,last)
		local tree = self.tree
		local leaf = type(value) ~= 'table' or next(value) == nil or depth >= self.settings.maxDepth
		local branch = DiesalGUI:Create('Branch')
		-- | Reset Branch	|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		branch:ReleaseChildren()
		-- | setup Branch |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		branch:SetParentObject(parent)
		parent:AddChild(branch)
		branch:SetSettings({
			key				= key,
			value			= value,
			position 	= position,
			depth			= depth,
			last			= last,
			leaf 			= leaf,
		})
		branch:SetEventListener('OnClick',function(this,event,button)
			if button =='RightButton' then			
				if not next(this.settings.menuData) then return end
				DiesalMenu:Menu(this.settings.menuData,this.frame,10,-10)	
			end	
		end)
				
		self:SetBranchLabel(branch,key,value,leaf)
		self:SetBranchMenu(branch,key,value)
		self:SetBranchIcon(branch,type(value))
		
		if value == tree or leaf then branch:ApplySettings() return end
		-- | sort Branch Table |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		local sortedTable = sortTable(value)		
		-- | build Branch Branches |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		for position, key in ipairs(sortedTable) do
			if self.settings.endtime <= time() then	self:Timeout() return end
			self:BuildBranch(branch,key[2],value[key[2]],position,depth+1,position == #sortedTable)
		end	
		-- | Update Branch | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		branch:ApplySettings()	
	end,
	['SetBranchIcon'] = function(self,branch,valueType)
		if valueType == 'function' 	then
			branch.icon:SetTexCoord(DiesalTools:GetIconCoords(4,8,16,256,128)) 
		elseif valueType == 'table'	then
			branch.icon:SetTexCoord(DiesalTools:GetIconCoords(1,8,16,256,128)) 
		else
			branch.icon:SetTexCoord(DiesalTools:GetIconCoords(3,8,16,256,128))
		end
	end,
	['SetBranchLabel'] = function(self,branch,key,value,leaf)
		local keyText, valueText
		local keyType			= type(key)
		local valueType 	= type(value)

		if valueType == 'userdata' then branch:SetLabel(('%suserdata%s %s'):format(grey,darkGrey,tostring(value):match('.*: (.*)') or tostring(value))) return end
		-- format key text
		if keyType == 'string' then
			if valueType == 'function' then
				keyText = ('%s%s'):format(blue,DiesalTools:EscapeString(key))
			elseif valueType == 'table' then
				keyText = ('%s%s'):format(orange,DiesalTools:EscapeString(key))
			else
				keyText = ('%s%s'):format(white,DiesalTools:EscapeString(key))
			end
		elseif keyType == 'number' then
			keyText = ("%s[%s%s%s]"):format(orange,yellow,key,orange)
		elseif keyType == 'boolean'	then
			keyText = ("%s%s"):format(blue,tostring(key))
		else
			local keyID = tostring(key):match('.*: (.*)') or tostring(key)
			if keyType == 'function' then
				keyText = ('%sfunction%s %s'):format(blue,darkBlue,keyID)
			elseif keyType == 'userdata' then
				keyText = ('%suserdata%s %s'):format(GREY,darkGrey,keyID)
			elseif keyType == 'table'	then
				keyText = ('%stable%s %s'):format(orange,darkOrange,keyID)
			end
		end
		-- format valueType
		if value == nil	then
			valueText = ("%s%s"):format(blue,'nil')	-- shouldnt happen JIC
		elseif valueType == 'string' 	then
			valueText = ("%s'%s'"):format(green,DiesalTools:EscapeString(value))
		elseif valueType == 'number' 	then
			valueText = ("%s%s"):format(yellow,value)
		elseif valueType == 'boolean' then
			valueText = ("%s%s"):format(blue,tostring(value))
		else
			local valueID = tostring(value):match('.*: (.*)') or tostring(value)
			if valueType == 'function' then
				valueText = ('%sfunction%s %s'):format(blue,darkBlue,valueID)
			elseif valueType == 'table'	then
				if next(value) == nil then
					valueText = ('%s{ } table%s %s'):format(orange,darkOrange,valueID)  -- Blank Table
				elseif leaf then
					valueText = ('%s{%s ... %s} table%s %s'):format(orange,red,orange,darkOrange,valueID) -- explore depth reached
				else
					valueText = ('%stable%s %s'):format(orange,darkOrange,valueID)
				end
			end
		end
		-- set label
		branch:SetLabel(('%s%s = %s'):format(keyText,lightYellow,valueText))
	end,
	['SetBranchMenu'] = function(self,branch,key,value)
		local menuData 		= {}		
		local keyType			= type(key)
		local valueType 	= type(value)		
		-- Explore Value 
		if valueType == 'table' and next(value) then
			local tablename = keyType == 'string' and key or keyType == 'number' and tostring(key) or tostring(value)
			menuData.exploreTable = {
				order = 10, 
				name = 'Explore Table',				
				onClick	= function() self:BuildTree(tablename,value) end,			
			}
			menuData.exploreTableNew = {
				order = 20,
				name = 'Explore Table in New Window',							
				onClick 	= function() texplore(tablename,value) end,
			}				
		end
		-- Explore key	
		if keyType == 'table' and next(key) then
			menuData.exploreTable = {
				order = 10, 
				name = 'Explore Table',
				onClick 	= function() tree:BuildTree(tostring(key),key) end,					
			}
			menuData.exploreTableNew = {
				order = 20, 
				name = 'Explore Table in New Window',
				onClick 	= function() texplore(tostring(key),key) end,
			}				
		end
		-- Collapse Children 
		if valueType == 'table' and next(value) and branch.settings.depth < (self.settings.maxDepth-1) then
			menuData.spacer = {
				order = 30, 
				type = 'spacer'
			}			
			menuData.collapseChildren = {
				order = 40, 
				name = 'Collapse Children',
				onClick 	= function()					
					for i=1 , #branch.children do 
						branch.children[i]:Collapse()																	
					end					
				end,
			}
		end
		-- function 
		if valueType == 'function' then					
			menuData.runFunction = {
				order = 30, 
				name = 'Run Function',
				onClick 	= function() value() end,
			}
		end
		-- set branch menuData	
		branch.settings.menuData = menuData
	end,
	['Timeout'] = function(self)
		self.tree:ReleaseChildren()
		self.tree:UpdateHeight()
		self.statusText:SetText('|cffff0000Table Exploration Timed out.')
	end,
	['Show'] = function(self)
		self.window:Show()
	end,
	['AddHistory'] = function(self,t,tname)
		self.history = self.settings.history
		if type(t) ~='table' then return end
		local s = tostring(t)
		self.history[#self.history+1].t = t
		self.history[#self.history+1].t = tname or s
	end,
}
-- ~~| TableExplorer Constructor |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function Constructor()
	local self 		= DiesalGUI:CreateObjectBase(Type)
	-- ~~ Default Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	self.defaults = {
		maxDepth = 2,
		timeout = 5,
	}
	-- ~~ Events ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- OnAcquire, OnRelease, OnHeightSet, OnWidthSet
	-- ~~ Construct ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	local window = DiesalGUI:Create('Window')
	window:SetSettings({
		header				= true,
		footer				= true,
		top						= 600,
		left 					= 5,
		headerHeight	= 21,
		height 				= 400,
		width 				= 300,
		minWidth 			= 250,
		sizerBRHeight	= 20,
		sizerBRWidth	= 20,
	},true)
	window:AddStyleSheet(windowStyleSheet)	
	window:SetEventListener('OnHide',function() self:Release() end)

	local homeButton = DiesalGUI:Create('Button')
	homeButton:SetParent(window.header)
	homeButton:SetPoint('TOPLEFT',0,0)
	homeButton:SetSettings({
		width			= 20,
		height		= 20,
	},true)
	homeButton:SetStyle('frame',homeButtonStyle)
	homeButton:SetEventListener('OnEnter', 	function()
		homeButton:SetStyle('frame',homeButtonOver)
		GameTooltip:SetOwner(homeButton.frame, "ANCHOR_TOPLEFT",0,2)
		GameTooltip:AddLine('Base Table')
		GameTooltip:Show()
	end)
	homeButton:SetEventListener('OnLeave', function()
		homeButton:SetStyle('frame',homeButtonNormal)
		GameTooltip:Hide()
	end)
	homeButton:SetEventListener('OnDisable', function() homeButton:SetStyle('frame',homeButtonDisabled)	end)
	homeButton:SetEventListener('OnEnable', function() homeButton:SetStyle('frame',homeButtonNormal)		end)
	homeButton:SetEventListener('OnClick', function()
		self:BuildTree(self.settings.homeTableName,self.settings.homeTable)
	end)
	window:AddChild(homeButton)

	local refreshButton = DiesalGUI:Create('Button')
	refreshButton:SetParent(window.header)
	refreshButton:SetPoint('TOPLEFT',20,0)
	refreshButton:SetSettings({
		width			= 20,
		height		= 20,
	},true)
	refreshButton:SetStyle('frame',refreshButtonStyle)
	refreshButton:SetEventListener('OnEnter', function()
		refreshButton:SetStyle('frame',refreshButtonOver)
		GameTooltip:SetOwner(refreshButton.frame, "ANCHOR_TOPLEFT",0,2)
		GameTooltip:AddLine('Refresh Table')
		GameTooltip:Show()
	end)
	refreshButton:SetEventListener('OnLeave',	function()
		refreshButton:SetStyle('frame',refreshButtonNormal)
		GameTooltip:Hide()
	end)
	refreshButton:SetEventListener('OnDisable',	function() refreshButton:SetStyle('frame',refreshButtonDisabled)	end)
	refreshButton:SetEventListener('OnEnable', function() refreshButton:SetStyle('frame',refreshButtonNormal)		end)
	refreshButton:SetEventListener('OnClick', function() self:BuildTree() end)
	window:AddChild(refreshButton)

	local collapseButton = DiesalGUI:Create('Button')
	collapseButton:SetParent(window.header)
	collapseButton:SetPoint('TOPLEFT',40,0)
	collapseButton:SetSettings({
		width			= 20,
		height		= 20,
	},true)
	collapseButton:SetStyle('frame',collapseButtonStyle)
	collapseButton:SetEventListener('OnEnter', 	function()
		collapseButton:SetStyle('frame',collapseButtonOver)
		GameTooltip:SetOwner(collapseButton.frame, "ANCHOR_TOPLEFT",0,2)
		GameTooltip:AddLine('Collapse All')
		GameTooltip:Show()
	end)
	collapseButton:SetEventListener('OnLeave', 	function()
		collapseButton:SetStyle('frame',collapseButtonNormal)
		GameTooltip:Hide()
	end)
	collapseButton:SetEventListener('OnDisable', 	function() collapseButton:SetStyle('frame',collapseButtonDisabled)	end)
	collapseButton:SetEventListener('OnEnable', 	function() collapseButton:SetStyle('frame',collapseButtonNormal)			end)
	collapseButton:SetEventListener('OnClick', 	function() self.tree:CollapseAll() end)
	window:AddChild(collapseButton)

	local expandButton = DiesalGUI:Create('Button')
	expandButton:SetParent(window.header)
	expandButton:SetPoint('TOPLEFT',60,0)
	expandButton:SetSettings({
		width			= 20,
		height		= 20,
	},true)
	expandButton:SetStyle('frame',expandButtonStyle)
	expandButton:SetEventListener('OnEnter', 	function()
		expandButton:SetStyle('frame',expandButtonOver)

		GameTooltip:SetOwner(expandButton.frame, "ANCHOR_TOPLEFT",0,2)
		GameTooltip:AddLine('Expand All')
		GameTooltip:Show()
	end)
	expandButton:SetEventListener('OnLeave', 	function()
		expandButton:SetStyle('frame',expandButtonNormal)
		GameTooltip:Hide()
	end)
	expandButton:SetEventListener('OnDisable', 	function() expandButton:SetStyle('frame',expandButtonDisabled)	end)
	expandButton:SetEventListener('OnEnable', 	function() expandButton:SetStyle('frame',expandButtonNormal)	end)
	expandButton:SetEventListener('OnClick', 	function() self.tree:ExpandAll() end)
	window:AddChild(expandButton)

	local depthText = window.header:CreateFontString(nil,"OVERLAY",'DiesalFontNormal')
	depthText:SetPoint('TOPRIGHT',-113,-1)
	depthText:SetSize(100,16)
	depthText:SetJustifyH("RIGHT")
	depthText:SetJustifyV("BOTTOM")
	depthText:SetWordWrap(false)
	depthText:SetTextColor(1,1,1,.7)
	depthText:SetText('Depth:')

	local depthSpinner = DiesalGUI:Create('Spinner')
	depthSpinner:SetParent(window.header)
	depthSpinner:SetPoint('TOPRIGHT',-82,-2)
	depthSpinner:SetSettings({
		step = 1,
		min	= 1,
		max = 10,
	})
	depthSpinner:SetEventListener('OnValueChanged', function(this,event,userInput,number) self:SetSettings({maxDepth = number})	end)
	depthSpinner:SetEventListener('OnEnter', 	function()
		GameTooltip:SetOwner(depthSpinner.frame, "ANCHOR_TOPLEFT",0,2)
		GameTooltip:AddLine('Set Table Exploration Depth')
		GameTooltip:Show()
	end)
	depthSpinner:SetEventListener('OnLeave', 	function()	GameTooltip:Hide() end)
	window:AddChild(depthSpinner)

	local timeText = window.header:CreateFontString(nil,"OVERLAY",'DiesalFontNormal')
	timeText:SetPoint('TOPRIGHT',-33,-1)
	timeText:SetSize(100,16)
	timeText:SetJustifyH("RIGHT")
	timeText:SetJustifyV("BOTTOM")
	timeText:SetWordWrap(false)
	timeText:SetTextColor(1,1,1,.7)
	timeText:SetText('Timeout:')

	local timeSpinner = DiesalGUI:Create('Spinner')
	timeSpinner:SetParent(window.header)
	timeSpinner:SetPoint('TOPRIGHT',-2,-2)
	timeSpinner:SetSettings({
		step = 1,
		min	= 2,
		max = 10,
	})
	timeSpinner:SetEventListener('OnValueChanged', function(this,event,userInput,number) self:SetSettings({timeout = number})	end)
	timeSpinner:SetEventListener('OnEnter',	function()
		GameTooltip:SetOwner(timeSpinner.frame, "ANCHOR_TOPLEFT",0,2)
		GameTooltip:AddLine('Set Table Exploration Timeout (seconds)')
		GameTooltip:Show()
	end)
	timeSpinner:SetEventListener('OnLeave',	function() GameTooltip:Hide() end)
	window:AddChild(timeSpinner)

	local scrollFrame = DiesalGUI:Create('ScrollFrame')
	scrollFrame:SetParentObject(window)
	scrollFrame:SetSettings({contentPadLeft = 1},true)
	scrollFrame:SetPoint('TOPLEFT',0,-2)
	scrollFrame:SetPoint('BOTTOMRIGHT',-3,2)
	window:AddChild(scrollFrame)

	local tree = DiesalGUI:Create('Tree')
	tree:SetParentObject(scrollFrame)
	tree:SetEventListener('OnHeightChange', function(this,event,height) scrollFrame:SetContentHeight(height) end)
	tree:SetAllPoints()
	scrollFrame:AddChild(tree)

	local statusText = window.footer:CreateFontString(nil,"OVERLAY",'DiesalFontNormal')
	statusText:SetPoint('TOPLEFT',4,-7)
	statusText:SetPoint('BOTTOMRIGHT',-6,0)
	statusText:SetJustifyH("LEFT")
	statusText:SetJustifyV("TOP")
	statusText:SetWordWrap(false)
	statusText:SetTextColor(1,1,1,.7)

	-- ~~ Frames ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	self.window 				= window
	self.frame					= window.frame
	self.scrollFrame 		= scrollFrame

	self.expandButton 	= expandButton
	self.collapseButton = collapseButton
	self.refreshButton 	= refreshButton
	self.homeButton 		= homeButton
	self.depthSpinner 	= depthSpinner
	self.timeSpinner 		= timeSpinner
	self.tree 					= tree
	self.statusText 		= statusText
	-- ~~ Methods ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	for method, func in pairs(methods) do	self[method] = func	end
	-- ~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	return self
end
DiesalGUI:RegisterObjectConstructor(Type,Constructor,Version)