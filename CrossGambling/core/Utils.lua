Utils = {}
--- Takes the host name and check if they are able to do a raid warning
function Utils:IsAbleToRaidWarn()
    local name = UnitName("player")
    if(IsInRaid) then 
        local numRaidMembers = GetNumGroupMembers()
        for i = 1, numRaidMembers do
            local unit = "raid" .. i
            local raiderName,raiderRank = GetRaidRosterInfo(i)
            print(name .. "," .. raiderName .. "," .. raiderRank)
            if(name == raiderName and raiderRank > 0) then
                return true
            end
        end
    else
        return false
    end
end

--- Converts an int into a wow currency string
--- @arg int_Currency is a type checked integer which will be turned into a wow currency i.e. 1001 = 10g 1s
function Utils:IntToCurrencyString(int_Currency)
    local argtype = type(int_Currency)

    if(argtype ~= "number") then
        return int_Currency
    end

    local Silver = math.fmod(int_Currency,100)
    local Gold = (int_Currency - Silver) / 100

    local outvar = ""
    if(Gold > 0) then
        outvar = outvar .. Gold .. "g "
    end

    if(Silver > 0) then 
        outvar = outvar .. Silver .. "s"
    end

    return  outvar
end

--- Sends a gambling event message
--- @arg str_msg the message to send to chat
function Utils:SendMessage(str_msg, Chat_Method)
    SendChatMessage(str_msg, Chat_Method)
end

--- Sends a gambling event message with emphasis
--- @arg str_msg the message we want to raid alert or message
function Utils:SendAlert(str_msg, Chat_Method)
    if(Chat_Method == "RAID" and CrossGambling:IsAbleToRaidWarn()) then
        SendChatMessage(str_msg, "RAID_WARNING")
    else 
        SendChatMessage(str_msg, Chat_Method)
    end
end