local DiscordLib = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/discord%20lib.txt")()

local SETTINGS = {
    AutoFarm = false,
}
local VirtualUser = game:GetService("VirtualUser")
local win = DiscordLib:Window("NMZ Hub")
local ItemSpawns = workspace.ItemSpawns
local NPCs = workspace.NPCS
local Living = workspace.Living
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RepModules = ReplicatedStorage.ReplicatedModules
local Player = Players.LocalPlayer

local senv = getsenv(Player.PlayerScripts.Input)

local Stands = require(RepModules.Stands)
local Moves = require(RepModules.Movesets)

Player.Idled:Connect(function()
    VirtualUser:ClickButton2(Vector2.new())
end)

for i,v in pairs(senv) do
    if i == "CanAttack" then
        local oldfun = senv[i]
        senv[i] = function(...)
            if SETTINGS.NoCooldown then
                return true
            else
                oldfun(...)
            end
        end
    end
end

local serv = win:Server("AUT", "")
local AutoFarms = {
    ["ChestAutoFarm"] = ItemSpawns.Chests,
    ["DuneAutoFarm"] = ItemSpawns["Sand Debris"],
    ["MTAutoFarm"] = ItemSpawns.Meteors,
    ["ItemAutoFarm"] = ItemSpawns.StandardItems,
}

local btns = serv:Channel("Information")
local StandName = Stands[Player.Data.Ability.Value]
btns:Label("Stand: "..StandName)
btns:Label("Moves:")
for i,v in pairs(Moves.Movesets[StandName]) do
    btns:Label(i.." - "..v)
end

local btns = serv:Channel("Farm")
btns:Toggle("AutoFarm", false, function(bool)
    SETTINGS.AutoFarm = true
end)
btns:Toggle("Chest AutoFarm", false, function(bool)
    SETTINGS.ChestAutoFarm = bool
end)
btns:Toggle("Sand Dune AutoFarm", false, function(bool)
    SETTINGS.DuneAutoFarm = bool
end)
btns:Toggle("Meteor AutoFarm", false, function(bool)
    SETTINGS.MTAutoFarm = bool
end)
btns:Toggle("Item AutoFarm", false, function(bool)
    SETTINGS.ItemAutoFarm = bool
end)
btns:Toggle("Dio AutoFarm", false, function(bool)
    SETTINGS.DioAutoFarm = bool
end)
btns:Toggle("Auto Attack", false, function(bool)
    SETTINGS.LMBAuto = bool
end)
btns:Toggle("Attack Spam", false, function(bool)
    SETTINGS.YAuto = bool
end)

local btns = serv:Channel("Teleports")
btns:Label("Presets")
btns:Button("Sakuya", function()
    local model = NPCs:FindFirstChild("Sakuya")
    local head = model and model:FindFirstChild("Head", true)
    if head then
        Player.Character:PivotTo(head.CFrame)
    end
end)
btns:Button("Pucci", function()
    local model = NPCs:FindFirstChild("Enrico Pucci")
    local head = model and model:FindFirstChild("Head", true)
    if head then
        Player.Character:PivotTo(head.CFrame)
    end
end)
btns:Button("Shop", function()
    local model = NPCs:FindFirstChild("StandShop")
    local head = model and model:FindFirstChild("Head", true)
    if head then
        Player.Character:PivotTo(head.CFrame)
    end
end)
btns:Button("Stand Storage", function()
    local model = NPCs:FindFirstChild("EpicFlow203")
    local head = model and model:FindFirstChild("Head", true)
    if head then
        Player.Character:PivotTo(head.CFrame)
    end
end)
btns:Label("All NPCs")
for i,v in pairs(NPCs:GetChildren()) do
    if v:IsA("Model") then
        btns:Button(v.Name, function()
            local model = v
            local head = model and model:FindFirstChild("Head", true)
            if head then
                Player.Character:PivotTo(head.CFrame)
            end
        end)
    end
end

