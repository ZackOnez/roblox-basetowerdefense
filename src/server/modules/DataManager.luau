--[[
  * 专门用来处理玩家数据读取与写入数据库的相关操作 *
]]
local DataStoreService = game:GetService("DataStoreService")
local playerDataStore = DataStoreService:GetDataStore("PlayerData3")
local CoinsOrderedDataStore = DataStoreService:GetOrderedDataStore("CoinsDataStore")
--local PlaytimeOrderedDataStore = DataStoreService:GetOrderedDataStore("PlaytimeDataStore")
--local PassOrderedDataStore = DataStoreService:GetOrderedDataStore("PassDataStore")

local ords = {
  ["CoinsDataStore"] = CoinsOrderedDataStore,
  --["PlaytimeDataStore"] = PlaytimeOrderedDataStore,
  --["PassEpiDataStore"] = PassOrderedDataStore,
}

local DefaultUserData = require(game.ServerScriptService.Server.modules.DefaultUserData)
-- 玩家默认数据模板
local Template = DefaultUserData.Template

local DataManager = {}

-- 新玩家初始化各排行榜
local function initLeaderboardData(player,dsName)
  local OrderedDataStore = ords[dsName]
  local success,errorMessage = pcall(function()
    OrderedDataStore:SetAsync(player.UserId,0)
  end)

  if success then
    return true
  else
    warn("无法初始化排行榜数据：" .. errorMessage)
    return false
  end
end

-- 获取玩家数据
function DataManager.loadPlayerData(player)
  -- 创建一个独一无二的玩家ID
  local playerkey = "Btd_" .. player.UserId
  local playerData = Template

  local success,errorMessage = pcall(function()
    local cloudData = playerDataStore:GetAsync(playerkey)
    if cloudData then
      -- 老玩家：使用旧数
      playerData = cloudData
      -- 设置玩家身份为：2（老玩家）
      playerData.PlayerIdentity = 2
      -- ===测试用===
      if player.UserId == 10044172975 then
        playerData.Level = 4
      end
      -- ===测试用===
    else
      -- 新玩家：需要初始化各排行榜数据
      initLeaderboardData(player, "CoinsDataStore")
      -- initLeaderboardData(player, "PlaytimeDataStore")
      -- initLeaderboardData(player, "PassEpiDataStore")
    end
  end)

  if success then
    return playerData
  else
    warn("无法加载数据：" .. errorMessage)
    return nil
  end
end

-- 存储玩家数据
function DataManager.savePlayerData(player,playerData)
  local playerKey = "Btd_" .. player.UserId

  local success,errorMessage = pcall(function()
    playerDataStore:SetAsync(playerKey,playerData)
  end)

  if success then
    return true
  else
    warn("无法保存数据：" .. errorMessage)
    -- TODO: 友情提示：在成熟游戏中，通常会加一个重试机制（Retry logic），比如：等待1秒后重试（3次），如果重试都失败，则放弃保存数据
    return false
  end
end

-- 分页查找 指定数据库 指定长度 数据
function DataManager.loadPageData(dsName,pageSize)
  local OrderedDataStore = ords[dsName]
  local CurrentPageData = nil
  local success,errorMessage = pcall(function()
    CurrentPageData = OrderedDataStore:GetSortedAsync(false,pageSize):GetCurrentPage()
  end)
  
  if success then
    return CurrentPageData
  else
    warn("无法加载数据：" .. errorMessage)
    return false
  end
end

return DataManager
