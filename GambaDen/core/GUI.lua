local GDPlayers = {}
local GD = "Interface\\AddOns\\GambaDen\\media\\GD.tga"
local Backdrop = {
	bgFile = GD,
	edgeFile = GD,
	tile = false, tileSize = 0, edgeSize = 1,
	insets = {left = 1, right = 1, top = 1, bottom = 1},

}
local frameColor = {r = 0.27, g = 0.27, b = 0.27}
local buttonColor = {r = 0.30, g = 0.30, b = 0.30}
local sideColor = {r = 0.20, g = 0.20, b = 0.20}
local playerNameColor = "|c" .. RAID_CLASS_COLORS[select(2, UnitClass("player"))].colorStr
local fontColor = ""
local BtnClr, SideClr = {}, {}
local ButtonColors = function(self)
if not self.SetBackdrop then
Mixin(self, BackdropTemplateMixin)
end
self:SetBackdrop(Backdrop)
self:SetBackdropBorderColor(0, 0, 0)
table.insert(BtnClr, self)
end

local SideColor = function(self)
if not self.SetBackdrop then
Mixin(self, BackdropTemplateMixin)
end
self:SetBackdrop(Backdrop)
self:SetBackdropBorderColor(0, 0, 0)
table.insert(SideClr, self)
end
local GambaDenUI

function GambaDen:toggleUi()
if (GambaDenUI:IsVisible()) then
GambaDenUI:Hide()
else
LoadColor()
GambaDenUI:Show()
end
end

function GambaDen:ShowSlick(info)
    -- Show Inerface
	if (GambaDenUI:IsVisible() ~= true) then
        GambaDenUI:Show()
		LoadColor()
	else 
		GambaDenUI:Hide()
	end
end

function GambaDen:HideSlick(info)
    -- Hide Interface
    if (GambaDenUI:IsVisible()) then
        GambaDenUI:Hide()
    end
end 

function GambaDen:DrawMainEvents()
-- Theme Changer (Needs work)
GDTheme = CreateFrame("Frame", "GambaDenTheme", UIParent, "BasicFrameTemplateWithInset")
GDTheme:SetSize(1000, 320) 
GDTheme:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
GDTheme:SetMovable(true)
GDTheme:EnableMouse(true)
GDTheme:SetUserPlaced(true)
GDTheme:Show()
GambaDenTheme:SetScript("OnLeave", function()
	self.db.global.themechoice = 0
end)
if self.db.global.themechoice == 1 then
GambaDenTheme:Show()
else
GambaDenTheme:Hide()
end
local GDThemeHeader = GDTheme:CreateFontString(nil, "ARTWORK", "GameFontNormal")
GDThemeHeader:SetPoint("TOP", GDTheme, "TOP", 0, -2)
GDThemeHeader:SetText("GambaDen")

local GDThemeText = GDTheme:CreateFontString(nil, "OVERLAY", "GameFontNormal")
GDThemeText:SetPoint("TOP", GDTheme, "TOP", 0, -50)
GDThemeText:SetText("New theme picker, choose between Classic or New Style! After picking, and confirming, your game will reload. \nBoth frames are Resizable! All frames and panels are movable and in the new style you can change its colors.")

local OldTheme = CreateFrame("CheckButton", nil, GDTheme, "ChatConfigCheckButtonTemplate")
OldTheme:SetSize(40, 40)
OldTheme:SetPoint("BOTTOMLEFT", GDTheme, "BOTTOMLEFT", 220, 5)
OldTheme:SetScript("OnEnter", ButtonOnEnter)
OldTheme:SetScript("OnLeave", ButtonOnLeave)
OldTheme:SetText("Old Theme")
OldTheme:SetScript("OnMouseUp", function()
self.db.global.theme = "Classic"
end)

local NewTheme = CreateFrame("CheckButton", nil, GDTheme,"ChatConfigCheckButtonTemplate")
NewTheme:SetSize(40, 40)
NewTheme:SetPoint("BOTTOMLEFT", GDTheme, "BOTTOMLEFT", 620, 5)
NewTheme:SetScript("OnEnter", ButtonOnEnter)
NewTheme:SetScript("OnLeave", ButtonOnLeave)
NewTheme:SetScript("OnMouseUp", function()
NewTheme:SetText("New Theme")
self.db.global.theme = "Slick"
end)

local GDThemeClassic = GDTheme:CreateTexture(nil, "ARTWORK")
GDThemeClassic:SetPoint("BOTTOMLEFT", GDTheme, "BOTTOMLEFT", 0, 10)
GDThemeClassic:SetTexture("Interface\\AddOns\\GambaDen\\media\\ClassicTheme.tga") 

local GDThemeConfirm = CreateFrame("Button", nil, GDTheme, "BackdropTemplate")
GDThemeConfirm:SetSize(100, 21)
GDThemeConfirm:SetPoint("BOTTOMLEFT", GDTheme, "BOTTOMRIGHT", -550, 10)
GDThemeConfirm:SetText("Confirm")
GDThemeConfirm:SetNormalFontObject("GameFontNormal")
ButtonColors(GDThemeConfirm)
GDThemeConfirm:SetScript("OnMouseUp", function(self)
ReloadUI()
end)

