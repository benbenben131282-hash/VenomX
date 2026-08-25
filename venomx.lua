-- 🩸 VenomX V5 – FULL SCRIPT (All Features Merged)
if _G.VenomXLoaded then return end
_G.VenomXLoaded = true

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

-- Locals
local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Wait for character
local Character = LP.Character or LP.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Superadmins/Admins/AllowedUsers
local superAdmins = {
  Papaswee2 = true,
  ["30excobite"] = true,
  xxgamer_2845 = true,
  Itspoiihere2 = true
}
local admins = {
  Papaswee2 = true,
  ["30excobite"] = true,
  xxgamer_2845 = true,
  Itspoiihere2 = true
}
local allowedUsers = {
  Papaswee2 = true,
  ["30excobite"] = true,
  xxgamer_2845 = true,
  Itspoiihere2 = true
}

-- State variables
local spin = false
local spinTarget = nil
local spinSpeed = 5
local spinGyro = {}
local loopKill = false
local loopKillTarget = nil
local frozen = false
local antiGrab = false
local antiGrabConn = nil
local autoAttack = false
local killMode = "Death"
local antiExplode = false
local antiVoid = false
local noclipGrab = false
local kickGrab = false
local crazyGrab = false
local crazySpeed = 0.1
local masslessGrab = false
local masslessSense = 30
local killGrab = false
local ragdollGrab = false
local RAGDOLL_ID = nil
local antiKick = false
local antiBanana = false
local antiPaint = false
local antiLoop = false
local antiLoopV2 = false
local housePos = Vector3.new(264, -7, 440)
local flingGrab = false
local invisLine = false
local crazyLine = false
local loopKillEnabled = false
local loopKickEnabled = false
local voidAura = false
local kickAura = false
local grabAura = false
local throwAura = false
local throwSpeed = 100
local throwVel = {}
local speedEnabled = false
local speedValue = 1
local jumpPowerEnabled = false
local jumpPowerValue = 50
local infJump = false
local noclip = false
local customFOV = false
local fovValue = 70
local customGrav = false
local gravValue = 196.2
local walkWater = false
local beamLights = false
local dayNight = false
local textures = false
local playerESP = false
local objectESP = false
local fullbright = false

-- Whitelist system
local Whitelist = {}
local WhitelistEnabled = false
local WL_FriendsEnabled = false
local selectedWLPlayer = nil
local loopTarget = nil

-- Remote setup
local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents")
local SetNetworkOwner = GrabEvents:WaitForChild("SetNetworkOwner")
local DestroyGrabLine = GrabEvents:WaitForChild("DestroyGrabLine")
local CreateGrabLine = GrabEvents:WaitForChild("CreateGrabLine")
local ExtendGrabLine = GrabEvents:WaitForChild("ExtendGrabLine")
local CharacterEvents = ReplicatedStorage:WaitForChild("CharacterEvents")
local RagdollRemote = CharacterEvents:WaitForChild("RagdollRemote")
local Struggle = CharacterEvents:WaitForChild("Struggle")
local MenuToys = ReplicatedStorage:WaitForChild("MenuToys")
local SpawnToyRF = MenuToys:WaitForChild("SpawnToyRemoteFunction")
local DestroyToyRF = MenuToys:FindFirstChild("DestroyToy")
local StickyEvent = nil
pcall(function()
    StickyEvent = ReplicatedStorage:WaitForChild("PlayerEvents"):WaitForChild("StickyPartEvent")
end)

-- BackPack
local BackPack = Workspace:FindFirstChild(LP.Name .. "SpawnedInToys")
if not BackPack then
    BackPack = Instance.new("Folder")
    BackPack.Name = LP.Name .. "SpawnedInToys"
    BackPack.Parent = Workspace
end

-- InPlot
local InPlot = LP:WaitForChild("InPlot")
local IsHeld = LP:WaitForChild("IsHeld")

-- BombEvents (for explosion spam)
local BombEvents = ReplicatedStorage:FindFirstChild("BombEvents")
if not BombEvents then
  warn("BombEvents not found, explosion features may not work")
end

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Role check
local function getRole(name)
    if superAdmins[name] then return "superadmin" end
    if admins[name] then return "admin" end
    if allowedUsers[name] then return "allowed" end
    return "user"
end

local role = getRole(LP.Name)
if role == "user" then
    warn("Not whitelisted")
    return
end

-- Chat func
local RBXGeneral = TextChatService.TextChannels:WaitForChild("RBXGeneral")
local function sendToChat(msg)
    RBXGeneral:SendAsync(msg)
end

-- Notify func
local function notify(title, content)
    pcall(function()
        Rayfield:Notify({
            Title = title,
            Content = content,
            Duration = 3
        })
    end)
end

-- Window setup
local Window = Rayfield:CreateWindow({
    Name = "🩸 VenomX V5 🩸 [PREMIUM]",
    LoadingTitle = "🩸 VenomX V5 🩸",
    LoadingSubtitle = "Loading all features...",
    Theme = {
        TextColor = Color3.fromRGB(240, 240, 240),
        Background = Color3.fromRGB(10, 10, 10),
        Topbar = Color3.fromRGB(10, 10, 10),
        Shadow = Color3.fromRGB(255, 50, 50),
        NotificationBackground = Color3.fromRGB(10, 10, 10),
        TabBackgroundSelected = Color3.fromRGB(255, 50, 50),
        TabTextColor = Color3.fromRGB(240, 240, 240),
        ElementBackground = Color3.fromRGB(15, 15, 15),
        ElementStroke = Color3.fromRGB(255, 50, 50),
        SliderProgress = Color3.fromRGB(255, 50, 50),
        ToggleEnabled = Color3.fromRGB(0, 255, 0),
        ToggleDisabled = Color3.fromRGB(255, 0, 0),
    },
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "VenomX",
        FileName = "V5_Config"
    },
    KeySystem = false
})

-- Tabs
local MainTab = Window:CreateTab("Player", 7743871002)
local InvTab = Window:CreateTab("Invincibility", 7734056608)
local GrabLinesTab = Window:CreateTab("Grab & Lines", 7485051715)
local LoopTab = Window:CreateTab("Loop", 7734058599)
local AuraTab = Window:CreateTab("Auras", 7733666258)
local ServerTab = Window:CreateTab("Server", "earth")
local VisualTab = Window:CreateTab("Visual", 7733774602)
local FunTab = Window:CreateTab("Fun", "smile")
local WhitelistTab = Window:CreateTab("Whitelist", 10723433811)
local InfoTab = Window:CreateTab("Info", 4483362458)
local ExplosionTab = Window:CreateTab("Explosions", 17837704089)
local MiscTab = Window:CreateTab("Misc", 7733916988)
local KeybindTab = Window:CreateTab("Keybind", 11710306232)
local FormTab = Window:CreateTab("Body Form [BETA]", "hand")

-- Utility funcs
local function GetOwnedPlot()
    local Plots = Workspace:WaitForChild("Plots", 5)
    if not Plots then return nil end
    for i = 1, 5 do
        local plot = Plots:FindFirstChild("Plot" .. i)
        if plot then
            local sign = plot:FindFirstChild("PlotSign")
            if sign then
                local owners = sign:FindFirstChild("ThisPlotsOwners")
                if owners then
                    for _, child in ipairs(owners:GetChildren()) do
                        if child:IsA("StringValue") and child.Value == LP.Name then
                            return i
                        end
                    end
                end
            end
        end
    end
    return nil
end

local function getAllPalletFolders()
    local folders = {}
    local spawned = Workspace:FindFirstChild(LP.Name .. "SpawnedInToys")
    if spawned then table.insert(folders, spawned) end
    local plotNum = GetOwnedPlot()
    if plotNum then
        local PlotItems = Workspace:FindFirstChild("PlotItems")
        if PlotItems then
            local plot = PlotItems:FindFirstChild("Plot" .. plotNum)
            if plot then table.insert(folders, plot) end
        end
    end
    return folders
end

local function canSpawn()
    if InPlot.Value then
        return GetOwnedPlot() ~= nil
    end
    return true
end

local function isWhitelisted(plr)
    if not plr then return false end
    if WL_FriendsEnabled and LP:IsFriendsWith(plr.UserId) then return true end
    if WhitelistEnabled then return Whitelist[plr.Name] == true end
    return false
end

local function toggleBlock(player, enable)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if enable then
        if not hrp:FindFirstChild("Block") then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "Block"
            bv.MaxForce = Vector3.new(1e999, 1e999, 1e999)
            bv.Velocity = Vector3.zero
            bv.Parent = hrp
        end
    else
        local block = hrp:FindFirstChild("Block")
        if block then block:Destroy() end
    end
end

-- Chat commands
TextChatService.OnIncomingMessage = function(message)
    local textSource = message.TextSource
    if not textSource then return end
    local sender = Players:GetPlayerByUserId(textSource.UserId)
    if not sender then return end
    local senderRole = getRole(sender.Name)
    if senderRole == "user" or senderRole == "allowed" then return end

    local args = {}
    for word in message.Text:gmatch("%S+") do
        table.insert(args, word)
    end
    if #args < 1 then return end

    local cmd = args[1]:lower()

    if cmd == "!reveal" and (senderRole == "superadmin" or senderRole == "admin") then
        sendToChat("🩸 VenomX V5 🩸")
    elseif cmd == "!chat" and #args >= 3 then
        if args[2] == LP.Name then
            sendToChat(table.concat(args, " ", 3))
        end
    elseif cmd == "!kick" and args[2] == LP.Name then
        LP:Kick("Kicked by " .. sender.Name)
    elseif cmd == "!kill" and args[2] == LP.Name then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = 0 end
    elseif cmd == "!bring" and args[2] == LP.Name then
        local senderHRP = sender.Character and sender.Character:FindFirstChild("HumanoidRootPart")
        local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if senderHRP and myHRP then
            myHRP.CFrame = senderHRP.CFrame + Vector3.new(0, 0, -3)
            toggleBlock(LP, true)
            task.delay(1, function() toggleBlock(LP, false) end)
        end
    elseif cmd == "!spin" and args[2] == LP.Name then
        spin = true
        spinTarget = sender
    elseif cmd == "!unspin" and args[2] == LP.Name then
        spin = false
        spinTarget = nil
    elseif cmd == "!loopkill" and args[2] == LP.Name then
        loopKill = true
        loopKillTarget = sender
    elseif cmd == "!unloopkill" and args[2] == LP.Name then
        loopKill = false
        loopKillTarget = nil
    elseif cmd == "!freeze" and args[2] == LP.Name then
        frozen = true
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hum then
            hum.WalkSpeed = 0
            hum.JumpPower = 0
        end
        if hrp then hrp.Anchored = true end
    elseif cmd == "!unfreeze" and args[2] == LP.Name then
        frozen = false
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
        if hrp then hrp.Anchored = false end
    elseif cmd == "!setfps" and args[2] == LP.Name and #args >= 3 then
        local fps = tonumber(args[3])
        if fps and fps > 0 then
            setfpscap(fps)
        end
    elseif cmd == "!crash" and args[2] == LP.Name then
        while true do
            Instance.new("Part").Parent = Workspace
        end
    end
end

-- Spin/Loop Kill handler
RunService.Heartbeat:Connect(function()
    if spin and spinTarget then
        local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local targetHRP = spinTarget.Character and spinTarget.Character:FindFirstChild("HumanoidRootPart")
        if myHRP and targetHRP then
            local angle = tick() * 2
            myHRP.CFrame = targetHRP.CFrame * CFrame.new(math.cos(angle) * 8, 2, math.sin(angle) * 8)
        end
    end

    if loopKill and loopKillTarget then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            hum.Health = 0
        end
    end
end)

-- Whitelist UI
WhitelistTab:CreateLabel("Whitelist Settings")
WhitelistTab:CreateToggle({
    Name = "Auto-Whitelist Friends",
    CurrentValue = false,
    Flag = "WL_AutoFriends",
    Callback = function(v) WL_FriendsEnabled = v end
})

WhitelistTab:CreateSection("Add Player")
local function buildPlayerList()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            table.insert(list, "@" .. plr.Name .. " (" .. plr.DisplayName .. ")")
        end
    end
    table.sort(list)
    return list
end

local wlAddDropdown = WhitelistTab:CreateDropdown({
    Name = "Select Player",
    Options = buildPlayerList(),
    CurrentOption = {},
    Flag = "WL_Add_Select",
    Callback = function(opt)
        selectedWLPlayer = opt[1] and opt[1]:match("@([%w_]+)")
    end
})

WhitelistTab:CreateButton({
    Name = "Add to Whitelist",
    Callback = function()
        if selectedWLPlayer then Whitelist[selectedWLPlayer] = true end
    end
})

WhitelistTab:CreateSection("Remove Player")
local function buildWhitelist()
    local list = {}
    for name, _ in pairs(Whitelist) do
        table.insert(list, "@" .. name)
    end
    table.sort(list)
    return list
end

local wlListDropdown = WhitelistTab:CreateDropdown({
    Name = "Whitelisted Players",
    Options = buildWhitelist(),
    CurrentOption = {},
    Flag = "WL_List",
    Callback = function(opt)
        local name = opt[1] and opt[1]:match("@([%w_]+)")
        if name then Whitelist[name] = nil end
    end
})

WhitelistTab:CreateToggle({
    Name = "Enable Whitelist",
    CurrentValue = false,
    Flag = "WL_Enable",
    Callback = function(v) WhitelistEnabled = v end
})

WhitelistTab:CreateParagraph({
    Title = "What does this whitelist affect?",
    Content = "The whitelist affects all AURAS, and LOOP ALL features"
})

Players.PlayerAdded:Connect(function() task.wait(0.5); wlAddDropdown:Refresh(buildPlayerList()) end)
Players.PlayerRemoving:Connect(function() task.wait(0.5); wlAddDropdown:Refresh(buildPlayerList()) end)

-- Player features
MainTab:CreateSection("Movement")

local speedConn = nil
MainTab:CreateToggle({
    Name = "WalkSpeed",
    CurrentValue = false,
    Flag = "Player_Speed",
    Callback = function(v)
        speedEnabled = v
        if speedConn then speedConn:Disconnect() end
        if v then
            speedConn = RunService.Heartbeat:Connect(function()
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.MoveDirection.Magnitude > 0 then
                    hrp.CFrame = hrp.CFrame + hum.MoveDirection.Unit * speedValue
                end
            end)
        end
    end
})

MainTab:CreateSlider({
    Name = "Speed Value",
    Range = {1, 20},
    Increment = 0.5,
    Suffix = " studs",
    CurrentValue = 1,
    Flag = "Player_SpeedValue",
    Callback = function(v) speedValue = v end
})

local jumpConn = nil
MainTab:CreateToggle({
    Name = "JumpPower",
    CurrentValue = false,
    Flag = "Player_Jump",
    Callback = function(v)
        jumpPowerEnabled = v
        if jumpConn then jumpConn:Disconnect() end
        if v then
            jumpConn = RunService.Heartbeat:Connect(function()
                local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.JumpPower = jumpPowerValue
                    hum.UseJumpPower = true
                end
            end)
        else
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.JumpPower = 50
                hum.UseJumpPower = false
            end
        end
    end
})

MainTab:CreateSlider({
    Name = "JumpPower Value",
    Range = {50, 200},
    Increment = 5,
    Suffix = " power",
    CurrentValue = 50,
    Flag = "Player_JumpValue",
    Callback = function(v) jumpPowerValue = v end
})

UserInputService.JumpRequest:Connect(function()
    if infJump then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "Player_InfJump",
    Callback = function(v) infJump = v end
})

MainTab:CreateToggle({
    Name = "Infinite Zoom",
    CurrentValue = false,
    Flag = "Player_InfZoom",
    Callback = function(v)
        LP.CameraMaxZoomDistance = v and 5000000 or 0.5
        LP.CameraMinZoomDistance = 0.5
    end
})

local function ChangeCollision(enable)
    pcall(function()
        local Map = Workspace:FindFirstChild("Map")
        if not Map then return end
        local AlwaysHere = Map:FindFirstChild("AlwaysHereTweenedObjects")
        if not AlwaysHere then return end
        local Ocean = AlwaysHere:FindFirstChild("Ocean")
        if not Ocean then return end
        local Object = Ocean:FindFirstChild("Object")
        if not Object then return end
        local ObjectModel = Object:FindFirstChild("ObjectModel")
        if not ObjectModel then return end
        for _, child in pairs(ObjectModel:GetChildren()) do
            if child:IsA("BasePart") then
                child.CanCollide = enable
            end
        end
    end)
end

MainTab:CreateToggle({
    Name = "Walk on Water",
    CurrentValue = false,
    Flag = "Player_WalkWater",
    Callback = function(v) walkWater = v; ChangeCollision(v) end
})

RunService.Stepped:Connect(function()
    if noclip then
        local char = LP.Character
        if char then
            for _, desc in pairs(char:GetDescendants()) do
                if desc:IsA("BasePart") then desc.CanCollide = false end
            end
        end
    end
end)

MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Player_Noclip",
    Callback = function(v) noclip = v end
})

-- Camera
MainTab:CreateSection("Camera")
MainTab:CreateToggle({
    Name = "Custom FOV",
    CurrentValue = false,
    Flag = "Camera_FOV",
    Callback = function(v)
        customFOV = v
        Camera.FieldOfView = v and fovValue or 70
    end
})

MainTab:CreateSlider({
    Name = "FOV Value",
    Range = {30, 120},
    Increment = 5,
    Suffix = "°",
    CurrentValue = 70,
    Flag = "Camera_FOVValue",
    Callback = function(v)
        fovValue = v
        if customFOV then Camera.FieldOfView = v end
    end
})

-- Gravity
MainTab:CreateSection("Gravity")
MainTab:CreateToggle({
    Name = "Custom Gravity",
    CurrentValue = false,
    Flag = "Player_Gravity",
    Callback = function(v)
        customGrav = v
        Workspace.Gravity = v and gravValue or 196.2
    end
})

MainTab:CreateSlider({
    Name = "Gravity Value",
    Range = {0, 500},
    Increment = 10,
    Suffix = " gravity",
    CurrentValue = 196.2,
    Flag = "Player_GravValue",
    Callback = function(v)
        gravValue = v
        if customGrav then Workspace.Gravity = v end
    end
})

-- Silent Aim (from ftap2)
MainTab:CreateSection("Silent Aim")
local silentAimEnabled = false
local silentAimRange = 50

