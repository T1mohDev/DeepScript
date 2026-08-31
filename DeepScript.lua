-- DeepScript v5.0: Одно меню + Text Notifications
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- ОСНОВНОЙ УЛЬТРА-ЧИСТЫЙ МЕНЮ
local screen = Instance.new("ScreenGui")
screen.Name = "DeepScript v5.0"
screen.ResetOnSpawn = false
screen.Parent = gui
screen.Enabled = false -- Меню скрыто по умолчанию

-- ДРАГАБЕЛЬНЫЙ ФРЕЙМ
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 500)
frame.Position = UDim2.new(0.5, -200, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.3
frame.Active = true
frame.Draggable = true
frame.Parent = screen

-- ГРАДИЕНТ
local gradient = Instance.new("UIGradient")
gradient.Rotation = 45
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
}
gradient.Parent = frame

-- ТИТУЛ
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
title.BackgroundTransparency = 0.5
title.Text = "DeepScript v5.0"
title.Font = Enum.Font.GothamBold
title.FontSize = Enum.FontSize.Size24
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.Parent = frame

-- АВТОМАТИЧЕСКИЙ УВЕДОМЛЕНИЕ
local function showNotification(message, isOff)
	-- 만약 포인터 (эхо) 또는 유용한 텍스트 라벨
	local notification = Instance.new("TextLabel")
	notification.Size = UDim2.new(0, 100, 0, 40)
	notification.Position = UDim2.new(0.5, -50, 1, -50)
	notification.Text = message
	notification.Font = Enum.Font.GothamBold
	notification.TextColor3 = isOff and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 255, 100)
	notification.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	notification.BackgroundTransparency = 0.5
	notification.Parent = frame

	-- 이동 애니메이션
	local tween = game:GetService("TweenService"):Create(
		notification,
		TweenInfo.new(0.5),
		{Position = UDim2.new(0.5, -50, 0.5, 100)}
	)
	tween:Play()

	-- Обработка 시간
	task.wait(2)
	tween = game:GetService("TweenService"):Create(
		notification,
		TweenInfo.new(0.5),
		{Position = UDim2.new(0.5, -50, 1, 50)}
	)
	tween:Play()
	task.wait(0.5)
	notification:Destroy()
end

-- ФУНКЦИИ МЕХАНИКИ
local flyEnabled = false
local noclipEnabled = false
local godModeEnabled = false
local invisibleEnabled = false
local speedEnabled = false

local function updateFly()
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	local hum = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
	if flyEnabled then
		if hum then hum.PlatformStand = true end
		if hrp then
			hrp:SetNetworkOwner(nil)
			hrp.Anchored = true
		end
	else
		if hum then hum.PlatformStand = false end
		if hrp then
			hrp:SetNetworkOwner(nil)
			hrp.Anchored = false
		end
	end
end

local function updateNoclip()
	if player.Character then
		for _, part in ipairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = not noclipEnabled
			end
		end
	end
end

local function updateGodMode()
	local hum = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
	if hum then
		hum.MaxHealth = godModeEnabled and math.huge or 100
		hum.Health = hum.MaxHealth
	end
end

local function updateInvisible()
	if player.Character then
		for _, part in ipairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part:SetNetworkOwner(nil)
				part.LocalTransparency = invisibleEnabled and 1 or 0
			end
		end
	end
end

local function updateSpeed()
	local hum = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
	if hum then
		hum.WalkSpeed = speedEnabled and 200 or 16
	end
end

-- КНОПКИ МЕНЮ
local function createButton(text, icon, yPos, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0.9, 0, 0, 40)
	button.Position = UDim2.new(0.05, 0, 0, yPos)
	button.Text = icon .. " " .. text
	button.Font = Enum.Font.GothamBold
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	button.BackgroundTransparency = 0
	button.BorderSizePixel = 0
	button.Parent = frame
	button.MouseButton1Click:Connect(callback)

	local buttonGradient = Instance.new("UIGradient")
	buttonGradient.Rotation = 45
	buttonGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 60)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
	}
	buttonGradient.Parent = button

	local result = Instance.new("TextLabel")
	result.Size = UDim2.new(0, 40, 0, 40)
	result.Position = UDim2.new(1, -45, 0, 0)
	result.Text = ""
	result.BackgroundTransparency = 1
	result.Font = Enum.Font.GothamBold
	result.TextColor3 = Color3.fromRGB(255, 255, 255)
	result.Parent = button

	return button, result
end

-- Кнопки
local flyBtn, flyResult = createButton("Fly", "✈️", 50, function()
	flyEnabled = not flyEnabled
	updateFly()
	flyResult.Text = flyEnabled and "ON" or "OFF"
	flyResult.TextColor3 = flyEnabled and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 255, 255)
	showNotification(flyEnabled and "Fly Включено" or "Fly Выключено", not flyEnabled)
end)

local noclipBtn, noclipResult = createButton("NoClip", "👻", 100, function()
	noclipEnabled = not noclipEnabled
	updateNoclip()
	noclipResult.Text = noclipEnabled and "ON" or "OFF"
	noclipResult.TextColor3 = noclipEnabled and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 255, 255)
	showNotification(noclipEnabled and "NoClip Включено" or "NoClip Выключено", not noclipEnabled)
