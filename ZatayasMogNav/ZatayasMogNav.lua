-- Created by Zataya - A52 (Ascension) - Zoey#0666 Discord
-- If you require modifications to this addon please let me know so i can put out an update. 
-- I prefer to not create forks. If you do fork this, please credit me and also let me know.
local addonname, addon = ...

local ZatayasMogNav = ZatayasMogNav or CreateFrame("Frame", "ZatayasMogNav", GossipFrame)

Zmn_Config = {} -- Global config table for savedvariables
Zmn_Config.CurrentButtons = {}
Zmn_Config.ScannedSets = {}
Zmn_Config.SetStats = {}
Zmn_Config.Sort = 0

ZatayasMogNav.Version = GetAddOnMetadata(addonname, "Version")

ZatayasMogNav.AddonNameChatColor = "|cFF9370DB"
ZatayasMogNav.TextChatColor = "|cFFFFFFFF"

ZatayasMogNav.ToolTip = CreateFrame("GameToolTip")

ZatayasMogNav.GossipButtons = {
  [1] = GossipTitleButton1,
  [2] = GossipTitleButton2,
  [3] = GossipTitleButton3,
  [4] = GossipTitleButton4,
  [5] = GossipTitleButton5,
  [6] = GossipTitleButton6,
  [7] = GossipTitleButton7,
  [8] = GossipTitleButton8,
  [9] = GossipTitleButton9,
  [10] = GossipTitleButton10,
  [11] = GossipTitleButton11,
  [12] = GossipTitleButton12,
  [13] = GossipTitleButton13,
  [14] = GossipTitleButton14,
  [15] = GossipTitleButton15,
  [16] = GossipTitleButton16,
  [17] = GossipTitleButton17,
  [18] = GossipTitleButton18,
  [19] = GossipTitleButton19,
  [20] = GossipTitleButton20,
  [21] = GossipTitleButton21,
  [22] = GossipTitleButton22,
  [23] = GossipTitleButton23,
  [24] = GossipTitleButton24,
  [25] = GossipTitleButton25,
  [26] = GossipTitleButton26,
  [27] = GossipTitleButton27,
  [28] = GossipTitleButton28,
  [29] = GossipTitleButton29,
  [30] = GossipTitleButton30
}

if not C_Timer or C_Timer._version ~= 2 then
  local setmetatable = setmetatable
  local type = type
  local tinsert = table.insert
  local tremove = table.remove

  C_Timer = C_Timer or {}
  C_Timer._version = 2
  C_Timer._implementedby = "ZatayasMogNav.lua"

  local TickerPrototype = {}
  local TickerMetatable = {
    __index = TickerPrototype,
    __metatable = true
  }

  local waitTable = {}
  local waitFrame = TimerFrame or CreateFrame("Frame", "TimerFrame", UIParent)
  waitFrame:SetScript("OnUpdate", function(self, elapsed)
    local total = #waitTable
    local i = 1

    while i <= total do
      local ticker = waitTable[i]

      if ticker._cancelled then
        tremove(waitTable, i)
        total = total - 1
      elseif ticker._delay > elapsed then
        ticker._delay = ticker._delay - elapsed
        i = i + 1
      else
        ticker._callback(ticker)

        if ticker._remainingIterations == -1 then
          ticker._delay = ticker._duration
          i = i + 1
        elseif ticker._remainingIterations > 1 then
          ticker._remainingIterations = ticker._remainingIterations - 1
          ticker._delay = ticker._duration
          i = i + 1
        elseif ticker._remainingIterations == 1 then
          tremove(waitTable, i)
          total = total - 1
        end
      end
    end

    if #waitTable == 0 then
      self:Hide()
    end
  end)

  local function AddDelayedCall(ticker, oldTicker)
    if oldTicker and type(oldTicker) == "table" then
      ticker = oldTicker
    end

    tinsert(waitTable, ticker)
    waitFrame:Show()
  end

  _G.AddDelayedCall = AddDelayedCall

  local function CreateTicker(duration, callback, iterations)
    local ticker = setmetatable({}, TickerMetatable)
    ticker._remainingIterations = iterations or -1
    ticker._duration = duration
    ticker._delay = duration
    ticker._callback = callback

    AddDelayedCall(ticker)

    return ticker
  end

  function C_Timer.After(duration, callback)
    AddDelayedCall({
      _remainingIterations = 1,
      _delay = duration,
      _callback = callback
    })
  end

  function C_Timer.NewTimer(duration, callback)
    return CreateTicker(duration, callback, 1)
  end

  function C_Timer.NewTicker(duration, callback, iterations)
    return CreateTicker(duration, callback, iterations)
  end

  function TickerPrototype:Cancel()
    self._cancelled = true
  end
