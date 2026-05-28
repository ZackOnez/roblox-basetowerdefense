--[[
  * 关于场景传送的各项功能 *
]]
local TeleportService = game:GetService("TeleportService")

local EpisodeList = {
  [0] = 124537114196627, -- 大厅
  [1] = 102926290631344, -- 第一关
  [2] = 74139605429457, -- 第二关
  [3] = 136104283681957, -- 第三关
  [4] = 116608081476637 -- 第四关
}

local TeleportManager = {}

-- 传送玩家到指定关卡
TeleportManager.teleportToEpisode = function(player,Eid)
  -- 避免重复触发传送
  if player:GetAttribute("Teleporting") then return end
  player:SetAttribute("Teleporting", true)

  local success, errorMessage = pcall(function()
    local teleportPlayerID = EpisodeList[Eid]
    TeleportService:TeleportAsync(teleportPlayerID, {player})
  end)

  if not success then
    warn("传送失败：" .. errorMessage)
    player:SetAttribute("Teleporting", false) -- 传送失败，允许重试
  end
end

return TeleportManager