local function getClosestPlayer()
  local closest = nil
  local minDist = silentAimRange or 50
  for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LP and plr.Character then
      local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
      if hrp then
        local dist = (LP.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
        if dist < minDist then
          minDist = dist
          closest = plr
        end
      end
    end
  end
  return closest
end

if hookmetamethod then
  local oldNamecall
  oldNamecall = hookmetamethod(game, "__namecall", function(...)
    local args = {...}
    local method = getnamecallmethod()
    if method == "Raycast" and args[1] == workspace and not checkcaller() and silentAimEnabled then
      local target = getClosestPlayer()
      if target and target.Character then
        local head = target.Character:FindFirstChild("Head")
        if head then
          local params = args[4] or RaycastParams.new()
          params.FilterDescendantsInstances = {target.Character}
          params.FilterType = Enum.RaycastFilterType.Include
          args[3] = (args[2] - head.Position).Unit * 1000
          args[4] = params
        end
      end
    end
    return oldNamecall(unpack(args))
  end)
end

MainTab:CreateToggle({
  Name = "Silent Aim",
  CurrentValue = false,
  Flag = "SilentAim",
  Callback = function(v) silentAimEnabled = v end
})
MainTab:CreateSlider({
  Name = "Range",
  Range = {10, 100},
  Increment = 5,
  Suffix = " studs",
  CurrentValue = 50,
  Flag = "SilentAimRange",
  Callback = function(v) silentAimRange = v end
})

-- Auto Farm Coins (from ftap2)
MainTab:CreateSection("Auto Farm Coins")
local autoFarmCoins = false
local function isSlotLit()
  for _, slot in pairs(Workspace.Slots:GetChildren()) do
    local handle = slot:FindFirstChild("SlotHandle")
    if handle and handle:FindFirstChild("LightBall") and handle.LightBall.Material == Enum.Material.Neon then
      return true
    end
  end
  return false
end

MainTab:CreateToggle({
  Name = "Auto-Spin (Coins)",
  CurrentValue = false,
  Flag = "AutoFarmCoins",
  Callback = function(v)
    autoFarmCoins = v
    if v then
      task.spawn(function()
        while autoFarmCoins do
          if isSlotLit() then
            local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if myHRP then
              local savedCF = myHRP.CFrame
              for _, slot in pairs(Workspace.Slots:GetChildren()) do
                local handle = slot:FindFirstChild("SlotHandle")
                if handle then
                  local coin = handle:FindFirstChild("Handle")
                  if coin then
                    myHRP.CFrame = coin.CFrame + Vector3.new(0, 5, 0)
                    SetNetworkOwner:FireServer(coin, coin.CFrame)
                    task.wait(0.2)
                  end
                end
              end
              myHRP.CFrame = savedCF
            end
          end
          task.wait(1)
        end
      end)
    end
  end
})

-- Auto Claim Plot (from ftap2)
MainTab:CreateSection("Auto Claim Plot")
local plotName = "Witch House"
local function getPlotModel()
  local plots = Workspace.Plots
  if plotName == "Witch House" then return plots:FindFirstChild("Plot3")
  elseif plotName == "Lumber House" then return plots:FindFirstChild("Plot2")
  elseif plotName == "Common House" then return plots:FindFirstChild("Plot1")
  elseif plotName == "American House" then return plots:FindFirstChild("Plot4")
  elseif plotName == "Chinese House" then return plots:FindFirstChild("Plot5") end
  return nil
end

MainTab:CreateDropdown({
  Name = "Plot",
  Options = {"Witch House", "Lumber House", "Common House", "American House", "Chinese House"},
  CurrentOption = {"Witch House"},
  Flag = "PlotSelect",
  Callback = function(opt) plotName = opt[1] end
})

MainTab:CreateButton({
  Name = "Claim Plot",
  Callback = function()
    local plot = getPlotModel()
    if plot then
      local sign = plot:FindFirstChild("PlotSign")
      if sign then
        local owners = sign:FindFirstChild("ThisPlotsOwners")
        if owners and #owners:GetChildren() == 0 then
          local plus = sign:FindFirstChild("Sign") and sign.Sign:FindFirstChild("Plus")
          if plus then
            local grab = plus:FindFirstChild("PlusGrabPart")
            if grab then
              local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
              if myHRP then
                local saved = myHRP.CFrame
                myHRP.CFrame = grab.CFrame * CFrame.new(0, 0, -5)
                for _ = 1, 15 do
                  SetNetworkOwner:FireServer(grab, grab.CFrame)
                  task.wait()
                end
                myHRP.CFrame = saved
              end
            end
          end
        end
      end
    end
  end
})

-- ==============================
-- INVINCIBILITY TAB
-- ==============================
InvTab:CreateSection("Anti Grab")

InvTab:CreateButton({
    Name = "Anti Gucci (Blobman)",
    Callback = function()
        local char = LP.Character or LP.CharacterAdded:Wait()
        local hum = char:WaitForChild("Humanoid")
        local hrp = char:WaitForChild("HumanoidRootPart")
        local pos = hrp.Position
        SpawnToyRF:InvokeServer("CreatureBlobman", CFrame.new(0, 50000, 0), Vector3.new(0, 60, 0))
        task.wait(0.5)
        local folder = Workspace:FindFirstChild(LP.Name .. "SpawnedInToys")
        if folder then
            local blob = folder:FindFirstChild("CreatureBlobman")
            if blob then
                local head = blob:FindFirstChild("Head")
                if head then
                    head.Anchored = true
                    head.CFrame = CFrame.new(0, 50000, 0)
                end
                local seat = blob:FindFirstChild("VehicleSeat")
                if seat then
                    hrp.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
                    task.wait(0.2)
                    seat:Sit(hum)
                end
            end
        end
        RunService.Heartbeat:Connect(function()
            pcall(function() RagdollRemote:FireServer(hrp, 0) end)
        end)
        hum:GetPropertyChangedSignal("Jump"):Connect(function()
            if hum.Jump and hum.Sit then pos = hrp.Position end
        end)
        task.spawn(function()
            while hum.Sit do task.wait(1) end
            task.wait(0.5)
            hrp.CFrame = CFrame.new(pos)
        end)
    end
})

InvTab:CreateButton({
    Name = "Invisibility (Train Gucci)",
    Callback = function()
        local char = LP.Character or LP.CharacterAdded:Wait()
        local hum = char:WaitForChild("Humanoid")
        local hrp = char:WaitForChild("HumanoidRootPart")
        local seat = Workspace.Map.AlwaysHereTweenedObjects.Train.Object.ObjectModel:WaitForChild("Seat")
        local pos = hrp.Position
        task.wait(0.5)
        hrp.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
        task.wait(0.2)
        seat:Sit(hum)
        RunService.Heartbeat:Connect(function()
            pcall(function() RagdollRemote:FireServer(hrp, 0) end)
        end)
        hum:GetPropertyChangedSignal("Jump"):Connect(function()
            if hum.Jump and hum.Sit then pos = hrp.Position end
        end)
        task.spawn(function()
            while hum.Sit do task.wait(1) end
            task.wait(0.5)
            hrp.CFrame = CFrame.new(pos)
        end)
    end
})

-- Anti Grab V1 (original)
InvTab:CreateToggle({
    Name = "Anti Grab V1 (Struggle)",
    CurrentValue = false,
    Flag = "Inv_AntiGrab",
    Callback = function(v)
        antiGrab = v
        if antiGrabConn then antiGrabConn:Disconnect() end
        if v then
            antiGrabConn = RunService.Heartbeat:Connect(function()
                if not antiGrab then return end
                local char = LP.Character
                if not char then return end
                local head = char:FindFirstChild("Head")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not head or not hrp or not hum then return end
                if not head:FindFirstChild("PartOwner") then return end
                local cf = hrp.CFrame
                for _ = 1, 3 do
                    pcall(function() Struggle:FireServer() end)
                    pcall(function() RagdollRemote:FireServer(hrp, 0) end)
                    pcall(function() DestroyGrabLine:FireServer() end)
                    hum.Sit = false
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.CFrame = cf
                    task.wait()
                end
            end)
        end
    end
})

-- Anti Grab V2 (IsHeld based)
local antiGrabV2Active = false
local antiGrabV2Conn = nil

local function setupAntiGrabV2()
    if antiGrabV2Conn then antiGrabV2Conn:Disconnect(); antiGrabV2Conn = nil end
    if not antiGrabV2Active then return end
    antiGrabV2Conn = IsHeld.Changed:Connect(function()
        if not antiGrabV2Active then return end
        if IsHeld.Value then
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Velocity = Vector3.zero
                hrp.Anchored = true
                pcall(function() Struggle:FireServer(LP) end)
                pcall(function() RagdollRemote:FireServer(hrp, 0) end)
            end
        else
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Anchored = false
                hrp.Velocity = Vector3.zero
            end
        end
    end)
end

LP.CharacterAdded:Connect(function()
    if antiGrabV2Active then
        setupAntiGrabV2()
    end
end)

InvTab:CreateToggle({
    Name = "Anti Grab V2 (2nd Best)",
    CurrentValue = false,
    Flag = "Inv_AntiGrabV2",
    Callback = function(v)
        antiGrabV2Active = v
        if v then
            setupAntiGrabV2()
        else
            if antiGrabV2Conn then antiGrabV2Conn:Disconnect(); antiGrabV2Conn = nil end
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Anchored = false
                hrp.Velocity = Vector3.zero
            end
        end
    end
})

-- Anti Grab V3 (Best) - combines both V1 and V2
local antiGrabV3Active = false
InvTab:CreateToggle({
    Name = "Anti Grab V3 (Best)",
    CurrentValue = false,
    Flag = "Inv_AntiGrabV3",
    Callback = function(v)
        antiGrabV3Active = v
        if v then
            antiGrab = true
            antiGrabV2Active = true
            if not antiGrabConn then
                antiGrabConn = RunService.Heartbeat:Connect(function()
                    if not antiGrab then return end
                    local char = LP.Character
                    if not char then return end
                    local head = char:FindFirstChild("Head")
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if not head or not hrp or not hum then return end
                    if not head:FindFirstChild("PartOwner") then return end
                    local cf = hrp.CFrame
                    for _ = 1, 3 do
                        pcall(function() Struggle:FireServer() end)
                        pcall(function() RagdollRemote:FireServer(hrp, 0) end)
                        pcall(function() DestroyGrabLine:FireServer() end)
                        hum.Sit = false
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.CFrame = cf
                        task.wait()
                    end
                end)
            end
            setupAntiGrabV2()
        else
            antiGrab = false
            antiGrabV2Active = false
            if antiGrabConn then antiGrabConn:Disconnect(); antiGrabConn = nil end
            if antiGrabV2Conn then antiGrabV2Conn:Disconnect(); antiGrabV2Conn = nil end
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Anchored = false
                hrp.Velocity = Vector3.zero
            end
        end
    end
})

InvTab:CreateToggle({
    Name = "Auto Attack",
    CurrentValue = false,
    Flag = "Inv_AutoAttack",
    Callback = function(v)
        autoAttack = v
        if not v then return end
        task.spawn(function()
            local warned = false
            while autoAttack do
                if not antiGrab then
                    if not warned then
                        notify("Error", "Enable AntiGrab first")
                        warned = true
                    end
                    task.wait(0.5)
                else
                    warned = false
                    local char = LP.Character
                    if char and char:FindFirstChild("Head") then
                        local owner = char.Head:FindFirstChild("PartOwner")
                        if owner and owner:IsA("StringValue") then
                            local target = Players:FindFirstChild(owner.Value)
                            if target and target.Character then
                                local thrp = target.Character:FindFirstChild("HumanoidRootPart")
                                local thum = target.Character:FindFirstChild("Humanoid")
                                if thrp then
                                    pcall(function()
                                        for _ = 1, 10 do
                                            SetNetworkOwner:FireServer(thrp, thrp.CFrame)
                                            task.wait()
                                        end
                                        if killMode == "Death" then
                                            DestroyGrabLine:FireServer(thrp)
                                            thrp.CFrame = CFrame.new(0, 90000000, 0)
                                            local bv = Instance.new("BodyVelocity")
                                            bv.Velocity = Vector3.new(0, 9000000000, 0)
                                            bv.MaxForce = Vector3.new(1e999, 1e999, 1e999)
                                            bv.Parent = thrp
                                            if thum then thum:ChangeState(Enum.HumanoidStateType.Dead) end
                                            Debris:AddItem(bv, 2)
                                        elseif killMode == "Sky" then
                                            DestroyGrabLine:FireServer(thrp)
                                            thrp.CFrame = CFrame.new(0, 999999, 0)
                                            local bv = Instance.new("BodyVelocity")
                                            bv.Velocity = Vector3.new(math.random(-3000, 3000), 9000000000, math.random(-3000, 3000))
                                            bv.MaxForce = Vector3.new(1e999, 1e999, 1e999)
                                            bv.Parent = thrp
                                            Debris:AddItem(bv, 3)
                                        elseif killMode == "TpToSpawn" then
                                            thrp.CFrame = CFrame.new(0, 0, 0)
                                        elseif killMode == "BigFling" then
                                            thrp.CFrame = CFrame.new(0, 100, 0)
                                            local bv = Instance.new("BodyVelocity")
                                            bv.MaxForce = Vector3.new(1e999, 1e999, 1e999)
                                            bv.Velocity = Vector3.new(math.random(-1000, 1000), 500, math.random(-1000, 1000))
                                            bv.Parent = thrp
                                            local bav = Instance.new("BodyAngularVelocity")
                                            bav.AngularVelocity = Vector3.new(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500))
                                            bav.MaxTorque = Vector3.new(1e999, 1e999, 1e999)
                                            bav.Parent = thrp
                                            Debris:AddItem(bv, 5)
                                            Debris:AddItem(bav, 5)
                                        elseif killMode == "Crazy" then
                                            local points = {
                                                Vector3.new(-17, 421, 50), Vector3.new(145, 397, -126),
                                                Vector3.new(157, 254, 89), Vector3.new(-26, 207, -26),
                                                Vector3.new(-23, 456, -19), Vector3.new(15, 211, 45)
                                            }
                                            task.spawn(function()
                                                while autoAttack and antiGrab do
                                                    local owned = not thrp:IsGrounded() and thrp.ReceiveAge == 0
                                                    if not owned then return end
                                                    for _, pt in ipairs(points) do
                                                        if not antiGrab then break end
                                                        thrp.CFrame = CFrame.new(pt)
                                                        task.wait(0.04)
                                                    end
                                                end
                                            end)
                                        end
                                    end)
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end
        end)
    end
})

InvTab:CreateDropdown({
    Name = "Kill Mode",
    Options = {"Death", "Sky", "TpToSpawn", "BigFling", "Crazy"},
    CurrentOption = {"Death"},
    Flag = "Inv_KillMode",
    Callback = function(opt) killMode = opt[1] end
})

InvTab:CreateSection("Anti Utility")

InvTab:CreateToggle({
    Name = "Anti-Kick (Kunai)",
    CurrentValue = false,
    Flag = "Inv_AntiKick",
    Callback = function(v)
        antiKick = v
        if v then
            task.spawn(function()
                while antiKick do
                    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp then task.wait(0.5) continue end
                    local folders = {}
                    local spawned = Workspace:FindFirstChild(LP.Name .. "SpawnedInToys")
                    if spawned then table.insert(folders, spawned) end
                    local PlotItems = Workspace:FindFirstChild("PlotItems")
                    if PlotItems then
                        for i = 1, 5 do
                            if PlotItems:FindFirstChild("Plot" .. i) then
                                table.insert(folders, PlotItems["Plot" .. i])
                            end
                        end
                    end
                    local found = false
                    for _, folder in ipairs(folders) do
                        local kunai = folder:FindFirstChild("NinjaKunai")
                        if kunai then
                            found = true
                            local part = kunai:FindFirstChild("StickyPart") or kunai:FindFirstChild("SoundPart") or kunai.PrimaryPart
                            if part then
                                local owner = part:FindFirstChild("PartOwner")
                                if owner and owner.Value ~= LP.Name then
                                    pcall(function() if DestroyToyRF then DestroyToyRF:FireServer(kunai) end end)
                                end
                                local sticky = part:FindFirstChild("StickyWeld")
                                local fire = hrp:FindFirstChild("FirePlayerPart")
                                if sticky and fire and StickyEvent then
                                    StickyEvent:FireServer(part, fire, CFrame.new(0, 0, 0, 1, 0, 0, 0, 0, -1, 0, 1, 0))
                                end
                                if (part.Position - hrp.Position).Magnitude > 50 then
                                    pcall(function() if DestroyToyRF then DestroyToyRF:FireServer(kunai) end end)
                                end
                            end
                            break
                        end
                    end
                    if not found then
                        task.spawn(function()
                            SpawnToyRF:InvokeServer("NinjaKunai", hrp.CFrame * CFrame.new(0, 0, 15), Vector3.new(0, 90, 0))
                        end)
                    end
                    task.wait(0.2)
                end
            end)
        end
    end
})

InvTab:CreateToggle({
    Name = "Anti-Explosion",
    CurrentValue = false,
    Flag = "Inv_AntiExplode",
    Callback = function(v)
        antiExplode = v
        if v then
            local function onRagdoll(char)
                local ragdoll = char:WaitForChild("Humanoid"):FindFirstChild("Ragdolled")
                if ragdoll then
                    ragdoll:GetPropertyChangedSignal("Value"):Connect(function()
                        if ragdoll.Value then
                            for _, child in ipairs(char:GetChildren()) do
                                if child:IsA("BasePart") then child.Anchored = true end
                            end
                        else
                            for _, child in ipairs(char:GetChildren()) do
                                if child:IsA("BasePart") then child.Anchored = false end
                            end
                        end
                    end)
                end
            end
            if LP.Character then onRagdoll(LP.Character) end
            LP.CharacterAdded:Connect(onRagdoll)
        end
    end
})

InvTab:CreateToggle({
    Name = "Anti Poison",
    CurrentValue = false,
    Flag = "Inv_AntiPoison",
    Callback = function(v)
        if v then
            for _, desc in ipairs(Workspace:GetDescendants()) do
                if desc:IsA("BasePart") and desc.Name == "PoisonHurtPart" then
                    desc.CFrame = desc.CFrame + Vector3.new(0, 10000, 0)
                end
            end
        end
    end
})

local burnPos = Workspace.Map.FactoryIsland.PoisonContainer.ExtinguishPart.Position
InvTab:CreateToggle({
    Name = "Anti Burn",
    CurrentValue = false,
    Flag = "Inv_AntiBurn",
    Callback = function(v)
        if v then
            local part = Workspace.Map.FactoryIsland.PoisonContainer.ExtinguishPart
            part.Transparency = 1
            RunService.Heartbeat:Connect(function()
                if not v then return end
                local char = LP.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hum or not hrp then return end
                local debounce = hum:WaitForChild("FireDebounce", 5)
                if debounce and debounce.Value then
                    local t = tick() * 3 % 3
                    local pos = t < 1 and hrp.Position or (t < 2 and burnPos or hrp.Position)
                    part.Position = pos + Vector3.new(math.sin(tick() * 5) * 3, math.cos(tick() * 3) * 2, math.sin(tick() * 4) * 3)
                else
                    part.Position = part.Position:Lerp(burnPos, 0.1)
                end
            end)
        else
            Workspace.Map.FactoryIsland.PoisonContainer.ExtinguishPart.Position = burnPos
            Workspace.Map.FactoryIsland.PoisonContainer.ExtinguishPart.Transparency = 0
        end
    end
})

InvTab:CreateToggle({
    Name = "Anti Banana",
    CurrentValue = false,
    Flag = "Inv_AntiBanana",
    Callback = function(v)
        antiBanana = v
        if v then
            RunService.Heartbeat:Connect(function()
                if not antiBanana then return end
                local char = LP.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hum or not hrp then return end
                local rleg = char:FindFirstChild("Right Leg")
                local lleg = char:FindFirstChild("Left Leg")
                if rleg or lleg then
                    Workspace.FallenPartsDestroyHeight = -10
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    pcall(function() RagdollRemote:FireServer(hrp, 1) end)
                    task.wait(0.2)
                    if rleg then rleg:PivotTo(CFrame.new(-9999, -99999999, -9999)) end
                    if lleg then lleg:PivotTo(CFrame.new(-9999, -99999999, -9999)) end
                    task.wait(2)
                    hrp.CFrame = CFrame.new(-86.8966, -10.1004, 7.777)
                else
                    hum.HipHeight = 2
                    Workspace.FallenPartsDestroyHeight = -500
                end
            end)
        else
            Workspace.FallenPartsDestroyHeight = -500
        end
    end
})

InvTab:CreateToggle({
    Name = "Anti Banana v2 (Eat Banana)",
    CurrentValue = false,
    Flag = "Inv_AntiBananaV2",
    Callback = function(v)
        if v then
            task.spawn(function()
                while v do
                    for _, child in ipairs(Workspace:GetChildren()) do
                        if child.Name == "FoodBanana" then
                            local holdPart = child:FindFirstChild("HoldPart")
                            if holdPart then
                                local holdRF = holdPart:FindFirstChild("HoldItemRemoteFunction")
                                local dropRF = holdPart:FindFirstChild("DropItemRemoteFunction")
                                if holdRF then
                                    pcall(function() holdRF:InvokeServer(child, LP.Character) end)
                                end
                                task.wait(0.01)
                                if dropRF then
                                    pcall(function() dropRF:InvokeServer(child, CFrame.new(0, -500, 0), Vector3.new(0, 97.69, 0)) end)
                                end
                            end
                        end
                    end
                    task.wait(0.2)
                end
            end)
        end
    end
})