local GDThemeSlick = GDTheme:CreateTexture(nil, "ARTWORK")
GDThemeSlick:SetPoint("BOTTOMRIGHT", GDTheme, "BOTTOMRIGHT", 0, 10)
GDThemeSlick:SetTexture("Interface\\AddOns\\GambaDen\\media\\NewTheme.tga") 
GDThemeSlick:SetSize(608, 280)

--Create Main UI
GambaDenUI = CreateFrame("Frame", "GambaDenSlick", UIParent, "BackdropTemplate")
GambaDenUI:SetSize(230, 200)
GambaDenUI:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
GambaDenUI:SetBackdrop(Backdrop)
GambaDenUI:SetMovable(true)
GambaDenUI:EnableMouse(true)
GambaDenUI:SetUserPlaced(true)
GambaDenUI:SetResizable(true)
GambaDenUI:SetBackdropBorderColor(0, 0, 0)
GambaDenUI:RegisterForDrag("LeftButton")
GambaDenUI:SetScript("OnDragStart", GambaDenUI.StartMoving)
GambaDenUI:SetScript("OnDragStop", GambaDenUI.StopMovingOrSizing)
GambaDenUI:SetClampedToScreen(true)
self.db.global.scale = self.db.global.scale
GambaDenUI:SetScale(self.db.global.scale)
GambaDenUI:Hide()
-- Header to hold options
local MainHeader = CreateFrame("Frame", nil, GambaDenUI, "BackdropTemplate")
MainHeader:SetSize(GambaDenUI:GetSize(), 21)
MainHeader:SetPoint("TOPLEFT", GambaDenUI, 0, 0)
ButtonColors(MainHeader)
-- Main Button
local MainMenu = CreateFrame("Frame", nil, GambaDenUI, "BackdropTemplate")
MainMenu:SetSize(GambaDenUI:GetSize(), 21)
MainMenu:SetPoint("TOPLEFT", GambaDenUI, 0, 0)
--Options Button
local OptionsButton = CreateFrame("Frame", nil, GambaDenUI, "BackdropTemplate")
OptionsButton:SetSize(GambaDenUI:GetSize(), 21)
OptionsButton:SetPoint("TOPLEFT", GambaDenUI, 0, 0)
OptionsButton:Hide()

-- Main Menu
local GDMainMenu = CreateFrame("Button", nil, MainHeader,  "BackdropTemplate")
GDMainMenu:SetSize(63, 21)
GDMainMenu:SetPoint("TOPLEFT", MainHeader, "TOPLEFT", 30, 0)
GDMainMenu:SetFrameStrata("MEDIUM")
GDMainMenu:SetText("Main")
GDMainMenu:SetNormalFontObject("GameFontNormal")
ButtonColors(GDMainMenu)
GDMainMenu:SetScript("OnMouseUp", function(self)
	if OptionsButton:IsShown() then
		OptionsButton:Hide()
		MainMenu:Show()
	end
	
end)
-- Footer
local MainFooter = CreateFrame("Button", nil, GambaDenUI, "BackdropTemplate")
MainFooter:SetSize(GambaDenUI:GetSize(), 15)
MainFooter:SetPoint("BOTTOMLEFT", GambaDenUI, 0, 0)
MainFooter:SetText("GambaDen - Folfykins@Pennance(AU)")
MainFooter:SetNormalFontObject("GameFontNormal")
ButtonColors(MainFooter)
-- Options Menu
local GDOptions = CreateFrame("Button", nil, MainHeader,  "BackdropTemplate")
GDOptions:SetSize(63, 21)
GDOptions:SetPoint("TOPRIGHT", MainHeader, "TOPRIGHT", -30, 0)
GDOptions:SetFrameStrata("MEDIUM")
GDOptions:SetText("Options")
GDOptions:SetNormalFontObject("GameFontNormal")
ButtonColors(GDOptions)
GDOptions:SetScript("OnMouseUp", function(self)
	if MainMenu:IsShown() then
		MainMenu:Hide()
		OptionsButton:Show()
	end
end)




local fontColor = {r = 1.0, g = 1.0, b = 1.0} 
function setFontColor(r, g, b)
    fontColor.r, fontColor.g, fontColor.b = r, g, b
    --print("Font Color Set: " .. fontColor.r .. ", " .. fontColor.g .. ", " .. fontColor.b)
end
function LoadColor()
    frameColor.r, frameColor.g, frameColor.b = self.db.global.colors.frameColor.r, self.db.global.colors.frameColor.g, self.db.global.colors.frameColor.b
    GambaDenUI:SetBackdropColor(frameColor.r, frameColor.g, frameColor.b)

    buttonColor.r, buttonColor.g, buttonColor.b = self.db.global.colors.buttonColor.r, self.db.global.colors.buttonColor.g, self.db.global.colors.buttonColor.b
    sideColor.r, sideColor.g, sideColor.b = self.db.global.colors.sideColor.r, self.db.global.colors.sideColor.g, self.db.global.colors.sideColor.b
	
    local fontColorRGB = self.db.global.colors.fontColor
    fontColor.r, fontColor.g, fontColor.b = fontColorRGB.r, fontColorRGB.g, fontColorRGB.b
    setFontColor(fontColor.r, fontColor.g, fontColor.b)

    for i = 1, #SideClr do
        SideClr[i]:SetBackdropColor(sideColor.r, sideColor.g, sideColor.b)
    end
    for i = 1, #BtnClr do
        BtnClr[i]:SetBackdropColor(buttonColor.r, buttonColor.g, buttonColor.b)
    end
