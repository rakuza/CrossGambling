function GambaDen:DrawSecondEvents()

function add_commas(value) 
return #tostring(value) > 3 and tostring(value):gsub("^(-?%d+)(%d%d%d)", "%1,%2"):gsub("(%d)(%d%d%d)", ",%1,%2") or tostring(value) 
end


GDCall["New_Game"] = function()
    -- Starts a new game
    if (self.game.state == "START" and self.game.host == true) then
        -- Start listening to chat messages
        self:RegisterChatEvents()

        -- Change the game state to REGISTRATION
        self.game.state = "REGISTER"
        self:GameStart()
		
		local MessageBuilder = "Maximum Wager - " .. Utils:IntToCurrencyString(self.db.global.wager)
		
		if(self.game.chatframeOption == true) then 
			MessageBuilder = "Game Mode - " .. self.game.mode .. " - " .. MessageBuilder
		end
		
		if (self.game.house == true) then
			MessageBuilder = MessageBuilder .. " - House Cut - " .. self.db.global.houseCut .. "%"
		end
		
		if(self.game.chatframeOption == false and self.game.host == true) then 
			self:SendMsg(format("CHAT_MSG:%s:%s:%s", self.game.PlayerName, self.game.PlayerClass, MessageBuilder))
		else 
			Utils:SendAlert(MessageBuilder, self.game.chatMethod )
		end 
		
        -- Disable Button for clients.
        self:SendMsg("DisableClient")
    end
end

-- Triggers Add Function for all clients.
GDCall["ADD_PLAYER"] = function(playerName)
	GambaDen:AddPlayer(playerName)
	self:registerPlayer(playerName)
end
-- Triggers Remove Function for all clients.
GDCall["Remove_Player"] = function(playerName)
	GambaDen:RemovePlayer(playerName)
	self:unregisterPlayer(playerName)
end
-- Sets the roll for all clients.
GDCall["SET_WAGER"] = function(value)
	self.db.global.wager = tonumber(value)
end 
-- Sets the game mode for all clients.
GDCall["GAME_MODE"] = function(value)
	self.game.mode = tostring(value)
end
GDCall["SET_HOUSE"] = function(value)
	self.db.global.houseCut = tostring(value)
end
-- Sets everyone to proper chatMethod for all clients.
GDCall["Chat_Method"] = function(value)
	self.game.chatMethod = tostring(value)
end
-- Lets the players know what the roll amount is.
GDCall["START_ROLLS"] = function(maxAmount)
	self:SendMsg("Disable_Join")
	if (self.game.mode == "BigTwo") then
		self.db.global.wager = 2
	elseif (self.game.mode == "501") then
		self.db.global.wager = 501
	else
		self.db.global.wager = self.db.global.wager
	end
	function rollMe(maxAmount, minAmount)
			if (minAmount == nil) then
				minAmount = 1
			end
    RandomRoll(minAmount, self.db.global.wager)
	end
	if(self.game.host == true) then
		local RollNotification = "Press Roll Me!"
	if(self.game.chatframeOption == false and self.game.host == true) then	
		self:SendMsg(format("CHAT_MSG:%s:%s:%s", self.game.PlayerName, self.game.PlayerClass, RollNotification))
	else
		Utils:SendAlert("Entries have closed. Roll now!", self.game.chatMethod)
		SendChatMessage(format("Type /roll %s", self.db.global.wager), self.game.chatMethod)
    end
  end
end

GDCall["LastCall"] = function()
	if(self.game.chatframeOption == false and self.game.host == true) then
		local RollNotification = "Last Call!"
		self:SendMsg(format("CHAT_MSG:%s:%s:%s", self.game.PlayerName, self.game.PlayerClass, RollNotification))
    elseif(self.game.host == true) then 
		Utils:SendAlert("Last Call to Enter", self.game.chatMethod)
	end
end



end

C_ChatInfo.RegisterAddonMessagePrefix("GambaDen")