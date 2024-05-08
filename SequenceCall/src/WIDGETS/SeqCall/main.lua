local dir = "/WIDGETS/SeqCall"
local sounds_dir = dir .. "/sounds/"
local seq_dir = dir .. "/seq/"

local options = {
  { "File", STRING, "Default1"},
  { "Next", SOURCE, 133 },  -- DEFAULT SH
  --{ "Repeat", SOURCE, 0 }
}

local seqPos=1
local sequence = {}

local lastError = nil
local fileName = nil
local header = nil

local HEADER_BG    = COLOR_THEME_SECONDARY1
local HEADER_TX    = COLOR_THEME_PRIMARY2 + BOLD
local NORMAL_BG    = COLOR_THEME_SECONDARY3
local NORMAL_TX    = COLOR_THEME_DISABLED
local SELECTED_BG  = COLOR_THEME_FOCUS
local SELECTED_TX  = COLOR_THEME_ACTIVE + BOLD
local ERROR_BG     = NORMAL_BG
local ERROR_TX     = COLOR_THEME_WARNING + BOLD

-- Change it to "true" to use your own colors
if (false) then
  HEADER_BG    = BLUE
  HEADER_TX    = WHITE + BOLD
  NORMAL_BG    = WHITE
  NORMAL_TX    = DARKGREY
  SELECTED_BG  = WHITE
  SELECTED_TX  = BLACK + BOLD
  ERROR_BG     = RED
  ERROR_TX     = WHITE + BOLD
end

local function playTrackSeq()
  local file =  sequence[seqPos].wav
  if (file) then
    playFile(sounds_dir .. file)
  end
end

