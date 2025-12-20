-- ==========================================
-- TLONG HUB FREEMIUM V1
-- AUTO PERCENTAGE HP | FULL CONTROL
-- ==========================================

local oldUI = game.CoreGui:FindFirstChild("TLONG_HUB_V1")
if oldUI then oldUI:Destroy() end

local MainUI = Instance.new("ScreenGui", game.CoreGui)
MainUI.Name = "TLONG_HUB_V1"

-- Biến hệ thống
local player = game.Players.LocalPlayer
local isFarmV1, isFarmV2, isUltraClean, isAutoEscape = false, false, false, false
local depth, angle = -6.5, 0
local LockedPlayer = nil
local Running = true
local IsEscaping = false

-- Nền tảng an toàn (Sky Base)
local SafePlatform = Instance.new("Part", game.Workspace)
SafePlatform.Size, SafePlatform.Anchored, SafePlatform.Transparency = Vector3.new(30, 1, 30), true, 1
SafePlatform.Position = Vector3.new(0, 9500, 0)
SafePlatform.Name = "TLONG_FREEMIUM_BASE"

-- --- GIAO DIỆN (280x450) ---
local MainFrame = Instance.new("Frame", MainUI)
MainFrame.Size = UDim2.new(0, 280, 0, 450)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Active, MainFrame.Draggable = true, true
Instance.new("UICorner", MainFrame)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color, UIStroke.Thickness = Color3.fromRGB(255, 0, 0), 2