end

function ZatayasMogNav:delay(tick)
  local th = coroutine.running()
  C_Timer.After(tick, function()
    coroutine.resume(th)
  end)
  coroutine.yield()
end

local function spairs(t, order) -- https://stackoverflow.com/questions/15706270/sort-a-table-in-lua
  -- collect the keys
  local keys = {}
  for k in pairs(t) do
    keys[#keys + 1] = k
  end

  -- if order function given, sort by it by passing the table and keys a, b,
  -- otherwise just sort the keys 
  if order then
    table.sort(keys, function(a, b)
      return order(t, a, b)
    end)
  else
    table.sort(keys)
  end

  -- return the iterator function
  local i = 0
  return function()
    i = i + 1
    if keys[i] then
      return keys[i], t[keys[i]]
    end
  end
end

-- frame
ZatayasMogNav:SetScript("OnEvent", function(self, event, ...)
  self[event](self, ...)
end)

ZatayasMogNav:SetSize(600, 432)
ZatayasMogNav:ClearAllPoints()
ZatayasMogNav:EnableMouse(true)
ZatayasMogNav:SetBackdrop({
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
  tile = true,
  tileSize = 32,
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  edgeSize = 16,
  insets = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 2
  }
})
ZatayasMogNav:SetBackdropColor(0, 0, 0, 1)
ZatayasMogNav:SetBackdropBorderColor(1, 1, 1, 1)
-- --/frame

ZatayasMogNav.NavButtonFrame = ZatayasMogNav.NavButtonFrame or
                                   CreateFrame("Frame", "ZatayasMogNavNavButtonFrame", GossipFrame)
ZatayasMogNav.NavButtonFrame:SetSize(342, 30)
ZatayasMogNav.NavButtonFrame:ClearAllPoints()
ZatayasMogNav.NavButtonFrame:EnableMouse(true)
ZatayasMogNav.NavButtonFrame:SetBackdrop({
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
  tile = true,
  tileSize = 32,
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  edgeSize = 16,
  insets = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 2
  }
})
ZatayasMogNav.NavButtonFrame:SetBackdropColor(0, 0, 0, 1)
ZatayasMogNav.NavButtonFrame:SetBackdropBorderColor(1, 1, 1, 1)

ZatayasMogNav.ZatayasMogNavTitleTxt = ZatayasMogNav:CreateFontString(nil, "OVERLAY", "GameFontNormal")
ZatayasMogNav.ZatayasMogNavTitleTxt:SetPoint("TOP", ZatayasMogNav, "TOP", 0, -5)
ZatayasMogNav.ZatayasMogNavTitleTxt:SetFont("Fonts\\FRIZQT__.TTF", 11, nil)
ZatayasMogNav.ZatayasMogNavTitleTxt:SetText("Zataya's Mog Nav")

ZatayasMogNav.ZatayasMogNavSetCntTxt = ZatayasMogNav:CreateFontString(nil, "OVERLAY", "GameFontNormal")
ZatayasMogNav.ZatayasMogNavSetCntTxt:SetPoint("BOTTOMLEFT", ZatayasMogNav, "BOTTOMLEFT", 15, 8)
ZatayasMogNav.ZatayasMogNavSetCntTxt:SetFont("Fonts\\FRIZQT__.TTF", 8, nil)

function ZatayasMogNav:SetTextures(button)
  local ntex = button:CreateTexture()
  ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
  ntex:SetTexCoord(0, 0.625, 0, 0.6875)
  ntex:SetAllPoints()
  button:SetNormalTexture(ntex)

  local htex = button:CreateTexture()
  htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
  htex:SetTexCoord(0, 0.625, 0, 0.6875)
  htex:SetAllPoints()
  button:SetHighlightTexture(htex)

  local ptex = button:CreateTexture()
  ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
  ptex:SetTexCoord(0, 0.625, 0, 0.6875)
  ptex:SetAllPoints()
  button:SetPushedTexture(ptex)
end

function ZatayasMogNav:Trim(s)
  return s:match("^%s*(.-)%s*$")
end

function ZatayasMogNav:ShortenString(s)
  local max = 16
  if s then
    local len = #s
    if len > max then
      return string.sub(s, 1, max) .. ".."
    else
      return s
    end
  end
end

function ZatayasMogNav:PadBtnTxt(text) -- probably dont need to do this anymore, dont think that odd edgecase is still valid.
  return string.format("~%s~", ZatayasMogNav:Trim(text))
end

function ZatayasMogNav:PutInChatBox(text)
  text = type(text) ~= "string" and "" or text
  local e = SELECTED_CHAT_FRAME.editBox
  ChatEdit_ActivateChat(e)
  e:SetText(text)
end