local btns = serv:Channel("Misc")
btns:Toggle("Sand Dune Notificator", false, function(bool)
    SETTINGS.DuneNotif = bool
end)
btns:Toggle("Chest Notificator", false, function(bool)
    SETTINGS.ChestNotif = bool
end)
btns:Toggle("Meteor Notificator", false, function(bool)
    SETTINGS.MeteorNotif = bool
end)
btns:Toggle("Dio Notificator", false, function(bool)
    SETTINGS.DioNotif = bool
end)
btns:Toggle("Hide Names", false, function(bool)
    SETTINGS.HideName = bool
end)
btns:Toggle("No Cooldown", false, function(bool)
    SETTINGS.NoCooldown = bool
end)
btns:Button("Stand Storage", function()
    local storage = Player.PlayerGui:FindFirstChild("StorageGui", true)
    local main = storage and storage:FindFirstChild("Main")
    if main then 
        main.Visible = not main.Visible
        main.Close.Visible = main.Visible
        
        if main.Visible then
            local Storage = main.Storage
            local v37 = TweenInfo.new(0.5, Enum.EasingStyle.Sine);
            main.Size = UDim2.fromScale(.664, .664);
            main.Position = UDim2.new(0.5, 0, 0.5, 0);
            main.Close.Size = UDim2.fromScale(.12, .12)
            main.Rotation = 0
        end
    end
end)
local tsincelastuse = 0
btns:Button("Reset Stand", function()
    local model = NPCs:FindFirstChild("Enrico Pucci")
    if model and tick()-tsincelastuse > .5 then
        local oldcf = Player.Character.PrimaryPart.CFrame
        Player.Character:PivotTo(model:FindFirstChild("Head", true).CFrame)
        wait(.5)
        fireproximityprompt(model:FindFirstChild("Interaction", true), 1)
        Player.Character:PivotTo(oldcf)
    end
end)
btns:Seperator()
btns:Toggle("God Mode", false, function(bool)
    Player.Character.Values.Block:Destroy()
    local Block = Instance.new("BoolValue")
    Block.Name = "Block"
    Block.Parent = Player.Character.Values
    Player.Character.Humanoid.MaxHealth = math.huge
    Player.Character.Humanoid.Health = math.huge
end)
btns:Seperator()
local box = btns:Textbox("Choose Victim", "Player Name", false, function(t)-- This script was generated by Hydroxide's RemoteSpy: https://github.com/Upbolt/Hydroxide
    SETTINGS.Target = t
end)
btns:Toggle("Player Kill Helper", false, function(bool)
    SETTINGS.KillHelper = bool
    while SETTINGS.KillHelper do
        local playertarget = SETTINGS.Target and Living:FindFirstChild(SETTINGS.Target)
        if playertarget then
            playertarget = SETTINGS.Target and Living:FindFirstChild(SETTINGS.Target)
            Player.Character:PivotTo(playertarget.PrimaryPart.CFrame * CFrame.new(0,0,-4) * CFrame.Angles(0,math.rad(180),0))
            if Player.Character:FindFirstChild("ForceField") then
                Player.Character:FindFirstChild("ForceField"):Destroy()
            end
        end
        wait()
    end
end)
btns:Button("Mr. President [KC Only] [Needs Sakuya]", function()
    local s,e = pcall(function()
    if Player.Data.Ability.Value == 9 and NPCs:FindFirstChild("Sakuya") then
        local playertarget = SETTINGS.Target and Living:FindFirstChild(SETTINGS.Target)
        if playertarget then
            local oldpos = Player.Character.PrimaryPart.CFrame
            local ohString1 = "KEY"
            local ohString2 = "R"
            
            task.spawn(function()
                game:GetService("ReplicatedStorage").Remotes.Input:FireServer(ohString1, ohString2)
                game:GetService("ReplicatedStorage").Remotes.InputFunc:InvokeServer(ohString2)
                game:GetService("ReplicatedStorage").Remotes.Input:FireServer(ohString1, "END-"..ohString2)
                game:GetService("ReplicatedStorage").Remotes.InputFunc:InvokeServer("END-"..ohString2)
            end)
            wait(.3)
            local start = tick()
            while tick()-start < .8 do
                Player.Character:PivotTo(playertarget.PrimaryPart.CFrame * CFrame.new(0,0,2.5))
                wait()
            end
            local model = NPCs:FindFirstChild("Sakuya")
            local head = model and model:FindFirstChild("Head", true)
            if head then
                Player.Character:PivotTo(head.CFrame)
            end
            wait(3)
            Player.Character:PivotTo(oldpos)
        end
    end
    end)
    if not s then error(e) end
end)
local teleported = false
function farm(index, v, obj)
    if not teleported then
        local oldcf = Player.Character.PrimaryPart.CFrame
    end
    local con; con = game:GetService("RunService").Stepped:Connect(function()
        if not obj.Parent then
            con:Disconnect()
            teleported = false
            if SETTINGS[index] and SETTINGS.AutoFarm then
                Player.Character.PrimaryPart.CFrame = oldcf
            end
            return
        end
        if obj:FindFirstChild("Interaction", true) and SETTINGS[index] and SETTINGS.AutoFarm then
            teleported = true
            fireproximityprompt(obj:FindFirstChild("Interaction", true), 1)
            Player.Character.PrimaryPart.CFrame = v.CFrame + Vector3.new(0,3,0)
        end
    end)
    local ohString2 = "All"
    if SETTINGS.DuneNotif and index == "DuneAutoFarm" then
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Areia Spawnow", ohString2)
    end
    if SETTINGS.MeteorNotif and index == "MTAutoFarm" then
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Meteor Spawnow", ohString2)
    end
    if SETTINGS.ChestNotif and index == "ChestAutoFarm" then
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Chest Spawnow", ohString2)
    end
