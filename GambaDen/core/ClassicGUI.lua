local GDPlayers = {}
local GambaDenUI
function GambaDen:toggleUi2()
if (GambaDenUI:IsVisible()) then
    GambaDenUI:Hide()
else
    GambaDenUI:Show()
end
end

function GambaDen:ShowClassic(info)
    -- Show Inerface
	if (GambaDenUI:IsVisible() ~= true) then
        GambaDenUI:Show()
		--LoadColor()
	else 
		GambaDenUI:Hide()
	end
end

function GambaDen:HideClassic(info)
    -- Hide Interface
    if (GambaDenUI:IsVisible()) then
        GambaDenUI:Hide()
    end
end 

function GambaDen:DrawMainEvents2()
--Create Main UI
GambaDenUI = CreateFrame("Frame", "GambaDenClassic", UIParent, "InsetFrameTemplate")
GambaDenUI:SetSize(320, 195) 
GambaDenUI:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
GambaDenUI:SetMovable(true)
GambaDenUI:EnableMouse(true)
GambaDenUI:SetUserPlaced(true)
GambaDenUI:SetResizable(true)
GambaDenUI:RegisterForDrag("LeftButton")
GambaDenUI:SetScript("OnDragStart", GambaDenUI.StartMoving)
GambaDenUI:SetScript("OnDragStop", GambaDenUI.StopMovingOrSizing)
GambaDenUI:SetClampedToScreen(true)
self.db.global.scale = self.db.global.scale
GambaDenUI:SetScale(self.db.global.scale)
GambaDenUI:Hide()
-- Header to hold options
local MainHeader = CreateFrame("Frame", nil, GambaDenUI, "InsetFrameTemplate")
MainHeader:SetSize(GambaDenUI:GetSize(), 21)
MainHeader:SetPoint("TOPLEFT", GambaDenUI, 0, 0)

-- Main Button
local MainMenu = CreateFrame("Frame", nil, GambaDenUI, "InsetFrameTemplate")
MainMenu:SetSize(GambaDenUI:GetSize(), 21)
MainMenu:SetPoint("TOPLEFT", GambaDenUI, 0, 0)
--Options Button
local OptionsButton = CreateFrame("Frame", nil, GambaDenUI, "InsetFrameTemplate")
OptionsButton:SetSize(GambaDenUI:GetSize(), 21)
OptionsButton:SetPoint("TOPLEFT", GambaDenUI, 0, 0)
OptionsButton:Hide()
-- Main Menu
local GDMainMenu = CreateFrame("Button", nil, MainHeader, "UIPanelButtonTemplate")
GDMainMenu:SetSize(100, 21)
GDMainMenu:SetPoint("TOPLEFT", MainHeader, "TOPLEFT", 30, 0)
GDMainMenu:SetFrameStrata("MEDIUM")
GDMainMenu:SetText("Main")
GDMainMenu:SetNormalFontObject("GameFontNormal")
GDMainMenu:SetScript("OnMouseUp", function(self)
	if OptionsButton:IsShown() then
		OptionsButton:Hide()
		MainMenu:Show()
	end
	
end)
-- Footer
local MainFooter = CreateFrame("Button", nil, GambaDenUI, "InsetFrameTemplate")
MainFooter:SetSize(GambaDenUI:GetSize(), 15)
MainFooter:SetPoint("BOTTOMLEFT", GambaDenUI, 0, 0)
MainFooter:SetText("GambaDen - Folfykins@Pennance(AU)")
MainFooter:SetNormalFontObject("GameFontNormal")
-- Options Menu
local GDOptions = CreateFrame("Button", nil, MainHeader, "UIPanelButtonTemplate")
GDOptions:SetSize(100, 21)
GDOptions:SetPoint("TOPRIGHT", MainHeader, "TOPRIGHT", -25, 0)
GDOptions:SetFrameStrata("MEDIUM")
GDOptions:SetText("Options")
GDOptions:SetNormalFontObject("GameFontNormal")
GDOptions:SetScript("OnMouseUp", function(self)
	if MainMenu:IsShown() then
		MainMenu:Hide()
		OptionsButton:Show()
	end
end)

