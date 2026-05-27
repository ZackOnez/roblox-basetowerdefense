--[[
  游戏主要逻辑实现：玩家加入服务器和退出服务器时的处理逻辑
]]
local Players = game:GetService("Players")

local DataManager = require(game.ServerScriptService.Server.Modules.DataManager)
local TeleportManager = require(game.ServerScriptService.Server.Modules.TeleportManager)

-- 当前服务器内的活跃玩家数据
local activePlayers = {}

-- 玩家加入服务器时的处理逻辑
local function onPlayerAdded(player)
  -- 获取玩家数据
  local playerData = DataManager.loadPlayerData(player)
  if playerData then
    print("玩家 " .. player.Name .. " 的数据加载成功")

    print("Btd_" .. player.UserId,playerData)
    activePlayers["Btd_" .. player.UserId] = playerData
  else
    warn("无法加载 " .. player.Name .. " 的数据，踢出玩家")
    player:Kick("无法加载数据，请重新加入游戏")
  end
end

-- 玩家退出服务器时的处理逻辑
local function onPlayerRemoving(player)
  print("玩家正在退出服务器......")

  local playerData = activePlayers["Btd_" .. player.UserId]
  if playerData then
    local result = DataManager.savePlayerData(player,playerData)
    if result then
      print("玩家 " .. player.Name .. " 的数据保存成功")
      -- 将玩家从活跃用户数据中删除
      activePlayers["Btd_" .. player.UserId] = nil
    else
      warn("玩家 " .. player.Name .. " 的数据保存失败")
    end
  else
    warn("玩家 " .. player.Name .. " 的数据不存在")
  end
end

-- 监听玩家加入服务器
Players.PlayerAdded:Connect(onPlayerAdded)
-- 监听玩家离开服务器
Players.PlayerRemoving:Connect(onPlayerRemoving)
-- 监听服务器关闭，以防服务器意外关闭或重启时，玩家数据丢失
game:BindToClose(function()
  print("服务器正在关闭/重启......")
  print("正在保存所有玩家数据")

  for _,player in pairs(Players:GetPlayers()) do
    onPlayerRemoving(player)
  end

  print("服务器已关闭......")
end)

-- 友情提示：在成熟游戏中，要定时对玩家数据进行保存，而不要等到玩家退出服务器时才保存数据

-- 监听服务端解锁关卡请求
game.ReplicatedStorage.RemoteFunction.UnlockEpisodeUI.OnServerInvoke = function(player)
  return activePlayers["Btd_" .. player.UserId].Level
end

-- 监听玩家传送
game.ReplicatedStorage.RemoteFunction.TeleportToEpisode.OnServerInvoke = function(player,Eid)
  local Level = activePlayers["Btd_" .. player.UserId].Level
  if Level and Eid <= Level then
    return TeleportManager.teleportToEpisode(player,Eid)
  else
    warn("还未解锁该关卡！")
    return false
  end
end