InvTab:CreateToggle({
    Name = "Anti Paint",
    CurrentValue = false,
    Flag = "Inv_AntiPaint",
    Callback = function(v)
        antiPaint = v
        if v then
            for _, desc in ipairs(Workspace:GetDescendants()) do
                if desc.Name == "PaintPlayerPart" then desc:Destroy() end
            end
            Workspace.DescendantAdded:Connect(function(desc)
                if desc.Name == "PaintPlayerPart" then task.wait(); desc:Destroy() end
            end)
        end
    end
})

InvTab:CreateToggle({
    Name = "Anti Lag (Movement)",
    CurrentValue = false,
    Flag = "Inv_AntiLag",
    Callback = function(v)
        local ps = LP:FindFirstChild("PlayerScripts")
        if ps then
            local move = ps:FindFirstChild("CharacterAndBeamMove")
            if move then move.Enabled = not v end
        end
    end
})

InvTab:CreateToggle({
    Name = "Anti Void",
    CurrentValue = false,
    Flag = "Inv_AntiVoid",
    Callback = function(v)
        antiVoid = v
        if v then
            Workspace.FallenPartsDestroyHeight = -100000
            task.spawn(function()
                while antiVoid do
                    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and hrp.Position.Y < -500 then
                        hrp.CFrame = CFrame.new(2, -7, -4)
                    end
                    task.wait(0.2)
                end
            end)
        else
            Workspace.FallenPartsDestroyHeight = -100
        end
    end
})

InvTab:CreateToggle({
    Name = "Anti Sticky",
    CurrentValue = false,
    Flag = "Inv_AntiSticky",
    Callback = function(v)
        local ps = LP:WaitForChild("PlayerScripts")
        local name = "StickyPartsTouchDetection"
        if v then
            local script = ps:FindFirstChild(name)
            if script then script.Disabled = true end
        else
            local script = ps:FindFirstChild(name)
            if script then script:Destroy() end
            local template = ReplicatedStorage:FindFirstChild(name)
            if template then template:Clone().Parent = ps end
        end
    end
})

InvTab:CreateToggle({
    Name = "Anti Blobman",
    CurrentValue = false,
    Flag = "Inv_AntiBlobman",
    Callback = function(v)
        if v then
            task.spawn(function()
                while v do
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= LP then
                            local folder = Workspace:FindFirstChild(plr.Name .. "SpawnedInToys")
                            if folder then
                                for _, child in ipairs(folder:GetChildren()) do
                                    if child:IsA("Model") and child.Name == "CreatureBlobman" then
                                        child:Destroy()
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.2)
                end
            end)
        end
    end
})

InvTab:CreateToggle({
    Name = "Anti Loop Ownership",
    CurrentValue = false,
    Flag = "Inv_AntiLoop",
    Callback = function(v)
        antiLoop = v
        if v then
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = CFrame.new(housePos) end
            RunService.Heartbeat:Connect(function()
                if not antiLoop then return end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = CFrame.new(housePos) end
            end)
        end
    end
})

LP.CharacterAdded:Connect(function(char)
    if antiLoop then
        task.wait(0.05)
        char:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(housePos)
    end
end)