local GCchatMethod = CreateFrame("Button", nil, MainMenu, "UIPanelButtonTemplate")
GCchatMethod:SetSize(150, 30)
GCchatMethod:SetPoint("TOPLEFT", MainHeader, "BOTTOMLEFT", 5, -2)
GCchatMethod:SetText(self.game.chatMethod)
GCchatMethod:SetNormalFontObject("GameFontNormal")
GCchatMethod:SetScript("OnClick", function() self:chatMethod() GCchatMethod:SetText(self.game.chatMethod) end)

local GDGameMode = CreateFrame("Button", nil, MainMenu, "UIPanelButtonTemplate")
GDGameMode:SetSize(150, 30)
GDGameMode:SetPoint("TOPRIGHT", MainHeader, "BOTTOMRIGHT", -4, -2)
GDGameMode:SetText(self.game.mode)
GDGameMode:SetNormalFontObject("GameFontNormal")
GDGameMode:SetScript("OnClick", function() self:changeGameMode() GDGameMode:SetText(self.game.mode) end)

local GDEditBox = CreateFrame("EditBox", nil, MainMenu, "InputBoxTemplate")
GDEditBox:SetSize(200, 30)
GDEditBox:SetSize(MainHeader:GetSize()-25, 25)
GDEditBox:SetPoint("TOPLEFT", GCchatMethod, 10, -30)
GDEditBox:SetAutoFocus(false)
GDEditBox:SetTextInsets(10, 10, 5, 5)
GDEditBox:SetMaxLetters(6)
GDEditBox:SetJustifyH("CENTER")
GDEditBox:SetText(self.db.global.wager)
GDEditBox:SetScript("OnEnterPressed", function() 
	self:SendMsg("SET_WAGER", GDEditBox:GetText())
	GDEditBox:ClearFocus() 
	end)
-- Left Side Controls
local GDGuildPercent = CreateFrame("EditBox", nil, OptionsButton, "InputBoxTemplate")
GDGuildPercent:SetSize(140, 30)
GDGuildPercent:SetPoint("TOPLEFT", GDOptions, -22, -55)
GDGuildPercent:SetAutoFocus(false)
GDGuildPercent:SetMaxLetters(2)
GDGuildPercent:SetJustifyH("CENTER")
GDGuildPercent:SetText(self.db.global.houseCut)
GDGuildPercent:SetScript("OnEnterPressed", EditBoxOnEnterPressed)

local GDAcceptOnes = CreateFrame("Button", nil, MainMenu, "UIPanelButtonTemplate")
GDAcceptOnes:SetSize(150, 30)
GDAcceptOnes:SetPoint("TOPLEFT", GCchatMethod, "BOTTOMLEFT", -0, -25)
GDAcceptOnes:SetText("New Game")
GDAcceptOnes:SetNormalFontObject("GameFontNormal")

GDAcceptOnes:SetScript("OnClick", function()
    
    GDAcceptOnes:Disable()  -- Disable the button during processing
	self:SendMsg("SET_WAGER", GDEditBox:GetText())
	GDEditBox:ClearFocus()
	
    if GDAcceptOnes:GetText() == "Host Game" then
        GDAcceptOnes:SetText("New Game")
    else
        self.game.state = "START"
        self:SendMsg("R_NewGame")
        self.game.host = true
        self:SendMsg("New_Game")
        
        -- Sets same roll for everyone.
        self:SendMsg("SET_WAGER", GDEditBox:GetText())

        -- Switches everyone to the same gamemode.
        self:SendMsg("GAME_MODE", GDGameMode:GetText())

        -- Switches everyone to the proper chat method.
        self:SendMsg("Chat_Method", GCchatMethod:GetText())

        self:SendMsg("SET_HOUSE", GDGuildPercent:GetText())
        -- Starts a new game but only if they're the host.
    end

    GDAcceptOnes:Enable()   -- Enable the button after processing
end)

