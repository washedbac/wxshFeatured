--[[
██████  ██      ███████ ██   ██ v3
██   ██ ██      ██       ██ ██
██████  ██      █████     ███
██      ██      ██       ██ ██
██      ███████ ███████ ██   ██
task#5555 // Opelika#1412
Universal Remote Spy Script (works on most executors)
]]
local https = game:GetService("HttpService")
local plrs = game:GetService("Players")

local lplr = plrs.LocalPlayer
local remotes = {}
local minimized = false

local settings = {
    Font = Enum.Font.SourceSans,
    Theme = "Dark", -- "Dark" or "Light"
    AdvancedMode = false -- idk why opelika added this
}

local function generateRandomString()
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local length = 10
    local randomString = ""
    for i = 1, length do
        local randomIndex = math.random(1, #chars)
        randomString = randomString .. chars:sub(randomIndex, randomIndex)
    end
    return randomString
end

local function initialize()
    local guiName = generateRandomString()
    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    ScreenGui.Name = guiName

    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 400, 0, 300)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    Frame.BackgroundColor3 = settings.Theme == "Dark" and Color3.new(0.1, 0.1, 0.1) or Color3.new(0.9, 0.9, 0.9)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true

    local TitleBar = Instance.new("Frame", Frame)
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = settings.Theme == "Dark" and Color3.new(0.2, 0.2, 0.2) or Color3.new(0.8, 0.8, 0.8)
    TitleBar.BorderSizePixel = 0

    local Title = Instance.new("TextLabel", TitleBar)
    Title.Size = UDim2.new(1, -30, 1, 0)
    Title.Position = UDim2.new(0, 5, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = settings.Theme == "Dark" and Color3.new(1, 1, 1) or Color3.new(0, 0, 0)
    Title.Text = "PLEX v3 - " .. guiName
    Title.Font = settings.Font
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Text = "PLEX v3 - " .. guiName
    Title.Font = settings.Font
    Title.RichText = true
    Title.Text = "<b>PLEX v3</b> - <i>" .. guiName .. "</i>"

    local MinimizeButton = Instance.new("TextButton", TitleBar)
    MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
    MinimizeButton.Position = UDim2.new(1, -30, 0, 0)
    MinimizeButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
    MinimizeButton.Text = "—"
    MinimizeButton.Font = settings.Font
    MinimizeButton.TextSize = 18

    local ScrollingFrame = Instance.new("ScrollingFrame", Frame)
    ScrollingFrame.Size = UDim2.new(1, 0, 1, -30)
    ScrollingFrame.Position = UDim2.new(0, 0, 0, 30)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #remotes * 30)
    ScrollingFrame.ScrollBarThickness = 8
    ScrollingFrame.BackgroundTransparency = 1

    for index, remote in ipairs(remotes) do
        local RemoteButton = Instance.new("TextButton", ScrollingFrame)
        RemoteButton.Size = UDim2.new(1, -16, 0, 30)
        RemoteButton.Position = UDim2.new(0, 8, 0, (index - 1) * 30)
        RemoteButton.BackgroundColor3 = settings.Theme == "Dark" and Color3.new(0.2, 0.2, 0.2) or Color3.new(0.8, 0.8, 0.8)
        RemoteButton.BorderSizePixel = 0
        RemoteButton.TextColor3 = settings.Theme == "Dark" and Color3.new(1, 1, 1) or Color3.new(0, 0, 0)
        RemoteButton.Text = remote.Name
        RemoteButton.Font = settings.Font
        RemoteButton.TextSize = 18
        RemoteButton.MouseButton1Click:Connect(function()
            setclipboard(remote:GetFullName())
        end)
    end

    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            ScrollingFrame.Visible = false
            Frame.Size = UDim2.new(0, 400, 0, 30)
        else
            ScrollingFrame.Visible = true
            Frame.Size = UDim2.new(0, 400, 0, 300)
        end
    end)
end

local function logRemoteCall(remote, method, args)
    if not table.find(remotes, remote) then
        table.insert(remotes, remote)
    end

    print("Remote Call Detected:")
    print("Remote:", remote)
    print("Method:", method)
    print("Arguments:")
    for i, v in ipairs(args) do
        print(i, v)
    end

    if settings.AdvancedMode then
        print("Advanced Info:")
        print("Remote Full Name:", remote:GetFullName())
        print("Caller:", getcallingscript() and getcallingscript().Name or "N/A")
    end
end

local old_nc
old_nc = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        logRemoteCall(self, method, args)
    end
    return old_nc(self, ...)
end))

local function onPlayerAdded(player)
    local function onChildAdded(child)
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
            table.insert(remotes, child)
        end
    end
    player.CharacterAdded:Connect(function(character)
        character.ChildAdded:Connect(onChildAdded)
    end)
end

plrs.PlayerAdded:Connect(onPlayerAdded)
for _, player in pairs(plrs:GetPlayers()) do
    onPlayerAdded(player)
end

initialize()