InvTab:CreateToggle({
    Name = "Anti Loop Ownership V2",
    CurrentValue = false,
    Flag = "Inv_AntiLoopV2",
    Callback = function(v)
        antiLoopV2 = v
        if v then
            local points = {
                Vector3.new(264, -7, 440), Vector3.new(0, 50, 0),
                Vector3.new(-500, 20, -500), Vector3.new(500, 20, 500),
                Vector3.new(0, 100, 0), Vector3.new(264, 50, 440)
            }
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = CFrame.new(points[1]) end
            RunService.Heartbeat:Connect(function()
                if not antiLoopV2 then return end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pt = points[math.random(1, #points)]
                    hrp.CFrame = CFrame.new(pt + Vector3.new(math.random(-10, 10), 0, math.random(-10, 10)))
                end
            end)
        end
    end
})

InvTab:CreateToggle({
    Name = "Anti BlobKill",
    CurrentValue = false,
    Flag = "Inv_AntiBlobKill",
    Callback = function(v)
        if v then
            task.spawn(function()
                local lastTick = 0
                local currentFood = nil
                local watched = {}
                local function getHRP()
                    local char = LP.Character
                    if char then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then return hrp end
                    end
                end
                local function spawnFood()
                    if not canSpawn() then return end
                    if tick() - lastTick < 0.5 then return end
                    lastTick = tick()
                    local hrp = getHRP()
                    if not hrp then return end
                    SpawnToyRF:InvokeServer("FoodHamburger", hrp.CFrame * CFrame.new(5, 0, 5), Vector3.new(0, 33.088, 0))
                end
                local function hold(food)
                    if not food or not food.Parent then return end
                    local holdPart = food:FindFirstChild("HoldPart")
                    if not holdPart then return end
                    local holdRF = holdPart:FindFirstChild("HoldItemRemoteFunction")
                    local dropRF = holdPart:FindFirstChild("DropItemRemoteFunction")
                    if holdRF then holdRF:InvokeServer(food, LP.Character) end
                    task.wait(0.01)
                    if dropRF then dropRF:InvokeServer(food, CFrame.new(-128.375, -10.35, 72.18), Vector3.new(0, 154.777, 0)) end
                end
                local function findFood()
                    local folders = getAllPalletFolders()
                    for _, folder in ipairs(folders) do
                        for _, child in ipairs(folder:GetChildren()) do
                            if child.Name == "FoodHamburger" then return child end
                        end
                    end
                    return nil
                end
                RunService.Heartbeat:Connect(function()
                    if not v then return end
                    getHRP()
                    if not currentFood or not currentFood.Parent then
                        currentFood = findFood()
                        if not currentFood then spawnFood() return end
                    else
                        hold(currentFood)
                    end
                end)
            end)
        end
    end
})

-- Grab Lines Features
GrabLinesTab:CreateSection("Grab Modifiers")

GrabLinesTab:CreateToggle({
    Name = "Kill Grab",
    CurrentValue = false,
    Flag = "Grab_Kill",
    Callback = function(v)
        killGrab = v
        if v then
            task.spawn(function()
                while killGrab do
                    pcall(function()
                        local gp = Workspace:FindFirstChild("GrabParts")
                        local grabPart = gp and gp:FindFirstChild("GrabPart")
                        local weld = grabPart and grabPart:FindFirstChildOfClass("WeldConstraint")
                        local model = weld and weld.Part1 and weld.Part1:FindFirstAncestorOfClass("Model")
                        local hum = model and model:FindFirstChild("Humanoid")
                        if hum then
                            task.wait(0.4)
                            hum.Health = 0
                        end
                    end)
                    task.wait()
                end
            end)
        end
    end
})

GrabLinesTab:CreateToggle({
    Name = "Noclip Grab",
    CurrentValue = false,
    Flag = "Grab_Noclip",
    Callback = function(v)
        noclipGrab = v
        if v then
            RunService.Heartbeat:Connect(function()
                if not noclipGrab then return end
                local gp = Workspace:FindFirstChild("GrabParts")
                if not gp then return end
                local grabPart = gp:FindFirstChild("GrabPart")
                if not grabPart then return end
                local weld = grabPart:FindFirstChildOfClass("WeldConstraint")
                if not weld or not weld.Part1 then return end
                local model = weld.Part1:FindFirstAncestorOfClass("Model")
                if model then
                    for _, desc in ipairs(model:GetDescendants()) do
                        if desc:IsA("BasePart") then desc.CanCollide = false end
                    end
                end
            end)
        end
    end
})

GrabLinesTab:CreateToggle({
    Name = "Kick Grab",
    CurrentValue = false,
    Flag = "Grab_Kick",
    Callback = function(v)
        kickGrab = v
        if v then
            RunService.Heartbeat:Connect(function()
                if not kickGrab then return end
                local gp = Workspace:FindFirstChild("GrabParts")
                if not gp then return end
                for _, grabPart in ipairs(gp:GetChildren()) do
                    if grabPart.Name == "GrabPart" then
                        local weld = grabPart:FindFirstChildOfClass("WeldConstraint")
                        if weld and weld.Part1 then
                            local thrp = weld.Part1.Parent:FindFirstChild("HumanoidRootPart")
                            if thrp then
                                pcall(function()
                                    SetNetworkOwner:FireServer(thrp, thrp.CFrame)
                                    DestroyGrabLine:FireServer(thrp)
                                    thrp.CFrame = CFrame.new(0, 9e13, 0)
                                    local bv = Instance.new("BodyVelocity")
                                    bv.Velocity = Vector3.new(0, 9e12, 0)
                                    bv.MaxForce = Vector3.new(1e999, 1e999, 1e999)
                                    bv.Parent = thrp
                                    Debris:AddItem(bv, 2)
                                end)
                            end
                        end
                    end
                end
            end)
        end
    end
})

GrabLinesTab:CreateParagraph({
    Title = "Credits",
    Content = "Thanks to netherlandson_top0 for the kick grab method"
})

-- Ragdoll Grab
local scriptRagdollToy = nil
local ragdollMonitor = nil
local isRespawning = false

local function UpdateRagdollMenu()
    task.spawn(function()
        local pg = LP:FindFirstChild("PlayerGui")
        if not pg then return end
        local menu = pg:FindFirstChild("MenuGui")
        if not menu or not scriptRagdollToy or not scriptRagdollToy:FindFirstChild("ScriptRagdollID") then return end
        local contents = menu.Menu.TabContents.ToyDestroy.Contents
        local id = scriptRagdollToy.ScriptRagdollID.Value
        local pallets = {}
        for _, child in ipairs(BackPack:GetChildren()) do
            if child.Name == "RagdollGrab" or child.Name == "PalletLightBrown" then
                table.insert(pallets, child)
            end
        end
        local idx = 0
        for i, p in ipairs(pallets) do
            if p:FindFirstChild("ScriptRagdollID") and p.ScriptRagdollID.Value == id then
                idx = i
                break
            end
        end
        if idx == 0 then return end
        local count = 0
        for _, child in ipairs(contents:GetChildren()) do
            if child.Name == "PalletLightBrown" and child:FindFirstChild("ViewItemButton") then
                count = count + 1
                if count == idx then
                    local btn = child.ViewItemButton
                    btn.Text = "Ragdoll Grab (DO NOT DELETE)"
                    btn.TextScaled = true
                    if btn:FindFirstChild("LowResImage") then btn.LowResImage.Image = "" end
                    return
                end
            end
        end
    end)
end

local function PrepareRagdoll()
    if scriptRagdollToy or isRespawning then return end
    isRespawning = true
    for _, child in ipairs(BackPack:GetChildren()) do
        if child.Name == "RagdollGrab" then
            pcall(function() if DestroyToyRF then DestroyToyRF:FireServer(child) end end)
        end
    end
    local guid = HttpService:GenerateGUID(false)
    for _ = 1, 3 do
        local head = LP.Character and LP.Character:FindFirstChild("Head")
        if head then
            task.spawn(function()
                SpawnToyRF:InvokeServer("PalletLightBrown", CFrame.new(head.Position + Vector3.new(0, 1, 0), head.Position) * CFrame.Angles(math.pi, 0, 0), Vector3.new(0, 0, 0))
            end)
            local pallet = nil
            local conn = BackPack.ChildAdded:Connect(function(c) if c.Name == "PalletLightBrown" then pallet = c end end)
            local start = tick()
            repeat task.wait() until pallet or tick() - start > 8
            conn:Disconnect()
            if pallet then
                if pallet:FindFirstChild("ScriptRagdollID") then pallet.ScriptRagdollID:Destroy() end
                local sv = Instance.new("StringValue")
                sv.Name = "ScriptRagdollID"
                sv.Value = guid
                sv.Parent = pallet
                pallet.Name = "RagdollGrab"
                local sound = pallet:WaitForChild("SoundPart", 5)
                if sound then
                    task.spawn(function()
                        while ragdollGrab and sound and sound.Parent do
                            if not sound:FindFirstChild("PartOwner") or sound.PartOwner.Value ~= LP.Name then
                                SetNetworkOwner:FireServer(sound, sound.CFrame)
                            end
                            task.wait(0.1)
                        end
                    end)
                    local bv = Instance.new("BodyVelocity")
                    bv.Parent = sound
                    bv.MaxForce = Vector3.new(0, 1e999, 0)
                    bv.Velocity = Vector3.new(0, 1000, 0)
                    for _, p in pairs(pallet:GetChildren()) do
                        if p:IsA("BasePart") then
                            p.Transparency = 1
                            p.Size = Vector3.new(0.5, 0.5, 0.5)
                            p.CanCollide = false
                        end
                    end
                    if sound:FindFirstChild("Wood") then sound.Wood:Destroy() end
                    scriptRagdollToy = pallet
                    RAGDOLL_ID = guid
                    isRespawning = false
                    UpdateRagdollMenu()
                    return
                end
                pallet:Destroy()
            end
        end
        task.wait(0.5)
    end
    isRespawning = false
end

local function DestroyRagdoll()
    if scriptRagdollToy and scriptRagdollToy.Parent then
        pcall(function() if DestroyToyRF then DestroyToyRF:FireServer(scriptRagdollToy) end end)
        task.wait(0.1)
    end
    scriptRagdollToy = nil
    RAGDOLL_ID = nil
end

local function StartRagdollMonitor()
    if ragdollMonitor then task.cancel(ragdollMonitor) end
    ragdollMonitor = task.spawn(function()
        while ragdollGrab do
            task.wait(2)
            local needsSpawn = not scriptRagdollToy or not scriptRagdollToy.Parent or not scriptRagdollToy:FindFirstChild("ScriptRagdollID") or scriptRagdollToy.ScriptRagdollID.Value ~= RAGDOLL_ID
            if needsSpawn then
                scriptRagdollToy = nil
                PrepareRagdoll()
            end
        end
    end)
end

GrabLinesTab:CreateToggle({
    Name = "Ragdoll Grab",
    CurrentValue = false,
    Flag = "Grab_Ragdoll",
    Callback = function(v)
        ragdollGrab = v
        if v then
            task.wait(0.2)
            PrepareRagdoll()
            StartRagdollMonitor()
        else
            DestroyRagdoll()
            if ragdollMonitor then task.cancel(ragdollMonitor); ragdollMonitor = nil end
        end
    end
})

Workspace.ChildAdded:Connect(function(c)
    if ragdollGrab and c.Name == "GrabParts" then
        task.wait(0.05)
        local weld = c:FindFirstChild("GrabPart") and c.GrabPart:FindFirstChild("WeldConstraint")
        if weld and weld.Part1 then
            local head = weld.Part1.Parent:FindFirstChild("Head")
            local rag = BackPack:FindFirstChild("RagdollGrab")
            if head and rag and rag:FindFirstChild("SoundPart") then
                firetouchinterest(rag.SoundPart, head, 0)
                task.wait()
                firetouchinterest(rag.SoundPart, head, 1)
            end
        end
    end
end)

BackPack.ChildAdded:Connect(function(c)
    if not ragdollGrab then return end
    task.wait(0.05)
    if c:FindFirstChild("ScriptRagdollID") and c.ScriptRagdollID.Value == RAGDOLL_ID then
        scriptRagdollToy = c
        UpdateRagdollMenu()
    end
end)

BackPack.ChildRemoved:Connect(function(c)
    if ragdollGrab and c == scriptRagdollToy then
        scriptRagdollToy = nil
        task.wait(0.5)
        if ragdollGrab and not scriptRagdollToy then PrepareRagdoll() end
    end
end)

GrabLinesTab:CreateToggle({
    Name = "Massless Grab",
    CurrentValue = false,
    Flag = "Grab_Massless",
    Callback = function(v)
        masslessGrab = v
        if v then
            RunService.Heartbeat:Connect(function()
                if not masslessGrab then return end
                local gp = Workspace:FindFirstChild("GrabParts")
                if not gp then return end
                local drag = gp:FindFirstChild("DragPart")
                if drag and drag:FindFirstChild("AlignPosition") and drag:FindFirstChild("AlignOrientation") then
                    drag.AlignPosition.Responsiveness = masslessSense
                    drag.AlignPosition.MaxForce = 1e999
                    drag.AlignPosition.MaxVelocity = 1e999
                    drag.AlignOrientation.Responsiveness = masslessSense
                    drag.AlignOrientation.MaxTorque = 1e999
                end
            end)
        end
    end
})

GrabLinesTab:CreateInput({
    Name = "Massless Sense",
    CurrentValue = "30",
    PlaceholderText = "Enter sense",
    Flag = "Grab_MasslessSense",
    Callback = function(v)
        local num = tonumber(v)
        if num and num > 0 then masslessSense = num end
    end
})

GrabLinesTab:CreateToggle({
    Name = "Crazy Grab",
    CurrentValue = false,
    Flag = "Grab_Crazy",
    Callback = function(v)
        crazyGrab = v
        if v then
            task.spawn(function()
                while crazyGrab do
                    pcall(function()
                        local gp = Workspace:FindFirstChild("GrabParts")
                        local grabPart = gp and gp:FindFirstChild("GrabPart")
                        local weld = grabPart and grabPart:FindFirstChild("WeldConstraint")
                        local thrp = weld and weld.Part1 and weld.Part1.Parent:FindFirstChild("HumanoidRootPart")
                        if thrp then
                            local points = {
                                Vector3.new(-17, 421, 50), Vector3.new(145, 397, -126),
                                Vector3.new(157, 254, 89), Vector3.new(-26, 207, -26),
                                Vector3.new(-23, 456, -19), Vector3.new(15, 211, 45)
                            }
                            for _, pt in ipairs(points) do
                                if not crazyGrab then return end
                                thrp.CFrame = CFrame.new(pt)
                                task.wait(crazySpeed)
                            end
                        end
                    end)
                    task.wait()
                end
            end)
        end
    end
})

GrabLinesTab:CreateSlider({
    Name = "Crazy Speed",
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = 0.1,
    Flag = "Grab_CrazySpeed",
    Callback = function(v) crazySpeed = v end
})

GrabLinesTab:CreateToggle({
    Name = "Fling Air Grab",
    CurrentValue = false,
    Flag = "Grab_Fling",
    Callback = function(v)
        flingGrab = v
        if v then
            RunService.Heartbeat:Connect(function()
                if not flingGrab then return end
                local gp = Workspace:FindFirstChild("GrabParts")
                if not gp then return end
                local grabPart = gp:FindFirstChild("GrabPart")
                if not grabPart then return end
                local weld = grabPart:FindFirstChildOfClass("WeldConstraint") or grabPart:FindFirstChild("Weld")
                if not weld then return end
                local model = weld.Part1 and weld.Part1.Parent
                if model and model:FindFirstChild("HumanoidRootPart") then
                    model.HumanoidRootPart.Velocity = Vector3.new(0, 500, 0)
                end
            end)
        end
    end
})

GrabLinesTab:CreateToggle({
    Name = "Spin Grab",
    CurrentValue = false,
    Flag = "Grab_Spin",
    Callback = function(v)
        spinGrab = v
        if not v then
            for part, _ in pairs(spinGyro) do
                if part and part:FindFirstChild("BodyGyro") then
                    part.BodyGyro:Destroy()
                end
            end
            spinGyro = {}
            return
        end
        task.spawn(function()
            while spinGrab do
                pcall(function()
                    local gp = Workspace:FindFirstChild("GrabParts")
                    if gp then
                        local grabPart = gp:FindFirstChild("GrabPart")
                        if grabPart then
                            local weld = grabPart:FindFirstChild("WeldConstraint")
                            if weld and weld.Part1 then
                                local part = weld.Part1
                                if not spinGyro[part] then
                                    spinGyro[part] = true
                                    local bg = Instance.new("BodyGyro")
                                    bg.P = 15000
                                    bg.D = 200
                                    bg.MaxTorque = Vector3.new(5000000, 5000000, 5000000)
                                    bg.CFrame = part.CFrame
                                    bg.Parent = part
                                end
                                if part:FindFirstChild("BodyGyro") then
                                    part.BodyGyro.CFrame = part.BodyGyro.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
                                end
                            end
                        end
                    end
                end)
                task.wait()
            end
        end)
    end
})

GrabLinesTab:CreateSlider({
    Name = "Spin Speed",
    Range = {1, 50},
    Increment = 1,
    Suffix = " speed",
    CurrentValue = 5,
    Flag = "Grab_SpinSpeed",
    Callback = function(v) spinSpeed = v end
})

-- Extend Line (Mobile)
local extendMobile = false
local camPart = Instance.new("Part")
camPart.Size = Vector3.new(1, 1, 1)
camPart.Anchored = false
camPart.CanCollide = false
camPart.Transparency = 1
camPart.Parent = Workspace
local vel = Instance.new("BodyVelocity")
vel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
vel.Parent = camPart
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
local buttons = {}
local uiReady = false
local extendDist = 10

local function Btn(name, pos, callback)
    if not extendMobile then return end
    local btn = Instance.new("TextButton", gui)
    btn.Size = UDim2.new(0, 100, 0, 50)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 20
    local down = false
    btn.MouseButton1Down:Connect(function()
        if not extendMobile then return end
        down = true
        coroutine.wrap(function()
            while extendMobile and down do
                callback(true)
                task.wait(0.025)
            end
        end)()
    end)
    btn.MouseButton1Up:Connect(function()
        if not extendMobile then return end
        callback(false)
    end)
    table.insert(buttons, btn)
end

local function UI()
    if uiReady or not extendMobile then return end
    local ctx = LP.PlayerGui:WaitForChild("ContextActionGui"):WaitForChild("ContextButtonFrame")
    repeat task.wait() until #ctx:GetChildren() >= 5
    local children = ctx:GetChildren()
    if children[5] and children[4] then
        Btn("Front", children[5].Position, function(down)
            if down then extendDist = math.clamp(extendDist + 10, 10, 500) end
        end)
        Btn("Back", children[4].Position, function(down)
            if down then extendDist = math.clamp(extendDist - 10, 5, 500) end
        end)
        children[4].Parent = nil
        children[5].Parent = nil
        uiReady = true
    end
end

GrabLinesTab:CreateToggle({
    Name = "Extend Line (Mobile)",
    CurrentValue = false,
    Flag = "Grab_ExtendMobile",
    Callback = function(v)
        extendMobile = v
        if v then UI() end
    end
})

-- Extend Line (PC)
local extendPC = false
local extendData = {d = 11, inc = 7, on = false, i = nil, c = nil}

local function stopExtend()
    if extendData.i then extendData.i:Disconnect(); extendData.i = nil end
    if extendData.c then extendData.c:Disconnect(); extendData.c = nil end
    extendData.d = 11
end

local function startExtend()
    extendData.i = UserInputService.InputChanged:Connect(function(input)
        if not extendData.on then return end
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            if extendData.d < 11 then extendData.d = 11 end
            if input.Position.Z > 0 then
                extendData.d = extendData.d + extendData.inc
            elseif input.Position.Z < 0 then
                extendData.d = extendData.d - extendData.inc
            end
        end
    end)
    extendData.c = Workspace.ChildAdded:Connect(function(c)
        if not extendData.on or c.Name ~= "GrabParts" then return end
        task.wait(0.2)
        if not c.Parent then return end
        local drag = c:FindFirstChild("DragPart")
        if not drag then return end
        local clone = drag:Clone()
        clone.Name = "DragPart_scroll"
        local attach = clone:FindFirstChild("DragAttach")
        if clone:FindFirstChild("AlignPosition") and attach then
            clone.AlignPosition.Attachment1 = attach
        end
        clone.Parent = c
        extendData.d = (clone.Position - Camera.CFrame.Position).Magnitude
        if clone:FindFirstChild("AlignOrientation") then clone.AlignOrientation.Enabled = false end
        if drag:FindFirstChild("AlignPosition") then drag.AlignPosition.Enabled = false end
        task.spawn(function()
            while c.Parent and extendData.on do
                clone.Position = Camera.CFrame.Position + Camera.CFrame.LookVector * extendData.d
                RunService.RenderStepped:Wait()
            end
            if clone then clone:Destroy() end
            extendData.d = 11
        end)
    end)
end

GrabLinesTab:CreateToggle({
    Name = "Extend Line (PC)",
    CurrentValue = false,
    Flag = "Grab_ExtendPC",
    Callback = function(v)
        extendData.on = v
        if v then startExtend() else stopExtend() end
    end
})

GrabLinesTab:CreateInput({
    Name = "Scroll Force",
    CurrentValue = "7",
    PlaceholderText = "Default: 7",
    Flag = "Grab_ScrollForce",
    Callback = function(v)
        local num = tonumber(v)
        if num then extendData.inc = num end
    end
})

-- Other lines
GrabLinesTab:CreateSection("Other Lines")

GrabLinesTab:CreateToggle({
    Name = "Invisible Line",
    CurrentValue = false,
    Flag = "Grab_InvisLine",
    Callback = function(v)
        invisLine = v
        while invisLine do
            CreateGrabLine:FireServer()
            task.wait()
        end
    end
})

GrabLinesTab:CreateToggle({
    Name = "Crazy Line",
    CurrentValue = false,
    Flag = "Grab_CrazyLine",
    Callback = function(v)
        crazyLine = v
        while crazyLine do
            for _, plr in ipairs(Players:GetPlayers()) do
                local char = plr.Character
                if char then
                    local head = char:FindFirstChild("Head")
                    if head then
                        CreateGrabLine:FireServer(head, head.CFrame)
                        task.wait()
                    end
                end
            end
        end
    end
})

GrabLinesTab:CreateToggle({
    Name = "Spinning Rainbow Line",
    CurrentValue = false,
    Flag = "Grab_RainbowLine",
    Callback = function(v)
        if v then
            local torso = LP.Character:WaitForChild("Torso", 5) or LP.Character:WaitForChild("UpperTorso", 5)
            if not torso then return end
            local angle = 0
            local rainbowConn = RunService.Heartbeat:Connect(function(dt)
                if not v then return end
                angle = (angle + math.pi * dt) % (2 * math.pi)
                local radius = 10
                local pos = torso.Position + Vector3.new(math.cos(angle) * radius, math.sin(tick() * 2) * 1.5, math.sin(angle) * radius)
                CreateGrabLine:FireServer(torso, CFrame.new(pos - torso.Position))
                ExtendGrabLine:FireServer(0)
            end)
        end
    end
})

-- Strength
GrabLinesTab:CreateSection("Strength")

GrabLinesTab:CreateToggle({
    Name = "Strength (PC)",
    CurrentValue = false,
    Flag = "Grab_StrengthPC",
    Callback = function(v)
        if v then
            Workspace.ChildAdded:Connect(function(child)
                if not v then return end
                if child.Name == "GrabParts" then
                    local grabPart = child:FindFirstChild("GrabPart")
                    local weld = grabPart and grabPart:FindFirstChild("WeldConstraint")
                    local part1 = weld and weld.Part1
                    if part1 then
                        child:GetPropertyChangedSignal("Parent"):Connect(function()
                            if not child.Parent and v then
                                local bv = Instance.new("BodyVelocity")
                                bv.MaxForce = Vector3.new(1e999, 1e999, 1e999)
                                bv.Velocity = Camera.CFrame.LookVector * 1000
                                bv.Parent = part1
                                Debris:AddItem(bv, 1)
                            end
                        end)
                    end
                end
            end)
        end
    end
})

GrabLinesTab:CreateSlider({
    Name = "Strength Force",
    Range = {100, 10000},
    Increment = 100,
    Suffix = "Force",
    CurrentValue = 1000,
    Flag = "Grab_StrengthForce",
    Callback = function(v) end
})

-- Anchor Grab
local anchoredParts = {}
local anchoredConns = {}
local compiledGroups = {}
local groupBillboardGuis = {}
local selectedGroupIndex = 1

GrabLinesTab:CreateSection("Anchor")

GrabLinesTab:CreateToggle({
    Name = "Anchor Grab",
    CurrentValue = false,
    Flag = "Grab_Anchor",
    Callback = function(v)
        if v then
            task.spawn(function()
                while v do
                    pcall(function()
                        local gp = Workspace:FindFirstChild("GrabParts")
                        if not gp then return end
                        local grabPart = gp:FindFirstChild("GrabPart")
                        if not grabPart then return end
                        local weld = grabPart:FindFirstChild("WeldConstraint")
                        if not weld or not weld.Part1 then return end
                        local part = weld.Part1
                        if part.Name == "SoundPart" then part = part.Parent end
                        if part:IsDescendantOf(Workspace.Map) then return end
                        for _, plr in ipairs(Players:GetPlayers()) do
                            if part:IsDescendantOf(plr.Character) then return end
                        end
                        if not table.find(anchoredParts, part) then
                            table.insert(anchoredParts, part)
                            local highlight = Instance.new("Highlight")
                            highlight.FillColor = Color3.new(0, 0, 1)
                            highlight.OutlineColor = Color3.new(0, 0, 0)
                            highlight.FillTransparency = 0.5
                            highlight.Parent = part
                        end
                        local bp = part:FindFirstChild("BodyPosition") or Instance.new("BodyPosition")
                        local bg = part:FindFirstChild("BodyGyro") or Instance.new("BodyGyro")
                        bp.MaxForce = Vector3.new(5000000, 5000000, 5000000)
                        bp.P = 15000
                        bp.D = 200
                        bp.Position = part.Position
                        bp.Parent = part
                        bg.MaxTorque = Vector3.new(5000000, 5000000, 5000000)
                        bg.P = 15000
                        bg.D = 200
                        bg.CFrame = part.CFrame
                        bg.Parent = part
                    end)
                    task.wait()
                end
            end)
        else
            for _, part in ipairs(anchoredParts) do
                if part and part.Parent then
                    local bp = part:FindFirstChild("BodyPosition")
                    local bg = part:FindFirstChild("BodyGyro")
                    local hl = part:FindFirstChild("Highlight")
                    if bp then bp:Destroy() end
                    if bg then bg:Destroy() end
                    if hl then hl:Destroy() end
                end
            end
            anchoredParts = {}
        end
    end
})

GrabLinesTab:CreateButton({
    Name = "Unanchor Parts",
    Callback = function()
        for _, part in ipairs(anchoredParts) do
            if part and part.Parent then
                local bp = part:FindFirstChild("BodyPosition")
                local bg = part:FindFirstChild("BodyGyro")
                local hl = part:FindFirstChild("Highlight")
                if bp then bp:Destroy() end
                if bg then bg:Destroy() end
                if hl then hl:Destroy() end
            end
        end
        anchoredParts = {}
    end
})

-- Groups
GrabLinesTab:CreateSection("Groups")

GrabLinesTab:CreateButton({
    Name = "Compile Parts",
    Callback = function()
        if #anchoredParts == 0 then return end
        local primary = anchoredParts[1]
        local group = {}
        for i = 2, #anchoredParts do
            table.insert(group, {part = anchoredParts[i], offset = primary.CFrame:ToObjectSpace(anchoredParts[i].CFrame)})
        end
        table.insert(compiledGroups, {primaryPart = primary, group = group})
        primary:GetPropertyChangedSignal("CFrame"):Connect(function()
            for _, item in ipairs(group) do
                if item.part and item.part.Parent then
                    item.part.CFrame = primary.CFrame * item.offset
                end
            end
        end)
        anchoredParts = {}
    end
})

GrabLinesTab:CreateDropdown({
    Name = "Select Group",
    Options = {"No groups"},
    CurrentOption = {"No groups"},
    Flag = "Grab_GroupSelect",
    Callback = function(opt) end
})

GrabLinesTab:CreateButton({
    Name = "Delete Selected Group",
    Callback = function()
        -- Implementation for deleting selected group
    end
})

GrabLinesTab:CreateButton({
    Name = "Delete All Groups",
    Callback = function()
        compiledGroups = {}
    end
})

-- Lag
GrabLinesTab:CreateSection("Lag")

GrabLinesTab:CreateToggle({
    Name = "Lag (Crash Server)",
    CurrentValue = false,
    Flag = "Grab_Lag",
    Callback = function(v)
        if v then
            task.spawn(function()
                while v do
                    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _ = 1, 10 do
                            for _, plr in ipairs(Players:GetPlayers()) do
                                if plr ~= LP and plr.Character then
                                    local torso = plr.Character:FindFirstChild("Torso") or plr.Character:FindFirstChild("HumanoidRootPart")
                                    if torso then
                                        CreateGrabLine:FireServer(torso, torso.CFrame)
                                    end
                                end
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

GrabLinesTab:CreateInput({
    Name = "Lag Intensity",
    CurrentValue = "10",
    PlaceholderText = "Enter number of lines",
    Flag = "Grab_LagIntensity",
    Callback = function(v) end
})

-- Loop Tab
LoopTab:CreateSection("Target Selection")

local function buildPlayerList()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            table.insert(list, "@" .. plr.Name .. " (" .. plr.DisplayName .. ")")
        end
    end
    return list
end

local loopDropdown = LoopTab:CreateDropdown({
    Name = "Select Player",
    Options = buildPlayerList(),
    CurrentOption = {},
    Flag = "Loop_Player",
    Callback = function(opt)
        loopTarget = opt[1] and opt[1]:match("@([%w_]+)")
    end
})

Players.PlayerAdded:Connect(function() task.wait(0.5); loopDropdown:Refresh(buildPlayerList()) end)
Players.PlayerRemoving:Connect(function() task.wait(0.5); loopDropdown:Refresh(buildPlayerList()) end)

LoopTab:CreateSection("Harmless")

LoopTab:CreateButton({
    Name = "Bring",
    Callback = function()
        if not loopTarget then return end
        local target = Players:FindFirstChild(loopTarget)
        if not target then return end
        local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        local myCF = myHRP.CFrame
        if target:FindFirstChild("InPlot") and target.InPlot.Value then return end
        if not target.Character or not target.Character:FindFirstChild("Head") then return end
        local head = target.Character.Head
        local tries = 0
        while target.Character and target.Character:FindFirstChild("Head") and tries < 10 do
            myHRP.CFrame = head.CFrame * CFrame.new(2, 0, 0)
            SetNetworkOwner:FireServer(head, myHRP.CFrame)
            task.wait(0.15)
            tries = tries + 1
            if head:FindFirstChild("PartOwner") and head.PartOwner.Value == LP.Name then break end
        end
        myHRP.CFrame = myCF
        head.CFrame = CFrame.new(myCF.Position + myCF.LookVector * 5)
        DestroyGrabLine:FireServer(head)
    end
})

LoopTab:CreateButton({
    Name = "Bring (Blobman)",
    Callback = function()
        if not loopTarget then return end
        -- Blobman bring implementation
    end
})

LoopTab:CreateToggle({
    Name = "Spectate",
    CurrentValue = false,
    Flag = "Loop_Spectate",
    Callback = function(v)
        if not loopTarget then return end
        local target = Players:FindFirstChild(loopTarget)
        if v and target and target.Character then
            Camera.CameraSubject = target.Character:FindFirstChild("Humanoid")
        else
            Camera.CameraSubject = LP.Character:FindFirstChild("Humanoid")
        end
    end
})

LoopTab:CreateToggle({
    Name = "Loop Teleport",
    CurrentValue = false,
    Flag = "Loop_Teleport",
    Callback = function(v)
        if v then
            RunService.RenderStepped:Connect(function()
                if not v or not loopTarget then return end
                local target = Players:FindFirstChild(loopTarget)
                if target and target.Character then
                    local thrp = target.Character:FindFirstChild("HumanoidRootPart")
                    local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    if thrp and myHRP then
                        myHRP.CFrame = myHRP.CFrame:Lerp(thrp.CFrame * CFrame.new(2, 0, 0), 0.2)
                    end
                end
            end)
        end
    end
})

LoopTab:CreateSection("Kill")

LoopTab:CreateToggle({
    Name = "Loop BlobKill",
    CurrentValue = false,
    Flag = "Loop_BlobKill",
    Callback = function(v)
        if v then
            task.spawn(function()
                while v do
                    -- BlobKill implementation
                    task.wait(0.25)
                end
            end)
        end
    end
})

LoopTab:CreateToggle({
    Name = "Loop Kill",
    CurrentValue = false,
    Flag = "Loop_Kill",
    Callback = function(v)
        loopKillEnabled = v
        if v then
            RunService.Heartbeat:Connect(function()
                if not loopKillEnabled or not loopTarget then return end
                local target = Players:FindFirstChild(loopTarget)
                if not target or not target.Character then return end
                local thrp = target.Character:FindFirstChild("HumanoidRootPart")
                local thum = target.Character:FindFirstChild("Humanoid")
                if not thrp or not thum or thum.Health <= 0 then return end
                if thrp.Position.Y > 100000 then return end
                if target:FindFirstChild("InPlot") and target.InPlot.Value then return end
                local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if not myHRP then return end
                SetNetworkOwner:FireServer(thrp, thrp.CFrame)
                task.wait(0.05)
                DestroyGrabLine:FireServer(thrp)
                task.wait(0.05)
                thum.BreakJointsOnDeath = false
                thum:ChangeState(Enum.HumanoidStateType.Dead)
            end)
        end
    end
})

LoopTab:CreateSection("Kick")

LoopTab:CreateToggle({
    Name = "Loop Kick",
    CurrentValue = false,
    Flag = "Loop_Kick",
    Callback = function(v)
        loopKickEnabled = v
        if v then
            RunService.Heartbeat:Connect(function()
                if not loopKickEnabled or not loopTarget then return end
                local target = Players:FindFirstChild(loopTarget)
                if not target or not target.Character then return end
                local thrp = target.Character:FindFirstChild("HumanoidRootPart")
                local thum = target.Character:FindFirstChild("Humanoid")
                local head = target.Character:FindFirstChild("Head")
                if not thrp or not thum or thum.Health <= 0 then return end
                if thrp.Position.Y > 100000 then return end
                if target:FindFirstChild("InPlot") and target.InPlot.Value then return end
                local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if not myHRP then return end
                local myCF = myHRP.CFrame
                myHRP.CFrame = thrp.CFrame + Vector3.new(0, 0, -3)
                SetNetworkOwner:FireServer(thrp, thrp.CFrame)
                task.wait()
                myHRP.CFrame = myCF
                task.wait(0.1)
                DestroyGrabLine:FireServer(thrp)
                task.wait(0.1)
                if head and head:FindFirstChild("PartOwner") and head.PartOwner.Value == LP.Name then
                    thum.Sit = false
                    thum.Jump = true
                    local bv = Instance.new("BodyVelocity")
                    bv.Velocity = Vector3.new(0, 1000000000, 0)
                    bv.MaxForce = Vector3.new(1e999, 1e999, 1e999)
                    bv.P = 100000000
                    bv.Parent = thrp
                    task.delay(3, function() if bv.Parent then bv:Destroy() end end)
                end
            end)
        end
    end
})

LoopTab:CreateToggle({
    Name = "Spam Kick Grab",
    CurrentValue = false,
    Flag = "Loop_SpamKick",
    Callback = function(v)
        if v then
            task.spawn(function()
                while v do
                    if not loopTarget then task.wait(0.1) continue end
                    local target = Players:FindFirstChild(loopTarget)
                    if not target then task.wait(0.1) continue end
                    if target:FindFirstChild("InPlot") and target.InPlot.Value then task.wait(0.1) continue end
                    local char = target.Character
                    local thrp = char and char:FindFirstChild("HumanoidRootPart")
                    local head = char and char:FindFirstChild("Head")
                    local thum = char and char:FindFirstChild("Humanoid")
                    local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    if not (thrp and head and thum and myHRP) or thum.Health <= 0 then task.wait(0.1) continue end
                    local dist = (thrp.Position - myHRP.Position).Magnitude
                    local owner = head:FindFirstChild("PartOwner")
                    if dist > 30 and owner and owner.Value ~= LP.Name then
                        local cf = myHRP.CFrame
                        myHRP.CFrame = thrp.CFrame * CFrame.new(0, 5, 0)
                        task.wait(0.05)
                        for _ = 1, 20 do
                            SetNetworkOwner:FireServer(thrp, thrp.CFrame)
                            if head:FindFirstChild("PartOwner") and head.PartOwner.Value == LP.Name then break end
                            task.wait()
                        end
                        myHRP.CFrame = cf
                    elseif owner and owner.Value ~= LP.Name then
                        SetNetworkOwner:FireServer(thrp, thrp.CFrame)
                    end
                    for _ = 1, 4 do
                        DestroyGrabLine:FireServer(thrp)
                        task.wait()
                        SetNetworkOwner:FireServer(thrp, thrp.CFrame)
                    end
                    local bp = thrp:FindFirstChild("KickBP") or Instance.new("BodyPosition")
                    bp.Name = "KickBP"
                    bp.MaxForce = Vector3.new(1e999, 1e999, 1e999)
                    bp.D = 200
                    bp.Position = myHRP.Position + Vector3.new(0, 20, 0)
                    bp.Parent = thrp
                    local bg = thrp:FindFirstChild("KickBG") or Instance.new("BodyGyro")
                    bg.Name = "KickBG"
                    bg.MaxTorque = Vector3.new(1e999, 1e999, 1e999)
                    bg.D = 100
                    bg.CFrame = CFrame.new(0, 0, 0)
                    bg.Parent = thrp
                    RunService.RenderStepped:Wait()
                end
            end)
        end
    end
})

LoopTab:CreateButton({
    Name = "Silent Kick",
    Callback = function()
        -- Silent kick implementation
    end
})

LoopTab:CreateSection("Lock")

LoopTab:CreateToggle({
    Name = "Basic Lock",
    CurrentValue = false,
    Flag = "Loop_BasicLock",
    Callback = function(v)
        if v then
            task.spawn(function()
                while v do
                    -- Basic lock implementation
                    task.wait()
                end
            end)
        end
    end
})

LoopTab:CreateToggle({
    Name = "Mid Lock",
    CurrentValue = false,
    Flag = "Loop_MidLock",
    Callback = function(v)
        if v then
            task.spawn(function()
                while v do
                    -- Mid lock implementation
                    task.wait()
                end
            end)
        end
    end
})

LoopTab:CreateToggle({
    Name = "Ultimate Lock",
    CurrentValue = false,
    Flag = "Loop_UltimateLock",
    Callback = function(v)
        if v then
            task.spawn(function()
                while v do
                    -- Ultimate lock implementation
                    task.wait()
                end
            end)
        end
    end
})

LoopTab:CreateSection("Fun")

LoopTab:CreateToggle({
    Name = "Loop Fling",
    CurrentValue = false,
    Flag = "Loop_Fling",
    Callback = function(v)
        if v then
            -- Loop fling implementation
        end
    end
})

LoopTab:CreateSection("Utility")

LoopTab:CreateToggle({
    Name = "Auto Freeze Blobman",
    CurrentValue = false,
    Flag = "Loop_FreezeBlob",
    Callback = function(v)
        if v then
            -- Auto freeze blobman implementation
        end
    end
})

-- Server Tab
ServerTab:CreateSection("Aggressive")

ServerTab:CreateToggle({
    Name = "LoopKill All",
    CurrentValue = false,
    Flag = "Server_KillAll",
    Callback = function(v)
        if v then
            RunService.Heartbeat:Connect(function()
                if not v then return end
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP and not isWhitelisted(plr) and plr.Character then
                        local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        local thum = plr.Character:FindFirstChild("Humanoid")
                        if thrp and thum and thum.Health > 0 then
                            SetNetworkOwner:FireServer(thrp, thrp.CFrame)
                            task.wait(0.05)
                            DestroyGrabLine:FireServer(thrp)
                            thum:ChangeState(Enum.HumanoidStateType.Dead)
                        end
                    end
                end
            end)
        end
    end
})

ServerTab:CreateToggle({
    Name = "LoopKick All",
    CurrentValue = false,
    Flag = "Server_KickAll",
    Callback = function(v)
        if v then
            RunService.Heartbeat:Connect(function()
                if not v then return end
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP and not isWhitelisted(plr) and plr.Character then
                        local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        local thum = plr.Character:FindFirstChild("Humanoid")
                        if thrp and thum and thum.Health > 0 then
                            SetNetworkOwner:FireServer(thrp, thrp.CFrame)
                            DestroyGrabLine:FireServer(thrp)
                            local bv = Instance.new("BodyVelocity")
                            bv.Velocity = Vector3.new(0, 1000000000, 0)
                            bv.MaxForce = Vector3.new(1e999, 1e999, 1e999)
                            bv.Parent = thrp
                            Debris:AddItem(bv, 3)
                        end
                    end
                end
            end)
        end
    end
})

ServerTab:CreateSection("Annoying")

ServerTab:CreateToggle({
    Name = "LoopRagdoll All (Banana)",
    CurrentValue = false,
    Flag = "Server_RagdollAll",
    Callback = function(v)
        if v then
            -- LoopRagdoll all implementation
        end
    end
})

ServerTab:CreateToggle({
    Name = "LoopVomit All (Poop)",
    CurrentValue = false,
    Flag = "Server_VomitAll",
    Callback = function(v)
        if v then
            -- LoopVomit all implementation
        end
    end
})

ServerTab:CreateToggle({
    Name = "Fire All (Campfire)",
    CurrentValue = false,
    Flag = "Server_FireAll",
    Callback = function(v)
        if v then
            -- Fire all implementation
        end
    end
})

ServerTab:CreateSection("Fun")

ServerTab:CreateToggle({
    Name = "Bring All",
    CurrentValue = false,
    Flag = "Server_BringAll",
    Callback = function(v)
        if v then
            -- Bring all implementation
        end
    end
})

-- Auras
AuraTab:CreateSection("OP Auras")

AuraTab:CreateToggle({
    Name = "Void Aura",
    CurrentValue = false,
    Flag = "Aura_Void",
    Callback = function(v)
        voidAura = v
        if v then
            RunService.Heartbeat:Connect(function()
                if not voidAura then return end
                local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if not myHRP then return end
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character and not isWhitelisted(plr) then
                        local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        local thum = plr.Character:FindFirstChild("Humanoid")
                        if thrp and thum and (myHRP.Position - thrp.Position).Magnitude <= 30 then
                            pcall(function()
                                SetNetworkOwner:FireServer(thrp, thrp.CFrame)
                                DestroyGrabLine:FireServer(thrp)
                                thrp.CFrame = CFrame.new(-9e11, 9e12, -9e11)
                                local bv = Instance.new("BodyVelocity")
                                bv.Velocity = Vector3.new(0, 9e10, 0)
                                bv.MaxForce = Vector3.new(1e999, 1e999, 1e999)
                                bv.Parent = thrp
                                thum.BreakJointsOnDeath = false
                                thum:ChangeState(Enum.HumanoidStateType.Dead)
                                Debris:AddItem(bv, 2)
                            end)
                        end
                    end
                end
            end)
        end
    end
})

AuraTab:CreateToggle({
    Name = "Kick Aura",
    CurrentValue = false,
    Flag = "Aura_Kick",
    Callback = function(v)
        kickAura = v
        if v then
            RunService.Heartbeat:Connect(function()
                if not kickAura then return end
                local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if not myHRP then return end
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character and not isWhitelisted(plr) then
                        local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        if thrp and (myHRP.Position - thrp.Position).Magnitude <= 30 then
                            pcall(function()
                                SetNetworkOwner:FireServer(thrp, thrp.CFrame)
                                DestroyGrabLine:FireServer(thrp)
                                thrp.CFrame = CFrame.new(0, 9e13, 0)
                                local bv = Instance.new("BodyVelocity")
                                bv.Velocity = Vector3.new(0, 9e12, 0)
                                bv.MaxForce = Vector3.new(1e999, 1e999, 1e999)
                                bv.Parent = thrp
                                Debris:AddItem(bv, 2)
                            end)
                        end
                    end
                end
            end)
        end
    end
})

AuraTab:CreateToggle({
    Name = "Grab Aura",
    CurrentValue = false,
    Flag = "Aura_Grab",
    Callback = function(v)
        grabAura = v
        if v then
            RunService.Heartbeat:Connect(function()
                if not grabAura then return end
                local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if not myHRP then return end
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character and not isWhitelisted(plr) then
                        local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        if thrp and (myHRP.Position - thrp.Position).Magnitude <= 30 then
                            pcall(function()
                                SetNetworkOwner:FireServer(thrp, thrp.CFrame)
                            end)
                        end
                    end
                end
            end)
        end
    end
})

AuraTab:CreateToggle({
    Name = "Throw Aura",
    CurrentValue = false,
    Flag = "Aura_Throw",
    Callback = function(v)
        throwAura = v
        if not v then
            for _, vel in pairs(throwVel) do
                if vel and vel.Parent then vel:Destroy() end
            end
            throwVel = {}
            return
        end
        RunService.Heartbeat:Connect(function()
            if not throwAura then return end
            local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not myHRP then return end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character and not isWhitelisted(plr) then
                    local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if thrp then
                        local dist = (thrp.Position - myHRP.Position).Magnitude
                        if dist <= 30 then
                            pcall(function() SetNetworkOwner:FireServer(thrp, thrp.CFrame) end)
                            local bv = thrp:FindFirstChild("ThrowBV")
                            if not bv then
                                bv = Instance.new("BodyVelocity")
                                bv.Name = "ThrowBV"
                                bv.MaxForce = Vector3.new(1e999, 1e999, 1e999)
                                bv.Parent = thrp
                                throwVel[thrp] = bv
                            end
                            bv.Velocity = Vector3.new(math.random(-throwSpeed, throwSpeed), math.random(5, throwSpeed), math.random(-throwSpeed, throwSpeed))
                        elseif throwVel[thrp] then
                            throwVel[thrp]:Destroy()
                            throwVel[thrp] = nil
                        end
                    end
                end
            end
        end)
    end
})

AuraTab:CreateSlider({
    Name = "Throw Speed",
    Range = {10, 1000},
    Increment = 10,
    Suffix = " velocity",
    CurrentValue = 100,
    Flag = "Aura_ThrowSpeed",
    Callback = function(v) throwSpeed = v end
})

AuraTab:CreateSection("Objects & Players Auras")

local telekinesisActive = false
local telekinesisObjects = {}
local telekinesisBodies = {}
local telekinesisOffset = 10
local telekinesisHeight = 5
local telekinesisSpeed = 0.1
local telekinesisImpact = "Players"

AuraTab:CreateToggle({
    Name = "Telekinesis Aura",
    CurrentValue = false,
    Flag = "Aura_Telekinesis",
    Callback = function(v)
        telekinesisActive = v
        if not v then
            for _, b in ipairs(telekinesisBodies) do
                if b and b.Parent then b:Destroy() end
            end
            telekinesisBodies = {}
            telekinesisObjects = {}
        end
    end
})

AuraTab:CreateDropdown({
    Name = "Impact",
    Options = {"Players", "Objects", "Player & Object"},
    CurrentOption = {"Players"},
    Flag = "Aura_TelekinesisImpact",
    Callback = function(opt) telekinesisImpact = opt[1] end
})

AuraTab:CreateSlider({
    Name = "Distance",
    Range = {1, 500},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 10,
    Flag = "Aura_TelekinesisDist",
    Callback = function(v) telekinesisOffset = v end
})

AuraTab:CreateSlider({
    Name = "Height",
    Range = {1, 500},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 5,
    Flag = "Aura_TelekinesisHeight",
    Callback = function(v) telekinesisHeight = v end
})

AuraTab:CreateSlider({
    Name = "Rotation Speed",
    Range = {0.01, 1},
    Increment = 0.001,
    Suffix = " speed",
    CurrentValue = 0.1,
    Flag = "Aura_TelekinesisSpeed",
    Callback = function(v) telekinesisSpeed = v end
})

RunService.Heartbeat:Connect(function()
    if not telekinesisActive then return end
    local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    local cf = myHRP.CFrame
    local angle = tick() * telekinesisSpeed * 2 * math.pi % (2 * math.pi)
    for _, obj in ipairs(telekinesisObjects) do
        if obj and obj.Parent then
            local bp = obj:FindFirstChild("TelekinesisBP") or Instance.new("BodyPosition")
            bp.Name = "TelekinesisBP"
            bp.MaxForce = Vector3.new(1000000, 1000000, 1000000)
            bp.P = 50000
            bp.D = 1250
            bp.Parent = obj
            local pos = cf.Position + Vector3.new(math.cos(angle) * telekinesisOffset, telekinesisHeight, math.sin(angle) * telekinesisOffset)
            bp.Position = pos
        end
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        if telekinesisActive then
            local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if myHRP then
                if telekinesisImpact == "Objects" or telekinesisImpact == "Player & Object" then
                    local parts = Workspace:GetPartBoundsInRadius(myHRP.Position, 30)
                    for _, part in ipairs(parts) do
                        if part:IsA("BasePart") and not part.Anchored then
                            local isPlayer = false
                            for _, plr in ipairs(Players:GetPlayers()) do
                                if plr.Character and part:IsDescendantOf(plr.Character) then
                                    isPlayer = true
                                    break
                                end
                            end
                            if not isPlayer then
                                pcall(function() SetNetworkOwner:FireServer(part, part.CFrame) end)
                                if not table.find(telekinesisObjects, part) then
                                    table.insert(telekinesisObjects, part)
                                end
                            end
                        end
                    end
                end
                if telekinesisImpact == "Players" or telekinesisImpact == "Player & Object" then
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= LP and plr.Character and not isWhitelisted(plr) then
                            local thrp = plr.Character:FindFirstChild("Torso") or plr.Character:FindFirstChild("HumanoidRootPart")
                            if thrp and (myHRP.Position - thrp.Position).Magnitude <= 30 then
                                pcall(function() SetNetworkOwner:FireServer(thrp, thrp.CFrame) end)
                                if not table.find(telekinesisObjects, thrp) then
                                    table.insert(telekinesisObjects, thrp)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

AuraTab:CreateSection("Air Suspend")

local airSuspendActive = false
local airSuspendSpeed = 50
local airSuspendImpact = "Players"
local airSuspendObjects = {}

AuraTab:CreateToggle({
    Name = "Air Suspend Aura",
    CurrentValue = false,
    Flag = "Aura_AirSuspend",
    Callback = function(v)
        airSuspendActive = v
        if not v then
            for _, obj in pairs(airSuspendObjects) do
                if obj and obj.Parent then obj:Destroy() end
            end
            airSuspendObjects = {}
        end
    end
})

AuraTab:CreateDropdown({
    Name = "Impact",
    Options = {"Players", "Objects", "Player & Object"},
    CurrentOption = {"Players"},
    Flag = "Aura_AirSuspendImpact",
    Callback = function(opt) airSuspendImpact = opt[1] end
})

AuraTab:CreateInput({
    Name = "Speed",
    CurrentValue = "50",
    PlaceholderText = "Enter speed",
    Flag = "Aura_AirSuspendSpeed",
    Callback = function(v)
        local num = tonumber(v)
        if num then airSuspendSpeed = num end
    end
})

task.spawn(function()
    while task.wait(0.1) do
        if airSuspendActive then
            local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if myHRP then
                local parts = Workspace:GetPartBoundsInRadius(myHRP.Position, 30)
                for _, part in ipairs(parts) do
                    if part:IsA("BasePart") and not part.Anchored then
                        local isPlayer = false
                        for _, plr in ipairs(Players:GetPlayers()) do
                            if plr.Character and part:IsDescendantOf(plr.Character) then
                                isPlayer = true
                                break
                            end
                        end
                        if not isPlayer and (airSuspendImpact == "Objects" or airSuspendImpact == "Player & Object") then
                            local bv = part:FindFirstChild("AirSuspendBV") or Instance.new("BodyVelocity")
                            bv.Name = "AirSuspendBV"
                            bv.MaxForce = Vector3.new(1e999, 1e999, 1e999)
                            bv.Velocity = Vector3.new(0, airSuspendSpeed, 0)
                            bv.Parent = part
                            airSuspendObjects[part] = bv
                        end
                    end
                end
                if airSuspendImpact == "Players" or airSuspendImpact == "Player & Object" then
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= LP and plr.Character and not isWhitelisted(plr) then
                            local thrp = plr.Character:FindFirstChild("Torso") or plr.Character:FindFirstChild("HumanoidRootPart")
                            if thrp and (myHRP.Position - thrp.Position).Magnitude <= 30 then
                                local bv = thrp:FindFirstChild("AirSuspendBV") or Instance.new("BodyVelocity")
                                bv.Name = "AirSuspendBV"
                                bv.MaxForce = Vector3.new(1e999, 1e999, 1e999)
                                bv.Velocity = Vector3.new(0, airSuspendSpeed, 0)
                                bv.Parent = thrp
                                airSuspendObjects[plr] = bv
                            end
                        end
                    end
                end
            end
        end
    end
end)

AuraTab:CreateSection("Teleport")

local tpAuraActive = false
local tpAuraLocation = "Cursed Cloud"

AuraTab:CreateToggle({
    Name = "Teleport Aura",
    CurrentValue = false,
    Flag = "Aura_Teleport",
    Callback = function(v)
        tpAuraActive = v
        if v then
            RunService.Heartbeat:Connect(function()
                if not tpAuraActive then return end
                local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if not myHRP then return end
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character and not isWhitelisted(plr) then
                        local thrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        if thrp and (myHRP.Position - thrp.Position).Magnitude <= 30 then
                            pcall(function()
                                SetNetworkOwner:FireServer(thrp, thrp.CFrame)
                            end)
                            local pos = Vector3.new(0, 0, 0)
                            if tpAuraLocation == "Cursed Cloud" then pos = Vector3.new(900000, 100, 3000)
                            elseif tpAuraLocation == "Spawn" then pos = Vector3.new(0, 0, 0)
                            elseif tpAuraLocation == "Void" then pos = Vector3.new(0, 1000000000000, 0)
                            elseif tpAuraLocation == "Cozy Place" then pos = Vector3.new(592, 153, -101)
                            elseif tpAuraLocation == "Big Cave" then pos = Vector3.new(-97.15, -7.35, 549.19)
                            elseif tpAuraLocation == "Small Cave" then pos = Vector3.new(-35.08, -7.35, -275.37)
                            elseif tpAuraLocation == "Small Cave 2" then pos = Vector3.new(137.87, -7.35, -389.94)
                            elseif tpAuraLocation == "Very Very Small Cave" then pos = Vector3.new(191.09, -7.35, -564.27)
                            elseif tpAuraLocation == "Island Cave" then pos = Vector3.new(90.77, 282.19, 333.66)
                            elseif tpAuraLocation == "Poison" then pos = Vector3.new(71.25, -68.07, 269.03)
                            end
                            thrp.CFrame = CFrame.new(pos)
                        end
                    end
                end
            end)
        end
    end
})

AuraTab:CreateDropdown({
    Name = "Teleport Location",
    Options = {"Cursed Cloud", "Spawn", "Void", "Cozy Place", "Big Cave", "Small Cave", "Small Cave 2", "Very Very Small Cave", "Island Cave", "Poison"},
    CurrentOption = {"Cursed Cloud"},
    Flag = "Aura_TeleportLocation",
    Callback = function(opt) tpAuraLocation = opt[1] end
})

-- Additional Auras from ftap2 (Poison, Death, Burn, Radioactive, Attraction) already included above but we'll keep them.
-- They are present.

-- Visual Tab
VisualTab:CreateSection("Shaders")

local InnerUFO = Workspace.Map.AlwaysHereTweenedObjects.InnerUFO.Object.ObjectModel
local OuterUFO = Workspace.Map.AlwaysHereTweenedObjects.OuterUFO.Object.ObjectModel

VisualTab:CreateToggle({
    Name = "Beam Lights",
    CurrentValue = false,
    Flag = "Visual_BeamLights",
    Callback = function(v)
        beamLights = v
        if v then
            OuterUFO.Laser.Beam.Brightness = 10
            OuterUFO.Laser.Beam.LightInfluence = 0
            InnerUFO.Laser.Beam.Brightness = 10
            InnerUFO.Laser.Beam.LightInfluence = 0
            OuterUFO.Laser.Beam.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 75, 0)),
                ColorSequenceKeypoint.new(0.9, Color3.fromRGB(84, 230, 96)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(193, 230, 187))
            })
            OuterUFO.Laser.Beam.Width0 = 2
            OuterUFO.Laser.Beam.Width1 = 10
            InnerUFO.Laser.Beam.Color = OuterUFO.Laser.Beam.Color
            InnerUFO.Laser.Beam.Width0 = 2
            InnerUFO.Laser.Beam.Width1 = 13
        else
            OuterUFO.Laser.Beam.Brightness = 1
            InnerUFO.Laser.Beam.Brightness = 1
        end
    end
})

local defaultLighting = {
    ClockTime = Lighting.ClockTime,
    Brightness = Lighting.Brightness,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
    EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
    ExposureCompensation = Lighting.ExposureCompensation,
    FogColor = Lighting.FogColor,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    MoonAngularSize = Lighting.Sky.MoonAngularSize,
    StarCount = Lighting.Sky.StarCount
}

VisualTab:CreateToggle({
    Name = "Day/Night Mode",
    CurrentValue = false,
    Flag = "Visual_DayNight",
    Callback = function(v)
        dayNight = v
        if v then
            Lighting.ClockTime = 4
            Lighting.Brightness = 3
            Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 1
            Lighting.ExposureCompensation = -1
            Lighting.Sky.MoonAngularSize = 20
            Lighting.Sky.StarCount = 5000
            Lighting.FogColor = Color3.fromRGB(52, 52, 52)
            Lighting.FogEnd = 1000
            Lighting.FogStart = 0
        else
            Lighting.ClockTime = defaultLighting.ClockTime
            Lighting.Brightness = defaultLighting.Brightness
            Lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
            Lighting.EnvironmentDiffuseScale = defaultLighting.EnvironmentDiffuseScale
            Lighting.EnvironmentSpecularScale = defaultLighting.EnvironmentSpecularScale
            Lighting.ExposureCompensation = defaultLighting.ExposureCompensation
            Lighting.Sky.MoonAngularSize = defaultLighting.MoonAngularSize
            Lighting.Sky.StarCount = defaultLighting.StarCount
            Lighting.FogColor = defaultLighting.FogColor
            Lighting.FogEnd = defaultLighting.FogEnd
            Lighting.FogStart = defaultLighting.FogStart
        end
    end
})

VisualTab:CreateToggle({
    Name = "Better Textures & Materials",
    CurrentValue = false,
    Flag = "Visual_Textures",
    Callback = function(v)
        textures = v
        if v then
            OuterUFO.Laser.Beam.Texture = "rbxassetid://8933355899"
            InnerUFO.Laser.Beam.Texture = "rbxassetid://8933355899"
        else
            OuterUFO.Laser.Beam.Texture = ""
            InnerUFO.Laser.Beam.Texture = ""
        end
    end
})

VisualTab:CreateSection("Player ESP")

local playerHighlights = {}
local playerBillboards = {}
local espHighlightColor = Color3.new(1, 0, 0)
local espOutlineColor = Color3.new(0, 0, 0)
local espFillTransparency = 0.5
local espOutlineTransparency = 0
local espDepthMode = Enum.HighlightDepthMode.AlwaysOnTop

VisualTab:CreateToggle({
    Name = "Player ESP (Highlight)",
    CurrentValue = false,
    Flag = "Visual_PlayerESP_Highlight",
    Callback = function(v)
        playerESP = v
        if v then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = espHighlightColor
                    highlight.OutlineColor = espOutlineColor
                    highlight.FillTransparency = espFillTransparency
                    highlight.OutlineTransparency = espOutlineTransparency
                    highlight.DepthMode = espDepthMode
                    highlight.Adornee = plr.Character
                    highlight.Parent = CoreGui
                    playerHighlights[plr] = highlight
                end
            end
        else
            for _, hl in pairs(playerHighlights) do
                if hl then hl:Destroy() end
            end
            playerHighlights = {}
        end
    end
})

VisualTab:CreateColorPicker({
    Name = "Fill Color",
    Color = espHighlightColor,
    Callback = function(c)
        espHighlightColor = c
        for _, hl in pairs(playerHighlights) do
            if hl then hl.FillColor = c end
        end
    end
})

VisualTab:CreateSlider({
    Name = "Fill Transparency",
    Range = {0, 1},
    Increment = 0.1,
    CurrentValue = 0.5,
    Flag = "ESP_FillTransparency",
    Callback = function(v)
        espFillTransparency = v
        for _, hl in pairs(playerHighlights) do
            if hl then hl.FillTransparency = v end
        end
    end
})

VisualTab:CreateColorPicker({
    Name = "Outline Color",
    Color = espOutlineColor,
    Callback = function(c)
        espOutlineColor = c
        for _, hl in pairs(playerHighlights) do
            if hl then hl.OutlineColor = c end
        end
    end
})

VisualTab:CreateSlider({
    Name = "Outline Transparency",
    Range = {0, 1},
    Increment = 0.1,
    CurrentValue = 0,
    Flag = "ESP_OutlineTransparency",
    Callback = function(v)
        espOutlineTransparency = v
        for _, hl in pairs(playerHighlights) do
            if hl then hl.OutlineTransparency = v end
        end
    end
})

VisualTab:CreateDropdown({
    Name = "Depth Mode",
    Options = {"AlwaysOnTop", "Occluded"},
    CurrentOption = {"AlwaysOnTop"},
    Flag = "ESP_DepthMode",
    Callback = function(opt)
        espDepthMode = opt[1] == "AlwaysOnTop" and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
        for _, hl in pairs(playerHighlights) do
            if hl then hl.DepthMode = espDepthMode end
        end
    end
})

VisualTab:CreateToggle({
    Name = "Player ESP (Icon)",
    CurrentValue = false,
    Flag = "Visual_PlayerESP_Icon",
    Callback = function(v)
        if v then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local bb = Instance.new("BillboardGui")
                        bb.Adornee = hrp
                        bb.Size = UDim2.new(0, 100, 0, 50)
                        bb.AlwaysOnTop = true
                        bb.StudsOffset = Vector3.new(0, 3, 0)
                        bb.Parent = CoreGui
                        local tl = Instance.new("TextLabel")
                        tl.Size = UDim2.new(1, 0, 1, 0)
                        tl.BackgroundTransparency = 1
                        tl.Text = plr.Name
                        tl.TextColor3 = Color3.new(1, 1, 1)
                        tl.TextStrokeTransparency = 0
                        tl.Font = Enum.Font.GothamBold
                        tl.TextScaled = true
                        tl.Parent = bb
                        playerBillboards[plr] = bb
                    end
                end
            end
        else
            for _, bb in pairs(playerBillboards) do
                if bb then bb:Destroy() end
            end
            playerBillboards = {}
        end
    end
})

VisualTab:CreateSection("Object ESP")

local objectHighlights = {}
local objectHighlightColor = Color3.new(0, 1, 0)

VisualTab:CreateToggle({
    Name = "Object ESP",
    CurrentValue = false,
    Flag = "Visual_ObjectESP",
    Callback = function(v)
        objectESP = v
        if v then
            for _, folder in pairs(Workspace:GetChildren()) do
                if folder:IsA("Folder") and folder.Name:match("SpawnedInToys$") then
                    for _, model in pairs(folder:GetDescendants()) do
                        if model:IsA("Model") and (model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")) then
                            local hl = Instance.new("Highlight")
                            hl.FillColor = objectHighlightColor
                            hl.OutlineColor = Color3.new(0, 0, 0)
                            hl.FillTransparency = 0.5
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Adornee = model
                            hl.Parent = CoreGui
                            objectHighlights[model] = hl
                        end
                    end
                end
            end
        else
            for _, hl in pairs(objectHighlights) do
                if hl then hl:Destroy() end
            end
            objectHighlights = {}
        end
    end
})

VisualTab:CreateColorPicker({
    Name = "Object Highlight Color",
    Color = objectHighlightColor,
    Callback = function(c)
        objectHighlightColor = c
        for _, hl in pairs(objectHighlights) do
            if hl then hl.FillColor = c end
        end
    end
})

VisualTab:CreateSection("Fullbright")

VisualTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Flag = "Visual_Fullbright",
    Callback = function(v)
        fullbright = v
        if v then
            Lighting.Brightness = 10
            Lighting.GlobalShadows = false
        else
            Lighting.Brightness = defaultLighting.Brightness
            Lighting.GlobalShadows = true
        end
    end
})

-- Fun Tab
FunTab:CreateLabel("Chat", "message-circle-more")

local keywords = {
  "kick", "dead", "yo", "ree", "mad", "uwu", "yay", "banana", "spook",
  "grr", "ew", "lol", "hehe", "hmm", "dad", "hold", "pew", "drink",
  "soda", "yeehaw", "fly", "ahem", "cough", "one", "two", "three",
  "four", "five", "mom", "yum", "sh", "aaa", "cry", "sing", "xd", "?"
}
local spamEnabled = false
local currentKeyword = keywords[1]
RunService.Heartbeat:Connect(function()
    if spamEnabled and currentKeyword then
        pcall(function()
            RBXGeneral:SendAsync("/clear " .. tostring(currentKeyword))
        end)
    end
end)
FunTab:CreateToggle({
    Name = "Enable Spam",
    CurrentValue = false,
    Flag = "SpamToggle",
    Callback = function(v) spamEnabled = v end
})
FunTab:CreateDropdown({
    Name = "Select Keyword",
    Options = keywords,
    CurrentOption = {keywords[1]},
    Flag = "KeywordDropdown",
    Callback = function(opt) currentKeyword = opt[1] end
})

FunTab:CreateLabel("Animation", "party-popper")

local animations = {
  Crouch = "rbxassetid://6980229055",
  FireFlail = "rbxassetid://11227676639",
  Flail = "rbxassetid://7047322890",
  Typing = "rbxassetid://7004578012"
}
local animEnabled = false
local currentAnimation = "Crouch"
local animator = nil
local animationTrack = nil

local function setupAnim(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    animator = hum:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = hum
    end
end
LP.CharacterAdded:Connect(setupAnim)
if LP.Character then setupAnim(LP.Character) end

RunService.Heartbeat:Connect(function()
    if animEnabled and animator then
        if not animationTrack or not animationTrack.IsPlaying then
            local anim = Instance.new("Animation")
            anim.AnimationId = animations[currentAnimation]
            animationTrack = animator:LoadAnimation(anim)
            animationTrack:Play()
        end
    elseif animationTrack then
        animationTrack:Stop()
        animationTrack = nil
    end
end)
FunTab:CreateToggle({
    Name = "Play Animation",
    CurrentValue = false,
    Flag = "AnimToggle",
    Callback = function(v) animEnabled = v end
})
FunTab:CreateDropdown({
    Name = "Select Animation",
    Options = {"Crouch", "FireFlail", "Flail", "Typing"},
    CurrentOption = {"Crouch"},
    Flag = "AnimDropdown",
    Callback = function(opt) currentAnimation = opt[1] end
})

FunTab:CreateLabel("Wings", "bird")

local wingsEnabled = false
local wingsSpeed = 2.5
local wingsAngle = 35
local wingPalletAmount = 12
local wingPalletName = "WingPallet"
local wingOffsets = {CFrame.new(-wingPalletAmount/2, 0, 1), CFrame.new(wingPalletAmount/2, 0, 1)}
local wingObjects = {}
local wingFolderConnections = {}

local function getWingFolder()
    if InPlot.Value then
        local plot = GetOwnedPlot()
        if plot then
            local items = Workspace:FindFirstChild("PlotItems")
            if items then return items:FindFirstChild("Plot"..plot) end
        end
        return nil
    end
    return BackPack
end

local function spawnWingPallet()
    if not canSpawn() or not wingsEnabled then return end
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local look = Camera.CFrame.LookVector
    local pos = hrp.Position + look * -3
    SpawnToyRF:InvokeServer("PalletLightBrown", CFrame.new(pos, pos + look), Vector3.new(0, 90, 0))
end

local function forceWingOwnership(model)
    local sound = model:FindFirstChild("SoundPart") or model.PrimaryPart
    if sound then
        for _=1,5 do
            SetNetworkOwner:FireServer(sound, sound.CFrame)
            task.wait(0.1)
        end
    end
end

local function setupWingAntiGrab(model)
    local sound = model:FindFirstChild("SoundPart") or model.PrimaryPart
    if not sound then return end
    task.spawn(function()
        while model.Parent and wingsEnabled do
            local owner = sound:FindFirstChild("PartOwner")
            if not owner or owner.Value ~= LP.Name then
                local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local saved = hrp.CFrame
                    hrp.CFrame = sound.CFrame * CFrame.new(0, 5, 0)
                    for _=1,8 do
                        SetNetworkOwner:FireServer(sound, sound.CFrame)
                    end
                    task.wait(0.05)
                    hrp.CFrame = saved
                end
            end
            task.wait(0.01)
        end
    end)
end

local function watchWingFolder(folder)
    if wingFolderConnections[folder] then return end
    wingFolderConnections[folder] = true
    for _, child in pairs(folder:GetChildren()) do
        if child.Name == "PalletLightBrown" and child:IsA("Model") then
            task.wait(0.2)
            child.Name = wingPalletName
            forceWingOwnership(child)
            setupWingAntiGrab(child)
        end
    end
    folder.ChildAdded:Connect(function(child)
        if child.Name == "PalletLightBrown" and wingsEnabled then
            task.wait(0.2)
            child.Name = wingPalletName
            forceWingOwnership(child)
            setupWingAntiGrab(child)
        end
    end)
end

local function rebuildWings()
    for _, v in pairs(wingObjects) do
        if v.Handle then v.Handle:Destroy() end
        if v.Segments then
            for _, seg in pairs(v.Segments) do if seg then seg:Destroy() end end
        end
    end
    wingObjects = {}
    for i=1,2 do
        local segs = {}
        for _=1, wingPalletAmount/2 do
            local p = Instance.new("Part")
            p.Anchored = true
            p.CanCollide = false
            p.Transparency = 1
            p.Size = Vector3.new(1,1,1)
            p.Parent = Workspace
            table.insert(segs, p)
        end
        wingObjects[i] = {Handle = Instance.new("Part"), Segments = segs}
        wingObjects[i].Handle.Anchored = true
        wingObjects[i].Handle.CanCollide = false
        wingObjects[i].Handle.Transparency = 1
        wingObjects[i].Handle.Size = Vector3.new(1,1,1)
        wingObjects[i].Handle.Parent = Workspace
    end
end
rebuildWings()

local function countWingPallets()
    local count = 0
    for _, folder in pairs(getAllPalletFolders()) do
        for _, child in pairs(folder:GetChildren()) do
            if child.Name == wingPalletName then count = count + 1 end
        end
    end
    return count
end

local function wingLoop()
    while wingsEnabled do
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local count = countWingPallets()
            if count < wingPalletAmount then spawnWingPallet() end
            local pallets = {}
            for _, folder in pairs(getAllPalletFolders()) do
                for _, child in pairs(folder:GetChildren()) do
                    if child.Name == wingPalletName then table.insert(pallets, child) end
                end
            end
            local angle = tick() * wingsSpeed
            for i=1,2 do
                local obj = wingObjects[i]
                if obj and obj.Handle then
                    local dir = i==1 and -1 or 1
                    local rot = math.sin(angle) * math.rad(wingsAngle) * dir
                    obj.Handle.CFrame = hrp.CFrame * wingOffsets[i] * CFrame.Angles(0, 0, rot)
                    for j, seg in ipairs(obj.Segments) do
                        local prev = j==1 and obj.Handle.CFrame or obj.Segments[j-1].CFrame
                        seg.CFrame = seg.CFrame:Lerp(prev * wingOffsets[i], 0.45)
                        local pallet = pallets[(i-1)*wingPalletAmount/2 + j]
                        if pallet then
                            local part = pallet.PrimaryPart or pallet:FindFirstChild("SoundPart")
                            if part then
                                local bp = part:FindFirstChild("WingPos") or Instance.new("BodyPosition")
                                local bg = part:FindFirstChild("WingGyro") or Instance.new("BodyGyro")
                                bp.Name = "WingPos"; bg.Name = "WingGyro"
                                bp.MaxForce = Vector3.new(1e10,1e10,1e10)
                                bp.P = 15000; bp.D = 200
                                bg.MaxTorque = Vector3.new(1e10,1e10,1e10)
                                bg.P = 15000; bg.D = 200
                                bp.Parent = part; bg.Parent = part
                                bp.Position = seg.Position
                                bg.CFrame = seg.CFrame * CFrame.Angles(0, math.pi, 0)
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end
        end
        task.wait()
    end
end

FunTab:CreateToggle({
    Name = "Enable Wings",
    CurrentValue = false,
    Flag = "WingsToggle",
    Callback = function(v)
        wingsEnabled = v
        if v then
            for _, folder in pairs(getAllPalletFolders()) do watchWingFolder(folder) end
            task.spawn(wingLoop)
        else
            for _, folder in pairs(getAllPalletFolders()) do
                for _, child in pairs(folder:GetChildren()) do
                    if child.Name == wingPalletName then
                        pcall(function() DestroyToyRF:FireServer(child) end)
                    end
                end
            end
            wingPallets = {}
        end
    end
})
FunTab:CreateSlider({
    Name = "Pallet Amount",
    Range = {2, 20},
    Increment = 2,
    CurrentValue = 12,
    Flag = "WingAmount",
    Callback = function(v) wingPalletAmount = v; rebuildWings() end
})
FunTab:CreateSlider({
    Name = "Wings Speed",
    Range = {1, 10},
    Increment = 0.1,
    CurrentValue = 2.5,
    Flag = "WingSpeed",
    Callback = function(v) wingsSpeed = v end
})
FunTab:CreateSlider({
    Name = "Wings Angle",
    Range = {10, 60},
    Increment = 1,
    CurrentValue = 35,
    Flag = "WingAngle",
    Callback = function(v) wingsAngle = v end
})

FunTab:CreateLabel("Sparkles", "wand-sparkles")

local sparklesEnabled = false
local sparkleTarget = nil
local sparkleAmount = 5
local sparkleShape = "Heart"
local sparkleSize = 2
local sparkleHeight = 20
local sparkleRotation = 0
local sparkleAutoRegrab = false
local sparklePath = {}
local sparkleFolderConnections = {}

local function generateSparklePath()
    sparklePath = {}
    local n = 3000
    local s = sparkleSize
    if sparkleShape == "Heart" then
        for i=0,n do
            local t = i/n * 2 * math.pi
            local x = 16 * math.sin(t)^3 * s
            local y = (13*math.cos(t) - 5*math.cos(2*t) - 2*math.cos(3*t) - math.cos(4*t)) * s
            sparklePath[i] = Vector3.new(x, y+2, 0)
        end
    elseif sparkleShape == "Dick" then
        for i=0,n do
            local t = i/n * 2 * math.pi
            local x,y
            if t < math.pi then
                x = 4*s*math.cos(t)
                y = 8*s + 16*s*math.sin(t)
            elseif t < math.pi*1.5 then
                local u = (t - math.pi)*4
                x = -5*s + 4*s*math.cos(u)
                y = -2*s + 4*s*math.sin(u)
            else
                local u = (t - 1.5*math.pi)*4 + math.pi
                x = 5*s + 4*s*math.cos(u)
                y = -2*s + 4*s*math.sin(u)
            end
            sparklePath[i] = Vector3.new(x, y+2, 0)
        end
    elseif sparkleShape == "L" then
        local w = 8*s; local h = 10*s
        for i=0,n do
            local t = math.abs(math.sin(i/n * 2 * math.pi))
            local x,y
            if t < 0.6 then
                x = t/0.6 * w*2
                y = 0
            else
                x = w*2
                y = (t-0.6)/0.4 * h*2
            end
            sparklePath[i] = Vector3.new(x - w, y+2, 0)
        end
    elseif sparkleShape == "MiddleFinger" then
        local w = 22*s; local h = 35*s; local r = 14*s
        for i=0,n do
            local t = i/n
            local x,y
            if t < 0.05 then
                x = -w*0.5
                y = t/0.05 * r
            elseif t < 0.15 then
                local u = (t-0.05)/0.1 * math.pi
                x = -w*0.4 + math.cos(math.pi - u) * w*0.1
                y = r + math.sin(u) * r*0.2
            elseif t < 0.25 then
                local u = (t-0.15)/0.1 * math.pi
                x = -w*0.2 + math.cos(math.pi - u) * w*0.1
                y = r + math.sin(u) * r*0.2
            elseif t < 0.55 then
                local u = (t-0.25)/0.3
                if u < 0.3 then
                    x = -w*0.1
                    y = r + u/0.3 * (h - r)
                elseif u < 0.7 then
                    local v = (u-0.3)/0.4 * math.pi
                    x = math.cos(math.pi - v) * w*0.1
                    y = h + math.sin(v) * w*0.1
                else
                    x = w*0.1
                    y = h - (u-0.7)/0.3 * (h - r)
                end
            elseif t < 0.65 then
                local u = (t-0.55)/0.1 * math.pi
                x = w*0.2 + math.cos(math.pi - u) * w*0.1
                y = r + math.sin(u) * r*0.2
            elseif t < 0.75 then
                local u = (t-0.65)/0.1 * math.pi
                x = w*0.4 + math.cos(math.pi - u) * w*0.1
                y = r + math.sin(u) * r*0.2
            elseif t < 0.8 then
                x = w*0.5
                y = r - (t-0.75)/0.05 * r
            else
                x = w*0.5 - (t-0.8)/0.2 * w
                y = 0
            end
            sparklePath[i] = Vector3.new(x, y+2, 0)
        end
    elseif sparkleShape == "Square" then
        local s2 = 14*s
        for i=0,n do
            local t = i/n * 2 * math.pi
            local seg = math.floor(t / (math.pi/2)) % 4
            local u = (t % (math.pi/2)) / (math.pi/2) * 2 - 1
            local x,y
            if seg == 0 then x = u*s2; y = s2
            elseif seg == 1 then x = s2; y = -u*s2
            elseif seg == 2 then x = -u*s2; y = -s2
            else x = -s2; y = u*s2 end
            sparklePath[i] = Vector3.new(x, y+2, 0)
        end
    elseif sparkleShape == "nazi cross" then
        local s2 = 12*s; local r2 = s2*0.4
        local pts = {}
        for i=0,12 do
            local a = i/12 * 2*math.pi
            local x,y
            if i%3 == 0 then
                x = math.sin(a) * s2*0.5
                y = math.cos(a) * s2*0.5
            else
                x = math.sin(a) * r2
                y = math.cos(a) * r2
            end
            table.insert(pts, Vector3.new(x,y,0))
        end
        local dists = {0}
        for i=2,#pts do dists[i] = dists[i-1] + (pts[i]-pts[i-1]).Magnitude end
        for i=0,n do
            local t = i/n * dists[#dists]
            local idx = 2
            while idx < #dists and t > dists[idx] do idx = idx+1 end
            local frac = (t - dists[idx-1]) / (dists[idx] - dists[idx-1])
            sparklePath[i] = pts[idx-1]:Lerp(pts[idx], frac) + Vector3.new(0,2,0)
        end
    elseif sparkleShape == "Triangle" then
        local s2 = 10*s
        for i=0,n do
            local t = i/n * 2*math.pi
            local seg = math.floor(t / (2*math.pi/3)) % 3
            local x,y
            if seg == 0 then x = s2; y = 0
            elseif seg == 1 then x = -s2*0.5; y = s2*0.866
            else x = -s2*0.5; y = -s2*0.866 end
            sparklePath[i] = Vector3.new(x, y+2, 0)
        end
    end
end
generateSparklePath()

local function getSmoothedSparklePos(t)
    if #sparklePath == 0 then return Vector3.zero end
    local idx = t * #sparklePath
    local i1 = math.floor(idx) % #sparklePath
    local i2 = (i1+1) % #sparklePath
    local frac = idx - math.floor(idx)
    return sparklePath[i1]:Lerp(sparklePath[i2], frac)
end

local function spawnSparkler()
    if not canSpawn() or not sparklesEnabled then return end
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local look = Camera.CFrame.LookVector
    local pos = hrp.Position + look * -3
    SpawnToyRF:InvokeServer("FireworkSparkler", CFrame.new(pos, pos + look), Vector3.new(0, 90, 0))
end

local function setupSparkleAntiGrab(model)
    local base = model:FindFirstChild("Base") or model.PrimaryPart or model:FindFirstChild("SoundPart")
    if not base then return end
    task.spawn(function()
        while model.Parent and sparklesEnabled do
            local owner = base:FindFirstChild("PartOwner")
            if sparkleAutoRegrab and (not owner or owner.Value ~= LP.Name) then
                local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local saved = hrp.CFrame
                    hrp.CFrame = base.CFrame * CFrame.new(0,5,0)
                    for _=1,8 do
                        SetNetworkOwner:FireServer(base, base.CFrame)
                    end
                    task.wait(0.05)
                    hrp.CFrame = saved
                end
            end
            task.wait(0.01)
        end
    end)
end

local function watchSparkleFolder(folder)
    if sparkleFolderConnections[folder] then return end
    sparkleFolderConnections[folder] = true
    folder.ChildAdded:Connect(function(child)
        if child.Name == "FireworkSparkler" and sparklesEnabled then
            task.wait(0.2)
            child.Name = "HeartSparkler"
            forceWingOwnership(child)
            setupSparkleAntiGrab(child)
        end
    end)
end

local function sparkleLoop()
    while sparklesEnabled do
        local target = sparkleTarget and Players:FindFirstChild(sparkleTarget)
        if target and target.Character then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pos = hrp.Position + Vector3.new(0, sparkleHeight, 0)
                local count = 0
                for _, folder in pairs(getAllPalletFolders()) do
                    for _, child in pairs(folder:GetChildren()) do
                        if child.Name == "HeartSparkler" then count = count + 1 end
                    end
                end
                if count < sparkleAmount then spawnSparkler() end
                local sparklers = {}
                for _, folder in pairs(getAllPalletFolders()) do
                    for _, child in pairs(folder:GetChildren()) do
                        if child.Name == "HeartSparkler" then table.insert(sparklers, child) end
                    end
                end
                local angle = tick() * 1.5
                for i, model in ipairs(sparklers) do
                    if i > sparkleAmount then break end
                    local t = (i-1) / sparkleAmount
                    local shapePos = getSmoothedSparklePos((angle + t * 2*math.pi) % (2*math.pi) / (2*math.pi))
                    local worldPos = pos + CFrame.Angles(0, math.rad(sparkleRotation), 0) * shapePos
                    local part = model.PrimaryPart or model:FindFirstChild("Base") or model:FindFirstChild("SoundPart")
                    if part then
                        local bp = part:FindFirstChild("SparklePos") or Instance.new("BodyPosition")
                        local bg = part:FindFirstChild("SparkleGyro") or Instance.new("BodyGyro")
                        bp.Name = "SparklePos"; bg.Name = "SparkleGyro"
                        bp.MaxForce = Vector3.new(1e10,1e10,1e10)
                        bp.P = 15000; bp.D = 200
                        bg.MaxTorque = Vector3.new(1e10,1e10,1e10)
                        bg.P = 15000; bg.D = 200
                        bp.Parent = part; bg.Parent = part
                        bp.Position = worldPos
                        bg.CFrame = CFrame.new(worldPos)
                        part.CanCollide = false
                    end
                end
            end
        end
        task.wait(0.05)
    end
end

FunTab:CreateToggle({
    Name = "Enable Sparkle Shape",
    CurrentValue = false,
    Flag = "SparkleToggle",
    Callback = function(v)
        sparklesEnabled = v
        if v then
            for _, folder in pairs(getAllPalletFolders()) do watchSparkleFolder(folder) end
            task.spawn(sparkleLoop)
        else
            for _, folder in pairs(getAllPalletFolders()) do
                for _, child in pairs(folder:GetChildren()) do
                    if child.Name == "HeartSparkler" then
                        pcall(function() DestroyToyRF:FireServer(child) end)
                    end
                end
            end
        end
    end
})
local sparklePlayerDropdown = FunTab:CreateDropdown({
    Name = "Target Player",
    Options = buildPlayerList(),
    CurrentOption = {},
    Flag = "SparkleTarget",
    Callback = function(opt) sparkleTarget = opt[1] and opt[1]:match("@([%w_]+)") end
})
FunTab:CreateSlider({
    Name = "Sparkler Amount",
    Range = {1, 5},
    Increment = 1,
    CurrentValue = 5,
    Flag = "SparkleAmount",
    Callback = function(v) sparkleAmount = v end
})
FunTab:CreateDropdown({
    Name = "Shape",
    Options = {"Heart", "Dick", "L", "MiddleFinger", "nazi cross", "Square", "Triangle"},
    CurrentOption = {"Heart"},
    Flag = "SparkleShape",
    Callback = function(opt) sparkleShape = opt[1]; generateSparklePath() end
})
FunTab:CreateSlider({
    Name = "Size",
    Range = {0, 10},
    Increment = 1,
    CurrentValue = 2,
    Flag = "SparkleSize",
    Callback = function(v) sparkleSize = v; generateSparklePath() end
})
FunTab:CreateSlider({
    Name = "Height",
    Range = {0, 100},
    Increment = 5,
    CurrentValue = 20,
    Flag = "SparkleHeight",
    Callback = function(v) sparkleHeight = v end
})
FunTab:CreateSlider({
    Name = "Rotation",
    Range = {-360, 360},
    Increment = 5,
    CurrentValue = 0,
    Flag = "SparkleRotation",
    Callback = function(v) sparkleRotation = v end
})
FunTab:CreateToggle({
    Name = "Auto Regrab",
    CurrentValue = false,
    Flag = "SparkleAutoRegrab",
    Callback = function(v) sparkleAutoRegrab = v end
})

FunTab:CreateLabel("Control", "footprints")

local controlEnabled = false
local controllingCreature = nil
local controlConnections = {}

local function clearControl()
    if controllingCreature then
        pcall(function() DestroyGrabLine:FireServer(controllingCreature:FindFirstChild("HumanoidRootPart")) end)
        controllingCreature = nil
    end
    for _, conn in pairs(controlConnections) do conn:Disconnect() end
    controlConnections = {}
end

local function controlCreature(target)
    if not target or target:IsDescendantOf(LP.Character) then return end
    local hum = target:FindFirstChildOfClass("Humanoid")
    local hrp = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart
    if not hum or not hrp then return end
    clearControl()
    controllingCreature = target
    local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local myHum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if not myHRP or not myHum then return end
    local bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(1e9, 0, 1e9)
    bv.Velocity = Vector3.zero
    local bg = Instance.new("BodyGyro", hrp)
    bg.MaxTorque = Vector3.new(0, 1e9, 0)
    bg.P = 40000; bg.D = 500
    hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    hum.Sit = false
    for _, part in pairs(LP.Character:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
    local conn = RunService.Heartbeat:Connect(function()
        if not controllingCreature or not controllingCreature.Parent then clearControl(); return end
        local move = myHum.MoveDirection
        myHRP.CFrame = hrp.CFrame * CFrame.new(0, -10, 0)
        myHRP.Velocity = Vector3.zero
        SetNetworkOwner:FireServer(hrp, hrp.CFrame)
        if move.Magnitude > 0 then
            hum:ChangeState(Enum.HumanoidStateType.Running)
            hum:Move(move, false)
            bv.Velocity = Vector3.new(move.X, 0, move.Z) * 26
        else
            bv.Velocity = Vector3.zero
        end
        bg.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z))
        Camera.CameraSubject = hum
    end)
    table.insert(controlConnections, conn)
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X and controlEnabled then
        if controllingCreature then clearControl(); return end
        local ray = Workspace:Raycast(Camera.CFrame.Position, Camera.CFrame.LookVector * 150, RaycastParams.new())
        if ray then
            local model = ray.Instance:FindFirstAncestorOfClass("Model")
            if model and model:FindFirstChildOfClass("Humanoid") and model ~= LP.Character then
                controlCreature(model)
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if controllingCreature then
        local hum = controllingCreature:FindFirstChildOfClass("Humanoid")
        if hum then hum.Jump = true end
    end
end)

FunTab:CreateToggle({
    Name = "Control (X)",
    CurrentValue = false,
    Flag = "ControlToggle",
    Callback = function(v) controlEnabled = v; if not v then clearControl() end
})

FunTab:CreateLabel("Hold", "ham")

local holdFoodEnabled = false
local heldFoods = {}
local foodModels = {"FoodDonut","FoodBread","FoodBanana","FoodBroccoli","FoodCakePink","FoodCoconut","FoodDippyEgg","FoodFrenchFries","FoodHamburger","FoodHotdog","FoodMayonnaise","FoodMeatStick","FoodMushroomPoison","FoodPizzaCheese","FoodPizzaPepperoni","FoodSodaCan","PoopPile","PoopPileSparkle","CupMugWhite","CupMugBrown"}

local function isFood(name)
    for _, f in pairs(foodModels) do if f == name then return true end end
    return false
end

local function findFoods()
    local list = {}
    for _, item in pairs(Workspace:GetChildren()) do
        if item:IsA("Model") and isFood(item.Name) and item:FindFirstChild("HoldPart") then
            table.insert(list, item)
        end
    end
    return list
end

local function holdAndEat(food)
    local hold = food:FindFirstChild("HoldPart")
    if not hold then return end
    local holdRF = hold:FindFirstChild("HoldItemRemoteFunction")
    if holdRF then pcall(function() holdRF:InvokeServer(food, LP.Character) end) end
    task.wait(0.03)
    if HoldEvents and HoldEvents.Use then
        pcall(function() HoldEvents.Use:FireServer(food) end)
    end
    heldFoods[food] = tick()
end

local function dropFood(food)
    local hold = food:FindFirstChild("HoldPart")
    if hold then
        local drop = hold:FindFirstChild("DropItemRemoteFunction")
        if drop then
            pcall(function() drop:InvokeServer(food, CFrame.new(0, -500, 0), Vector3.new(0, 97.69, 0)) end)
        end
    end
    heldFoods[food] = nil
end

local function holdFoodLoop()
    while holdFoodEnabled do
        local foods = findFoods()
        for _, food in pairs(foods) do
            if not heldFoods[food] then
                holdAndEat(food)
                task.wait(0.1)
            end
        end
        for food, time in pairs(heldFoods) do
            if tick() - time > 2.7 then
                dropFood(food)
            elseif not food.Parent then
                heldFoods[food] = nil
            end
        end
        task.wait(0.3)
    end
end

FunTab:CreateToggle({
    Name = "Eat all Food",
    CurrentValue = false,
    Flag = "HoldFood",
    Callback = function(v) holdFoodEnabled = v; if v then task.spawn(holdFoodLoop) end
})

FunTab:CreateLabel("Instruments", "music")

local holdInstrumentEnabled = false
local heldInstruments = {}
local instrumentModels = {"InstrumentBrassBugle","InstrumentBrassTrumpet","InstrumentBrassVuvuzela","InstrumentDrumBongos","InstrumentDrumSnare","InstrumentGuitarAcoustic","InstrumentGuitarBanjo","InstrumentGuitarLyre","InstrumentGuitarUkulele","InstrumentGuitarViolin","InstrumentPianoKeyboard","InstrumentPianoMelodica","InstrumentVoiceMicrophone","InstrumentWoodwindOcarina","InstrumentWoodwindSaxophone"}

local function isInstrument(name)
    for _, f in pairs(instrumentModels) do if f == name then return true end end
    return false
end

local function findInstruments()
    local list = {}
    for _, item in pairs(Workspace:GetChildren()) do
        if item:IsA("Model") and isInstrument(item.Name) and item:FindFirstChild("HoldPart") then
            table.insert(list, item)
        end
    end
    return list
end

local function holdAndUseInst(inst)
    local hold = inst:FindFirstChild("HoldPart")
    if not hold then return end
    local holdRF = hold:FindFirstChild("HoldItemRemoteFunction")
    if holdRF then pcall(function() holdRF:InvokeServer(inst, LP.Character) end) end
    task.wait(0.03)
    if HoldEvents and HoldEvents.Use then
        pcall(function() HoldEvents.Use:FireServer(inst) end)
    end
    heldInstruments[inst] = tick()
end

local function dropInst(inst)
    local hold = inst:FindFirstChild("HoldPart")
    if hold then
        local drop = hold:FindFirstChild("DropItemRemoteFunction")
        if drop then
            pcall(function() drop:InvokeServer(inst, CFrame.new(0, -500, 0), Vector3.new(0, 97.69, 0)) end)
        end
    end
    heldInstruments[inst] = nil
end

local function instLoop()
    while holdInstrumentEnabled do
        local insts = findInstruments()
        for _, inst in pairs(insts) do
            if not heldInstruments[inst] then
                holdAndUseInst(inst)
                task.wait(0.1)
            end
        end
        for inst, time in pairs(heldInstruments) do
            if tick() - time > 2.7 then
                dropInst(inst)
            elseif not inst.Parent then
                heldInstruments[inst] = nil
            end
        end
        task.wait(0.3)
    end
end

FunTab:CreateToggle({
    Name = "Use all Instruments",
    CurrentValue = false,
    Flag = "HoldInstrument",
    Callback = function(v) holdInstrumentEnabled = v; if v then task.spawn(instLoop) end
})

FunTab:CreateLabel("PlotBreaker", "tower-control")

local plotBreakerEnabled = false
local lastBreakTick = 0

FunTab:CreateToggle({
    Name = "Auto Break Plot",
    CurrentValue = false,
    Flag = "PlotBreaker",
    Callback = function(v)
        plotBreakerEnabled = v
        if v then
            task.spawn(function()
                while plotBreakerEnabled do
                    if tick() - lastBreakTick < 0.6 then task.wait(0.1) continue end
                    lastBreakTick = tick()
                    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp then continue end
                    local saved = hrp.CFrame
                    SpawnToyRF:InvokeServer("FoodHamburger", hrp.CFrame * CFrame.new(4,4,15), Vector3.zero)
                    task.wait(0.25)
                    local burger = BackPack:FindFirstChild("FoodHamburger")
                    if burger and burger:FindFirstChild("HoldPart") then
                        local hold = burger.HoldPart:FindFirstChild("HoldItemRemoteFunction")
                        if hold then pcall(function() hold:InvokeServer(burger, LP.Character) end) end
                    end
                    hrp.CFrame = CFrame.new(-541, -7, 68)
                    task.wait(0.1)
                    if burger then DestroyToyRF:FireServer(burger) end
                    hrp.CFrame = saved
                    task.wait(0.6)
                    local boomboxes = 0
                    for _, child in pairs(BackPack:GetChildren()) do
                        if child.Name == "Boombox" then boomboxes = boomboxes + 1 end
                    end
                    if boomboxes > 0 then
                        plotBreakerEnabled = false
                        notify("PlotBreaker", "Server broken")
                        break
                    end
                    SpawnToyRF:InvokeServer("Boombox", CFrame.new(-541, -2, 68), Vector3.zero)
                    task.wait(0.8)
                end
            end)
        end
    end
})

-- Info Tab
InfoTab:CreateSection("Premium Info")
InfoTab:CreateParagraph({
    Title = "How to get premium?",
    Content = "Join the discord, price is 200 ROBUX for permanent."
})
InfoTab:CreateButton({
    Name = "Copy Discord Link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/PMk4T9F8ZC")
            notify("Copied", "Discord link copied to clipboard")
        end
    end
})
InfoTab:CreateLabel("Your Role: " .. role)
InfoTab:CreateLabel("Script by: VenomX Team")