local GDLastCall = CreateFrame("Button", nil, MainMenu, "UIPanelButtonTemplate")
GDLastCall:SetSize(150, 30)
GDLastCall:SetPoint("TOPLEFT", GDAcceptOnes, "BOTTOMLEFT", -0, -3)
GDLastCall:SetText("Last Call!")
GDLastCall:SetNormalFontObject("GameFontNormal")
GDLastCall:SetScript("OnClick", function()
    Hooks:click_LastCall(self.game.chatMethod)
end)

local GDStartRoll = CreateFrame("Button", nil, MainMenu, "UIPanelButtonTemplate")
GDStartRoll:SetSize(150, 30)
GDStartRoll:SetPoint("TOPLEFT", GDLastCall, "BOTTOMLEFT", -0, -3)
GDStartRoll:SetText("Start Rolling")
GDStartRoll:SetNormalFontObject("GameFontNormal")
GDStartRoll:SetScript("OnClick", function()
self:GDRolls()
GDStartRoll:SetText("Whos Left?")
end)
-- Right Side Controls 
local GDEnter = CreateFrame("Button", nil, MainMenu, "UIPanelButtonTemplate")
GDEnter:SetSize(150, 30)
GDEnter:SetPoint("TOPLEFT", GDGameMode, "BOTTOMLEFT", -0, -25)
GDEnter:SetText("Join Game")
GDEnter:SetNormalFontObject("GameFontNormal")
GDEnter:SetScript("OnClick", function()
	if (GDEnter:GetText() == "Join Game") then
         SendChatMessage("1" , self.game.chatMethod)
        GDEnter:SetText("Leave Game")
    elseif (GDEnter:GetText() == "Leave Game") then
		SendChatMessage("-1" , self.game.chatMethod)
        GDEnter:SetText("Join Game")
    end
end)


local GDRollMe = CreateFrame("Button", nil, MainMenu, "UIPanelButtonTemplate")
GDRollMe:SetSize(150, 30)
GDRollMe:SetPoint("TOPLEFT", GDEnter, "BOTTOMLEFT", -0, -3)
GDRollMe:SetText("Roll Me")
GDRollMe:SetNormalFontObject("GameFontNormal")
GDRollMe:SetScript("OnClick", function()
  rollMe()
end)

local GDCloseGame = CreateFrame("Button", nil, MainMenu, "UIPanelButtonTemplate")
GDCloseGame:SetSize(150, 30)
GDCloseGame:SetPoint("TOPLEFT", GDRollMe, "BOTTOMLEFT", -0, -3)
GDCloseGame:SetText("Close")
GDCloseGame:SetNormalFontObject("GameFontNormal")
GDCloseGame:SetScript("OnClick", function()
  GambaDenUI:Hide()
end)

-- Options Menu Buttons

-- Left Options
local GDFullStats = CreateFrame("Button", nil, OptionsButton, "UIPanelButtonTemplate")
GDFullStats:SetSize(150, 30)
GDFullStats:SetPoint("TOPLEFT", MainHeader, "BOTTOMLEFT", 5, -2)
GDFullStats:SetText("Full Stats")
GDFullStats:SetNormalFontObject("GameFontNormal")
GDFullStats:SetScript("OnClick", function(full)
  self:reportStats(full)
end)

local GDGuildCut = CreateFrame("Button", nil, OptionsButton, "UIPanelButtonTemplate")
GDGuildCut:SetSize(150, 30)
GDGuildCut:SetPoint("TOPLEFT", GDFullStats, "BOTTOMLEFT", -0, -3)
GDGuildCut:SetText("Guild Cut(OFF)")
GDGuildCut:SetNormalFontObject("GameFontNormal")
GDGuildCut:SetScript("OnClick", function()
  if (self.game.house == true) then
		self.game.house = false
		GDGuildCut:SetText("Guild Cut (OFF)");
		DEFAULT_CHAT_FRAME:AddMessage("|cffffff00Guild cut has been turned off.")
	else
		self.game.house = true
		GDGuildCut:SetText("Guild Cut (ON)");
		DEFAULT_CHAT_FRAME:AddMessage("|cffffff00Guild cut has been turned on.")
	end
end)

