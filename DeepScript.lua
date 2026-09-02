-- ==========================================
-- DeepScript v9.0 - Pro Edition
-- Только для Roblox Studio (Личная песочница)
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ==========================================
-- 1. НАСТРОЙКИ (КОНФИГ)
-- ==========================================
local Config = {
	Password = "561",
	FlySpeed = 150,
	WalkSpeedBoost = 200,
	MainColor = Color3.fromRGB(20, 20, 25),
	AccentColor = Color3.fromRGB(255, 215, 0) -- Золотой
}

-- ==========================================
-- 2. СОЗДАНИЕ ИНТЕРФЕЙСА
-- ==========================================
local screen = Instance.new("ScreenGui")
screen.Name = "DeepScript_Pro"
screen.ResetOnSpawn = false
screen.Parent = playerGui

local function createCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = parent
end

-- ЭКРАН ВХОДА
local loginFrame = Instance.new("Frame")
loginFrame.Size = UDim2.new(0, 320, 0, 220)
loginFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loginFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
loginFrame.BackgroundColor3 = Config.MainColor
loginFrame.Parent = screen
createCorner(loginFrame, 12)

local loginStroke = Instance.new("UIStroke")
loginStroke.Color = Config.AccentColor
loginStroke.Thickness = 2
loginStroke.Parent = loginFrame

local loginTitle = Instance.new("TextLabel")
loginTitle.Size = UDim2.new(1, 0, 0, 50)
loginTitle.BackgroundTransparency = 1
loginTitle.Text = "DEEPSCRIPT PRO"
loginTitle.Font = Enum.Font.GothamBold
loginTitle.TextSize = 24
loginTitle.TextColor3 = Config.AccentColor
loginTitle.Parent = loginFrame

local passwordBox = Instance.new("TextBox")
passwordBox.Size = UDim2.new(0.8, 0, 0, 45)
passwordBox.Position = UDim2.new(0.1, 0, 0.3, 0)
passwordBox.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
passwordBox.TextColor3 = Color3.fromRGB(255, 255, 255)
passwordBox.PlaceholderText = "Введи пароль (561)"
passwordBox.Font = Enum.Font.Gotham
passwordBox.TextSize = 16
passwordBox.Parent = loginFrame
createCorner(passwordBox, 6)

local loginButton = Instance.new("TextButton")
loginButton.Size = UDim2.new(0.8, 0, 0, 45)
loginButton.Position = UDim2.new(0.1, 0, 0.65, 0)
loginButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
loginButton.Text = "ВОЙТИ"
loginButton.Font = Enum.Font.GothamBold
loginButton.TextColor3 = Color3.fromRGB(255, 255, 255)
loginButton.Parent = loginFrame
createCorner(loginButton, 6)

local errorLabel = Instance.new("TextLabel")
errorLabel.Size = UDim2.new(0.8, 0, 0, 30)
errorLabel.Position = UDim2.new(0.1, 0, 0.85, 0)
errorLabel.BackgroundTransparency = 1
errorLabel.Text = ""
errorLabel.Font = Enum.Font.Gotham
errorLabel.TextSize = 14
errorLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
errorLabel.Parent = loginFrame

-- ГЛАВНОЕ МЕНЮ
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 540)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -270)
mainFrame.BackgroundColor3 = Config.MainColor
mainFrame.Visible = false
mainFrame.Parent = screen
createCorner(mainFrame, 12)
mainFrame.Active = true
mainFrame.Draggable = true

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Config.AccentColor
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- ХЕДЕР
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
header.Parent = mainFrame
createCorner(header, 12)

local headerTitle = Instance.new("TextLabel")
headerTitle.Size = UDim2.new(1, 0, 1, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "DeepScript v9.0 (PRO)"
headerTitle.Font = Enum.Font.GothamBold
headerTitle.TextSize = 18
headerTitle.TextColor3 = Config.AccentColor
headerTitle.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = header
createCorner(closeBtn, 6)
closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

-- УВЕДОМЛЕНИЯ
local function showNotification(text, isOn)
	local note = Instance.new("TextLabel")
	note.Size = UDim2.new(0, 200, 0, 40)
	note.Position = UDim2.new(0.5, -100, 1, -60)
	note.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	note.Text = text
	note.Font = Enum.Font.GothamBold
	note.TextSize = 14
	note.TextColor3 = isOn and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
	note.Parent = mainFrame
	createCorner(note, 8)

	local tween = TweenService:Create(note, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -100, 0.8, 0)})
	tween:Play()

	task.wait(1.5)
	local tween2 = TweenService:Create(note, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -100, 1.1, 0)})
	tween2:Play()
	task.wait(0.5)
	note:Destroy()