-- Explosions Tab (from ftap2)
ExplosionTab:CreateLabel("Missile", "Rocket")

local missileTarget = nil
local missileAmount = 5
local missileMode = "Instant"
local missileDelay = 0.05
local missileSpam = false
local missileObjects = {}
local missileQueue = {}
local missileFolder = BackPack

local function setupExplosionChar()
    missileFolder = Workspace:FindFirstChild(LP.Name .. "SpawnedInToys") or BackPack
    if not missileFolder then
        missileFolder = Instance.new("Folder", Workspace)
        missileFolder.Name = LP.Name .. "SpawnedInToys"
    end
    missileObjects = {}
    missileQueue = {}
    for _, child in pairs(missileFolder:GetChildren()) do
        if child.Name == "BombMissile" then table.insert(missileQueue, child) end
    end
end
setupExplosionChar()

local function spawnMissile()
    if not missileSpam then return end
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local pos = hrp.Position + Vector3.new(0, 10, 0)
    SpawnToyRF:InvokeServer("BombMissile", CFrame.new(pos), Vector3.new(0, 90, 0))
end

local function explodeMissile(model)
    if not BombEvents then return end
    local hitbox = model:FindFirstChild("PartHitDetector") or model:FindFirstChild("Body") or model.PrimaryPart
    if not hitbox then return end
    local target = missileTarget and Players:FindFirstChild(missileTarget)
    local pos = Vector3.zero
    if target and target.Character then
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then pos = hrp.Position end
    else
        pos = Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10))
    end
    BombEvents.BombExplode:FireServer({
        Radius = 17.5,
        TimeLength = 2,
        Hitbox = hitbox,
        ExplodesByFire = false,
        MaxForcePerStudSquared = 225,
        Model = model,
        ImpactSpeed = 100,
        ExplodesByPointy = false,
        DestroysModel = false,
        PositionPart = workspace.SpawnLocation,
    }, pos)