local GDReset = CreateFrame("Button", nil, OptionsButton, "UIPanelButtonTemplate")
GDReset:SetSize(158, 30)
GDReset:SetPoint("TOPLEFT", GDGuildCut, "BOTTOMLEFT", -0, -3)
GDReset:SetText("Reset Stats!")
GDReset:SetScript("OnMouseDown", function()
self.game.host = false
for i = 1, #GDPlayers do
		GDPlayers[1].HasRolled = false
		GambaDen:RemovePlayer(GDPlayers[1].Name)
	    
end
	GDEnter:SetText("Join Game")
    self.game.state = "START"
    self.game.players = {}
    self.game.result = nil
    self.db.global.stats = {}
	self.db.global.joinstats = {}
	self.db.global.housestats = 0
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00GD ALL STATS RESET!")
end)

-- Create a button to toggle the realm filter
local GDRealmFilter = CreateFrame("Button", "GDRealmFilter", OptionsButton, "UIPanelButtonTemplate")
GDRealmFilter:SetPoint("TOPLEFT", GDReset, "BOTTOMLEFT", -0, -3)
GDRealmFilter:SetSize(158, 30)
GDRealmFilter:SetText("Realm Filter(OFF)")
GDRealmFilter:Show()

-- Function to toggle the realm filter
local function ToggleRealmFilter()
  if(self.game.realmFilter == false) then
    GDRealmFilter:SetText("Realm Filter(ON)")
	self.game.realmFilter = true
  else
    GDRealmFilter:SetText("Realm Filter(OFF)")
	self.game.realmFilter = false
  end
end

-- Set the button's OnClick behavior to toggle the realm filter
GDRealmFilter:SetScript("OnClick", ToggleRealmFilter)


-- Right Options 
local GDFameShame = CreateFrame("Button", nil, OptionsButton, "UIPanelButtonTemplate")
GDFameShame:SetSize(150, 30)
GDFameShame:SetPoint("TOPRIGHT", MainHeader, "BOTTOMRIGHT", -4, -3)
GDFameShame:SetText("Fame/Shame")
GDFameShame:SetNormalFontObject("GameFontNormal")
GDFameShame:SetScript("OnClick", function()
  self:reportStats()
end)

local GDTheme = CreateFrame("Button", nil, OptionsButton, "UIPanelButtonTemplate")
GDTheme:SetSize(150, 30)
GDTheme:SetPoint("TOPRIGHT", GDFameShame, "BOTTOMRIGHT", -0, -35)
GDTheme:SetText("Slick Theme")
GDTheme:SetNormalFontObject("GameFontNormal")
GDTheme:SetScript("OnClick", function()
  self.db.global.theme = "Slick"
	  ReloadUI()
end)

-- Right Side Menu

local GDRightMenu = CreateFrame("Frame", "GDRightMenu", GambaDenUI, "InsetFrameTemplate")
GDRightMenu:SetPoint("TOPLEFT", GambaDenUI, "TOPRIGHT", 0, 0)
GDRightMenu:SetSize(220, 150)
GDRightMenu:Hide()

local function onUpdate(self,elapsed)
    local mainX, mainY = GambaDenUI:GetCenter()
    local leftX, leftY = GDRightMenu:GetCenter()
    local distance = math.sqrt((mainX - leftX)^2 + (mainY - leftY)^2)
    if distance < 260 then
        GDRightMenu:ClearAllPoints()
        GDRightMenu:SetPoint("TOPLEFT", GambaDenUI, "TOPRIGHT", 0, 0)
end
end

GDRightMenu:SetScript("OnUpdate", onUpdate)
GDRightMenu:SetMovable(true)
GDRightMenu:EnableMouse(true)
GDRightMenu:SetUserPlaced(true)
GDRightMenu:SetClampedToScreen(true)

GDRightMenu:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" and not self.isMoving then
        self:StartMoving();
        self.isMoving = true;
    end
end)
GDRightMenu:SetScript("OnMouseUp", function(self, button)
    if button == "LeftButton" and self.isMoving then
        self:StopMovingOrSizing();
        self.isMoving = false;
    end
end)

-- Create the text field frame within the right side menu frame