end


function SaveColor()
	self.db.global.colors.frameColor.r, self.db.global.colors.frameColor.g, self.db.global.colors.frameColor.b = frameColor.r, frameColor.g, frameColor.b
    self.db.global.colors.buttonColor.r, self.db.global.colors.buttonColor.g, self.db.global.colors.buttonColor.b = buttonColor.r, buttonColor.g, buttonColor.b
    self.db.global.colors.sideColor.r, self.db.global.colors.sideColor.g, self.db.global.colors.sideColor.b = sideColor.r, sideColor.g, sideColor.b
	self.db.global.colors.fontColor = fontColor
end



function changeColor(element)
    local color
    if element == "frame" then
        color = frameColor
    elseif element == "buttons" then
        color = buttonColor
    elseif element == "sidecolor" then
        color = sideColor
    elseif element == "fontcolor" then
        color = fontColor
    elseif element == "resetColors" then
        frameColor = { r = 0.27, g = 0.27, b = 0.27 }
        GambaDenUI:SetBackdropColor(frameColor.r, frameColor.g, frameColor.b)
        buttonColor = { r = 0.30, g = 0.30, b = 0.30 }
        for i, button in ipairs(BtnClr) do
            button:SetBackdropColor(buttonColor.r, buttonColor.g, buttonColor.b)
        end
        sideColor = { r = 0.20, g = 0.20, b = 0.20 }
        for i, button in ipairs(SideClr) do
            button:SetBackdropColor(sideColor.r, sideColor.g, sideColor.b)
        end
        SaveColor()
        return
    end

    local function ShowColorPicker(r, g, b, a, changedCallback)
        ColorPickerFrame.hasOpacity = false
        ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = changedCallback, changedCallback, changedCallback
        ColorPickerFrame:Hide()
        ColorPickerFrame:Show()
    end
	
	ColorPickerFrame.swatchFunc = function()
        local r, g, b = ColorPickerFrame:GetColorRGB()
    end
	
	
	


local function ColorCallback(restore)
    local newR, newG, newB = ColorPickerFrame:GetColorRGB()
    
		if element == "fontcolor" then
		--print("Setting font color with RGB values:", newR, newG, newB)
		setFontColor(newR, newG, newB)
		else
        color.r, color.g, color.b = newR, newG, newB

        if element == "frame" then
            GambaDenUI:SetBackdropColor(color.r, color.g, color.b)
        elseif element == "buttons" then
            for i, button in ipairs(BtnClr) do
                button:SetBackdropColor(color.r, color.g, color.b)
            end
        elseif element == "sidecolor" then
            for i, button in ipairs(SideClr) do
                button:SetBackdropColor(color.r, color.g, color.b)
            end
        end
    end

    if not restore then
        SaveColor()
    end
end



    ShowColorPicker(color.r, color.g, color.b, nil, ColorCallback)
end

local GCchatMethod = CreateFrame("Button", nil, MainMenu, "BackdropTemplate")
GCchatMethod:SetSize(105, 30)
GCchatMethod:SetPoint("TOPLEFT", MainHeader, "BOTTOMLEFT", 5, -2)
GCchatMethod:SetText(self.game.chatMethod)
GCchatMethod:SetNormalFontObject("GameFontNormal")
ButtonColors(GCchatMethod)
GCchatMethod:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
local highlight = GCchatMethod:GetHighlightTexture()
highlight:SetBlendMode("ADD")
highlight:SetAllPoints()

GCchatMethod:SetScript("OnEnter", function(self)
    highlight:Show()
end)

GCchatMethod:SetScript("OnLeave", function(self)
    highlight:Hide()
end)
GCchatMethod:SetScript("OnClick", function() self:chatMethod() GCchatMethod:SetText(self.game.chatMethod) end)

local GDGameMode = CreateFrame("Button", nil, MainMenu, "BackdropTemplate")
GDGameMode:SetSize(105, 30)
GDGameMode:SetPoint("TOPRIGHT", MainHeader, "BOTTOMRIGHT", -4, -2)
GDGameMode:SetText(self.game.mode)
GDGameMode:SetNormalFontObject("GameFontNormal")
ButtonColors(GDGameMode)
GDGameMode:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
local highlight = GDGameMode:GetHighlightTexture()
highlight:SetBlendMode("ADD")
highlight:SetAllPoints()

GDGameMode:SetScript("OnEnter", function(self)
    highlight:Show()
end)

