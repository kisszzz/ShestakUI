local T, C, L = unpack(select(2, ...))
if C.unitframe.enable ~= true or C.unitframe.plugins_reputation_bar ~= true then return end

----------------------------------------------------------------------------------------
--	Based on oUF_Reputation(by p3lim)
----------------------------------------------------------------------------------------
local _, ns = ...
local oUF = ns.oUF

local function tooltip(self)
	local name, id, min, max, value = GetWatchedFactionInfo()
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -5)
	GameTooltip:AddLine(string.format("%s (%s)", name, _G["FACTION_STANDING_LABEL"..id]))
	GameTooltip:AddLine(string.format("%d / %d (%d%%)", value - min, max - min, (value - min) / (max - min) * 100))
	GameTooltip:Show()
end

local function update(self, event, unit)
	local bar = self.Reputation
	if not GetWatchedFactionInfo() then return bar:Hide() end

	local name, id, min, max, value = GetWatchedFactionInfo()
	bar:SetMinMaxValues(min, max)
	bar:SetValue(value)
	bar:Show()

	if bar.Text then
		if bar.OverrideText then
			bar:OverrideText(min, max, value, name, id)
		else
			bar.Text:SetFormattedText("%d / %d - %s", value - min, max - min, name)
		end
	end

	if bar.PostUpdate then bar.PostUpdate(self, event, unit, bar, min, max, value, name, id) end
end

local function enable(self, unit)
	local bar = self.Reputation
	if bar and unit == "player" then
		self:RegisterEvent("UPDATE_FACTION", update)

		if bar.Tooltip then
			bar:EnableMouse()
			bar:HookScript("OnLeave", GameTooltip_Hide)
			bar:HookScript("OnEnter", tooltip)
		end

		return true
	end
end

local function disable(self)
	if self.Reputation then
		self:UnregisterEvent("UPDATE_FACTION", update)
	end
end

oUF:AddElement("Reputation", update, enable, disable)