GDRightMenu.TextField = CreateFrame("ScrollingMessageFrame", nil, GDRightMenu)
GDRightMenu.TextField:SetPoint("CENTER", GDRightMenu, 2, -0)
GDRightMenu.TextField:SetSize(GDRightMenu:GetWidth()-8, -140)
GDRightMenu.TextField:SetFont("Fonts\\FRIZQT__.TTF", 11, "")
GDRightMenu.TextField:SetFading(false)
GDRightMenu.TextField:SetJustifyH("LEFT")
GDRightMenu.TextField:SetMaxLines(50)
GDRightMenu.TextField:SetScript("OnMouseWheel", function(self, delta)
    if (delta == 1) then
        self:ScrollUp()
    else
        self:ScrollDown()
    end
end)

local function OnChatSubmit(GDChatBox)
    local message = GDChatBox:GetText()
    if message ~= "" and message ~= " " then
        local playerName = UnitName("player")
	local playerClass = select(2, UnitClass("player"))
	local messageWithPlayerInfo = string.format("%s:%s:%s", playerName, playerClass, message)
		self:SendMsg("CHAT_MSG", messageWithPlayerInfo)
    end
    GDChatBox:SetText("")
    GDChatBox:ClearFocus()
end

local CallFrame = CreateFrame("Frame")
CallFrame:RegisterEvent("CHAT_MSG_ADDON")
CallFrame:SetScript("OnEvent", function(self, event, prefix, msg)
	if prefix ~= "GambaDen" then return end
		local event_type, arg1, arg2 = strsplit(":", msg)
	if GDCall[event_type] then
		GDCall[event_type](arg1, arg2)
	elseif event_type == "CHAT_MSG" then
	local name, class, message = strmatch(msg, "CHAT_MSG:(%S+):(%S+):(.+)")
	local formatted = string.format("[%s|r]: %s", name, message)
	GDRightMenu.TextField:AddMessage(formatted)
	end
end)

local GDChatBox = CreateFrame("EditBox", nil, GDRightMenu, "InputBoxTemplate")
GDChatBox:SetPoint("TOPLEFT", GDRightMenu, "BOTTOMLEFT", 5, -20)
GDChatBox:SetSize(GDRightMenu:GetWidth() - 10, -15)
GDChatBox:SetAutoFocus(false)
GDChatBox:SetTextInsets(10, 10, 5, 5)
GDChatBox:SetMaxLetters(55)
GDChatBox:SetText("Type Here...")
GDChatBox:SetScript("OnEnterPressed", OnChatSubmit)

local GDChatToggle = CreateFrame("Button", nil, MainHeader, "UIPanelButtonTemplate")
GDChatToggle:SetSize(20, 21) 
GDChatToggle:SetPoint("TOPRIGHT", MainHeader, "TOPRIGHT", 0, 0)
GDChatToggle:SetText(">")
GDChatToggle:SetNormalFontObject("GameFontNormal")
GDChatToggle:SetScript("OnMouseDown", function()
   if GDRightMenu:IsShown() then
		GDRightMenu:Hide()
		GDChatToggle:SetText(">")
		self.game.chatframeOption = true
	else
		GDRightMenu:Show()
		GDChatToggle:SetText("<")
		self.game.chatframeOption = false
	end
end)


