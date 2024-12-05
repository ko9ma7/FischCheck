local selectItems = {
    "Enchant Relic",
    "Lunar Thread"
}

local highlightItems = {
    "Aurora Totem",
    "Treasure Map"
}

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer

player.CameraMaxZoomDistance = 1000

local webhookURL = "https://discordapp.com/api/webhooks/1314086370985246720/syawg53o8nPNKXaZRsuw6JTXPSLjxaSUKthexnvzaaBb8Ou9WuFyuCWyL5tDuaudWUlN"

local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request)

local function cleanItemName(rawName)
    return rawName:match("^(.-)%d*$") or rawName
end

local function countItemsInInventory(player)
    local inventory = ReplicatedStorage:FindFirstChild("playerstats")
        :FindFirstChild(player.Name)
        :FindFirstChild("Inventory")
    
    if not inventory then
        warn("Inventory not found for player :", player.Name)
        return {}
    end

    local itemCounts = {}
    for _, item in ipairs(inventory:GetChildren()) do
        if item:IsA("StringValue") and item:FindFirstChild("Stack") and item.Stack:IsA("NumberValue") then
            local cleanName = cleanItemName(item.Name)
            local stackValue = item.Stack.Value
            
            if itemCounts[cleanName] then
                itemCounts[cleanName] += stackValue
            else
                itemCounts[cleanName] = stackValue
            end
        else
            warn("Item or Stack invalid :", item.Name)
        end
    end

    return itemCounts
end

local function formatNumberWithCommas(num)
    local numStr = tostring(num)
    return numStr:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local itemCounts = countItemsInInventory(player)

local playerStats = ReplicatedStorage:FindFirstChild("playerstats")
local coins = playerStats and playerStats:FindFirstChild(player.Name) and playerStats[player.Name]:FindFirstChild("Stats") and playerStats[player.Name].Stats:FindFirstChild("coins")
local coinValue = coins and coins.Value or 0

local levels = playerStats and playerStats:FindFirstChild(player.Name) and playerStats[player.Name]:FindFirstChild("Stats") and playerStats[player.Name].Stats:FindFirstChild("level")
local levelValue = levels and levels.Value or 0

local rod = playerStats and playerStats:FindFirstChild(player.Name) and playerStats[player.Name]:FindFirstChild("Stats") and playerStats[player.Name].Stats:FindFirstChild("rod")
local rodValue = rod and rod.Value or 0

local streak = playerStats and playerStats:FindFirstChild(player.Name) and playerStats[player.Name]:FindFirstChild("Stats") and playerStats[player.Name].Stats:FindFirstChild("tracker_streak")
local streakValue = streak and streak.Value or 0

local perfect = playerStats and playerStats:FindFirstChild(player.Name) and playerStats[player.Name]:FindFirstChild("Stats") and playerStats[player.Name].Stats:FindFirstChild("tracker_perfectcatches")
local perfectValue = perfect and perfect.Value or 0

local fishcaught = playerStats and playerStats:FindFirstChild(player.Name) and playerStats[player.Name]:FindFirstChild("Stats") and playerStats[player.Name].Stats:FindFirstChild("tracker_fishcaught")
local fishcaughtValue = fishcaught and fishcaught.Value or 0

local crabcagesopened = playerStats and playerStats:FindFirstChild(player.Name) and playerStats[player.Name]:FindFirstChild("Stats") and playerStats[player.Name].Stats:FindFirstChild("tracker_crabcagesopened")
local crabcagesopenedValue = crabcagesopened and crabcagesopened.Value or 0

local playerexp = playerStats and playerStats:FindFirstChild(player.Name) and playerStats[player.Name]:FindFirstChild("Stats") and playerStats[player.Name].Stats:FindFirstChild("xp")
local playerexpValue = playerexp and playerexp.Value or 0

local spawnlocation = playerStats and playerStats:FindFirstChild(player.Name) and playerStats[player.Name]:FindFirstChild("Stats") and playerStats[player.Name].Stats:FindFirstChild("spawnlocation")
local spawnlocationValue = spawnlocation and spawnlocation.Value or 0