GDGameMode:SetScript("OnLeave", function(self)
    highlight:Hide()
end)
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
-- Left Side Controls
local GDGuildPercent = CreateFrame("EditBox", nil, OptionsButton, "InputBoxTemplate")
GDGuildPercent:SetSize(100, 30)
GDGuildPercent:SetPoint("TOPLEFT", GDOptions, -10, -56)
GDGuildPercent:SetAutoFocus(false)
GDGuildPercent:SetTextInsets(10, 10, 5, 5)
GDGuildPercent:SetMaxLetters(2)
GDGuildPercent:SetJustifyH("CENTER")
GDGuildPercent:SetText(self.db.global.houseCut)
GDGuildPercent:SetScript("OnEnterPressed", EditBoxOnEnterPressed)

local GDAcceptOnes = CreateFrame("Button", nil, MainMenu, "BackdropTemplate")
GDAcceptOnes:SetSize(105, 30)
GDAcceptOnes:SetPoint("TOPLEFT", GCchatMethod, "BOTTOMLEFT", -0, -25)
GDAcceptOnes:SetText("New Game")
GDAcceptOnes:SetNormalFontObject("GameFontNormal")
ButtonColors(GDAcceptOnes)

-- Add the following lines to create the highlight effect
GDAcceptOnes:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
local highlight = GDAcceptOnes:GetHighlightTexture()
highlight:SetBlendMode("ADD")
highlight:SetAllPoints()

GDAcceptOnes:SetScript("OnEnter", function(self)
    highlight:Show()
end)

GDAcceptOnes:SetScript("OnLeave", function(self)
    highlight:Hide()
end)
-- End of highlight effect code

GDAcceptOnes:SetScript("OnClick", function()
    GDAcceptOnes:Disable()  -- Disable the button during processing

    if GDAcceptOnes:GetText() == "Host Game" then
        GDAcceptOnes:SetText("New Game")
    else
        self.game.state = "START"
        self:SendMsg("R_NewGame")
		
		
        -- Sets same roll for everyone.
        self:SendMsg("SET_WAGER", GDEditBox:GetText())

        -- Switches everyone to the same gamemode.
        self:SendMsg("GAME_MODE", GDGameMode:GetText())

        -- Switches everyone to the proper chat method.
        self:SendMsg("Chat_Method", GCchatMethod:GetText())

        self:SendMsg("SET_HOUSE", GDGuildPercent:GetText())
		
		self.game.host = true
        self:SendMsg("New_Game")


        -- Starts a new game but only if they're the host.
    end

    GDAcceptOnes:Enable()   -- Enable the button after processing
end)


local GDLastCall = CreateFrame("Button", nil, MainMenu, "BackdropTemplate")
GDLastCall:SetSize(105, 30)
GDLastCall:SetPoint("TOPLEFT", GDAcceptOnes, "BOTTOMLEFT", -0, -3)
GDLastCall:SetText("Last Call!")
GDLastCall:SetNormalFontObject("GameFontNormal")
ButtonColors(GDLastCall)
GDLastCall:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
local highlight = GDLastCall:GetHighlightTexture()
highlight:SetBlendMode("ADD")
highlight:SetAllPoints()

GDLastCall:SetScript("OnEnter", function(self)
    highlight:Show()
end)

GDLastCall:SetScript("OnLeave", function(self)
    highlight:Hide()
end)
GDLastCall:SetScript("OnClick", function()
self:SendMsg("LastCall")
end)

local GDStartRoll = CreateFrame("Button", nil, MainMenu, "BackdropTemplate")
GDStartRoll:SetSize(105, 30)
GDStartRoll:SetPoint("TOPLEFT", GDLastCall, "BOTTOMLEFT", -0, -3)
GDStartRoll:SetText("Start Rolling")
GDStartRoll:SetNormalFontObject("GameFontNormal")
ButtonColors(GDStartRoll)
GDStartRoll:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
local highlight = GDStartRoll:GetHighlightTexture()
highlight:SetBlendMode("ADD")
highlight:SetAllPoints()

GDStartRoll:SetScript("OnEnter", function(self)
    highlight:Show()
end)

GDStartRoll:SetScript("OnLeave", function(self)
    highlight:Hide()
end)
GDStartRoll:SetScript("OnClick", function()
self:GDRolls()
GDStartRoll:SetText("Whos Left?")
end)
-- Right Side Controls 
local GDEnter = CreateFrame("Button", nil, MainMenu, "BackdropTemplate")
GDEnter:SetSize(105, 30)
GDEnter:SetPoint("TOPLEFT", GDGameMode, "BOTTOMLEFT", -0, -25)
GDEnter:SetText("Join Game")
GDEnter:SetNormalFontObject("GameFontNormal")
ButtonColors(GDEnter)
GDEnter:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
local highlight = GDEnter:GetHighlightTexture()
highlight:SetBlendMode("ADD")
highlight:SetAllPoints()

GDEnter:SetScript("OnEnter", function(self)
    highlight:Show()
end)

GDEnter:SetScript("OnLeave", function(self)
    highlight:Hide()
end)
GDEnter:SetScript("OnClick", function()
	if (GDEnter:GetText() == "Join Game") then
         SendChatMessage("1" , self.game.chatMethod)
        GDEnter:SetText("Leave Game")
    elseif (GDEnter:GetText() == "Leave Game") then
		SendChatMessage("-1" , self.game.chatMethod)
        GDEnter:SetText("Join Game")
    end
end)