function ZatayasMogNav:PrintToChat(msg)
  local output = ZatayasMogNav.AddonNameChatColor .. "ZMN:|r " .. ZatayasMogNav.TextChatColor .. msg .. "|r"
  if DEFAULT_CHAT_FRAME == SELECTED_CHAT_FRAME then
    DEFAULT_CHAT_FRAME:AddMessage(output)
  else
    DEFAULT_CHAT_FRAME:AddMessage(output)
    SELECTED_CHAT_FRAME:AddMessage(output)
  end
end

-- https://authors.curseforge.com/forums/world-of-warcraft/general-chat/lua-code-discussion/226226-removing-wow-escape-sequences-from-a-string
ZatayasMogNav.escapes = {
  ["|c%x%x%x%x%x%x%x%x"] = "", -- color start
  ["|r"] = "", -- color end
  ["|H.-|h(.-)|h"] = "%1", -- links
  ["|T.-|t"] = "", -- textures
  ["{.-}"] = "" -- raid target icons
}

function ZatayasMogNav:unescape(str)
  for k, v in pairs(ZatayasMogNav.escapes) do
    str = gsub(str, k, v)
  end
  return str
end

function ZatayasMogNav:ScanPage()
  Zmn_Config.CurrentButtons = {}

  local i = 30
  while (true) do

    if ZatayasMogNav.GossipButtons[i]:GetText() then
      local btntext = ZatayasMogNav:unescape(ZatayasMogNav.GossipButtons[i]:GetText())
      if ZatayasMogNav.GossipButtons[i]:IsShown() then
        Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(btntext)] = {}
        Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(btntext)].DisplayText = btntext
        Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(btntext)].original = ZatayasMogNav.GossipButtons[i]:GetText()
        Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(btntext)].buttonindex = i
        Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(btntext)].DisplayIndex =
            tonumber(ZatayasMogNav:Trim(gsub(ZatayasMogNav.GossipButtons[i]:GetName(), "GossipTitleButton", ""))) - 1
      else
        if Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(btntext)] then
          Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(btntext)] = nil
        end
      end
    end

    --- dont fuck with this part. We absolutely have to loop through these in reverse. I am glad i still have hair.
    i = i - 1
    if i == 0 then
      break
    end
  end

end

ZatayasMogNav.mognpcs = {
  ["Gimbly"] = true,
  ["Kahn"] = true,
  ["Marazz"] = true,
  ["Archmage Thorpe"] = true,
  ["A'lae Stargazer"] = true,
  ["Julian Springforce"] = true
}

-- /script print(GossipFrameNpcNameText:GetText())
ZatayasMogNav.navbtns = {
  [1] = "How sets work",
  [2] = "Save Set",
  [3] = "Next..",
  [4] = "Previous..",
  [5] = "Back..",
  [6] = "Use set",
  [7] = "Delete set",
  [8] = "Assign spec",
  [9] = "Save and Manage Sets",
  [10] = "Save set"
}

ZatayasMogNav.excludebtns = {
  ["How sets work"] = 1,
  ["Save Set"] = 2,
  ["Next.."] = 3,
  ["Previous.."] = 4,
  ["Back.."] = 5,
  ["Use set"] = 6,
  ["Delete set"] = 7,
  ["Assign spec"] = 8,
  ["Save and Manage Sets"] = 9,
  ["Save set"] = 10
}

function ZatayasMogNav:IsMogWindowOpen()
  if GossipFrame:IsShown() and ZatayasMogNav.mognpcs[GossipFrameNpcNameText:GetText()] then
    return true
  end
  return false
end

function ZatayasMogNav:IsInSetPages()
  if Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[4])] then
    return true
  end
  return false
end

function ZatayasMogNav:IsInRootMenu()
  if Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[9])] then
    return true
  end
  return false
end

function ZatayasMogNav:IsInSetMenu()
  if Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[5])] and
      not Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[1])] then
    return true
  end
  return false
end