local Header = Instance.new("TextLabel", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.Text = "TLONG HUB FREEMIUM V1"
Header.TextColor3 = Color3.new(1,1,1)
Header.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Header.Font = Enum.Font.GothamBold
Header.TextSize = 13
Instance.new("UICorner", Header)

local function QuickBtn(txt, pos, size, color)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Text, btn.Position, btn.Size = txt, pos, size
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    Instance.new("UICorner", btn)
    return btn
end

-- --- INPUTS ---
local NameBox = Instance.new("TextBox", MainFrame)
NameBox.Size = UDim2.new(1, -20, 0, 30)
NameBox.Position = UDim2.new(0, 10, 0, 45)
NameBox.PlaceholderText = "NHẬP TÊN ĐỐI THỦ..."
NameBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
NameBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", NameBox)

-- Ô Chỉnh Tầm Xa & Tốc Độ
local DistBox = Instance.new("TextBox", MainFrame)
DistBox.Size = UDim2.new(0, 125, 0, 25)
DistBox.Position = UDim2.new(0, 10, 0, 80)
DistBox.Text = "7"
DistBox.PlaceholderText = "Tầm xa V2..."
DistBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
DistBox.TextColor3 = Color3.new(0, 1, 1)
Instance.new("UICorner", DistBox)

local SpdBox = Instance.new("TextBox", MainFrame)
SpdBox.Size = UDim2.new(0, 125, 0, 25)
SpdBox.Position = UDim2.new(0, 145, 0, 80)
SpdBox.Text = "6"
SpdBox.PlaceholderText = "Tốc độ V2..."
SpdBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SpdBox.TextColor3 = Color3.new(1, 1, 0)
Instance.new("UICorner", SpdBox)

-- --- CÁC NÚT CHỨC NĂNG ---
local F1 = QuickBtn("FARM V1 (CHUI ĐẤT)", UDim2.new(0, 10, 0, 115), UDim2.new(0, 125, 0, 35), Color3.fromRGB(130, 0, 0))
local F2 = QuickBtn("FARM V2 (ORBIT)", UDim2.new(0, 145, 0, 115), UDim2.new(0, 125, 0, 35), Color3.fromRGB(80, 0, 130))
local Esc = QuickBtn("AUTO ESCAPE (20-85%): OFF", UDim2.new(0, 10, 0, 155), UDim2.new(1, -20, 0, 35))
local Cln = QuickBtn("FIX LAG: OFF", UDim2.new(0, 10, 0, 195), UDim2.new(1, -20, 0, 35), Color3.fromRGB(0, 90, 130))

local DAdd = QuickBtn("ĐỘ SÂU V1 (+)", UDim2.new(0, 10, 0, 235), UDim2.new(0, 125, 0, 30))
local DSub = QuickBtn("ĐỘ SÂU V1 (-)", UDim2.new(0, 145, 0, 235), UDim2.new(0, 125, 0, 30))

local Exit = QuickBtn("XÓA HUB", UDim2.new(0, 10, 0, 400), UDim2.new(1, -20, 0, 35), Color3.fromRGB(180, 0, 0))

-- --- LOGIC ---
F1.MouseButton1Click:Connect(function() isFarmV1 = not isFarmV1 isFarmV2 = false LockedPlayer = nil F1.Text = isFarmV1 and "V1: ĐANG CHẠY" or "FARM V1 (CHUI ĐẤT)" F2.Text = "FARM V2 (ORBIT)" end)
F2.MouseButton1Click:Connect(function() isFarmV2 = not isFarmV2 isFarmV1 = false LockedPlayer = nil F2.Text = isFarmV2 and "V2: ĐANG CHẠY" or "FARM V2 (ORBIT)" F1.Text = "FARM V1 (CHUI ĐẤT)" end)
Esc.MouseButton1Click:Connect(function() isAutoEscape = not isAutoEscape Esc.Text = isAutoEscape and "ESCAPE: BẬT" or "ESCAPE: TẮT" end)
Cln.MouseButton1Click:Connect(function() isUltraClean = not isUltraClean Cln.Text = isUltraClean and "LAG: BẬT" or "FIX LAG: OFF" end)
DAdd.MouseButton1Click:Connect(function() depth = depth + 0.5 end)
DSub.MouseButton1Click:Connect(function() depth = depth - 0.5 end)
Exit.MouseButton1Click:Connect(function() Running = false SafePlatform:Destroy() MainUI:Destroy() end)

-- --- VÒNG LẶP CORE ---
game:GetService("RunService").Heartbeat:Connect(function(dt)
    if not Running or not player.Character or not player.Character:FindFirstChild("Humanoid") then return end
    local hum, hrp = player.Character.Humanoid, player.Character.HumanoidRootPart
    
    -- TRỐN VÀ QUAY LẠI THEO PHẦN TRĂM
    if isAutoEscape then
        local hpPercent = (hum.Health / hum.MaxHealth) * 100
        if hpPercent < 20 and hum.Health > 0 then
            IsEscaping = true
        elseif IsEscaping and hpPercent >= 85 then
            IsEscaping = false
        end
    end

    if IsEscaping then
        hrp.CFrame = SafePlatform.CFrame * CFrame.new(0, 5, 0)
        hrp.Velocity = Vector3.zero
        return
    end

    -- LOGIC FARM
    if isFarmV1 or isFarmV2 then
        local tName = NameBox.Text:lower()
        if tName == "" then return end
        
        if not LockedPlayer or not LockedPlayer.Parent or LockedPlayer.Character.Humanoid.Health <= 0 then
            LockedPlayer = nil
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= player and (p.Name:lower():find(tName) or p.DisplayName:lower():find(tName)) then
                    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then LockedPlayer = p break end
                end
            end
        end

        if LockedPlayer then
            local enHrp = LockedPlayer.Character.HumanoidRootPart
            if isFarmV1 then
                hrp.CFrame = enHrp.CFrame * CFrame.new(0, depth, 0) * CFrame.Angles(math.rad(90), 0, 0)
            elseif isFarmV2 then
                angle = angle + (dt * (tonumber(SpdBox.Text) or 6))
                local d = tonumber(DistBox.Text) or 7
                hrp.CFrame = CFrame.new(enHrp.Position + Vector3.new(math.cos(angle)*d, 0, math.sin(angle)*d), enHrp.Position)
            end
            
            -- Đấm (LeftClick)
            local rem = game:GetService("ReplicatedStorage"):FindFirstChild("Communicate", true)
            if rem then rem:FindFirstChildOfClass("RemoteEvent"):FireServer({["Goal"] = "LeftClick"}) end
            
            -- Noclip
            for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
            hrp.Velocity = Vector3.zero
        else
            hrp.Velocity = Vector3.zero 
        end
    end
end)