local GDRollMe = CreateFrame("Button", nil, MainMenu, "BackdropTemplate")
GDRollMe:SetSize(105, 30)
GDRollMe:SetPoint("TOPLEFT", GDEnter, "BOTTOMLEFT", -0, -3)
GDRollMe:SetText("Roll Me")
GDRollMe:SetNormalFontObject("GameFontNormal")
ButtonColors(GDRollMe)
GDRollMe:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
local highlight = GDRollMe:GetHighlightTexture()
highlight:SetBlendMode("ADD")
highlight:SetAllPoints()

GDRollMe:SetScript("OnEnter", function(self)
    highlight:Show()
end)

GDRollMe:SetScript("OnLeave", function(self)
    highlight:Hide()
end)
GDRollMe:SetScript("OnClick", function()
  rollMe()
end)

local GDCloseGame = CreateFrame("Button", nil, MainMenu, "BackdropTemplate")
GDCloseGame:SetSize(105, 30)
GDCloseGame:SetPoint("TOPLEFT", GDRollMe, "BOTTOMLEFT", -0, -3)
GDCloseGame:SetText("Close")
GDCloseGame:SetNormalFontObject("GameFontNormal")
ButtonColors(GDCloseGame)
GDCloseGame:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
local highlight = GDCloseGame:GetHighlightTexture()
highlight:SetBlendMode("ADD")
highlight:SetAllPoints()

GDCloseGame:SetScript("OnEnter", function(self)
    highlight:Show()
end)

GDCloseGame:SetScript("OnLeave", function(self)
    highlight:Hide()
end)
GDCloseGame:SetScript("OnClick", function()
  GambaDenUI:Hide()
end)

-- Options Menu Buttons

-- Left Options
local GDFullStats = CreateFrame("Button", nil, OptionsButton, "BackdropTemplate")
GDFullStats:SetSize(105, 30)
GDFullStats:SetPoint("TOPLEFT", MainHeader, "BOTTOMLEFT", 5, -2)
GDFullStats:SetText("Full Stats")
GDFullStats:SetNormalFontObject("GameFontNormal")
ButtonColors(GDFullStats)
GDFullStats:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
local highlight = GDFullStats:GetHighlightTexture()
highlight:SetBlendMode("ADD")
highlight:SetAllPoints()

GDFullStats:SetScript("OnEnter", function(self)
    highlight:Show()
end)

GDFullStats:SetScript("OnLeave", function(self)
    highlight:Hide()
end)
GDFullStats:SetScript("OnClick", function(full)
  self:reportStats(full)
end)

local GDGuildCut = CreateFrame("Button", nil, OptionsButton, "BackdropTemplate")
GDGuildCut:SetSize(105, 30)
GDGuildCut:SetPoint("TOPLEFT", GDFullStats, "BOTTOMLEFT", -0, -3)
GDGuildCut:SetText("Guild Cut(OFF)")
GDGuildCut:SetNormalFontObject("GameFontNormal")
ButtonColors(GDGuildCut)
GDGuildCut:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
local highlight = GDGuildCut:GetHighlightTexture()
highlight:SetBlendMode("ADD")
highlight:SetAllPoints()

GDGuildCut:SetScript("OnEnter", function(self)
    highlight:Show()
end)

GDGuildCut:SetScript("OnLeave", function(self)
    highlight:Hide()
end)
GDGuildCut:SetScript("OnClick", function()
  if (self.game.house == true) then
		self.game.house = false
		GDGuildCut:SetText("Guild Cut (OFF)");
		DEFAULT_CHAT_FRAME:AddMessage("Guild cut has been turned off.")
	else
		self.game.house = true
		GDGuildCut:SetText("Guild Cut (ON)");
		DEFAULT_CHAT_FRAME:AddMessage("Guild cut has been turned on.")
	end
end)

local GDReset = CreateFrame("Button", nil, OptionsButton, "BackdropTemplate")
GDReset:SetSize(105, 30)
GDReset:SetPoint("TOPLEFT", GDGuildCut, "BOTTOMLEFT", -0, -3)
GDReset:SetText("Reset Stats!")
GDReset:SetNormalFontObject("GameFontNormal")
ButtonColors(GDReset)
GDReset:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
local highlight = GDReset:GetHighlightTexture()
highlight:SetBlendMode("ADD")
highlight:SetAllPoints()

GDReset:SetScript("OnEnter", function(self)
    highlight:Show()
end)

GDReset:SetScript("OnLeave", function(self)
    highlight:Hide()
end)
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
	DEFAULT_CHAT_FRAME:AddMessage("ALL STATS RESET!")
end)

-- Create a button to toggle the realm filter
local GDRealmFilter = CreateFrame("Button", "GDRealmFilter", OptionsButton, "BackdropTemplate")
GDRealmFilter:SetPoint("TOPLEFT", GDReset, "BOTTOMLEFT", -0, -3)
GDRealmFilter:SetSize(105, 30)
ButtonColors(GDRealmFilter)
GDRealmFilter:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
local highlight = GDRealmFilter:GetHighlightTexture()
highlight:SetBlendMode("ADD")
highlight:SetAllPoints()