function ZatayasMogNav:FullScan()

  Zmn_Config.ScannedSets = {}

  local page = 1

  if not ZatayasMogNav:IsMogWindowOpen() then
    -- xmog npc dialog is not open, lets quit while we are ahead.
    ZatayasMogNav:PrintToChat("Please open the dialog with an xmog npc and try again")
    return
  end

  ZatayasMogNav:delay(0.2)
  ZatayasMogNav:ScanPage()

  if ZatayasMogNav:IsInSetPages() then
    -- we are somewhere in the set pages, we should back out so we can start searching from page one
    ZatayasMogNav.GossipButtons[Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[5])].buttonindex]:Click()
  end

  ZatayasMogNav:delay(0.2)
  ZatayasMogNav:ScanPage()

  if ZatayasMogNav:IsInRootMenu() then
    -- we are in the root menu, lets get into the Save and Manage Sets pages before we continue
    ZatayasMogNav.GossipButtons[Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[9])].buttonindex]:Click()
  end

  ZatayasMogNav:delay(0.2)
  ZatayasMogNav:ScanPage()

  if ZatayasMogNav:IsInSetMenu() then
    -- We are currently in a mog set, lets back out of it to the sets pages before we continue
    ZatayasMogNav.GossipButtons[Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[5])].buttonindex]:Click()
  end

  local i = 1
  while (true) do
    ZatayasMogNav:delay(0.2)
    ZatayasMogNav:ScanPage()

    for k, v in pairs(Zmn_Config.CurrentButtons) do
      if not ZatayasMogNav.excludebtns[v.DisplayText] then
        Zmn_Config.ScannedSets[i] = {}
        Zmn_Config.ScannedSets[i].Key = k
        Zmn_Config.ScannedSets[i].DisplayText = v.DisplayText
        Zmn_Config.ScannedSets[i].original = v.original
        Zmn_Config.ScannedSets[i].buttonindex = v.buttonindex
        Zmn_Config.ScannedSets[i].DisplayIndex = v.DisplayIndex
        Zmn_Config.ScannedSets[i].page = page

        if not Zmn_Config.SetStats[v.DisplayText] then
          Zmn_Config.SetStats[v.DisplayText] = {}
          Zmn_Config.SetStats[v.DisplayText].UseCount = 0
        end

        Zmn_Config.ScannedSets[i].UseCount = Zmn_Config.SetStats[v.DisplayText].UseCount

        if page == 1 then
          Zmn_Config.ScannedSets[i].realindex = v.DisplayIndex
        else
          Zmn_Config.ScannedSets[i].realindex = ((page - 1) * 10) + v.DisplayIndex
        end

        i = i + 1
      end
    end

    if not Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[3])] then
      break
    end

    ZatayasMogNav.GossipButtons[Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[3])].buttonindex]:Click()
    page = page + 1
  end

  ZatayasMogNav:delay(0.2)
  ZatayasMogNav.GossipButtons[Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[5])].buttonindex]:Click()

  ZatayasMogNav:UpdateSetButtons()
end

local function GotoSet(setname, useset)
  -- print(string.format("GotoSet Starting %s - %s", setname, tostring(useset)))

  if not ZatayasMogNav:IsMogWindowOpen() then
    -- xmog npc dialog is not open, lets quit while we are ahead.
    -- print(string.format("Xmog npc window not open! exiting function GotoSet!", setname, tostring(useset)))
    ZatayasMogNav:PrintToChat("Please open the dialog with an xmog npc and try again")
    return
  end

  ZatayasMogNav:delay(0.2)
  ZatayasMogNav:ScanPage()

  if ZatayasMogNav:IsInSetPages() then
    -- we are somewhere in the set pages, we should back out so we can start searching from page one
    ZatayasMogNav.GossipButtons[Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[5])].buttonindex]:Click()
    -- print(string.format("Backing out of saved sets, Clicking %s", navbtns[5]))
  end

  ZatayasMogNav:delay(0.2)
  ZatayasMogNav:ScanPage()

  if ZatayasMogNav:IsInRootMenu() then
    -- we are in the root menu, lets get into the Save and Manage Sets pages before we continue
    ZatayasMogNav.GossipButtons[Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[9])].buttonindex]:Click()
    -- print(string.format("Clicking into %s", navbtns[9]))
  end

  ZatayasMogNav:delay(0.2)
  ZatayasMogNav:ScanPage()

  if ZatayasMogNav:IsInSetMenu() then
    -- We are currently in a mog set, lets back out of it to the sets pages before we continue
    ZatayasMogNav.GossipButtons[Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[5])].buttonindex]:Click()
    -- print(string.format("Backing out of set! Clicking %s", navbtns[5]))
  end

  local setfound = false
  while (true) do
    -- lets check the current page for our set
    ZatayasMogNav:delay(0.2)
    ZatayasMogNav:ScanPage()

    if Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(setname)] then
      -- we found the set! Lets click into it.
      -- print(string.format("Found set %s", setname))
      ZatayasMogNav.GossipButtons[Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(setname)].buttonindex]:Click()
      setfound = true
      break
    end

    if not setfound then
      if not Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[3])] then
        -- We have hit the last page of sets, there is no Next.. button.
        -- print(string.format("End of sets! %s button not found", navbtns[3]))
        setfound = false
        break
      else
        -- We did not find the set on this page, lets click Next..
        -- print(string.format("Set %s not found! Clicking %s", setname, navbtns[3]))
        ZatayasMogNav.GossipButtons[Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[3])]
            .buttonindex]:Click()
      end
    end
  end

  if setfound and useset then
    -- print(string.format("Found set %s and clicking Use Set!", setname))
    ZatayasMogNav:delay(0.2)
    ZatayasMogNav:ScanPage()
    -- We are in the set, and now we are going to apply the set.
    ZatayasMogNav.GossipButtons[Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[6])].buttonindex]:Click()
    ZatayasMogNav:delay(0.2)
    -- lets click Accept on the confirmation
    StaticPopup1Button1:Click()
    ZatayasMogNav:delay(0.2)
    -- Now lets back out to the first page of our mog sets
    ZatayasMogNav.GossipButtons[Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[5])].buttonindex]:Click()

  end

  -- print(string.format("GotoSet Finished"))
