--[[
  * 专门用来处理玩家数据读取与写入数据库的相关操作 *
]]
local DataStoreService = game:GetService("DataStoreService")

local DefaultUserData = require(game.ServerScriptService.Server.Modules.DefaultUserData)
-- 玩家默认数据模板
local Template = DefaultUserData.Template

local DataManager = {}

local playerDataStore = DataStoreService:GetDataStore("PlayerData")

-- 获取玩家数据
function DataManager.loadPlayerData(player)
  -- 创建一个独一无二的玩家ID
  local playerkey = "Btd_" .. player.UserId
  local playerData = Template

  local success,errorMessage = pcall(function()
    local cloudData = playerDataStore:GetAsync(playerkey)
    if cloudData then
      playerData = cloudData
      -- 设置玩家身份为：2（老玩家）
      playerData.PlayerIdentity = 2
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
    -- 友情提示：在成熟游戏中，通常会加一个重试机制（Retry logic），比如：等待1秒后重试（3次），如果重试都失败，则放弃保存数据
    return false
  end
end

return DataManager