GDRealmFilter:SetScript("OnEnter", function(self)
    highlight:Show()
end)

GDRealmFilter:SetScript("OnLeave", function(self)
    highlight:Hide()
end)
GDRealmFilter:SetText("Realm Filter(OFF)")
GDRealmFilter:SetNormalFontObject("GameFontNormal")
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
local GDFameShame = CreateFrame("Button", nil, OptionsButton, "BackdropTemplate")
GDFameShame:SetSize(105, 30)
GDFameShame:SetPoint("TOPRIGHT", MainHeader, "BOTTOMRIGHT", -4, -2)
GDFameShame:SetText("Fame/Shame")
GDFameShame:SetNormalFontObject("GameFontNormal")
ButtonColors(GDFameShame)
GDFameShame:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
local highlight = GDFameShame:GetHighlightTexture()
highlight:SetBlendMode("ADD")
highlight:SetAllPoints()

GDFameShame:SetScript("OnEnter", function(self)
    highlight:Show()
end)

GDFameShame:SetScript("OnLeave", function(self)
    highlight:Hide()
end)
GDFameShame:SetScript("OnClick", function()
  self:reportStats()
end)

local GDClassic = CreateFrame("Button", nil, OptionsButton, "BackdropTemplate")
GDClassic:SetSize(105, 30)
GDClassic:SetPoint("TOPRIGHT", GDFameShame, "BOTTOMRIGHT", -0, -36)
GDClassic:SetText("Classic Theme")
GDClassic:SetNormalFontObject("GameFontNormal")
ButtonColors(GDClassic)
GDClassic:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
local highlight = GDClassic:GetHighlightTexture()
highlight:SetBlendMode("ADD")
highlight:SetAllPoints()

GDClassic:SetScript("OnEnter", function(self)
    highlight:Show()
end)

GDClassic:SetScript("OnLeave", function(self)
    highlight:Hide()
end)
GDClassic:SetScript("OnClick", function()
  self.db.global.theme = "Classic"
	  ReloadUI()
end)

local ChangeColorButton = CreateFrame("Button", nil, OptionsButton, "BackdropTemplate")
ChangeColorButton:SetSize(57.5, 30)
ChangeColorButton:SetPoint("BOTTOMLEFT", MainFooter, "BOTTOMLEFT", 0, 15)
ChangeColorButton:SetText("Button\nColor")
ChangeColorButton:SetNormalFontObject("GameFontNormal")
ButtonColors(ChangeColorButton)
ChangeColorButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
local highlight = ChangeColorButton:GetHighlightTexture()
highlight:SetBlendMode("ADD")
highlight:SetAllPoints()

ChangeColorButton:SetScript("OnEnter", function(self)
    highlight:Show()
end)

ChangeColorButton:SetScript("OnLeave", function(self)
    highlight:Hide()
end)
ChangeColorButton:SetScript("OnMouseUp", function() changeColor("buttons") end)

local ChangeColorSide = CreateFrame("Button", nil, OptionsButton, "BackdropTemplate")
ChangeColorSide:SetSize(ChangeColorButton:GetSize()) --remove the height
ChangeColorSide:SetPoint("BOTTOMLEFT", ChangeColorButton, "BOTTOMRIGHT", 0, 0) -- change position
ChangeColorSide:SetText("Side\nColor")
ChangeColorSide:SetNormalFontObject("GameFontNormal")
ButtonColors(ChangeColorSide)
ChangeColorSide:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
local highlight = ChangeColorSide:GetHighlightTexture()
highlight:SetBlendMode("ADD")
highlight:SetAllPoints()

ChangeColorSide:SetScript("OnEnter", function(self)
    highlight:Show()
end)

ChangeColorSide:SetScript("OnLeave", function(self)
    highlight:Hide()
end)
ChangeColorSide:SetScript("OnMouseUp", function() changeColor("sidecolor") end)

local ChangeColorFrame = CreateFrame("Button", nil, OptionsButton, "BackdropTemplate")
ChangeColorFrame:SetSize(ChangeColorButton:GetSize()) --remove the height
ChangeColorFrame:SetPoint("BOTTOMLEFT", ChangeColorSide, "BOTTOMRIGHT", 0, 0) -- change position
ChangeColorFrame:SetText("Frame\nColor")
ChangeColorFrame:SetNormalFontObject("GameFontNormal")
ButtonColors(ChangeColorFrame)
ChangeColorFrame:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
local highlight = ChangeColorFrame:GetHighlightTexture()
highlight:SetBlendMode("ADD")
highlight:SetAllPoints()

ChangeColorFrame:SetScript("OnEnter", function(self)
    highlight:Show()
end)

ChangeColorFrame:SetScript("OnLeave", function(self)
    highlight:Hide()
end)
ChangeColorFrame:SetScript("OnMouseUp", function() changeColor("frame") end)

