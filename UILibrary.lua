local Library = loadstring(game:HttpGet("https://github.com/legend158/xk92mfqle-privn1x/edit/main/UILibrary.lua
        "))()
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local UILibrary = {}

-- ==================== ТЕМЫ ====================
local Themes = {
    Theme1 = {
        SchemeColor = Color3.fromRGB(90, 140, 255),
        Background = Color3.fromRGB(20, 20, 24),
        Header = Color3.fromRGB(15, 15, 18),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(30, 30, 35),
    },
    Theme2 = {
        SchemeColor = Color3.fromRGB(150, 72, 148),
        Background = Color3.fromRGB(15, 15, 15),
        Header = Color3.fromRGB(15, 15, 15),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(20, 20, 20),
    },
    Theme3 = {
        SchemeColor = Color3.fromRGB(60, 180, 120),
        Background = Color3.fromRGB(18, 18, 18),
        Header = Color3.fromRGB(12, 12, 12),
        TextColor = Color3.fromRGB(235, 235, 235),
        ElementColor = Color3.fromRGB(26, 26, 26),
    },
}

-- ==================== ВСПОМОГАТЕЛЬНОЕ ====================
local function corner(instance, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 6)
    c.Parent = instance
    return c
end

local function makeDraggable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ==================== СОЗДАНИЕ ОКНА ====================
function UILibrary.CreateLib(windowTitle, themeNameOrColors)
    local theme
    if type(themeNameOrColors) == "table" then
        theme = themeNameOrColors
    else
        theme = Themes[themeNameOrColors] or Themes.Theme1
    end

    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    -- Удаляем старое окно с тем же именем, если есть (чтобы не дублировалось при повторном запуске)
    local existing = playerGui:FindFirstChild("UILibrary_" .. windowTitle)
    if existing then
        existing:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UILibrary_" .. windowTitle
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 520, 0, 360)
    mainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
    mainFrame.BackgroundColor3 = theme.Background
    mainFrame.Parent = screenGui
    corner(mainFrame, 10)

    -- Шапка окна (заголовок + перетаскивание)
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = theme.Header
    header.Parent = mainFrame
    corner(header, 10)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextColor3 = theme.TextColor
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = windowTitle
    title.Parent = header

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 28, 0, 28)
    closeButton.Position = UDim2.new(1, -34, 0, 6)
    closeButton.BackgroundColor3 = theme.ElementColor
    closeButton.TextColor3 = theme.TextColor
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Text = "X"
    closeButton.Parent = header
    corner(closeButton, 6)
    closeButton.MouseButton1Click:Connect(function()
        screenGui.Enabled = false
    end)

    makeDraggable(mainFrame, header)

    -- Список вкладок (слева)
    local tabListFrame = Instance.new("Frame")
    tabListFrame.Size = UDim2.new(0, 130, 1, -40)
    tabListFrame.Position = UDim2.new(0, 0, 0, 40)
    tabListFrame.BackgroundColor3 = theme.Header
    tabListFrame.Parent = mainFrame

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Padding = UDim.new(0, 4)
    tabListLayout.Parent = tabListFrame

    local tabListPadding = Instance.new("UIPadding")
    tabListPadding.PaddingTop = UDim.new(0, 8)
    tabListPadding.PaddingLeft = UDim.new(0, 6)
    tabListPadding.PaddingRight = UDim.new(0, 6)
    tabListPadding.Parent = tabListFrame

    -- Контейнер контента вкладок (справа)
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -130, 1, -40)
    contentFrame.Position = UDim2.new(0, 130, 0, 40)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    local Window = {}
    local tabs = {}
    local firstTab = true

    function Window:NewTab(tabName)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, 0, 0, 32)
        tabButton.BackgroundColor3 = theme.ElementColor
        tabButton.TextColor3 = theme.TextColor
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 14
        tabButton.Text = tabName
        tabButton.Parent = tabListFrame
        corner(tabButton, 6)

        local tabPage = Instance.new("ScrollingFrame")
        tabPage.Size = UDim2.new(1, 0, 1, 0)
        tabPage.BackgroundTransparency = 1
        tabPage.ScrollBarThickness = 4
        tabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabPage.Visible = firstTab
        tabPage.Parent = contentFrame

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding = UDim.new(0, 10)
        pageLayout.Parent = tabPage

        local pagePadding = Instance.new("UIPadding")
        pagePadding.PaddingTop = UDim.new(0, 10)
        pagePadding.PaddingLeft = UDim.new(0, 10)
        pagePadding.PaddingRight = UDim.new(0, 10)
        pagePadding.Parent = tabPage

        firstTab = false

        tabButton.MouseButton1Click:Connect(function()
            for _, t in ipairs(tabs) do
                t.page.Visible = false
                t.button.BackgroundColor3 = theme.ElementColor
            end
            tabPage.Visible = true
            tabButton.BackgroundColor3 = theme.SchemeColor
        end)

        table.insert(tabs, { button = tabButton, page = tabPage })
        if #tabs == 1 then
            tabButton.BackgroundColor3 = theme.SchemeColor
        end

        local Tab = {}

        function Tab:NewSection(sectionName)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Size = UDim2.new(1, 0, 0, 0)
            sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            sectionFrame.BackgroundColor3 = theme.ElementColor
            sectionFrame.Parent = tabPage
            corner(sectionFrame, 8)

            local sectionLayout = Instance.new("UIListLayout")
            sectionLayout.Padding = UDim.new(0, 6)
            sectionLayout.Parent = sectionFrame

            local sectionPadding = Instance.new("UIPadding")
            sectionPadding.PaddingTop = UDim.new(0, 10)
            sectionPadding.PaddingBottom = UDim.new(0, 10)
            sectionPadding.PaddingLeft = UDim.new(0, 10)
            sectionPadding.PaddingRight = UDim.new(0, 10)
            sectionPadding.Parent = sectionFrame

            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Size = UDim2.new(1, 0, 0, 20)
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Font = Enum.Font.GothamBold
            sectionTitle.TextSize = 14
            sectionTitle.TextColor3 = theme.SchemeColor
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            sectionTitle.Text = sectionName
            sectionTitle.Parent = sectionFrame

            local Section = {}

            function Section:NewLabel(text)
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, 18)
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.Gotham
                label.TextSize = 13
                label.TextColor3 = theme.TextColor
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Text = text
                label.Parent = sectionFrame
                return label
            end

            function Section:NewButton(text, info, callback)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 32)
                btn.BackgroundColor3 = theme.SchemeColor
                btn.TextColor3 = theme.TextColor
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 13
                btn.Text = text
                btn.Parent = sectionFrame
                corner(btn, 6)

                if info and info ~= "" then
                    local tip = Instance.new("TextLabel")
                    tip.Size = UDim2.new(1, 0, 0, 14)
                    tip.BackgroundTransparency = 1
                    tip.Font = Enum.Font.Gotham
                    tip.TextSize = 11
                    tip.TextColor3 = Color3.fromRGB(160, 160, 160)
                    tip.TextXAlignment = Enum.TextXAlignment.Left
                    tip.Text = info
                    tip.Parent = sectionFrame
                end

                btn.MouseButton1Click:Connect(function()
                    if callback then callback() end
                end)
                return btn
            end

            function Section:NewToggle(text, info, callback)
                local container = Instance.new("Frame")
                container.Size = UDim2.new(1, 0, 0, 32)
                container.BackgroundColor3 = theme.Background
                container.Parent = sectionFrame
                corner(container, 6)

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -50, 1, 0)
                label.Position = UDim2.new(0, 8, 0, 0)
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.Gotham
                label.TextSize = 13
                label.TextColor3 = theme.TextColor
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Text = text
                label.Parent = container

                local switchBg = Instance.new("Frame")
                switchBg.Size = UDim2.new(0, 40, 0, 20)
                switchBg.Position = UDim2.new(1, -46, 0.5, -10)
                switchBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                switchBg.Parent = container
                corner(switchBg, 10)

                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 16, 0, 16)
                knob.Position = UDim2.new(0, 2, 0.5, -8)
                knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                knob.Parent = switchBg
                corner(knob, 8)

                local state = false
                local function setState(newState)
                    state = newState
                    local goalPos = state and UDim2.new(0, 22, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    local goalColor = state and theme.SchemeColor or Color3.fromRGB(60, 60, 60)
                    TweenService:Create(knob, TweenInfo.new(0.15), { Position = goalPos }):Play()
                    TweenService:Create(switchBg, TweenInfo.new(0.15), { BackgroundColor3 = goalColor }):Play()
                    if callback then callback(state) end
                end

                container.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then
                        setState(not state)
                    end
                end)

                return container
            end

            function Section:NewSlider(text, info, maxValue, minValue, callback)
                minValue = minValue or 0
                local container = Instance.new("Frame")
                container.Size = UDim2.new(1, 0, 0, 46)
                container.BackgroundTransparency = 1
                container.Parent = sectionFrame

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, 18)
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.Gotham
                label.TextSize = 13
                label.TextColor3 = theme.TextColor
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Text = text .. ": " .. tostring(minValue)
                label.Parent = container

                local track = Instance.new("Frame")
                track.Size = UDim2.new(1, 0, 0, 8)
                track.Position = UDim2.new(0, 0, 0, 24)
                track.BackgroundColor3 = theme.ElementColor
                track.Parent = container
                corner(track, 4)

                local fill = Instance.new("Frame")
                fill.Size = UDim2.new(0, 0, 1, 0)
                fill.BackgroundColor3 = theme.SchemeColor
                fill.Parent = track
                corner(fill, 4)

                local dragging = false
                local function updateFromX(xPos)
                    local relative = math.clamp((xPos - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    local value = math.floor(minValue + (maxValue - minValue) * relative)
                    fill.Size = UDim2.new(relative, 0, 1, 0)
                    label.Text = text .. ": " .. tostring(value)
                    if callback then callback(value) end
                end

                track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        updateFromX(input.Position.X)
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                        or input.UserInputType == Enum.UserInputType.Touch) then
                        updateFromX(input.Position.X)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                return container
            end

            function Section:NewTextBox(text, info, callback)
                local container = Instance.new("Frame")
                container.Size = UDim2.new(1, 0, 0, 32)
                container.BackgroundColor3 = theme.Background
                container.Parent = sectionFrame
                corner(container, 6)

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(0, 100, 1, 0)
                label.Position = UDim2.new(0, 8, 0, 0)
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.Gotham
                label.TextSize = 12
                label.TextColor3 = theme.TextColor
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Text = text
                label.Parent = container

                local box = Instance.new("TextBox")
                box.Size = UDim2.new(1, -116, 0, 22)
                box.Position = UDim2.new(0, 108, 0.5, -11)
                box.BackgroundColor3 = theme.ElementColor
                box.TextColor3 = theme.TextColor
                box.Font = Enum.Font.Gotham
                box.TextSize = 12
                box.PlaceholderText = info or ""
                box.Text = ""
                box.ClearTextOnFocus = false
                box.Parent = container
                corner(box, 4)

                box.FocusLost:Connect(function(enterPressed)
                    if enterPressed and callback then
                        callback(box.Text)
                    end
                end)

                return container
            end

            function Section:NewKeybind(text, info, defaultKey, callback)
                local container = Instance.new("Frame")
                container.Size = UDim2.new(1, 0, 0, 32)
                container.BackgroundColor3 = theme.Background
                container.Parent = sectionFrame
                corner(container, 6)

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -70, 1, 0)
                label.Position = UDim2.new(0, 8, 0, 0)
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.Gotham
                label.TextSize = 13
                label.TextColor3 = theme.TextColor
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Text = text
                label.Parent = container

                local keyButton = Instance.new("TextButton")
                keyButton.Size = UDim2.new(0, 56, 0, 22)
                keyButton.Position = UDim2.new(1, -62, 0.5, -11)
                keyButton.BackgroundColor3 = theme.ElementColor
                keyButton.TextColor3 = theme.TextColor
                keyButton.Font = Enum.Font.GothamBold
                keyButton.TextSize = 12
                keyButton.Text = defaultKey and defaultKey.Name or "..."
                keyButton.Parent = container
                corner(keyButton, 4)

                local currentKey = defaultKey
                local listening = false

                keyButton.MouseButton1Click:Connect(function()
                    listening = true
                    keyButton.Text = "..."
                end)

                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        keyButton.Text = currentKey.Name
                        listening = false
                    elseif not listening and not gameProcessed
                        and input.UserInputType == Enum.UserInputType.Keyboard
                        and input.KeyCode == currentKey then
                        if callback then callback() end
                    end
                end)

                return container
            end

            function Section:NewDropdown(text, info, optionsList, callback)
                local container = Instance.new("Frame")
                container.Size = UDim2.new(1, 0, 0, 32)
                container.BackgroundColor3 = theme.Background
                container.ClipsDescendants = false
                container.Parent = sectionFrame
                corner(container, 6)

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(0.5, -8, 1, 0)
                label.Position = UDim2.new(0, 8, 0, 0)
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.Gotham
                label.TextSize = 13
                label.TextColor3 = theme.TextColor
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Text = text
                label.Parent = container

                local selectButton = Instance.new("TextButton")
                selectButton.Size = UDim2.new(0.5, -8, 0, 22)
                selectButton.Position = UDim2.new(0.5, 0, 0.5, -11)
                selectButton.BackgroundColor3 = theme.ElementColor
                selectButton.TextColor3 = theme.TextColor
                selectButton.Font = Enum.Font.Gotham
                selectButton.TextSize = 12
                selectButton.Text = optionsList[1] or "..."
                selectButton.Parent = container
                corner(selectButton, 4)

                local optionsFrame = Instance.new("Frame")
                optionsFrame.Size = UDim2.new(0.5, -8, 0, #optionsList * 22)
                optionsFrame.Position = UDim2.new(0.5, 0, 1, 2)
                optionsFrame.BackgroundColor3 = theme.ElementColor
                optionsFrame.Visible = false
                optionsFrame.ZIndex = 5
                optionsFrame.Parent = container
                corner(optionsFrame, 4)

                local optionsLayout = Instance.new("UIListLayout")
                optionsLayout.Parent = optionsFrame

                for _, optionText in ipairs(optionsList) do
                    local optionButton = Instance.new("TextButton")
                    optionButton.Size = UDim2.new(1, 0, 0, 22)
                    optionButton.BackgroundTransparency = 1
                    optionButton.TextColor3 = theme.TextColor
                    optionButton.Font = Enum.Font.Gotham
                    optionButton.TextSize = 12
                    optionButton.Text = optionText
                    optionButton.ZIndex = 5
                    optionButton.Parent = optionsFrame

                    optionButton.MouseButton1Click:Connect(function()
                        selectButton.Text = optionText
                        optionsFrame.Visible = false
                        if callback then callback(optionText) end
                    end)
                end

                selectButton.MouseButton1Click:Connect(function()
                    optionsFrame.Visible = not optionsFrame.Visible
                end)

                if callback and optionsList[1] then
                    callback(optionsList[1])
                end

                return container
            end

            return Section
        end

        return Tab
    end

    return Window
end

return UILibrary
