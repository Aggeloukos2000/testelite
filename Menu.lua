Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36,["CTRL"] = 36, ["LEFTALT"] = 19,  ["ALT"] = 19,["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local function NewMenu(pool)
	local self = setmetatable(Container(), Menu)

	-- private
	local visible = false

	local lowerRight = vector2(0, 0)

	-- public
	self.pool = pool

	self.parent = nil

	self.order = 0

	self.width = 0.15

	self.colors = {
		border      = BORDER.COLOR,
		background  = BACKGROUND.COLOR,
		hBackground = BACKGROUND.H_COLOR,
		text        = TEXT.COLOR,
		hText       = TEXT.H_COLOR
	}

	local border = Border()
	border:Color(self.colors.border)
	border:Parent(self)

	local function RecalculatePosition(_position)
		self.position = _position

		local totalHeight = 0.0
		local nonScaledHeight = 0.0
		for i, item in ipairs(self.objectList) do
			totalHeight = totalHeight + item:Height() * self.scale.y
			nonScaledHeight = nonScaledHeight + item:Height()
		end

		lowerRight = self:AbsolutePosition() + vector2(self.width * self.scale.x, totalHeight)
		if (lowerRight.x > 1.0) then
			if (self.parent ~= nil) then
				self.position = vector2(self.position.x - self.width - self.parent.width, self.position.y)
				lowerRight = vector2(lowerRight.x - self.width - self.parent.width, lowerRight.y)
			else
				self.position = self.position - vector2(lowerRight.x - 1.0, 0.0)
				lowerRight = vector2(1.0, lowerRight.y)
			end
		end
		if (lowerRight.y > 1.0) then
			self.position = self.position - vector2(0.0, lowerRight.y - 1.0)
			lowerRight = vector2(lowerRight.x, 1.0)
		end

		border:Size(lowerRight - self.position)
		border:Size(vector2(self.width, nonScaledHeight))

		local currPos = vector2(0, 0)
		for i, item in ipairs(self.objectList) do
			item:Position(currPos)
			currPos = currPos + vector2(0.0, item:Height())
		end
	end



	function self:AddAnyItem(item)
		self:Add(item)

		RecalculatePosition(self.position)

		return self.objectList[#self.objectList]
	end

	function self:AddBaseItem()
		return self:AddAnyItem(BaseItem(self))
	end

	-- adds a new Separator to the menu
	function self:AddSeparator()
		return self:AddAnyItem(SeparatorItem(self))
	end

	-- adds a new TextItem to the menu
	function self:AddTextItem(title)
		return self:AddAnyItem(TextItem(self, title))
	end

	-- adds a new Item to the menu
	function self:AddItem(title)
		return self:AddAnyItem(Item(self, title))
	end

	-- adds a new Item to the menu
	function self:AddSpriteItem(textureDict, textureName)
		return self:AddAnyItem(SpriteItem(self, textureDict, textureName))
	end

	-- adds a new Item to the menu
	function self:AddCheckboxItem(title, checked)
		return self:AddAnyItem(CheckboxItem(self, title, checked))
	end

	-- adds a new submenu to this menu
	function self:AddSubmenu(title)
		local submenu = self.pool:AddMenu()
		submenu.order = self.order + 1
		submenu:Parent(self)

		return submenu, self:AddAnyItem(SubmenuItem(self, title, submenu))
	end

	-- adds a new scroll submenu to this menu
	function self:AddScrollSubmenu(title, maxItems)
		local scrollSubmenu = self.pool:AddScrollMenu(maxItems)
		scrollSubmenu.order = self.order + 1
		scrollSubmenu:Parent(self)

		return scrollSubmenu, self:AddAnyItem(SubmenuItem(self, title, scrollSubmenu))
	end

	-- adds a new scroll submenu to this menu
	function self:AddPageSubmenu(title, maxItems)
		local pageSubmenu = self.pool:AddPageMenu(maxItems)
		pageSubmenu.order = self.order + 1
		pageSubmenu:Parent(self)

		return pageSubmenu, self:AddAnyItem(SubmenuItem(self, title, pageSubmenu))
	end

	-- processes and draws the menu
	function self:Process(cursorPosition)
		if (not visible) then
			return
		end

		for i, item in ipairs(self.objectList) do
			if (item.Process) then
				item:Process(cursorPosition)
			end
		end
	end

	function self:Draw()
		if (not visible) then
			return
		end

		if (self:IsOverlapped()) then
			local sprite = Sprite(BACKGROUND.TXD, BACKGROUND.NAME, self:AbsolutePosition(), (self:AbsolutePosition() - lowerRight) * -1.0, nil, self.colors.background)
			sprite:Draw()

			return
		end

		for i, obj in ipairs(self.objectList) do
			obj:Draw()
		end

		border:Draw()
	end

	-- when anything was activated
	function self:Activated(cursorPosition)
		for i, item in ipairs(self.objectList) do
			if (item:InBounds(cursorPosition) and item.Activated) then
				item:Activated()

				return
			end
		end
	end

	-- when the activate button was released
	function self:Released(cursorPosition)
		for i, item in ipairs(self.objectList) do
			if (item:InBounds(cursorPosition) and item.Released) then
				item:Released()
				return
			end
		end
	end

	-- get/set the visibility of the Menu
	function self:Visible(visibility)
		if (visibility == nil) then
			return visible
		end

		--if (visibility == false) then
		--    CreateThread(function()
		--        self.OnClosed()
		--    end)
		--end

		visible = visibility
	end

	-- get/set the position of the Menu
	function self:Position(_position)
		if (_position == nil) then
			return self.position
		end

		RecalculatePosition(_position)
	end

	-- get/set the scale of the Menu
	function self:Scale(newScale)
		if (not newScale) then
			return self.scale
		end

		self.scale = newScale

		for i, item in ipairs(self.objectList) do
			item:Scale(item:Scale())
		end

		RecalculatePosition(self.position)
	end

	-- checks if the given position is inside the bounds of the Menu
	function self:InBounds(point)
		local pos = self:AbsolutePosition()
		return point.x >= pos.x 
			and point.y >= pos.y 
			and point.x < lowerRight.x 
			and point.y < lowerRight.y
	end

	function self:IsOverlapped(position)
		for i, item in ipairs(self.objectList) do
			if (item.submenu and item.submenu:Visible()) then
				for j, subItem in ipairs(item.submenu.objectList) do
					if (subItem.submenu and subItem.submenu:Visible() and subItem.submenu.objectList) then
						for k, sub2Item in ipairs(subItem.submenu.objectList) do
							if (self:InBounds(sub2Item:AbsolutePosition() + vector2(sub2Item.parent.width, sub2Item.height) * 0.5)) then
								return true
							end
						end
					end
				end
			end
		end

		return false
	end

	function self:Destroy()
		LogDebug("Destroyed " .. tostring(self))

		self.parent = nil

		for k, v in pairs(self.children) do
			if (self.children[k].Destroy) then
				self.children[k]:Destroy()
			end

			self.children[k] = nil
		end

		for k, v in pairs(self.objectList) do
			if (self.objectList[k].Destroy) then
				self.objectList[k]:Destroy()
			end

			self.objectList[k] = nil
		end

		for k, v in pairs(self) do
			self[k] = nil
		end
	end



	return self
end



Menu = {}
Menu.__index = Menu
setmetatable(Menu, {
	__call = function(cls, ...)
		return NewMenu(...)
	end
})

Menu.__tostring = function(obj)
	return string.format("Menu()")
end

Menu.__gc = function(obj)
	if (obj.Destroy) then
		obj:Destroy()
	end
end