local ChangeColorReset = CreateFrame("Button", nil, OptionsButton, "BackdropTemplate")
ChangeColorReset:SetSize(ChangeColorButton:GetSize()) --remove the height
ChangeColorReset:SetPoint("BOTTOMLEFT", ChangeColorFrame, "BOTTOMRIGHT", 0, 0) -- change position
ChangeColorReset:SetText("Reset\nColors")
ChangeColorReset:SetNormalFontObject("GameFontNormal")
ButtonColors(ChangeColorReset)
ChangeColorReset:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
local highlight = ChangeColorReset:GetHighlightTexture()
highlight:SetBlendMode("ADD")
highlight:SetAllPoints()

ChangeColorReset:SetScript("OnEnter", function(self)
    highlight:Show()
end)

ChangeColorReset:SetScript("OnLeave", function(self)
    highlight:Hide()
end)
ChangeColorReset:SetScript("OnMouseUp", function() changeColor("resetColors") end)


-- Right Side Menu
local GDRightMenu = CreateFrame("Frame", "GDRightMenu", GambaDenUI, "BackdropTemplate")
GDRightMenu:SetPoint("TOPLEFT", GambaDenUI, "TOPRIGHT", 0, 0)
GDRightMenu:SetSize(220, 150)
SideColor(GDRightMenu)
GDRightMenu:Hide()

local function onUpdate(self,elapsed)
    local mainX, mainY = GambaDenUI:GetCenter()
    local leftX, leftY = GDRightMenu:GetCenter()
    local distance = math.sqrt((mainX - leftX)^2 + (mainY - leftY)^2)
    if distance < 220 then
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
GDRightMenu.TextField:SetFont("Fonts\\FRIZQT__.TTF", self.db.global.fontvalue, "")
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


-- Variables to store the color and font size settings

local function OnChatSubmit(GDChatBox)
    local message = GDChatBox:GetText()
    if message ~= "" and message ~= " " then
        local playerName = UnitName("player")

        -- Apply font color to the message
        local formattedMessage = string.format("[%s]|r: |cFF%02x%02x%02x%s", playerName, fontColor.r * 255, fontColor.g * 255, fontColor.b * 255, message)
		--print("Formatted Message: " .. formattedMessage)  -- Debug print


        -- Send the modified message with player info and formatting
        local messageWithPlayerInfo = string.format("%s:%s", playerNameColor .. playerName, formattedMessage)
        self:SendMsg("CHAT_MSG", messageWithPlayerInfo)

        -- Reset chat box
        GDChatBox:SetText("")
        GDChatBox:ClearFocus()
    end
end


local fontColorButton = CreateFrame("Button", nil, GDRightMenu, "BackdropTemplate")
fontColorButton:SetSize(220, 20) --remove the height
fontColorButton:SetPoint("BOTTOMLEFT", GDRightMenu, "BOTTOMLEFT", 0, -40) -- change position
fontColorButton:SetText("Font Color")
fontColorButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
local highlight = fontColorButton:GetHighlightTexture()
highlight:SetBlendMode("ADD")
highlight:SetAllPoints()

fontColorButton:SetScript("OnEnter", function(self)
    highlight:Show()
end)

fontColorButton:SetScript("OnLeave", function(self)
    highlight:Hide()
end)
fontColorButton:SetNormalFontObject("GameFontNormal")
ButtonColors(fontColorButton)
fontColorButton:SetScript("OnMouseUp", function() changeColor("fontcolor") end)

local fontSizeSlider = CreateFrame("Slider", nil, fontColorButton, "OptionsSliderTemplate")
fontSizeSlider:SetPoint("BOTTOMLEFT", 0, -20)
fontSizeSlider:SetSize(220, 20)
fontSizeSlider:SetMinMaxValues(1, 100)  -- Set the range from 1 to 100
fontSizeSlider:SetValueStep(1)
fontSizeSlider:SetObeyStepOnDrag(true)
-- Load the saved font size from self.db.global.fontvalue
fontSizeSlider:SetValue(self.db.global.fontvalue)
-- Set the slider orientation to horizontal
fontSizeSlider:SetOrientation("HORIZONTAL")
-- Set the slider's text to display the selected value
fontSizeSlider.Low:SetText("1")  
fontSizeSlider.High:SetText("100")  

-- Create a fontString to display the selected value
local sliderText = fontSizeSlider:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
sliderText:SetPoint("TOP", 0, -20)  
sliderText:SetText(self.db.global.fontvalue)  -- Set the initial text

-- Function to update font size and auto-save
local function UpdateFontSize(_, value)
    self.db.global.fontvalue = value
    sliderText:SetText(value)  -- Update the displayed value
    GDRightMenu.TextField:SetFont("Fonts\\FRIZQT__.TTF", self.db.global.fontvalue, "")  -- Update the chat font size
end

fontSizeSlider:SetScript("OnValueChanged", function(_, value)
    UpdateFontSize(_, value)
end)


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

