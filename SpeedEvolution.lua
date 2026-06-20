local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Teleport Control"
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.FontSize = Enum.FontSize.Size14
titleLabel.TextScaled = true
titleLabel.Parent = titleBar

local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end
end)

local world1Label = Instance.new("TextLabel")
world1Label.Text = "World 1"
world1Label.Size = UDim2.new(0, 180, 0, 25)
world1Label.Position = UDim2.new(0, 10, 0, 40)
world1Label.BackgroundTransparency = 1
world1Label.TextColor3 = Color3.fromRGB(255, 255, 255)
world1Label.FontSize = Enum.FontSize.Size12
world1Label.TextScaled = true
world1Label.Parent = frame

local world1Separator = Instance.new("Frame")
world1Separator.Size = UDim2.new(0, 180, 0, 2)
world1Separator.Position = UDim2.new(0, 10, 0, 65)
world1Separator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
world1Separator.BorderSizePixel = 0
world1Separator.Parent = frame

local world1Toggle = Instance.new("TextButton")
world1Toggle.Text = "Teleport TO"
world1Toggle.Size = UDim2.new(0, 180, 0, 30)
world1Toggle.Position = UDim2.new(0, 10, 0, 70)
world1Toggle.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
world1Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
world1Toggle.BorderSizePixel = 0
world1Toggle.Parent = frame

local world2Label = Instance.new("TextLabel")
world2Label.Text = "World 2"
world2Label.Size = UDim2.new(0, 180, 0, 25)
world2Label.Position = UDim2.new(0, 10, 0, 105)
world2Label.BackgroundTransparency = 1
world2Label.TextColor3 = Color3.fromRGB(255, 255, 255)
world2Label.FontSize = Enum.FontSize.Size12
world2Label.TextScaled = true
world2Label.Parent = frame

local world2Separator = Instance.new("Frame")
world2Separator.Size = UDim2.new(0, 180, 0, 2)
world2Separator.Position = UDim2.new(0, 10, 0, 130)
world2Separator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
world2Separator.BorderSizePixel = 0
world2Separator.Parent = frame

local world2Toggle = Instance.new("TextButton")
world2Toggle.Text = "Teleport TO"
world2Toggle.Size = UDim2.new(0, 180, 0, 30)
world2Toggle.Position = UDim2.new(0, 10, 0, 135)
world2Toggle.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
world2Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
world2Toggle.BorderSizePixel = 0
world2Toggle.Parent = frame

local pos1 = Vector3.new(11912, 179, 971)
local pos2 = Vector3.new(11914, 179, 971)

local isTeleporting1 = false
local isTeleporting2 = false

local moveAmount = Vector3.new(-0.5, 0, 0)
local moveDuration = 0.2

local function teleportWithMovement(pos)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
    if not rootPart then return end
    
    local originalPos = rootPart.Position
    
    local direction = pos - rootPart.Position
    local distance = direction.Magnitude
    
    rootPart.CFrame = CFrame.new(pos)
    
    local leftCFrame = CFrame.new(pos + moveAmount)
    rootPart.CFrame = leftCFrame
    wait(moveDuration)
    
    local rightCFrame = CFrame.new(pos - moveAmount)
    rootPart.CFrame = rightCFrame
    wait(moveDuration)
    
    rootPart.CFrame = CFrame.new(originalPos)
end

world1Toggle.MouseButton1Click:Connect(function()
    isTeleporting1 = not isTeleporting1
    world1Toggle.Text = isTeleporting1 and "Teleport ON" or "Teleport OFF"
    
    if isTeleporting1 then
        while isTeleporting1 do
            teleportWithMovement(pos1)
            wait(0.7)
        end
    end
end)

world2Toggle.MouseButton1Click:Connect(function()
    isTeleporting2 = not isTeleporting2
    world2Toggle.Text = isTeleporting2 and "Teleport ON" or "Teleport OFF"
    
    if isTeleporting2 then
        while isTeleporting2 do
            teleportWithMovement(pos2)
            wait(1) -- Wait 2 seconds before next teleport
        end
    end
end)

-- Cleanup when GUI is removed
frame.Destroying:Connect(function()
    isTeleporting1 = false
    isTeleporting2 = false
end)