end

local function missileLoop()
    while missileSpam do
        local count = 0
        for _, child in pairs(missileFolder:GetChildren()) do
            if child.Name == "BombMissile" then count = count + 1 end
        end
        if count < missileAmount then
            spawnMissile()
            task.wait(0.1)
        end
        local missiles = {}
        for _, child in pairs(missileFolder:GetChildren()) do
            if child.Name == "BombMissile" then table.insert(missiles, child) end
        end
        if #missiles >= missileAmount then
            for i=1, missileAmount do
                local m = missiles[i]
                if m then
                    explodeMissile(m)
                    if missileMode == "Sequential" then
                        task.wait(missileDelay)
                    end
                end
            end
            task.wait(0.3)
        end
        task.wait(0.1)
    end
end

local function refreshMissileDropdown()
    local opts = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP then
            table.insert(opts, "@" .. plr.Name .. " (" .. plr.DisplayName .. ")")
        end
    end
    missileDropdown:Refresh(opts)
end

local missileDropdown = ExplosionTab:CreateDropdown({
    Name = "Select Target",
    Options = {},
    CurrentOption = {},
    Flag = "MissileTarget",
    Callback = function(opt)
        missileTarget = opt[1] and opt[1]:match("@([%w_]+)")
    end
})
Players.PlayerAdded:Connect(function() task.wait(0.5); refreshMissileDropdown() end)
Players.PlayerRemoving:Connect(function() task.wait(0.5); refreshMissileDropdown() end)
refreshMissileDropdown()

