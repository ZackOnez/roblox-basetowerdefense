local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local DataManager = require(game.ServerScriptService.Server.Modules.DataManager)

local LeaderboardManager = {}

-- 刷新排行榜数据
function LeaderboardManager.refreshLeaderboard()
  while true do
    
  end

  -- 排行榜每60秒刷新一次
  task.wait(60)
end

return LeaderboardManager