local function nextSeq() 
  print("nextSeq() ")
  if (seqPos < #sequence) then
    seqPos = seqPos + 1
    playTrackSeq()
  else
    playFile(sounds_dir .."end.wav")
  end
end

local function prevSeq() 
  print("prevSeq() ")
  if (seqPos > 1) then
    seqPos = seqPos - 1
    playTrackSeq()
  end
end

local function restartSeq() 
  print("restartSeq() ")
  seqPos = 1
  if (sequence[seqPos]) then
    header = sequence[seqPos].text
    print ("Header =".. (header or ""))
  end
end


local function loadFile(name) 
  local fileName = seq_dir .. name .. ".txt"

  print("Loading File = "..fileName)

  local file = io.open(fileName, "r");
  if (file==nil) then 
    -- cannot open file 
    lastError =  "Cannot open file:"..fileName
    print("CANNOT OPEN FILE")
    return
  end

  local lines = io.read(file, 5000)
  io.close(file)

  sequence = {}

  local lineNo = 1

  for line in string.gmatch(lines, "[^\r\n]+") do
    print("Line=".. line)
    local text, wavFile = string.match(line, "([^,]+),%s*([^,]*)%s*")
    if (text==nil) then -- no COMMA 
      text=line 
    end

    print("Text=" .. (text or "") .. " WAV=" .. (wavFile or ""))

    sequence[lineNo] = {}
    sequence[lineNo].text = text
    sequence[lineNo].wav = wavFile
     lineNo = lineNo + 1
  end

  restartSeq();

  lastError = nil 
end

local function create(zone, options)
  print("create()")
  local wgt = { zone=zone, options=options}
  offsetX = (wgt.zone.w - 178) / 2
  offsetY = (wgt.zone.h - 148) / 2

  loadFile(options.File)

  wgt.telemResetLowestMinRSSI = 0

  return wgt
end

local function update(wgt, options)
  print("update()")
  if (options.File == wgt.options.File and options.Next == wgt.options.Next) then
    print("No Change on Update()")
    return
  end
  -- Changes
  wgt.options = options
  print("NextSwitch = "..wgt.options.Next)
  print("File = "..wgt.options.File)

  if (wgt.options.File == nil) then
      return -- no file
  end

  loadFile(options.File)
end

-- workaround to detect telemetry-reset event, until a proper implementation on the lua interface will be created
-- this workaround assume that:
--   RSSI- is always going down
--   RSSI- is reset on the C++ side when a telemetry-reset is pressed by user
--   widget is calling this func on each refresh/background
-- on event detection, the function onTelemetryResetEvent() will be trigger
--
local function detectResetEvent(wgt, callback_onTelemetryResetEvent)

  local currMinRSSI = getValue('RSSI-')
  if (currMinRSSI == nil) then
      --log("telemetry reset event: can not be calculated")
      return
  end
  if (currMinRSSI == wgt.telemResetLowestMinRSSI) then
      --log("telemetry reset event: not found")
      return
  end

  if (currMinRSSI < wgt.telemResetLowestMinRSSI) then
      -- rssi just got lower, record it
      wgt.telemResetLowestMinRSSI = currMinRSSI
      --log("telemetry reset event: not found")
      return
  end

  -- reset telemetry detected
  wgt.telemResetLowestMinRSSI = 101
  --log("telemetry reset event detected")

  -- notify event
  callback_onTelemetryResetEvent(wgt)
end

local function onTelemetryReset(wgt)
  restartSeq()
end

local prevTrig = false
local function background(wgt)
  local NextSwitchValue    = getSourceValue(wgt.options.Next) or -1 -- (Switch is between -1024,0,+1024)
  local triggerNextNow     = NextSwitchValue > 0 -- True when the Switch is in POS position.

  -- Logic to monitor switch change pos 
	prevTrig, triggerNextNow = triggerNextNow, triggerNextNow and not prevTrig 

  -- print ("Switch Value ="..switchValue.."   Trigger = "..(triggerNow and "TRUE" or "FALSE"))

  if (triggerNextNow) then
    nextSeq();
  end

  detectResetEvent(wgt, onTelemetryReset)
end


local function drawSequence(x,y,w,h, lh)
  local y1 = y+lh
  local max_h = h - lh

  lcd.drawFilledRectangle(x,y1,w,lh,SELECTED_BG)
  lcd.drawText(x,y1,string.format("%d. %s %s",seqPos-1, CHAR_RIGHT, sequence[seqPos].text), SELECTED_TX)
  for i=1,30 do
    y1 = y1 + lh
    if (sequence[seqPos+i] == nil or (y1 >= max_h)) then
      return
    end
    lcd.drawText(x,y1,string.format("%d. %s",seqPos+i-1, sequence[seqPos+i].text or ""), NORMAL_TX)    
  end
end 

local function refresh(wgt, event, touchState)
  background(wgt)
  
  local x =  wgt.zone.x
  local y =  wgt.zone.y
  local w =  wgt.zone.w
  local h =  wgt.zone.h

  local lh = 20
 
  if (event == EVT_VIRTUAL_PREV_PAGE) then
    prevSeq();
  elseif (event == EVT_VIRTUAL_NEXT_PAGE) then
    nextSeq();
  elseif (event == EVT_VIRTUAL_ENTER_LONG) then
    restartSeq();
  elseif (event == EVT_TOUCH_BREAK or event == EVT_VIRTUAL_ENTER) then
    playTrackSeq()
  else
    if ((event or 0) ~= 0) then
      print("Unknow event:".. (event or ""))
    end
  end

  -- runs onty on large enough zone
  lcd.drawFilledRectangle(x,y,w,h,NORMAL_BG);
  lcd.drawFilledRectangle(x,y,w,lh,HEADER_BG);
  lcd.drawText(x+5,y,header or "Seq Call", HEADER_TX)

  if (lastError~=nil) then
    y1 = h - (lh*2)
    lcd.drawFilledRectangle(x,y1,w,lh,ERROR_BG);
    lcd.drawText(x,y1,lastError or "", ERROR_TX)
    return
  end

  drawSequence(x,y,w,h, lh)

  -- Minimized version ??
  if w < 180 or h < 145 then    
    return
  end

 -- Maximize version, show instructions
  y1 = h-lh
  lcd.drawFilledRectangle(x,y1,w,lh,HEADER_BG);
  lcd.drawText(x,y1,"PAGE> = Next, PAGE< = Prev, Long ENTER to Restart", HEADER_TX)

end

return { name="SeqCall", options=options, create=create, update=update, refresh=refresh, background=background }