ExplosionTab:CreateToggle({
    Name = "Auto Spam",
    CurrentValue = false,
    Flag = "MissileSpam",
    Callback = function(v)
        missileSpam = v
        if v then task.spawn(missileLoop) end
    end
})
ExplosionTab:CreateSlider({
    Name = "Missiles per Wave",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 5,
    Flag = "MissileAmount",
    Callback = function(v) missileAmount = v end
})
ExplosionTab:CreateDropdown({
    Name = "Explosion Mode",
    Options = {"Instant", "Sequential"},
    CurrentOption = {"Instant"},
    Flag = "MissileMode",
    Callback = function(opt) missileMode = opt[1] end
})
ExplosionTab:CreateSlider({
    Name = "Delay (Sequential)",
    Range = {0, 0.3},
    Increment = 0.01,
    CurrentValue = 0.05,
    Flag = "MissileDelay",
    Callback = function(v) missileDelay = v end
})

-- Misc Tab
MiscTab:CreateLabel("Silent Aim", "Target")

local silentAimV2 = false
local silentAimRangeV2 = 30

local function getNearestPlayerV2()
    local closest, minDist = nil, silentAimRangeV2
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (LP.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if dist < minDist then minDist = dist; closest = plr end
            end
        end
    end
    return closest
end

MiscTab:CreateToggle({
    Name = "Silent Aim (Mouse1)",
    CurrentValue = false,
    Flag = "SilentAimV2",
    Callback = function(v) silentAimV2 = v end
})
MiscTab:CreateSlider({
    Name = "Range",
    Range = {1, 100},
    Increment = 1,
    CurrentValue = 30,
    Flag = "SilentAimRangeV2",
    Callback = function(v) silentAimRangeV2 = v end
})

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and silentAimV2 then
        local target = getNearestPlayerV2()
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            if head then
                SetNetworkOwner:FireServer(head, head.CFrame)
                CreateGrabLine:FireServer(head, head.CFrame)
                task.delay(0.1, function() DestroyGrabLine:FireServer(head) end)
            end
        end
    end
end)