end

function ZatayasMogNav:NextPage()
  ZatayasMogNav:ScanPage()

  if Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[9])] then
    -- we want the next page, but we arent in the sets!
    ZatayasMogNav.GossipButtons[Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[9])].buttonindex]:Click()
  elseif Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[3])] then
    ZatayasMogNav.GossipButtons[Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[3])].buttonindex]:Click()
  end
end

function ZatayasMogNav:PrevPage()
  ZatayasMogNav:ScanPage()

  if Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[4])] then
    ZatayasMogNav.GossipButtons[Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[4])].buttonindex]:Click()
  end
end

function ZatayasMogNav:BackPage()
  ZatayasMogNav:ScanPage()

  if Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[5])] then
    ZatayasMogNav.GossipButtons[Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[5])].buttonindex]:Click()
  end
end

function ZatayasMogNav:SaveNewSet()

  coroutine.wrap(function()

    ZatayasMogNav:delay(0.2)
    ZatayasMogNav:ScanPage()

    if ZatayasMogNav:IsInSetPages() then
      -- we are somewhere in the set pages, we should back out just because
      ZatayasMogNav.GossipButtons[Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[5])]
          .buttonindex]:Click()
    end

    ZatayasMogNav:delay(0.2)
    ZatayasMogNav:ScanPage()

    if ZatayasMogNav:IsInRootMenu() then
      -- we are in the root menu, lets get into the Save and Manage Sets pages before we continue
      ZatayasMogNav.GossipButtons[Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[9])]
          .buttonindex]:Click()
    end

    ZatayasMogNav:delay(0.2)
    ZatayasMogNav:ScanPage()

    if Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[10])] then

      ZatayasMogNav.GossipButtons[Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[10])]
          .buttonindex]:Click() -- click the first save button

      ZatayasMogNav:delay(0.2)
      ZatayasMogNav:ScanPage()

      ZatayasMogNav:delay(0.2)
      ZatayasMogNav:ScanPage()

      ZatayasMogNav.GossipButtons[Zmn_Config.CurrentButtons[ZatayasMogNav:PadBtnTxt(ZatayasMogNav.navbtns[10])]
          .buttonindex]:Click() -- click the second save button

      ZatayasMogNav:delay(0.2)

      StaticPopup1Button1:Click() -- Click the Accept button so we can type in a name
    end

  end)()
end

-- frame events

function ZatayasMogNav:ShowFrame()
  if ZatayasMogNav:IsMogWindowOpen() then
    ZatayasMogNav:SetPoint("TOPLEFT", GossipFrame, "TOPRIGHT", -30, -20)
    ZatayasMogNav.NavButtonFrame:SetPoint("TOPLEFT", GossipFrame, "BOTTOMLEFT", 14, 65)
    ZatayasMogNav.BtnScanSets:Show()
    ZatayasMogNav:Show()
    ZatayasMogNav.NavButtonFrame:Show()
  else
    ZatayasMogNav.BtnScanSets:Hide()
    ZatayasMogNav:Hide()
    ZatayasMogNav.NavButtonFrame:Hide()
  end
end

GossipFrame:HookScript("OnShow", function()
  coroutine.wrap(function() -- Need to wait for the frame to set up for the current npc
    ZatayasMogNav:delay(0.01)
    ZatayasMogNav:ShowFrame()
  end)()
end)

GossipFrame:HookScript("OnHide", function()
  if ZatayasMogNav:IsShown() then
    ZatayasMogNav:Hide()
  end
end)

function ZatayasMogNav:CheckUpdates()
  if not Zmn_Config then
    Zmn_Config = {}
  end
  if not Zmn_Config.ScannedSets then
    Zmn_Config.ScannedSets = {}
  end
  if not Zmn_Config.SetStats then
    Zmn_Config.SetStats = {}
  end
  if not Zmn_Config.CurrentButtons then
    Zmn_Config.CurrentButtons = {}
  end
  if not Zmn_Config.Sort then
    Zmn_Config.Sort = 0
  end
end

