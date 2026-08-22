local Library = loadstring(game:HttpGet("https://github.com/legend158/xk92mfqle-privn1x/edit/main/UILibrary.lua
        "))()
-- client/scripts/MenuGui.lua

local player = game:GetService("Players").LocalPlayer
local userInputService = game:GetService("UserInputService")
local contextActionService = game:GetService("ContextActionService")

-- Создаём GUI (если ещё не создан)
local gui = Instance.new("ScreenGui")
gui.Name = "MenuGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Создаём основной фрейм
local menuFrame = Instance.new("Frame")
menuFrame.Name = "MenuFrame"
menuFrame.Size = UDim2.new(0, 300, 0, 200)
menuFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
menuFrame.BackgroundTransparency = 0.3
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
menuFrame.BorderSizePixel = 2
menuFrame.BorderColor3 = Color3.fromRGB(100, 100, 120)
menuFrame.Parent = gui

-- Заголовок
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Text = "Меню"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = menuFrame

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Text = "Закрыть (Esc)"
closeBtn.Size = UDim2.new(0, 100, 0, 30)
closeBtn.Position = UDim2.new(0.5, -50, 1, -35)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.Gotham
closeBtn.TextSize = 14
closeBtn.Parent = menuFrame

-- Основная логика
local isOpen = false

local function toggleMenu()
    isOpen = not isOpen
    menuFrame.Visible = isOpen
end

local function closeMenu()
    if isOpen then
        isOpen = false
        menuFrame.Visible = false
    end
end

-- Открыть по клавише F
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        toggleMenu()
    end
end)

-- Закрыть по ESC или кнопке
closeBtn.MouseButton1Click:Connect(closeMenu)
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Escape then
        closeMenu()
    end
end)

-- Инициализация (скрыто при старте)
menuFrame.Visible = false
