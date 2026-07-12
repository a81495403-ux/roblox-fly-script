-- RAYFIELD KÜTÜPHANESİ (Delta ile En Uyumlu ve Sorunsuz Arayüz)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Beehive Pro | Fly v2",
   LoadingTitle = "Script Yükleniyor...",
   LoadingSubtitle = "by a81495403-ux",
   ConfigurationSaving = {
      Enabled = false
   }
})

-- ANA SEKME
local Tab = Window:CreateTab("Uçuş Menüsü", 4483345998)

-- UÇUŞ DEĞİŞKENLERİ
local Flying = false
local Speed = 50
local Player = game.Players.LocalPlayer

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

    task.spawn(function()
        while Flying do
            task.wait()
            if workspace.CurrentCamera then
                BodyVelocity.Velocity = (workspace.CurrentCamera.CFrame.LookVector * Speed)
                BodyGyro.CFrame = workspace.CurrentCamera.CFrame
            end
        end
        BodyVelocity:Destroy()
        BodyGyro:Destroy()
    end)
end

-- ARAYÜZ ELEMANLARI
Tab:CreateToggle({
   Name = "Uçmayı Başlat",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
        Flying = Value
        if Flying then
            StartFlying()
        end
   end,
})

Tab:CreateSlider({
   Name = "Uçuş Hızı",
   Info = "Uçma hızını ayarlar",
   Min = 10,
   Max = 200,
   CurrentValue = 50,
   Flag = "FlySpeed",
   Callback = function(Value)
        Speed = Value
   end,
})