local formattedCoinValue = formatNumberWithCommas(coinValue)
local formattedLevelValue = formatNumberWithCommas(levelValue)
local formattedRodValue = formatNumberWithCommas(rodValue)
local formattedStreakValue = formatNumberWithCommas(streakValue)
local formattedPerfectValue = formatNumberWithCommas(perfectValue)
local formattedFishcaughtValue = formatNumberWithCommas(fishcaughtValue)
local formattedCrabCagesValue = formatNumberWithCommas(crabcagesopenedValue)
local formattedExpValue = formatNumberWithCommas(playerexpValue)
local setspawnlocationValue = formatNumberWithCommas(spawnlocationValue)

local function highlightItemName(itemName)
    if table.find(highlightItems, itemName) then
        return "- " .. itemName .. ""
    else
        return itemName
    end
end

local moreItemsText1 = ""
local moreItemsText2 = ""

local itemCount = 0
for itemName, count in pairs(itemCounts) do
    if not table.find(selectItems, itemName) then
        itemCount = itemCount + 1
        local highlightedItemName = highlightItemName(itemName)
        if itemCount <= 40 then
            moreItemsText1 = moreItemsText1 .. highlightedItemName .. " : " .. formatNumberWithCommas(count) .. "\n"
        else
            moreItemsText2 = moreItemsText2 .. highlightedItemName .. " : " .. formatNumberWithCommas(count) .. "\n"
        end
    end
end

local mainFields = {}
table.insert(mainFields, {
    name = "Rod",
    value = formattedRodValue,
    inline = false
})

table.insert(mainFields, {
    name = "Levels",
    value = formattedLevelValue,
    inline = false
})

table.insert(mainFields, {
    name = "Exps",
    value = formattedExpValue,
    inline = false
})

table.insert(mainFields, {
    name = "Spawn location",
    value = setspawnlocationValue,
    inline = false
})

table.insert(mainFields, {
    name = "Fish Caught",
    value = formattedFishcaughtValue,
    inline = false
})

table.insert(mainFields, {
    name = "Perfect Catches",
    value = formattedPerfectValue,
    inline = false
})

table.insert(mainFields, {
    name = "Catch Streaks",
    value = formattedStreakValue,
    inline = false
})

table.insert(mainFields, {
    name = "Crab Cages Opened",
    value = formattedCrabCagesValue,
    inline = false
})

table.insert(mainFields, {
    name = "Coins",
    value = formattedCoinValue .. " C$",
    inline = false
})

table.insert(mainFields, {
    name = "------------------------------------------",
    value = "",
    inline = false
})

for _, itemName in ipairs(selectItems) do
    local count = itemCounts[itemName] or 0
    local formattedCashCount = formatNumberWithCommas(count)
    table.insert(mainFields, {
        name = itemName,
        value = "Count : " .. formattedCashCount,
        inline = false
    })
end

local playerInfoField = {
    name = "Player Name",
    value = player.Name .. " (" .. player.DisplayName .. ")",
    inline = false
}

local payload = {
    content = "",
    embeds = {
        {
            title = "[** PHE BOT **]",
            type = "rich",
            description = "Made by Phoomphat",
            color = tonumber(0x808080),
            fields = {
                playerInfoField,
                unpack(mainFields)
            },
        },
        {
            title = "[** More Items 1 **]",
            type = "rich",
            description = "Made by Phoomphat",
            color = tonumber(0x808080),
            fields = {
                {
                    name = "------------------------------------------",
                    value = moreItemsText1 ~= "" and moreItemsText1 or "No additional items.",
                    inline = false
                }
            }
        },
        {
            title = "[** More Items 2 **]",
            type = "rich",
            description = "Made by Phoomphat",
            color = tonumber(0x808080),
            fields = {
                {
                    name = "------------------------------------------",
                    value = moreItemsText2 ~= "" and moreItemsText2 or "No additional items.",
                    inline = false
                }
            }
        }
    }
}

print("Payload being sent :")
print(HttpService:JSONEncode(payload))

local response = httpRequest({
    Url = webhookURL,
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = HttpService:JSONEncode(payload)
})

if response and response.Success then
    print("Webhook sent successfully!")
else
    warn("Failed to send webhook.")
    if response then
        print("Status Code :", response.StatusCode)
        print("Response :", response.Body)
    else
        print("Response is nil.")
    end
end