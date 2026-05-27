local Player = game:GetService("Players").LocalPlayer

local Door = workspace:WaitForChild("StoneGate"):WaitForChild("Door")
local EpisodeGui = Player.PlayerGui:WaitForChild("EpisodeGui")

-- 打开并显示章节选择界面 和 关闭界面按钮
Door.ProximityPrompt.Triggered:Connect(function()
    EpisodeGui.EpisodeFrame.Visible = true
    EpisodeGui.CloseButton.Visible = true
end)

-- 关闭 章节选择界面 和 关闭界面按钮
EpisodeGui.CloseButton.Activated:Connect(function()
    EpisodeGui.EpisodeFrame.Visible = false
    EpisodeGui.CloseButton.Visible = false
end)