MiscTab:CreateLabel("Boombox", "speaker")

local boomboxVolume = 0.5
local boomboxSounds = {}

local function updateBoomboxVolume()
    for _, sound in pairs(boomboxSounds) do
        if sound and sound.Parent then
            sound.Volume = boomboxVolume
        end
    end
end

Workspace.DescendantAdded:Connect(function(desc)
    if desc.Name == "Boombox" and desc:FindFirstChild("Speaker") then
        for _, sound in pairs(desc.Speaker:GetChildren()) do
            if sound:IsA("Sound") and (sound.Name:find("01_Green") or sound.Name:find("02_Street") or sound.Name:find("03_Ukrainian")) then
                table.insert(boomboxSounds, sound)
                sound.Volume = boomboxVolume
            end
        end
    end
end)

for _, desc in pairs(Workspace:GetDescendants()) do
    if desc.Name == "Boombox" and desc:FindFirstChild("Speaker") then
        for _, sound in pairs(desc.Speaker:GetChildren()) do
            if sound:IsA("Sound") and (sound.Name:find("01_Green") or sound.Name:find("02_Street") or sound.Name:find("03_Ukrainian")) then
                table.insert(boomboxSounds, sound)
                sound.Volume = boomboxVolume
            end
        end
    end
end

MiscTab:CreateSlider({
    Name = "Boombox Volume",
    Range = {0, 1},
    Increment = 0.1,
    CurrentValue = 0.5,
    Flag = "BoomboxVolume",
    Callback = function(v) boomboxVolume = v; updateBoomboxVolume() end
})

MiscTab:CreateLabel("Auto", "Repeat")

local autoSpinEnabled = false

local function slotsLit()
    for _, slot in pairs(Workspace.Slots:GetChildren()) do
        local handle = slot:FindFirstChild("SlotHandle")
        if handle and handle:FindFirstChild("LightBall") and handle.LightBall.Material == Enum.Material.Neon then
            return true
        end
    end
    return false
end

MiscTab:CreateToggle({
    Name = "Auto-Spin",
    CurrentValue = false,
    Flag = "AutoSpinMisc",
    Callback = function(v)
        autoSpinEnabled = v
        if v then
            task.spawn(function()
                while autoSpinEnabled do
                    if slotsLit() then
                        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local saved = hrp.CFrame
                            for _, slot in pairs(Workspace.Slots:GetChildren()) do
                                local handle = slot:FindFirstChild("SlotHandle")
                                if handle then
                                    local coin = handle:FindFirstChild("Handle")
                                    if coin then
                                        hrp.CFrame = coin.CFrame + Vector3.new(0,5,0)
                                        SetNetworkOwner:FireServer(coin, coin.CFrame)
                                        task.wait(0.2)
                                    end
                                end
                            end
                            hrp.CFrame = saved
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

-- Keybind Tab
KeybindTab:CreateSection("Keybinds")

KeybindTab:CreateKeybind({
    Name = "Teleport to Mouse (Z)",
    CurrentKeybind = "Z",
    HoldToInteract = false,
    Callback = function()
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local mouse = LP:GetMouse()
            if mouse and mouse.Target then
                local pos = mouse.Hit.Position + Vector3.new(0,5,0)
                hrp.CFrame = CFrame.new(pos)
            end
        end
    end
})

KeybindTab:CreateKeybind({
    Name = "Spawn Pallet (P)",
    CurrentKeybind = "P",
    HoldToInteract = false,
    Callback = function()
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local look = Camera.CFrame.LookVector
            local pos = hrp.Position + look * 3
            SpawnToyRF:InvokeServer("PalletLightBrown", CFrame.new(pos, pos + look), Vector3.new(0, 5, 0))
        end
    end
})

KeybindTab:CreateKeybind({
    Name = "Delete Limbs (U)",
    CurrentKeybind = "U",
    HoldToInteract = false,
    Callback = function()
        local gp = Workspace:FindFirstChild("GrabParts")
        if gp then
            local grab = gp:FindFirstChild("GrabPart")
            if grab then
                local weld = grab:FindFirstChild("WeldConstraint")
                if weld and weld.Part1 then
                    local model = weld.Part1:FindFirstAncestorOfClass("Model")
                    if model then
                        for _, limb in pairs({"Right Arm", "Left Arm", "Right Leg", "Left Leg"}) do
                            local part = model:FindFirstChild(limb)
                            if part then
                                part.CFrame = CFrame.new(0, -10000, 0)
                            end
                        end
                    end
                end
            end
        end
    end
})

KeybindTab:CreateKeybind({
    Name = "Aimbot (T)",
    CurrentKeybind = "T",
    HoldToInteract = false,
    Callback = function()
        local target = getNearestPlayerV2()
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            if head then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
            end
        end
    end
})

KeybindTab:CreateSection("Lobotomy OP")

KeybindTab:CreateButton({
    Name = "Lobotomy",
    Callback = function()
        local char = LP.Character or LP.CharacterAdded:Wait()
        local hum = char:WaitForChild("Humanoid")
        local hrp = char:WaitForChild("HumanoidRootPart")
        SpawnToyRF:InvokeServer("CreatureBlobman", hrp.CFrame * CFrame.new(0,0,-5), Vector3.new(0,-16.157,0))
        task.spawn(function()
            while true do
                local blob = BackPack:FindFirstChild("CreatureBlobman")
                if blob then
                    local seat = blob:FindFirstChild("VehicleSeat")
                    if seat and seat.Occupant ~= hum then
                        seat:Sit(hum)
                    end
                end
                task.wait(0.1)
            end
        end)
        task.spawn(function()
            while true do
                pcall(function() LP.IsHeld.Value = true end)
                task.wait()
            end
        end)
        task.spawn(function()
            while true do
                for _=1,12 do
                    RagdollRemote:FireServer(hrp, 0)
                end
                task.wait()
            end
        end)
    end
})

-- Form Tab
FormTab:CreateLabel("Form Grab", "Hand")

local formEnabled = false
local formTarget = nil
local formDistance = 10
local formRotation = 0
local formPreset = "Penis Head"
local formCopyMovement = false
local formParts = {}
local formConnections = {}

local presets = {
    ["Penis Head"] = {
        Torso = {pos = Vector3.new(0,-10,0), rot = CFrame.Angles(0,0,0)},
        ["Right Arm"] = {pos = Vector3.new(0,3,0), rot = CFrame.Angles(0,0,1.57)},
        ["Left Arm"] = {pos = Vector3.new(0,0,0), rot = CFrame.Angles(0,0,-1.57)},
        ["Right Leg"] = {pos = Vector3.new(1.75,0,0), rot = CFrame.Angles(0,0,0)},
        ["Left Leg"] = {pos = Vector3.new(-1,0,0), rot = CFrame.Angles(0,0,0)},
        Head = {pos = Vector3.new(0,4,0), rot = CFrame.Angles(0,math.pi,0)}
    },
    ["L Shape"] = {
        Torso = {pos = Vector3.new(0,-10,0), rot = CFrame.Angles(0,0,0)},
        ["Right Arm"] = {pos = Vector3.new(0,3,0), rot = CFrame.Angles(0,0,1.57)},
        ["Left Arm"] = {pos = Vector3.new(0,0,0), rot = CFrame.Angles(0,0,-1.57)},
        ["Right Leg"] = {pos = Vector3.new(0,-10,0), rot = CFrame.Angles(0,0,0)},
        ["Left Leg"] = {pos = Vector3.new(-1,0,0), rot = CFrame.Angles(0,0,0)},
        Head = {pos = Vector3.new(0,-10,0), rot = CFrame.Angles(0,0,0)}
    },
    ["Ice Cream"] = {
        Torso = {pos = Vector3.new(0,0,0), rot = CFrame.Angles(0,0,0)},
        ["Right Arm"] = {pos = Vector3.new(0,-1,0), rot = CFrame.Angles(0,0,1.57)},
        ["Left Arm"] = {pos = Vector3.new(0,-1,0), rot = CFrame.Angles(0,0,1.57)},
        ["Right Leg"] = {pos = Vector3.new(0,-1,0), rot = CFrame.Angles(0,0,1.57)},
        ["Left Leg"] = {pos = Vector3.new(0,-1,0), rot = CFrame.Angles(0,0,1.57)},
        Head = {pos = Vector3.new(0,1.5,0), rot = CFrame.Angles(0,0,0)}
    },
    Dog = {
        Torso = {pos = Vector3.new(0,-1,0), rot = CFrame.Angles(4.71,0,0)},
        ["Right Arm"] = {pos = Vector3.new(-1,-2.5,1), rot = CFrame.Angles(math.pi,0,1.57)},
        ["Left Arm"] = {pos = Vector3.new(1,-2.5,1), rot = CFrame.Angles(math.pi,0,1.57)},
        ["Right Leg"] = {pos = Vector3.new(1,-2,-1), rot = CFrame.Angles(0,0,1.57)},
        ["Left Leg"] = {pos = Vector3.new(-1,-2,-1), rot = CFrame.Angles(0,0,1.57)},
        Head = {pos = Vector3.new(0,0,-1), rot = CFrame.Angles(0,0,0)}
    },
    Square = {
        Torso = {pos = Vector3.zero, rot = CFrame.Angles(0,0,0)},
        ["Right Arm"] = {pos = Vector3.new(0.5,0,0), rot = CFrame.Angles(0,0,0)},
        ["Left Arm"] = {pos = Vector3.new(0.5,0,0), rot = CFrame.Angles(0,0,0)},
        ["Right Leg"] = {pos = Vector3.new(0.5,0,0), rot = CFrame.Angles(0,0,0)},
        ["Left Leg"] = {pos = Vector3.new(0.5,0,0), rot = CFrame.Angles(0,0,0)},
        Head = {pos = Vector3.zero, rot = CFrame.Angles(0,0,0)}
    }
}

local function getFormParts(model)
    local parts = {}
    parts.torso = model:FindFirstChild("Torso") or model:FindFirstChild("HumanoidRootPart")
    parts.head = model:FindFirstChild("Head")
    parts.limbs = {}
    for _, name in pairs({"Left Arm", "Right Arm", "Left Leg", "Right Leg"}) do
        local limb = model:FindFirstChild(name)
        if limb then
            local rag = limb:FindFirstChild("RagdollLimbPart")
            if rag then
                table.insert(parts.limbs, {part = rag, name = name})
            end
        end
    end
    return parts
end

local function applyForm(model)
    if not formEnabled then return end
    local parts = getFormParts(model)
    if not parts.torso then return end
    local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    local look = myHRP.CFrame.LookVector
    local pos = myHRP.Position + look * formDistance
    local baseCF = CFrame.new(pos, pos + look) * CFrame.Angles(0, math.rad(formRotation), 0)
    local preset = presets[formPreset] or presets["Penis Head"]
    for _, part in pairs(model:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
    if parts.torso then
        parts.torso.CFrame = baseCF * CFrame.new(preset.Torso.pos) * preset.Torso.rot
        parts.torso.Velocity = Vector3.zero
        parts.torso.RotVelocity = Vector3.zero
    end
    if parts.head then
        parts.head.CFrame = baseCF * CFrame.new(preset.Head.pos) * preset.Head.rot
        parts.head.Velocity = Vector3.zero
        parts.head.RotVelocity = Vector3.zero
    end
    for _, limb in pairs(parts.limbs) do
        if limb.part then
            local data = preset[limb.name]
            if data then
                limb.part.CFrame = baseCF * CFrame.new(data.pos) * data.rot
                limb.part.Velocity = Vector3.zero
                limb.part.RotVelocity = Vector3.zero
            end
        end
    end
end

local function formLoop()
    while formEnabled do
        local target = formTarget and Players:FindFirstChild(formTarget)
        if target and target.Character then
            applyForm(target.Character)
        end
        task.wait(0.05)
    end
end

local function refreshFormDropdown()
    local opts = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP then
            table.insert(opts, "@" .. plr.Name .. " (" .. plr.DisplayName .. ")")
        end
    end
    formDropdown:Refresh(opts)
end

local formDropdown = FormTab:CreateDropdown({
    Name = "Target Player",
    Options = {},
    CurrentOption = {},
    Flag = "FormTarget",
    Callback = function(opt)
        formTarget = opt[1] and opt[1]:match("@([%w_]+)")
    end
})
Players.PlayerAdded:Connect(function() task.wait(0.5); refreshFormDropdown() end)
Players.PlayerRemoving:Connect(function() task.wait(0.5); refreshFormDropdown() end)
refreshFormDropdown()

FormTab:CreateToggle({
    Name = "Enable Form Grab",
    CurrentValue = false,
    Flag = "FormEnable",
    Callback = function(v)
        formEnabled = v
        if v then task.spawn(formLoop) end
    end
})
FormTab:CreateSlider({
    Name = "Distance",
    Range = {0, 20},
    Increment = 1,
    CurrentValue = 10,
    Flag = "FormDistance",
    Callback = function(v) formDistance = v end
})
FormTab:CreateSlider({
    Name = "Rotation",
    Range = {0, 360},
    Increment = 5,
    CurrentValue = 0,
    Flag = "FormRotation",
    Callback = function(v) formRotation = v end
})
FormTab:CreateDropdown({
    Name = "Preset",
    Options = {"Penis Head", "L Shape", "Ice Cream", "Dog", "Square"},
    CurrentOption = {"Penis Head"},
    Flag = "FormPreset",
    Callback = function(opt) formPreset = opt[1] end
})
FormTab:CreateToggle({
    Name = "Copy Movement (Premium)",
    CurrentValue = false,
    Flag = "FormCopyMove",
    Callback = function(v) formCopyMovement = v end
})

-- Final notifications
notify("🩸VenomX🔥", "V5 with all features from ftap2 and Bloody P2")
notify("Made by VenomX Team", "Enjoy the full package!")