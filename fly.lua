local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Beehive Pro | Fly v3",
   LoadingTitle = "Script Yükleniyor...",
   LoadingSubtitle = "by a81495403-ux",
   ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Özellikler", 4483345998)

-- DEĞİŞKENLER
local Flying = false
local Speed = 50
local WallHopEnabled = false
local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- 1. GELİŞMİŞ UÇUŞ FONKSİYONU (Sadece Yürüdüğünde Gider)
local function StartFlying()
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Root = Character:WaitForChild("HumanoidRootPart")
    local Humanoid = Character:WaitForChild("Humanoid")
    
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Name = "FlyVelocity"
    BodyVelocity.MaxForce = Vector3.new(1/0, 1/0, 1/0)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.Parent = Root
    
    local BodyGyro = Instance.new("BodyGyro")
    BodyGyro.Name = "FlyGyro"
    BodyGyro.MaxTorque = Vector3.new(1/0, 1/0, 1/0)
    BodyGyro.P = 10000
    BodyGyro.CFrame = Root.CFrame
    BodyGyro.Parent = Root

    task.spawn(function()
        while Flying do
            RunService.RenderStepped:Wait()
            if Character and Root and Humanoid then
                -- MoveDirection, oyuncunun joystick veya klavyeyle hareket edip etmediğini kontrol eder
                if Humanoid.MoveDirection.Magnitude > 0 then
                    -- Oyuncu yürüme tuşlarına basıyorsa kameranın yönüne doğru uçur
                    BodyVelocity.Velocity = workspace.CurrentCamera.CFrame.LookVector * Speed
                else
                    -- Tuşlara basmıyorsa havada sabit tut
                    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
                BodyGyro.CFrame = workspace.CurrentCamera.CFrame
            end
        end
        if BodyVelocity then BodyVelocity:Destroy() end
        if BodyGyro then BodyGyro:Destroy() end
    end)
end

-- 2. OTOMATİK WALL HOP FONKSİYONU
task.spawn(function()
    while true do
        task.wait(0.1)
        if WallHopEnabled then
            local Character = Player.Character
            local Root = Character and Character:FindFirstChild("HumanoidRootPart")
            local Humanoid = Character and Character:FindFirstChild("Humanoid")
            
            if Root and Humanoid and Humanoid.MoveDirection.Magnitude > 0 then
                -- Karakterin önünde duvar olup olmadığını algılamak için ışın (Raycast) gönderiyoruz
                local RaycastParams = RaycastParams.new()
                RaycastParams.FilterDescendantsInstances = {Character}
                RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
                
                -- Karakterin baktığı yöne doğru kısa bir mesafe tarama yap
                local RaycastResult = workspace:Raycast(Root.Position, Root.CFrame.LookVector * 3, RaycastParams)
                
                -- Önünde bir nesne varsa ve yerle teması kesilmediyse otomatik zıplat
                if RaycastResult and Humanoid.FloorMaterial ~= Enum.Material.Air then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
    end
end)

-- ARAYÜZ ELEMANLARI
Tab:CreateToggle({
   Name = "Gelişmiş Uçuşu Aç",
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
   Min = 10,
   Max = 200,
   CurrentValue = 50,
   Flag = "FlySpeed",
   Callback = function(Value)
        Speed = Value
   end,
})

Tab:CreateToggle({
   Name = "Otomatik Wall Hop",
   CurrentValue = false,
   Flag = "WallHopToggle",
   Callback = function(Value)
        WallHopEnabled = Value
   end,
})