local GDChatBox = CreateFrame("EditBox", nil, GDRightMenu, "BackdropTemplate")
GDChatBox:SetPoint("TOPLEFT", GDRightMenu, "BOTTOMLEFT", 0, -20)
GDChatBox:SetSize(GDRightMenu:GetWidth() - 0, -20)
ButtonColors(GDChatBox)
GDChatBox:SetFont("Fonts\\FRIZQT__.TTF", 11, "")
GDChatBox:SetAutoFocus(false)
GDChatBox:SetTextInsets(10, 10, 5, 5)
GDChatBox:SetMaxLetters(55)
GDChatBox:SetText("Type Here...")
GDChatBox:SetScript("OnEnterPressed", OnChatSubmit)
GDChatBox:SetScript("OnMouseDown", function(self)
    self:SetText("")
end)

local GDChatToggle = CreateFrame("Button", nil, MainHeader,  "BackdropTemplate")
GDChatToggle:SetSize(20, 21) 
GDChatToggle:SetPoint("TOPRIGHT", MainHeader, "TOPRIGHT", 0, 0)
GDChatToggle:SetFrameLevel(15)
GDChatToggle:SetText(">")
GDChatToggle:SetNormalFontObject("GameFontNormal")
ButtonColors(GDChatToggle)
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
    slider:SetMinMaxValues(100, 250)
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
local GDLeftMenu = CreateFrame("Frame", "GDLeftMenu", GambaDenUI, "BackdropTemplate")
GDLeftMenu:SetPoint("TOPLEFT", GambaDenUI, "TOPLEFT", -300, -20)
GDLeftMenu:SetSize(300, 180)
SideColor(GDLeftMenu)
GDLeftMenu:Show()

local function onUpdate(self,elapsed)
    local mainX, mainY = GambaDenUI:GetCenter()
    local leftX, leftY = GDLeftMenu:GetCenter()
    local distance = math.sqrt((mainX - leftX)^2 + (mainY - leftY)^2)
    if distance < 260 then
        GDLeftMenu:ClearAllPoints()
        GDLeftMenu:SetPoint("TOPLEFT", GambaDenUI, "TOPLEFT", -300, -20)
end
end

GDLeftMenu:SetScript("OnUpdate", onUpdate)
GDLeftMenu:SetMovable(true)
GDLeftMenu:EnableMouse(true)
GDLeftMenu:SetUserPlaced(true)
GDLeftMenu:SetClampedToScreen(true)
GDLeftMenu:Hide()

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

local GDLeftMenuHeader = CreateFrame("Button", nil, GDLeftMenu,  "BackdropTemplate")
GDLeftMenuHeader:SetSize(GDLeftMenu:GetSize(), 21) 
GDLeftMenuHeader:SetPoint("TOPLEFT", GDLeftMenu, "TOPLEFT", 0, 20)
GDLeftMenuHeader:SetFrameLevel(15)
GDLeftMenuHeader:SetText("Roll Tracker")
GDLeftMenuHeader:SetNormalFontObject("GameFontNormal")
ButtonColors(GDLeftMenuHeader)

local GDMenuToggle = CreateFrame("Button", nil, MainHeader,  "BackdropTemplate")
GDMenuToggle:SetSize(20, 21) 
GDMenuToggle:SetPoint("TOPLEFT", MainHeader, "TOPLEFT", 0, 0)
GDMenuToggle:SetFrameLevel(15)
GDMenuToggle:SetText("<")
GDMenuToggle:SetNormalFontObject("GameFontNormal")
ButtonColors(GDMenuToggle)
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
scrollFrame:SetPoint("TOPLEFT", 10, 10)

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

-- Create a new table to store the player buttons
playerButtons = {}

function UpdatePlayerList()
    -- Remove all current player buttons
    for i, button in ipairs(playerButtons) do
        button:Hide()
        button:SetParent(nil)
    end

    -- Sort the player names alphabetically
    table.sort(GDPlayers, function(a, b)
        return a.name < b.name
    end)

    local row = 0
    local column = 0

    -- Iterate through the sorted GDPlayers table and create a button for each player
    for i, player in ipairs(GDPlayers) do
        -- Create a button for each player
        local playerButton = CreateFrame("Button", "PlayerButton" .. i, playerButtonsFrame, "BackdropTemplate")
        playerButton:SetSize(250, 30)
        playerButton:SetPoint("TOPLEFT", 0, -row * 30)
        ButtonColors(playerButton)
		LoadColor()

        -- Create a font string for the button
        local buttonText = playerButton:CreateFontString(nil, "OVERLAY")
        buttonText:SetFont("Fonts\\FRIZQT__.TTF", 20)
        buttonText:SetPoint("LEFT", 5, 0)
        playerButton.text = buttonText

        -- Get the player's class color
        local classColor = RAID_CLASS_COLORS[select(2, UnitClass(player.name))]
        local playerNameColor = "|c" .. classColor.colorStr

        if player.roll ~= nil then
            buttonText:SetText(playerNameColor .. player.name .. "|r : |cFF000000" .. player.roll .. "|r")
        else
            buttonText:SetText(playerNameColor .. player.name .. "|r")
        end

        table.insert(playerButtons, playerButton)
        row = row + 1
    end

    -- Update the height of the scroll frame based on the number of players
    playerButtonsFrame:SetHeight(row * 30)
	

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