local valuescale = function(val,valStep)
		 	self.db.global.scalevalue = val
    return floor(val/valStep)*valStep
  end
  
	--basic slider func
	local CreateBasicSlider = function(parent, name, title, minVal, maxVal, valStep)
	local slider = CreateFrame("Slider", name, GambaDenUI, "OptionsSliderTemplate")
	slider:SetSize(GambaDenUI:GetSize(), 21)
	slider:SetPoint("BOTTOM", GambaDenUI, "BOTTOM", 0, -20)
    local editbox = CreateFrame("EditBox", "$parentEditBox", slider, "InputBoxTemplate")
    slider:SetMinMaxValues(50, 250)
	self.db.global.scalevalue = self.db.global.scalevalue
	slider:SetValue(self.db.global.scalevalue)
    slider:SetValueStep(valStep)
	slider:SetFrameStrata("LOW")
    slider.text = _G[name.."Text"]
    slider.text:SetText(title)
    slider.textLow = _G[name.."Low"]
    slider.textHigh = _G[name.."High"]
    slider.textLow:SetText("")
    slider.textHigh:SetText("")
    slider.textLow:SetTextColor(0,0,0)
    slider.textHigh:SetTextColor(0.4,0.4,0.4)
    editbox:ClearAllPoints()
    editbox:SetPoint("LEFT", slider, "RIGHT", 10, 0)
    editbox:SetText(slider:GetValue())
    editbox:SetAutoFocus(false)
	
    slider:SetScript("OnValueChanged", function(self,value)
      self.editbox:SetText(valuescale (value,valStep))
    end)
    slider.editbox = editbox
    return slider
  end
  
 
    local slider = CreateBasicSlider(parent, "GDSlider", "", 0, 1, 0.001)
    slider:HookScript("OnMouseUp", function(self,value)
      --save value
	  CrossScale(self)
    end)

	function CrossScale()
		self.db.global.scale = slider:GetValue()/100
		GambaDenUI:SetScale(self.db.global.scale)
	end
	
-- Left Side Menu
local GDLeftMenu = CreateFrame("Frame", "GDLeftMenu", GambaDenUI, "InsetFrameTemplate")
GDLeftMenu:SetPoint("TOPLEFT", GambaDenUI, "TOPLEFT", -300, -20)
GDLeftMenu:SetSize(300, 180)
GDLeftMenu:Hide()

local function onUpdate(self,elapsed)
    local mainX, mainY = GambaDenUI:GetCenter()
    local leftX, leftY = GDLeftMenu:GetCenter()
    local distance = math.sqrt((mainX - leftX)^2 + (mainY - leftY)^2)
    if distance < 300 then
        GDLeftMenu:ClearAllPoints()
        GDLeftMenu:SetPoint("TOPLEFT", GambaDenUI, "TOPLEFT", -300, -20)
end
end

GDLeftMenu:SetScript("OnUpdate", onUpdate)
GDLeftMenu:SetMovable(true)
GDLeftMenu:EnableMouse(true)
GDLeftMenu:SetUserPlaced(true)
GDLeftMenu:SetClampedToScreen(true)

GDLeftMenu:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" and not self.isMoving then
        self:StartMoving();
        self.isMoving = true;
    end
end)
GDLeftMenu:SetScript("OnMouseUp", function(self, button)
    if button == "LeftButton" and self.isMoving then
        self:StopMovingOrSizing();
        self.isMoving = false;
    end
end)

local GDLeftMenuHeader = CreateFrame("Button", nil, GDLeftMenu, "UIPanelButtonTemplate")
GDLeftMenuHeader:SetSize(GDLeftMenu:GetSize(), 21) 
GDLeftMenuHeader:SetPoint("TOPLEFT", GDLeftMenu, "TOPLEFT", 0, 20)
GDLeftMenuHeader:SetFrameLevel(15)
GDLeftMenuHeader:SetText("Roll Tracker")
GDLeftMenuHeader:SetNormalFontObject("GameFontNormal")

local GDMenuToggle = CreateFrame("Button", nil, MainHeader,  "UIPanelButtonTemplate")
GDMenuToggle:SetSize(20, 21) 
GDMenuToggle:SetPoint("TOPLEFT", MainHeader, "TOPLEFT", 0, 0)
GDMenuToggle:SetFrameLevel(15)
GDMenuToggle:SetText("<")
GDMenuToggle:SetNormalFontObject("GameFontNormal")
GDMenuToggle:SetScript("OnMouseDown", function(self)
   if GDLeftMenu:IsShown() then
		GDLeftMenu:Hide()
		GDMenuToggle:SetText("<")
	else
		GDLeftMenu:Show()
		GDMenuToggle:SetText(">")
	end
end)

function GambaDen:RemovePlayer(name)
    -- loop through the "GDPlayers" table
    for i, player in pairs(GDPlayers) do
        if player.name == name then
            -- remove the player from the "GDPlayers" table
            table.remove(GDPlayers, i)
            -- update the player list
            UpdatePlayerList()
            -- player found and removed, exit the function
            return
        end
    end
end