ZatayasMogNav:RegisterEvent("PLAYER_LOGIN")
function ZatayasMogNav:PLAYER_LOGIN()
  ZatayasMogNav:CheckUpdates()

  ZatayasMogNav:PrintToChat(string.format("%s loaded! %s /zmn", addonname, ZatayasMogNav.Version))
  ZatayasMogNav:Hide()
  ZatayasMogNav:CreateSetsButtons()
  ZatayasMogNav:CreateNavButtons()
end

-- /frameevents

-- Buttons

ZatayasMogNav.MogSetButtons = {} -- buttons displayed in our frame for each saved set.

local columns = {
  [20] = 1,
  [40] = 2,
  [60] = 3,
  [80] = 4,
  [100] = 5,
  [120] = 6,
  [140] = 7,
  [160] = 8,
  [180] = 9,
  [200] = 10
}

function ZatayasMogNav:CreateSetsButtons()

  local vspace = 3
  local hspace = 9

  local top = -40

  local x = hspace
  local y = top

  local h = 20
  local w = 100

  for i = 1, 200 do

    local button = CreateFrame("Button", nil, ZatayasMogNav)
    button:SetPoint("TOPLEFT", ZatayasMogNav, "TOPLEFT", x, y)
    button:SetWidth(w)
    button:SetHeight(h)

    button:SetText("Button" .. i)
    button:GetFontString():SetTextColor(1, 1, 1, 1)
    button:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 8, nil)

    button:SetNormalFontObject("GameFontNormal")

    ZatayasMogNav:SetTextures(button)

    button:RegisterForClicks("LeftButtonDown", "RightButtonDown")

    ZatayasMogNav.MogSetButtons[i] = button

    y = y - h - vspace

    if columns[i] then
      x = (w * columns[i]) + hspace
      y = top
    end
  end

  ZatayasMogNav:UpdateSetButtons()
end

local framewidthsbycolumn = {
  [1] = 118,
  [2] = 218,
  [3] = 318,
  [4] = 418,
  [5] = 518,
  [6] = 618,
  [7] = 718,
  [8] = 818,
  [9] = 918,
  [10] = 1018
}

local frameheightsbyrow = {
  [0] = 50,
  [1] = 82,
  [2] = 105,
  [3] = 128,
  [4] = 151,
  [5] = 174,
  [6] = 197,
  [7] = 220,
  [8] = 243,
  [9] = 266,
  [10] = 289,
  [11] = 312,
  [12] = 335,
  [13] = 358,
  [14] = 381,
  [15] = 404,
  [16] = 427,
  [17] = 450,
  [18] = 473,
  [19] = 496,
  [20] = 519
}

function ZatayasMogNav:UpdateSetButtons()
  local row = 0
  local column = 1
  local sets = 0

  local Sort = nil
  local SortByIndex = function(t, a, b)
    return t[b].realindex > t[a].realindex
  end
  local SortByName = function(t, a, b)
    return string.lower(t[b].DisplayText) > string.lower(t[a].DisplayText)
  end
  local SortByUsage = function(t, a, b)
    return t[b].UseCount < t[a].UseCount
  end

  if Zmn_Config.Sort == 0 then
    Sort = SortByName
  elseif Zmn_Config.Sort == 1 then
    Sort = SortByIndex
  elseif Zmn_Config.Sort == 2 then
    Sort = SortByUsage
  end

  local sortedsets = {}

  local x = 1
  for k, v in spairs(Zmn_Config.ScannedSets, Sort) do
    sortedsets[x] = v
    x = x + 1
  end

  for k, v in ipairs(ZatayasMogNav.MogSetButtons) do

    if sortedsets[k] then
      sets = sets + 1

      if columns[k] then
        column = column + 1
      end

      if row < 20 then
        row = row + 1
      end

      ZatayasMogNav.MogSetButtons[k]:SetText(ZatayasMogNav:ShortenString(sortedsets[k].DisplayText))
      ZatayasMogNav.MogSetButtons[k]:SetScript("OnClick", nil)
      ZatayasMogNav.MogSetButtons[k]:SetScript("OnClick", function(self, button, down)
        if button and button == "LeftButton" then
          coroutine.wrap(GotoSet)(sortedsets[k].DisplayText, true)
          Zmn_Config.SetStats[sortedsets[k].DisplayText].UseCount =
              Zmn_Config.SetStats[sortedsets[k].DisplayText].UseCount + 1
          sortedsets[k].UseCount = Zmn_Config.SetStats[sortedsets[k].DisplayText].UseCount
          ZatayasMogNav:UpdateSetButtons()
        elseif button and button == "RightButton" then
          coroutine.wrap(GotoSet)(sortedsets[k].DisplayText, false)
        end
      end)

      sortedsets[k].UseCount = Zmn_Config.SetStats[sortedsets[k].DisplayText].UseCount

      ZatayasMogNav.MogSetButtons[k]:SetScript("OnEnter", nil)
      ZatayasMogNav.MogSetButtons[k]:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(ZatayasMogNav.MogSetButtons[k], "ANCHOR_CURSOR")
        GameTooltip:AddLine("|cFFFFFFFF" .. sortedsets[k].DisplayText .. "|r")
        GameTooltip:AddLine(string.format("Page: %s Set: %s", sortedsets[k].page, sortedsets[k].DisplayIndex))
        GameTooltip:AddLine("Left Click: Use Set")
        GameTooltip:AddLine("Right Click: View Set")
        GameTooltip:AddLine("Set: " .. sortedsets[k].realindex)
        GameTooltip:AddLine("Used: " .. sortedsets[k].UseCount)

        GameTooltip:Show()
      end)

      ZatayasMogNav.MogSetButtons[k]:SetScript("OnLeave", nil)
      ZatayasMogNav.MogSetButtons[k]:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
      end)

      ZatayasMogNav.MogSetButtons[k]:Show()
    else
      ZatayasMogNav.MogSetButtons[k]:SetText("Button" .. k)
      ZatayasMogNav.MogSetButtons[k]:SetScript("OnClick", nil)
      ZatayasMogNav.MogSetButtons[k]:SetScript("OnEnter", nil)
      ZatayasMogNav.MogSetButtons[k]:SetScript("OnLeave", nil)
      ZatayasMogNav.MogSetButtons[k]:Hide()
    end

  end

  ZatayasMogNav.ZatayasMogNavSetCntTxt:SetText(string.format("Sets: %s", sets))
  ZatayasMogNav:SetSize(framewidthsbycolumn[column], frameheightsbyrow[row])