end

-- ФУНКЦИЯ СОЗДАНИЯ КНОПОК
local function createButton(text, yPos, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0.9, 0, 0, 45)
	button.Position = UDim2.new(0.05, 0, 0, yPos)
	button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
	button.Text = text
	button.Font = Enum.Font.GothamBold
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Parent = mainFrame
	createCorner(button, 8)

	local statusText = Instance.new("TextLabel")
	statusText.Size = UDim2.new(0, 50, 1, 0)
	statusText.Position = UDim2.new(1, -60, 0, 0)
	statusText.BackgroundTransparency = 1
	statusText.Text = "OFF"
	statusText.Font = Enum.Font.GothamBold
	statusText.TextColor3 = Color3.fromRGB(255, 80, 80)
	statusText.Parent = button
	
	button.MouseButton1Click:Connect(function()
		local isOn = callback()
		statusText.Text = isOn and "ON" or "OFF"
		statusText.TextColor3 = isOn and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 80, 80)
	end)
	return button
end

-- ==========================================
-- 3. ЛОГИКА ФУНКЦИЙ (ИСПРАВЛЕННАЯ)
-- ==========================================
local flyEnabled = false
local noclipEnabled = false
local godModeEnabled = false
local invisibleEnabled = false
local speedEnabled = false
local targetPlayer = nil

-- ФЛАЙ (Исправлено: AssemblyLinearVelocity + PlatformStand)
local function updateFly()
	local character = player.Character
	if not character then return end
	
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local hum = character:FindFirstChildWhichIsA("Humanoid")
	
	if flyEnabled then
		if hum then hum.PlatformStand = true end
		if hrp then
			hrp.Anchored = false
		end
	else
		if hum then hum.PlatformStand = false end
		if hrp then
			hrp.Velocity = Vector3.zero
		end
	end
end

RunService.Heartbeat:Connect(function()
	if flyEnabled and player.Character then
		local hrp = player.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			local velocity = Vector3.zero
			local cam = workspace.CurrentCamera
			
			local moveDir = Vector3.zero
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				moveDir = moveDir + cam.CFrame.LookVector
			elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
				moveDir = moveDir - cam.CFrame.LookVector
			end
			
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				moveDir = moveDir + cam.CFrame.RightVector
			elseif UserInputService:IsKeyDown(Enum.KeyCode.D) then
				moveDir = moveDir - cam.CFrame.RightVector
			end
			
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				moveDir = moveDir + Vector3.new(0, 1, 0)
			elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				moveDir = moveDir - Vector3.new(0, 1, 0)
			end
			
			if moveDir.Magnitude > 0 then
				velocity = moveDir.Unit * Config.FlySpeed
			end
			
			hrp.AssemblyLinearVelocity = velocity
		end
	end
end)

