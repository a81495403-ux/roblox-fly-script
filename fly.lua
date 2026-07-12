-- ORION KÜTÜPHANESİ (Arayüz İçin)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Beehive Pro | Fly v1", HidePremium = false, SaveConfig = true, ConfigFolder = "BeehiveConfig"})

-- ANA SEKME
local FlyTab = Window:MakeTab({
    Name = "Uçuş Menüsü",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- UÇUŞ DEĞİŞKENLERİ
local Flying = false
local Speed = 50
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()

-- UÇUŞ FONKSİYONU
local function StartFlying()
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Root = Character:WaitForChild("HumanoidRootPart")
    
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Name = "FlyVelocity"
    BodyVelocity.MaxForce = Vector3.new(1/0, 1/0, 1/0)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.Parent = Root
    
    local BodyGyro = Instance.new("BodyGyro")
    BodyGyro.Name = "FlyGyro"
    BodyGyro.MaxTorque = Vector3.new(1/0, 1/0, 1/0)
    BodyGyro.P = 10000
    BodyGyro.D = 100
    BodyGyro.CFrame = Root.CFrame
    BodyGyro.Parent = Root

    spawn(function()
        while Flying do
            wait()
            BodyVelocity.Velocity = (workspace.CurrentCamera.CFrame.LookVector * Speed)
            BodyGyro.CFrame = workspace.CurrentCamera.CFrame
        end
        BodyVelocity:Destroy()
        BodyGyro:Destroy()
    end)
end

-- ARAYÜZ (GUI) ELEMANLARI
FlyTab:AddToggle({
    Name = "Uçmayı Başlat",
    Default = false,
    Callback = function(Value)
        Flying = Value
        if Flying then
            StartFlying()
        end
    end
})

FlyTab:AddSlider({
    Name = "Uçuş Hızı",
    Min = 10,
    Max = 200,
    Default = 50,
    Increment = 1,
    ValueName = "Hız",
    Callback = function(Value)
        Speed = Value
    end
})

OrionLib:Init()
