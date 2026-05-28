local Player = game:GetService("Players").LocalPlayer

local Door = workspace:WaitForChild("StoneGate"):WaitForChild("Door")
local EpisodeGui = Player.PlayerGui:WaitForChild("EpisodeGui")

-- 发送请求解锁关卡EpisodeUI
local function UnlockEpisodeUI()
    local result = game.ReplicatedStorage.RemoteFunction.UnlockEpisodeUI:InvokeServer()
    if result then
        local EpisodeUIs = EpisodeGui.EpisodeFrame.TextButton.EpisodesFrame:GetChildren()
        for _, EpisodeUI in EpisodeUIs do
            if EpisodeUI:IsA("ImageButton") then
                local Eid = EpisodeUI.EpisodeID.Value

                if Eid <= result then
                    -- 解锁关卡
                    EpisodeUI.LockButton.Visible = false

                    -- 绑定事件，传送至对应关卡
                    EpisodeUI.Activated:Connect(function(Eid)
                        -- 发送请求传送玩家到对应关卡
                        local result = game.ReplicatedStorage.RemoteFunction.TeleportToEpisode:InvokeServer(Eid)
                        if result then
                            print("传送成功")
                        else
                            warn("传送失败")
                        end
                    end)
                end
            end
        end
    else
        warn("解锁关卡失败")
    end
end

-- 打开并显示章节选择界面 和 关闭界面按钮
Door.ProximityPrompt.Triggered:Connect(function()
    EpisodeGui.EpisodeFrame.Visible = true
    EpisodeGui.CloseButton.Visible = true
    UnlockEpisodeUI()
end)

-- 关闭 章节选择界面 和 关闭界面按钮
EpisodeGui.CloseButton.Activated:Connect(function()
    EpisodeGui.EpisodeFrame.Visible = false
    EpisodeGui.CloseButton.Visible = false
end)