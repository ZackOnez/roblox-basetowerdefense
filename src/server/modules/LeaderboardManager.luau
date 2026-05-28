local DataManager = require(game.ServerScriptService.Server.modules.DataManager)
local Players = game:GetService("Players")

-- 各排行榜模型
local Leaderboards = workspace:WaitForChild("LeaderBoards")
local CoinsLeaderboardModel = Leaderboards:WaitForChild("CoinsLeaderboard")
--local TimeLeaderboardModel = Leaderboards:WaitForChild("TimesLeaderboard")
--local PassLeaderboardModel = Leaderboards:WaitForChild("PassLeaderboard")

-- 排行榜模板项
local itemTemplate = Leaderboards:WaitForChild("ItemTemplate")

-- 刷新时间间隔
local RefreshRate = 60
-- 排行榜单长度（前n名）
local pageSize = 100

local LeaderboardManager = {}

-- -- 更新第一名人物模型函数
local function UpdateTop1Player(LeaderboardModel,playerId,Username)
  -- 获取场景中的家人模型
  local dummy = LeaderboardModel:WaitForChild("Top1Player")
  local humanoid = dummy:WaitForChild("Humanoid")

  local success,errorMessage = pcall(function(...)
    local description = Players:GetHumanoidDescriptionFromUserIdAsync(playerId)
    humanoid:ApplyDescriptionAsync(description)
    humanoid.DisplayName = Username
  end)

  if success then
    print("排名第一名模型更新成功！")
  else
    warn("无法获取玩家外观数据，错误信息：", errorMessage)
  end
end

  -- 销毁排行榜旧数据
local function DestroyLeaderboard(LeaderboardModel)
  for _,Frame in pairs(LeaderboardModel.Board.SurfaceGui.ItemContainer:WaitForChild("ScrollingFrame"):GetChildren()) do
    if Frame.Name ~= "Item" and Frame:IsA("Frame") then
      Frame:Destroy()
    end
  end
end

-- 处理排行榜操作
local function LeaderboardHandle(dsName,LeaderboardModel)
  print("开始刷新排行榜！")

  -- 请求获取新数据并设置
  local RollsPage = DataManager.loadPageData(dsName,pageSize)
  if RollsPage then
    -- 销毁旧数据
    DestroyLeaderboard(LeaderboardModel)
    -- 设置新数据
    for Rank,SaveData in ipairs(RollsPage) do
      local UserId = tonumber(SaveData.key)
      local lbValue = SaveData.value

      if lbValue >= 0 then
        local Username = Players:GetNameFromUserIdAsync(UserId)

        local NewSample = itemTemplate:Clone()
        
        NewSample.Name = Username
        NewSample.RankText.Text = "#" .. Rank
        NewSample.NameText.Text = Username
        NewSample.LbValueText.Text = lbValue
        NewSample.Parent = LeaderboardModel.Board.SurfaceGui.ItemContainer:WaitForChild("ScrollingFrame")
      
        -- 给前三名设置不一样的背景色
        if Rank == 1 then
          NewSample.BackgroundColor3 = Color3.fromRGB(255, 213, 0)
          -- 更新第一名人物模型
          UpdateTop1Player(LeaderboardModel,UserId,Username)
        elseif Rank == 2 then
          NewSample.BackgroundColor3 = Color3.fromRGB(192, 192, 192)
        elseif Rank == 3 then
          NewSample.BackgroundColor3 = Color3.fromRGB(205, 127, 50)
        else
          NewSample.BackgroundColor3 = Color3.fromRGB(216, 216, 216)
        end
      end
    end
  end

  print("排行榜已刷新！")
end

-- 刷新金币排行榜
function LeaderboardManager.refreshCoinsLeaderboard()
  while true do
    LeaderboardHandle("CoinsDataStore",CoinsLeaderboardModel)
    -- 排行榜每60秒刷新一次
    task.wait(RefreshRate)
  end
end

-- 刷新游玩时长排行榜
function LeaderboardManager.refreshPlaytimeLeaderboard()
  -- TODO: 
  -- 具体实现同上，自行完成
end

-- 刷新通关关卡排行榜
function LeaderboardManager.refreshPassEpisodeLeaderboard()
  -- TODO: 
  -- 具体实现同上，自行完成
end

return LeaderboardManager