end)

local godBtn, godResult = createButton("God Mode", "🧊", 150, function()
	godModeEnabled = not godModeEnabled
	updateGodMode()
	godResult.Text = godModeEnabled and "ON" or "OFF"
	godResult.TextColor3 = godModeEnabled and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 255, 255)
	showNotification(godModeEnabled and "God Mode Включено" or "God Mode Выключено", not godModeEnabled)
end)

local invisibleBtn, invisibleResult = createButton("Invisible", "👁️", 200, function()
	invisibleEnabled = not invisibleEnabled
	updateInvisible()
	invisibleResult.Text = invisibleEnabled and "ON" or "OFF"
	invisibleResult.TextColor3 = invisibleEnabled and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 255, 255)
	showNotification(invisibleEnabled and "Invisible Включено" or "Invisible Выключено", not invisibleEnabled)
end)

local speedBtn, speedResult = createButton("Speed", "🏎️", 250, function()
	speedEnabled = not speedEnabled
	updateSpeed()
	speedResult.Text = speedEnabled and "ON" or "OFF"
	speedResult.TextColor3 = speedEnabled and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 255, 255)
	showNotification(speedEnabled and "Speed Включено" or "Speed Выключено", not speedEnabled)
end)

-- СЛЕДУЮЩАЯ КНОПКА ТЕЛЕПОРТ
local teleportBtn, teleportResult = createButton("Teleport to Target", "🧲", 330, function()
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	local targetHrp = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
	if hrp and targetHrp then
		hrp.CFrame = targetHrp.CFrame
	end
	teleportResult.Text = "DONE"
	teleportResult.TextColor3 = Color3.fromRGB(255, 255, 255)
	showNotification("Teleport Done", false)
end)

-- ПОДОЖДИ, ТЕЛЕПОРТ К ЦЕЛИ
local teleportBtn2, teleportResult2 = createButton("Teleport to Target (Boost)", "🧲", 370, function()
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	local targetHrp = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
	if hrp and targetHrp then
		hrp.CFrame = targetHrp.CFrame
		hrp.Velocity = Vector3.new(0, 50, 0)
	end
	teleportResult2.Text = "DONE"
	teleportResult2.TextColor3 = Color3.fromRGB(255, 255, 255)
	showNotification("Teleport Boost Done", false)
end)

-- КНОПКА ДЛЯ ВЫБОРА ЦЕЛИ
local listButton = Instance.new("TextButton")
listButton.Size = UDim2.new(0.9, 0, 0, 40)
listButton.Position = UDim2.new(0.05, 0, 0, 290)
listButton.Text = "📋 Player List"
listButton.Font = Enum.Font.GothamBold
listButton.TextColor3 = Color3.fromRGB(255, 255, 255)
listButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
listButton.BorderSizePixel = 0
listButton.Parent = frame
listButton.MouseButton1Click:Connect(function()
	listButton.Visible = false
	listButton.Parent = frame
	-- По-прежнему нужен список
	local list = Instance.new("ScrollingFrame")
	list.Size = UDim2.new(0.9, 0, 0.5, 0)
	list.Position = UDim2.new(0.05, 0, 0.6, 0)
	list.BackgroundTransparency = 1
	list.Parent = frame

	local y = 0
	for _, target in ipairs(Players:GetPlayers()) do
		local nameBtn = Instance.new("TextButton")
		nameBtn.Size = UDim2.new(1, 0, 0, 30)
		nameBtn.Position = UDim2.new(0, 0, 0, y)
		nameBtn.Text = target.Name
		nameBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		nameBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameBtn.Parent = list
		y = y + 35
		nameBtn.MouseButton1Click:Connect(function()
			targetPlayer = target
			showNotification("Player Selected: " .. target.Name, false)
		end)
	end
end)

-- УПРАВЛЕНИЕ FLY
UserInputService.InputBegan:Connect(function(input)
	if flyEnabled and player.Character then
		local hrp = player.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			if input.KeyCode == Enum.KeyCode.E then
				hrp.Velocity = Vector3.new(0, 50, 0)
			elseif input.KeyCode == Enum.KeyCode.Q then
				hrp.Velocity = Vector3.new(0, -50, 0)
			end
		end
	end
end)

-- СТОП ДВИЖЕНИЕ (СТАБИЛЬНЫЙ ФЛАЙ)
RunService.Heartbeat:Connect(function()
	if flyEnabled and player.Character then
		local hrp = player.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				hrp.Velocity = Vector3.new(0, 0, 50)
			end
		end
	end
end)

-- ПРОВЕРКА ВЫБОРА КНОПКИ ТЕЛЕПОРТ
local targetPlayer = nil

-- МЕНЮ - ДВИЖЕНИЕ
local function toggleMenu()
	screen.Enabled = not screen.Enabled
	if screen.Enabled then
		frame.Visible = true
	end
end

-- KEY INSERT
UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Insert then
		toggleMenu()
	end
end)