end
local tracking = {}
for index,Parent in pairs(AutoFarms) do
    for i,v in pairs(Parent:GetChildren()) do
        v.ChildAdded:Connect(function(obj)
            farm(index, v, obj)
        end)
        if v:GetChildren()[1] then
            farm(index, v, v:GetChildren()[1])
        end
    end
    Parent.ChildAdded:Connect(function(Spot)
        if not tracking[Spot] then
            tracking[Spot] = true
            Spot.ChildAdded:Connect(function(obj)
                farm(index, Spot, obj)
            end)
        end
    end)
end
function diofarm(obj)
    if SETTINGS.DioNotif then
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Dio Spawnow", "All")
    end
    
    local con; con = game:GetService("RunService").Stepped:Connect(function()
        if not obj.Parent then
            if SETTINGS.DioAutoFarm and SETTINGS.AutoFarm then
                con:Disconnect()
            end
            return
        end
        if obj.PrimaryPart and SETTINGS.DioAutoFarm and SETTINGS.AutoFarm then
            Player.Character.PrimaryPart.CFrame = obj.PrimaryPart.CFrame * CFrame.new(0,0,2.5)
        end
    end)
end
Living.ChildAdded:Connect(function(obj)
    if obj.Name == "Dio" then
        diofarm(obj)
    end
end)
for i,v in pairs(Living:GetChildren()) do
    if v.Name == "Dio" then
        diofarm(v)
    end
end

local lmbstart = 0
local ystart = 0
RunService.Heartbeat:Connect(function()
    if SETTINGS.NoCooldown then
        task.spawn(function()
            game:GetService("ReplicatedStorage").Remotes.Input:FireServer("KEY", "L")
            game:GetService("ReplicatedStorage").Remotes.InputFunc:InvokeServer("L")
        end)
        for i,v in pairs(Player.Cooldowns:GetChildren()) do
            v:Destroy()
        end
        for i,v in pairs(Player.UniversalCooldowns:GetChildren()) do
            v:Destroy()
        end
        for i,v in pairs(Player.Character.Cooldowns:GetChildren()) do
            v:Destroy()
        end
    end
    if SETTINGS.HideName then
        for i,v in pairs(Living:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") then
                v:FindFirstChildOfClass("Humanoid").DisplayName = " "
            end
        end
        for i,plr in pairs(Players:GetPlayers()) do
            local v = plr.Character
            if v and v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") then
                v:FindFirstChildOfClass("Humanoid").DisplayName = " "
            end
        end
    end
    if tick()-lmbstart > .25 and SETTINGS.LMBAuto then
        task.spawn(function()
            local ohString1 = "KEY"
            local ohString2 = "E"
            game:GetService("ReplicatedStorage").Remotes.Input:FireServer(ohString1, ohString2)
            game:GetService("ReplicatedStorage").Remotes.InputFunc:InvokeServer(ohString2)
            --game:GetService("ReplicatedStorage").Remotes.Input:FireServer(ohString1, "END-"..ohString2)
            --game:GetService("ReplicatedStorage").Remotes.InputFunc:InvokeServer("END-"..ohString2)
            local ohString2 = "LMB"
            game:GetService("ReplicatedStorage").Remotes.Input:FireServer(ohString1, ohString2)
            game:GetService("ReplicatedStorage").Remotes.InputFunc:InvokeServer(ohString2)
            --game:GetService("ReplicatedStorage").Remotes.Input:FireServer(ohString1, "END-"..ohString2)
            --game:GetService("ReplicatedStorage").Remotes.InputFunc:InvokeServer("END-"..ohString2)
        end)
    end
    if tick()-ystart > .25 and SETTINGS.YAuto then
        task.spawn(function()
            local ohString1 = "KEY"
            local ohString2 = SETTINGS.CURRENTKEY
            if ohString2 then
                game:GetService("ReplicatedStorage").Remotes.Input:FireServer(ohString1, ohString2)
                game:GetService("ReplicatedStorage").Remotes.InputFunc:InvokeServer(ohString2)
            end
        end)
    end
end)

UserInputService.InputBegan:Connect(function(InputObject, Gamepor)
    if not Gamepor then
        if InputObject.KeyCode ~= Enum.KeyCode.Unknown then
            SETTINGS.CURRENTKEY = UserInputService:GetStringForKeyCode(InputObject.KeyCode)
        end
    end
end)

UserInputService.InputBegan:Connect(function(InputObject)
    if InputObject.KeyCode ~= Enum.KeyCode.Unknown then
        SETTINGS.CURRENTKEY = nil
    end
end)

DiscordLib:Notification("Notification", "Script ran successfully", "Got it!")
