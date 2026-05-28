--[[
  * 玩家基本数据信息UI处理 *
]]
local Player = game:GetService("Players").LocalPlayer

-- UI对象
local InfoGui = Player.PlayerGui:WaitForChild("InfoGui")
local InfoFrame = InfoGui:WaitForChild("InfoFrame")
local CoinsValue = InfoFrame:WaitForChild("Coins").CoinsValue
local PassValue = InfoFrame:WaitForChild("PassEpi").PassValue
local PlaytimeValue = InfoFrame:WaitForChild("Playtime").PlaytimeValue
-- 数据
local leaderstats = Player:WaitForChild("leaderstats")
local Coins = leaderstats:WaitForChild("Coins")
local Level = leaderstats:WaitForChild("Level")
local Playtime = leaderstats:WaitForChild("Playtime")

-- 1、设置金币UI的值
CoinsValue.Text = Coins.Value
-- 2、设置通过关卡UI的值
PassValue.Text = Level.Value
-- 3、设置游玩时间UI的值
-- 格式化游玩时间
local hours = math.floor(Playtime.Value / 3600)
local minutes = math.floor((Playtime.Value % 3600) / 60)
local seconds = Playtime.Value % 60
PlaytimeValue.Text = string.format("%02d:%02d:%02d", hours, minutes, seconds)