end

function ZatayasMogNav:CreateNavButtons()

  ZatayasMogNav.ZatayasMogNavTitleTxt:SetPoint("TOP", ZatayasMogNav, "TOP", 0, -5)

  local sortbtn = CreateFrame("Button", nil, ZatayasMogNav)
  sortbtn:SetPoint("TOP", ZatayasMogNav, "TOP", 0, -20)
  sortbtn:SetHeight(15)
  sortbtn:SetWidth(70)
  sortbtn:SetText("Alphabetical")
  sortbtn:GetFontString():SetTextColor(1, 1, 1, 1)
  sortbtn:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 8, nil)

  sortbtn:SetNormalFontObject("GameFontNormal")
  ZatayasMogNav:SetTextures(sortbtn)

  if Zmn_Config.Sort == 0 then
    sortbtn:SetText("Alphabetical")
  elseif Zmn_Config.Sort == 1 then
    sortbtn:SetText("Original")
  elseif Zmn_Config.Sort == 2 then
    sortbtn:SetText("Used")
  end

  sortbtn:SetScript("OnClick", function(self, button, down)
    if Zmn_Config.Sort == 0 then
      Zmn_Config.Sort = 1
      sortbtn:SetText("Original")
    elseif Zmn_Config.Sort == 1 then
      Zmn_Config.Sort = 2
      sortbtn:SetText("Used")
    elseif Zmn_Config.Sort == 2 then
      Zmn_Config.Sort = 0
      sortbtn:SetText("Alphabetical")
    end
    ZatayasMogNav:UpdateSetButtons()
  end)

  sortbtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(sortbtn, "ANCHOR_CURSOR")
    GameTooltip:AddLine("Original: As they are in the xmog npc dialog.")
    GameTooltip:AddLine("Alphabetical: By the name of the set.")
    GameTooltip:AddLine(
        "Used: Based on the number of times you have clicked one of the below buttons with the given set name.")
    GameTooltip:Show()
  end)

  sortbtn:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)

  local height = 23
  local width = 82

  local nextbtn = CreateFrame("Button", nil, ZatayasMogNav.NavButtonFrame)
  nextbtn:SetPoint("RIGHT", ZatayasMogNav.NavButtonFrame, "RIGHT", -7, 0)
  nextbtn:SetHeight(height)
  nextbtn:SetWidth(width)
  nextbtn:SetText("Next")

  nextbtn:SetNormalFontObject("GameFontNormal")
  ZatayasMogNav:SetTextures(nextbtn)

  nextbtn:SetScript("OnClick", function(self, button, down)
    ZatayasMogNav:NextPage()
  end)

  local prevbtn = CreateFrame("Button", nil, ZatayasMogNav.NavButtonFrame)
  prevbtn:SetPoint("RIGHT", nextbtn, "LEFT", 0, 0)
  prevbtn:SetHeight(height)
  prevbtn:SetWidth(width)
  prevbtn:SetText("Previous")

  prevbtn:SetNormalFontObject("GameFontNormal")
  ZatayasMogNav:SetTextures(prevbtn)

  prevbtn:SetScript("OnClick", function(self, button, down)
    ZatayasMogNav:PrevPage()
  end)

  local backbtn = CreateFrame("Button", nil, ZatayasMogNav.NavButtonFrame)
  backbtn:SetPoint("RIGHT", prevbtn, "LEFT", 0, 0)
  backbtn:SetHeight(height)
  backbtn:SetWidth(width)
  backbtn:SetText("Back")

  backbtn:SetNormalFontObject("GameFontNormal")
  ZatayasMogNav:SetTextures(backbtn)

  backbtn:SetScript("OnClick", function(self, button, down)
    ZatayasMogNav:BackPage()
  end)

  local savebtn = CreateFrame("Button", nil, ZatayasMogNav.NavButtonFrame)
  savebtn:SetPoint("RIGHT", backbtn, "LEFT", 0, 0)
  savebtn:SetHeight(height)
  savebtn:SetWidth(width)
  savebtn:SetText("Save")

  savebtn:SetNormalFontObject("GameFontNormal")
  ZatayasMogNav:SetTextures(savebtn)

  savebtn:SetScript("OnClick", function(self, button, down)
    ZatayasMogNav:SaveNewSet()
  end)

  local scanbtn = CreateFrame("Button", nil, GossipFrame)
  scanbtn:SetPoint("TOPRIGHT", GossipFrameCloseButton, "BOTTOMRIGHT", -10, 0)
  scanbtn:SetHeight(height)
  scanbtn:SetWidth(width)
  scanbtn:SetText("Scan Sets")

  scanbtn:SetNormalFontObject("GameFontNormal")
  ZatayasMogNav:SetTextures(scanbtn)

  scanbtn:SetScript("OnClick", function(self, button, down)
    coroutine.wrap(function()
      ZatayasMogNav:FullScan()
    end)()
  end)

  ZatayasMogNav.BtnSort = sortbtn

  ZatayasMogNav.BtnNext = nextbtn
  ZatayasMogNav.BtnPrev = prevbtn
  ZatayasMogNav.BtnBack = backbtn
  ZatayasMogNav.BtnSave = savebtn
  ZatayasMogNav.BtnScanSets = scanbtn

  ZatayasMogNav.BtnScanSets:Hide()