-- NOCLIP
local function updateNoclip()
	for _, part in ipairs(player.Character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = not noclipEnabled
		end
	end
end

-- GOD MODE
local function updateGodMode()
	local hum = player.Character:FindFirstChildWhichIsA("Humanoid")
	if hum then
		if godModeEnabled then
			hum.MaxHealth = math.huge
			hum.Health = hum.MaxHealth
		else
			hum.MaxHealth = 100
			hum.Health = 100
		end
	end
end

-- INVISIBLE (Улучшено: SetNetworkOwner + LocalTransparency)
local function updateInvisible()
	for _, part in ipairs(player.Character:GetDescendants()) do
		if part:IsA("BasePart") then
			part:SetNetworkOwner(nil) -- Критически важно для работы на клиенте
			part.LocalTransparency = invisibleEnabled and 1 or 0
		end
	end
end

-- SPEED
local function updateSpeed()
	local hum = player.Character:FindFirstChildWhichIsA("Humanoid")
	if hum then
		hum.WalkSpeed = speedEnabled and Config.WalkSpeedBoost or 16
	end
end

-- ==========================================
-- 4. НАЗНАЧЕНИЕ КНОПОК
-- ==========================================
local flyBtn = createButton("🚀 Fly (WASD/Space)", 60, function()
	flyEnabled = not flyEnabled
	updateFly()
	showNotification(flyEnabled and "Fly ВКЛЮЧЕН" or "Fly ВЫКЛЮЧЕН", flyEnabled)
	return flyEnabled
end)

local noclipBtn = createButton("👻 NoClip (Ghost)", 115, function()
	noclipEnabled = not noclipEnabled
	updateNoclip()
	showNotification(noclipEnabled and "NoClip ВКЛЮЧЕН" or "NoClip ВЫКЛЮЧЕН", noclipEnabled)
	return noclipEnabled
end)

local godBtn = createButton("🧊 God Mode", 170, function()
	godModeEnabled = not godModeEnabled
	updateGodMode()
	showNotification(godModeEnabled and "God Mode ВКЛЮЧЕН" or "God Mode ВЫКЛЮЧЕН", godModeEnabled)
	return godModeEnabled
end)

local invisBtn = createButton("👁 Invisible (Ghost)", 225, function()
	invisibleEnabled = not invisibleEnabled
	updateInvisible()
	showNotification(invisibleEnabled and "Invisible ВКЛЮЧЕН" or "Invisible ВЫКЛЮЧЕН", invisibleEnabled)
	return invisibleEnabled
end)

local speedBtn = createButton("🏎 Speed Boost", 280, function()
	speedEnabled = not speedEnabled
	updateSpeed()
	showNotification(speedEnabled and "Speed ВКЛЮЧЕН" or "Speed ВЫКЛЮЧЕН", speedEnabled)
	return speedEnabled
end)

-- СПИСОК ИГРОКОВ И ТЕЛЕПОРТ
local playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Size = UDim2.new(0.9, 0, 0.25, 0)
playerListFrame.Position = UDim2.new(0.05, 0, 0.65, 0)
playerListFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
playerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
playerListFrame.ScrollBarThickness = 4
playerListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
playerListFrame.Visible = false
playerListFrame.Parent = mainFrame
createCorner(playerListFrame, 8)

local listBtn = createButton("📋 Игроки", 335, function()
	playerListFrame.Visible = not playerListFrame.Visible
	-- Очистить старый список
	for _, child in ipairs(playerListFrame:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	
	local y = 0
	for _, target in ipairs(Players:GetPlayers()) do
		local nameBtn = Instance.new("TextButton")
		nameBtn.Size = UDim2.new(0.9, 0, 0, 35)
		nameBtn.Position = UDim2.new(0.05, 0, 0, y)
		nameBtn.Text = target.Name
		nameBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
		nameBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameBtn.Parent = playerListFrame
		createCorner(nameBtn, 6)
		
		nameBtn.MouseButton1Click:Connect(function()
			targetPlayer = target
			playerListFrame.Visible = false
			showNotification("Цель: " .. target.Name, false)
		end)
		
		y = y + 40
	end
	return playerListFrame.Visible
end)

local teleportBtn = createButton("🧲 Телепорт к игроку", 390, function()
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	local targetHrp = targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
	if hrp and targetHrp then
		hrp.CFrame = targetHrp.CFrame
		showNotification("Телепорт выполнен", false)
	end
	return false
end)

-- ==========================================
-- 5. ВВОД ПАРОЛЯ И УПРАВЛЕНИЕ МЕНЮ
-- ==========================================
local function checkLogin()
	if passwordBox.Text == Config.Password then
		TweenService:Create(loginFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
		task.wait(0.3)
		loginFrame.Visible = false
		mainFrame.Visible = true
		-- Анимация появления
		mainFrame.Position = UDim2.new(0.5, -210, 0.6, 0)
		TweenService:Create(mainFrame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -210, 0.5, -270)}):Play()
	else
		errorLabel.Text = "Неверный пароль!"
	end
end

loginButton.MouseButton1Click:Connect(checkLogin)
passwordBox.FocusLost:Connect(function(enter)
	if enter then checkLogin() end
end)

-- Управление меню клавишей Insert
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.Insert then
		if mainFrame.Visible then
			mainFrame.Visible = false
		else
			mainFrame.Visible = true
		end
	end
end)
