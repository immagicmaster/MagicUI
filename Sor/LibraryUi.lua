local CoreGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {}

local NotifyScreen = Instance.new("ScreenGui")
NotifyScreen.Name = "NotifyUI"
NotifyScreen.Parent = CoreGui

local NL = Instance.new("Frame")
NL.Name = "NL"
NL.Size = UDim2.new(0, 250, 1, -20)
NL.Position = UDim2.new(1, -260, 0, 10)
NL.BackgroundTransparency = 1
NL.Parent = NotifyScreen

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyLayout.Padding = UDim.new(0, 10)
NotifyLayout.Parent = NL

function Library:Notify(titleText, descText, duration)
    duration = duration or 3

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(1, 0, 0, 60)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    NotifFrame.BackgroundTransparency = 0.5
    NotifFrame.Parent = NL
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = NotifFrame
    
    local NTitle = Instance.new("TextLabel")
    NTitle.Size = UDim2.new(1, -10, 0, 20)
    NTitle.Position = UDim2.new(0, 10, 0, 5)
    NTitle.BackgroundTransparency = 1
    NTitle.Text = titleText
    NTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    NTitle.Font = Enum.Font.GothamBold
    NTitle.TextSize = 14
    NTitle.TextXAlignment = Enum.TextXAlignment.Left
    NTitle.Parent = NotifFrame
    
    local NDesc = Instance.new("TextLabel")
    NDesc.Size = UDim2.new(1, -10, 0, 30)
    NDesc.Position = UDim2.new(0, 10, 0, 25)
    NDesc.BackgroundTransparency = 1
    NDesc.Text = descText
    NDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    NDesc.Font = Enum.Font.Gotham
    NDesc.TextSize = 12
    NDesc.TextWrapped = true
    NDesc.TextXAlignment = Enum.TextXAlignment.Left
    NDesc.TextYAlignment = Enum.TextYAlignment.Top
    NDesc.Parent = NotifFrame

    NotifFrame.Position = UDim2.new(1, 50, 0, 0)
    TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()

    task.delay(duration, function()
        local fade = TweenService:Create(NotifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
        TweenService:Create(NTitle, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(NDesc, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        fade:Play()
        fade.Completed:Wait()
        NotifFrame:Destroy()
    end)
end

function Library:CreateWindow(config)
    local MainTitle = config.Title or "Default Hub"
    local SubTitle = config.SubName or ""
    local CustomSize = config.Size or UDim2.fromOffset(500, 300)
    
    if config.Folder then
        if isfolder and makefolder then
            if not isfolder(config.Folder) then
                makefolder(config.Folder)
            end
        end
    end

    local Window = {}
    local CurrentTab = nil
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomUI_" .. MainTitle
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui
    
    local Toolbar = Instance.new("Frame")
    Toolbar.Size = UDim2.new(0, 200, 0, 35)
    Toolbar.Position = UDim2.new(0.5, -100, 0, -40)
    Toolbar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Toolbar.BackgroundTransparency = 0.4
    Toolbar.Visible = false
    Toolbar.Parent = ScreenGui
    Instance.new("UICorner", Toolbar).CornerRadius = UDim.new(0, 6)
    
    local ToolTitle = Instance.new("TextLabel")
    ToolTitle.Size = UDim2.new(1, -40, 1, 0)
    ToolTitle.Position = UDim2.new(0, 10, 0, 0)
    ToolTitle.BackgroundTransparency = 1
    ToolTitle.Text = MainTitle
    ToolTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToolTitle.Font = Enum.Font.GothamBold
    ToolTitle.TextSize = 14
    ToolTitle.TextXAlignment = Enum.TextXAlignment.Left
    ToolTitle.Parent = Toolbar
    
    local MaximizeBtn = Instance.new("TextButton")
    MaximizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MaximizeBtn.Position = UDim2.new(1, -35, 0, 2)
    MaximizeBtn.BackgroundTransparency = 1
    MaximizeBtn.Text = "⬜"
    MaximizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MaximizeBtn.TextSize = 14
    MaximizeBtn.Parent = Toolbar

    -- MAIN FRAME
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = CustomSize
    MainFrame.Position = UDim2.new(0.5, -CustomSize.X.Offset/2, 0.5, -CustomSize.Y.Offset/2)
    
    if config.Background and config.BackgroundColor then
        MainFrame.BackgroundColor3 = config.BackgroundColor
    else
        MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    end
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    
    -- Drag Logic
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- TOP BAR
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = MainFrame
    
    -- Xử lý vị trí Title phụ thuộc vào Icon Lucide
    local TitleStartPos = 15
    if config.Icon and config.Icon ~= "" then
        local CleanIcon = string.lower(string.gsub(config.Icon, "%s+", ""))
        local IconImg = Instance.new("ImageLabel")
        IconImg.Size = UDim2.fromOffset(20, 20)
        IconImg.Position = UDim2.new(0, 15, 0.5, -10)
        IconImg.BackgroundTransparency = 1
        -- Sử dụng API Iconify để lấy trực tiếp luồng ảnh PNG từ Lucide
        IconImg.Image = "https://api.iconify.design/lucide:" .. CleanIcon .. ".png?color=ffffff"
        IconImg.Parent = TopBar
        TitleStartPos = 42
    end

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 0, 1, 0)
    Title.Position = UDim2.new(0, TitleStartPos, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = MainTitle
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.AutomaticSize = Enum.AutomaticSize.X
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    if SubTitle ~= "" then
        local Sub = Instance.new("TextLabel")
        Sub.Size = UDim2.new(0, 0, 1, 0)
        Sub.Position = UDim2.new(1, 7, 0, 2)
        Sub.BackgroundTransparency = 1
        Sub.Text = SubTitle
        Sub.TextColor3 = Color3.fromRGB(180, 180, 180)
        Sub.Font = Enum.Font.Gotham
        Sub.TextSize = 12
        Sub.AutomaticSize = Enum.AutomaticSize.X
        Sub.TextXAlignment = Enum.TextXAlignment.Left
        Sub.Parent = Title
    end

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.Gotham
    CloseBtn.TextSize = 14
    CloseBtn.Parent = TopBar

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -65, 0, 5)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "─"
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 14
    MinBtn.Parent = TopBar

    if config.Discord and config.Url then
        local DiscordBtn = Instance.new("TextButton")
        DiscordBtn.Size = UDim2.new(0, 30, 0, 30)
        DiscordBtn.Position = UDim2.new(1, -95, 0, 5)
        DiscordBtn.BackgroundTransparency = 1
        DiscordBtn.Text = ""
        DiscordBtn.Parent = TopBar
        
        local DiscIcon = Instance.new("ImageLabel")
        DiscIcon.Size = UDim2.fromOffset(18, 18)
        DiscIcon.Position = UDim2.new(0.5, -9, 0.5, -9)
        DiscIcon.BackgroundTransparency = 1
        DiscIcon.Image = "https://api.iconify.design/bi:discord.png?color=5865f2"
        DiscIcon.Parent = DiscordBtn

        DiscordBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(config.Url)
                Library:Notify("Discord", "Đã sao chép liên kết Discord!", 3)
            else
                Library:Notify("Lỗi", "Executor không hỗ trợ bộ nhớ tạm!", 3)
            end
        end)
    end

    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    
    MinBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        Toolbar.Visible = true
        Toolbar.Position = UDim2.new(0.5, -100, 0, -40)
        TweenService:Create(Toolbar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -100, 0, 10)}):Play()
    end)

    MaximizeBtn.MouseButton1Click:Connect(function()
        local tw = TweenService:Create(Toolbar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -100, 0, -40)})
        tw:Play()
        tw.Completed:Wait()
        Toolbar.Visible = false
        MainFrame.Visible = true
    end)

    -- TAB BAR CONTAINER
    local TabCo = Instance.new("ScrollingFrame")
    TabCo.Size = UDim2.new(1, -20, 0, 30)
    TabCo.Position = UDim2.new(0, 10, 0, 45)
    TabCo.BackgroundTransparency = 1
    TabCo.ScrollBarThickness = 0
    TabCo.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabCo.AutomaticCanvasSize = Enum.AutomaticSize.X
    TabCo.Parent = MainFrame
    
    local TabL = Instance.new("UIListLayout")
    TabL.FillDirection = Enum.FillDirection.Horizontal
    TabL.SortOrder = Enum.SortOrder.LayoutOrder
    TabL.Padding = UDim.new(0, 8)
    TabL.Parent = TabCo

    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -20, 1, -90)
    PageContainer.Position = UDim2.new(0, 10, 0, 80)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame

    function Window:CreateTab(TabName)
        local Tab = {}
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0, 90, 1, 0)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = TabName
        TabBtn.TextColor3 = Color3.fromRGB(140, 140, 140)
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 13
        TabBtn.Parent = TabCo
        
        local Underline = Instance.new("Frame")
        Underline.Size = UDim2.new(1, 0, 0, 2)
        Underline.Position = UDim2.new(0, 0, 1, -2)
        Underline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Underline.Visible = false
        Underline.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
        Page.Visible = false
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.Parent = PageContainer
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.Parent = Page

        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(TabCo:GetChildren()) do
                if child:IsA("TextButton") then
                    child.TextColor3 = Color3.fromRGB(140, 140, 140)
                    if child:FindFirstChild("Frame") then child.Frame.Visible = false end
                end
            end
            for _, child in pairs(PageContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Underline.Visible = true
            Page.Visible = true
        end)

        if not CurrentTab then
            CurrentTab = TabBtn
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Underline.Visible = true
            Page.Visible = true
        end

        -- 1. LABEL
        function Tab:CreateLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 25)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(230, 230, 230)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Page
            return Label
        end

        -- 2. BUTTON
        function Tab:CreateButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 36)
            Btn.BackgroundColor3 = Color3.fromRGB(26, 26, 28)
            Btn.Text = "  " .. text
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.GothamMedium
            Btn.TextSize = 13
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Parent = Page
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

            local Stroke = Instance.new("UIStroke")
            Stroke.Color = Color3.fromRGB(45, 45, 48)
            Stroke.Thickness = 1
            Stroke.Parent = Btn

            Btn.MouseButton1Click:Connect(function() if callback then callback() end end)
        end

        -- 3. TOGGLE
        function Tab:CreateToggle(text, default, callback)
            local toggled = default or false
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 36)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 28)
            ToggleFrame.Parent = Page
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

            local Stroke = Instance.new("UIStroke")
            Stroke.Color = Color3.fromRGB(45, 45, 48)
            Stroke.Thickness = 1
            Stroke.Parent = ToggleFrame

            local Txt = Instance.new("TextLabel")
            Txt.Size = UDim2.new(1, -50, 1, 0)
            Txt.Position = UDim2.new(0, 12, 0, 0)
            Txt.BackgroundTransparency = 1
            Txt.Text = text
            Txt.TextColor3 = Color3.fromRGB(255, 255, 255)
            Txt.Font = Enum.Font.GothamMedium
            Txt.TextSize = 13
            Txt.TextXAlignment = Enum.TextXAlignment.Left
            Txt.Parent = ToggleFrame

            local Indicator = Instance.new("TextButton")
            Indicator.Size = UDim2.new(0, 34, 0, 18)
            Indicator.Position = UDim2.new(1, -44, 0.5, -9)
            Indicator.BackgroundColor3 = toggled and Color3.fromRGB(40, 167, 69) or Color3.fromRGB(50, 50, 53)
            Indicator.Text = ""
            Indicator.Parent = ToggleFrame
            Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 9)

            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.new(0, 14, 0, 14)
            Knob.Position = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Knob.Parent = Indicator
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(0, 7)

            Indicator.MouseButton1Click:Connect(function()
                toggled = not toggled
                TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = toggled and Color3.fromRGB(40, 167, 69) or Color3.fromRGB(50, 50, 53)}):Play()
                TweenService:Create(Knob, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
                if callback then callback(toggled) end
            end)
        end

        -- 4. NEW: SLIDER
        function Tab:CreateSlider(text, min, max, default, callback)
            min = min or 0
            max = max or 100
            default = math.clamp(default or min, min, max)

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 48)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 28)
            SliderFrame.Parent = Page
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

            local Stroke = Instance.new("UIStroke")
            Stroke.Color = Color3.fromRGB(45, 45, 48)
            Stroke.Thickness = 1
            Stroke.Parent = SliderFrame

            local Txt = Instance.new("TextLabel")
            Txt.Size = UDim2.new(1, -70, 0, 24)
            Txt.Position = UDim2.new(0, 12, 0, 2)
            Txt.BackgroundTransparency = 1
            Txt.Text = text
            Txt.TextColor3 = Color3.fromRGB(255, 255, 255)
            Txt.Font = Enum.Font.GothamMedium
            Txt.TextSize = 13
            Txt.TextXAlignment = Enum.TextXAlignment.Left
            Txt.Parent = SliderFrame

            local ValLabel = Instance.new("TextLabel")
            ValLabel.Size = UDim2.new(0, 50, 0, 24)
            ValLabel.Position = UDim2.new(1, -62, 0, 2)
            ValLabel.BackgroundTransparency = 1
            ValLabel.Text = tostring(default)
            ValLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
            ValLabel.Font = Enum.Font.GothamBold
            ValLabel.TextSize = 13
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValLabel.Parent = SliderFrame

            local BarBack = Instance.new("TextButton")
            BarBack.Size = UDim2.new(1, -24, 0, 6)
            BarBack.Position = UDim2.new(0, 12, 0, 32)
            BarBack.BackgroundColor3 = Color3.fromRGB(50, 50, 53)
            BarBack.Text = ""
            BarBack.AutoButtonColor = false
            BarBack.Parent = SliderFrame
            Instance.new("UICorner", BarBack).CornerRadius = UDim.new(0, 3)

            local BarFill = Instance.new("Frame")
            BarFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            BarFill.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
            BarFill.Parent = BarBack
            Instance.new("UICorner", BarFill).CornerRadius = UDim.new(0, 3)

            local sliding = false
            local function updateSlider(input)
                local percentage = math.clamp((input.Position.X - BarBack.AbsolutePosition.X) / BarBack.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * percentage)
                ValLabel.Text = tostring(value)
                BarFill.Size = UDim2.new(percentage, 0, 1, 0)
                if callback then callback(value) end
            end

            BarBack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    updateSlider(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)
        end

        -- 5. NEW: DROPDOWN (DOWNDROP)
        function Tab:CreateDropdown(text, list, callback)
            local expanded = false
            list = list or {}

            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(1, 0, 0, 36)
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 28)
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent = Page
            Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 6)

            local Stroke = Instance.new("UIStroke")
            Stroke.Color = Color3.fromRGB(45, 45, 48)
            Stroke.Thickness = 1
            Stroke.Parent = DropdownFrame

            local MainBtn = Instance.new("TextButton")
            MainBtn.Size = UDim2.new(1, 0, 0, 36)
            MainBtn.BackgroundTransparency = 1
            MainBtn.Text = "  " .. text .. " : " .. (list[1] or "Trống")
            MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            MainBtn.Font = Enum.Font.GothamMedium
            MainBtn.TextSize = 13
            MainBtn.TextXAlignment = Enum.TextXAlignment.Left
            MainBtn.Parent = DropdownFrame

            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 30, 1, 0)
            Arrow.Position = UDim2.new(1, -35, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▼"
            Arrow.TextColor3 = Color3.fromRGB(150, 150, 150)
            Arrow.TextSize = 10
            Arrow.Parent = MainBtn

            local OptionContainer = Instance.new("Frame")
            OptionContainer.Size = UDim2.new(1, 0, 0, #list * 30)
            OptionContainer.Position = UDim2.new(0, 0, 0, 36)
            OptionContainer.BackgroundTransparency = 1
            OptionContainer.Parent = DropdownFrame

            local OptionLayout = Instance.new("UIListLayout")
            OptionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionLayout.Parent = OptionContainer

            for i, option in ipairs(list) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 30)
                OptBtn.BackgroundTransparency = 1
                OptBtn.Text = "    " .. tostring(option)
                OptBtn.TextColor3 = Color3.fromRGB(190, 190, 190)
                OptBtn.Font = Enum.Font.Gotham
                OptBtn.TextSize = 12
                OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                OptBtn.Parent = OptionContainer

                OptBtn.MouseButton1Click:Connect(function()
                    MainBtn.Text = "  " .. text .. " : " .. tostring(option)
                    expanded = false
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, 36)}):Play()
                    Arrow.Text = "▼"
                    if callback then callback(option) end
                end)
            end

            MainBtn.MouseButton1Click:Connect(function()
                expanded = not expanded
                local targetHeight = expanded and (36 + (#list * 30)) or 36
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
                Arrow.Text = expanded and "▲" or "▼"
            end)
        end

        -- 6. NEW: INPUT
        function Tab:CreateInput(text, placeholder, callback)
            local InputFrame = Instance.new("Frame")
            InputFrame.Size = UDim2.new(1, 0, 0, 36)
            InputFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 28)
            InputFrame.Parent = Page
            Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 6)

            local Stroke = Instance.new("UIStroke")
            Stroke.Color = Color3.fromRGB(45, 45, 48)
            Stroke.Thickness = 1
            Stroke.Parent = InputFrame

            local Txt = Instance.new("TextLabel")
            Txt.Size = UDim2.new(0.4, 0, 1, 0)
            Txt.Position = UDim2.new(0, 12, 0, 0)
            Txt.BackgroundTransparency = 1
            Txt.Text = text
            Txt.TextColor3 = Color3.fromRGB(255, 255, 255)
            Txt.Font = Enum.Font.GothamMedium
            Txt.TextSize = 13
            Txt.TextXAlignment = Enum.TextXAlignment.Left
            Txt.Parent = InputFrame

            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(0.55, -12, 0, 24)
            TextBox.Position = UDim2.new(1, -12, 0.5, -12)
            TextBox.AnchorPoint = Vector2.new(1, 0)
            TextBox.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
            TextBox.PlaceholderText = placeholder or "Nhập..."
            TextBox.Text = ""
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 104)
            TextBox.Font = Enum.Font.Gotham
            TextBox.TextSize = 12
            TextBox.ClearTextOnFocus = false
            TextBox.Parent = InputFrame
            Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 4)

            local BoxStroke = Instance.new("UIStroke")
            BoxStroke.Color = Color3.fromRGB(45, 45, 48)
            BoxStroke.Thickness = 1
            BoxStroke.Parent = TextBox

            TextBox.FocusLost:Connect(function(enterPressed)
                if callback then callback(TextBox.Text) end
            end)
        end

        return Tab
    end
    return Window
end

return Library