end
-- /Butons

function ZatayasMogNav:PrintHelp()
  ZatayasMogNav:PrintToChat("/zmn or /ZatayasMogNav")
  ZatayasMogNav:PrintToChat("/zmn fullscan To scan all of your saved sets")
  ZatayasMogNav:PrintToChat("/zmn goto setname : To view the set with this name")
  ZatayasMogNav:PrintToChat("/zmn useset setname : To go to setname and click Use Set")
  ZatayasMogNav:PrintToChat("/zmn next|prev|back : To navigate through the pages")
  ZatayasMogNav:PrintToChat("/zmn save : To save your current mog as a set")
  ZatayasMogNav:PrintToChat("/zmn list : To list all found sets")
end

SLASH_ZMN1 = "/Zmn"
SLASH_ZMN2 = "/ZatayasMogNav"
SlashCmdList["ZMN"] = function(msg)
  local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
  if msg ~= "" then
    if string.lower(cmd) == "scan" then
      ZatayasMogNav:ScanPage()
    elseif string.lower(cmd) == "fullscan" then
      coroutine.wrap(function()
        ZatayasMogNav:FullScan()
      end)()
    elseif string.lower(cmd) == "goto" then
      coroutine.wrap(GotoSet)(args, false)
    elseif string.lower(cmd) == "useset" then
      coroutine.wrap(GotoSet)(args, true)
    elseif string.lower(cmd) == "next" then
      ZatayasMogNav:NextPage()
    elseif string.lower(cmd) == "prev" then
      ZatayasMogNav:PrevPage()
    elseif string.lower(cmd) == "back" then
      ZatayasMogNav:BackPage()
    elseif string.lower(cmd) == "save" then
      ZatayasMogNav:SaveNewSet()
    elseif string.lower(cmd) == "list" then
      for k, v in ipairs(Zmn_Config.ScannedSets) do
        ZatayasMogNav:PrintToChat(string.format("%s %s", k, v.DisplayText))
      end
    elseif string.lower(cmd) == "clear" then
      Zmn_Config.ScannedSets = {}
      ZatayasMogNav:UpdateSetButtons()
    elseif string.lower(cmd) == "rl" then
      ZatayasMogNav:UpdateSetButtons()
    end
  else
    ZatayasMogNav:PrintHelp()
  end
end