function GambaDen:AddPlayer(playerName)
    -- First, check if the player already exists in the "GDPlayers" table
    for i, player in pairs(GDPlayers) do
        if player.name == playerName then
            -- player already exists, exit the function
            return
        end
    end
    -- create a new table to store the player's information
    local newPlayer = {
        name = playerName,
        total = 0,
    }
    -- insert the new player into the "GDPlayers" table
    table.insert(GDPlayers, newPlayer)

    -- sort the "GDPlayers" table by name
    table.sort(GDPlayers, function(a, b)
        return a.name < b.name
    end)
    UpdatePlayerList()
end

-- Create the main frame for the player list
local playerListFrame = CreateFrame("Frame", "PlayerListFrame", GDLeftMenu)
playerListFrame:SetSize(300, 150)
playerListFrame:SetPoint("CENTER")

-- Create a scroll frame to hold the player list
local scrollFrame = CreateFrame("ScrollFrame", "PlayerListScrollFrame", playerListFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(266, 170)
scrollFrame:SetPoint("TOPLEFT", 10, 15)

-- Enable scrolling with the mouse wheel
scrollFrame:EnableMouseWheel(true)
scrollFrame:SetScript("OnMouseWheel", function(self, delta)
    local currentValue = scrollFrame:GetVerticalScroll()
    local rowHeight = 30
    local numRows = #GDPlayers
    local maxRows = math.max(numRows * rowHeight - scrollFrame:GetHeight(), 0)
    local newValue = math.max(0, math.min(currentValue - delta * rowHeight, maxRows))
    scrollFrame:SetVerticalScroll(newValue)
end)

local playerButtonsFrame = CreateFrame("Frame", "PlayerButtonsFrame", scrollFrame)
playerButtonsFrame:SetSize(280, 1)  -- Set the height to 1 for dynamic sizing
scrollFrame:SetScrollChild(playerButtonsFrame)

-- create a new table to store the player buttons
playerButtons = {}

function UpdatePlayerList()
    -- Sort GDPlayers table alphabetically by player name
    table.sort(GDPlayers, function(a, b)
        return a.name < b.name
    end)

    -- Remove all current player buttons
    for i, button in ipairs(playerButtons) do
        button:Hide()
        button:SetParent(nil)
    end

    for i, player in ipairs(GDPlayers) do
        local playerButton = CreateFrame("Button", "PlayerButton"..i, playerButtonsFrame, "InsetFrameTemplate")
        playerButton:SetSize(260, 20)
        playerButton:SetPoint("TOPLEFT", playerButtonsFrame, 0, -i * 20)
        playerButton:SetNormalFontObject("GameFontNormal")
        playerButton:SetHighlightFontObject("GameFontHighlight")

        if player.roll ~= nil then
            playerButton:SetText(player.name .. " : " .. player.roll)
        else
            playerButton:SetText(player.name)
        end

        table.insert(playerButtons, playerButton)
    end

	-- For testing
	--for i = 1, 40 do
  --  local randomName = "Player " .. math.random(1, 20)
   -- GambaDen:AddPlayer(randomName)
--end
end



GDCall["PLAYER_ROLL"] = function(playerName, value)
    -- find the player in the "GDPlayers" table
    for i, player in pairs(GDPlayers) do
        if player.name == playerName then
            player.roll = value -- change roll to value
            break
        end
    end
    UpdatePlayerList()
end

GDCall["R_NewGame"] = function()
    for i = #GDPlayers, 1, -1 do
        GambaDen:RemovePlayer(GDPlayers[i].name)
    end
GDEnter:SetText("Join Game")
GDEnter:Enable()
end



GDCall["DisableClient"] = function()
		GDAcceptOnes:Disable()
		GDLastCall:Disable()
		GDStartRoll:Disable()
		self.game.players = {}
		self.game.result = nil
	if(self.game.host) then
		GDAcceptOnes:Enable()
		GDLastCall:Enable()
		GDStartRoll:Enable()
	end
end

GDCall["Disable_Join"] = function()
GDEnter:Disable()
end

end

C_ChatInfo.RegisterAddonMessagePrefix("GambaDen")
