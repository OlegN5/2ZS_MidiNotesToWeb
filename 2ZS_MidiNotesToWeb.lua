--[[
 * ReaScript Name: Convert region names for the dedicated web browser interface
 * About: Have a track named lyrics and text items on it. Run the web interface.
 * Screenshot: https://monosnap.com/file/lDLQNmSP9K6SHCdK7tMWXS3zW31lP7
 * Author: X-Raym, 2ZS
 * Author URI: http://extremraym.com
 * Repository: GitHub > X-Raym > EEL Scripts for Cockos REAPER
 * Repository URI: https://github.com/X-Raym/REAPER-EEL-Scripts
 * Licence: GPL v3
 * Link: Forum https://forum.cockos.com/showthread.php?p=2127630#post2127630
 * REAPER: 5.0
* Version: 1.1
--]]
 
--[[
 * Changelog:
 * v1.1 (2021-02-11)
  + Send dummy text if notes == "", for having instructions on web interface is script is not running.
 * v1.0 (2019-08-30)
  + Initial Release
 --]]
 
 -- Set ToolBar Button State
function SetButtonState( set )
  if not set then set = 0 end
  local is_new_value, filename, sec, cmd, mode, resolution, val = reaper.get_action_context()
  local state = reaper.GetToggleCommandStateEx( sec, cmd )
  reaper.SetToggleCommandState( sec, cmd, set ) -- Set ON
  reaper.RefreshToolbar2( sec, cmd )
end

function Exit()
  reaper.SetProjExtState( 0, "2ZS_Lyrics", "text", "" )
  SetButtonState()
end


-- Main Function (which loop in background)
function main()
  
  -- Get play or edit cursor
  allPosNote, allLyric = getMidiNotesStart ()
  if reaper.GetPlayState() > 0 then
    cur_pos = reaper.GetPlayPosition()
    allPosNote, allLyric = getMidiNotesStart ()
    reaper.SetProjExtState( 0, "2ZS_Lyrics", "text", allPosNote) 
  else
    cur_pos = reaper.GetCursorPosition()
    allPosNote, allLyric = getMidiNotesStart ()
    reaper.SetProjExtState( 0, "2ZS_Lyrics", "text", allPosNote)
    
    --reaper.SetProjExtState( 0, "2ZS_Lyrics", "text", "--XR-NO-TEXT--" )
  end
  
  regionName = GetRegionName(cur_pos)
  reaper.SetProjExtState( 0, "2ZS_Lyrics", "regionName", regionName)
  reaper.SetProjExtState( 0, "2ZS_Lyrics", "allLyric", allLyric)
  
  if reaper.GetExtState("notes", "save") ~= "" then
   --save to notes
    item = reaper.GetSelectedMediaItem(0, 0)
    --reaper.ULT_SetMediaItemNote(item, reaper.GetExtState("notes", "save"))
  end
  
  --Msg (reaper.GetExtState("Lyric", "Y"))
  --Msg (reaper.GetExtState("Lyric0", "Y"))
  
  
  
  
  if reaper.GetExtState("Lyric", "Y") ~= ""  then
  lyrFromWeb0=reaper.GetExtState("Lyric0", "Y")
    reaper.SetExtState("Lyric0", "Y", "", false )
    lyrFromWeb1=reaper.GetExtState("Lyric1", "Y")
    reaper.SetExtState("Lyric1", "Y", "", false )
    lyrFromWeb2=reaper.GetExtState("Lyric2", "Y") 
    reaper.SetExtState("Lyric2", "Y", "", false )
    lyrFromWeb3=reaper.GetExtState("Lyric3", "Y") 
    reaper.SetExtState("Lyric3", "Y", "", false )
    lyrFromWeb4=reaper.GetExtState("Lyric4", "Y") 
    reaper.SetExtState("Lyric4", "Y", "", false )
    lyrFromWeb5=reaper.GetExtState("Lyric5", "Y")
    reaper.SetExtState("Lyric5", "Y", "", false )
    lyrFromWeb6=reaper.GetExtState("Lyric6", "Y")
    reaper.SetExtState("Lyric6", "Y", "", false )
    lyrFromWeb7=reaper.GetExtState("Lyric7", "Y") 
    reaper.SetExtState("Lyric7", "Y", "", false )
    lyrFromWeb8=reaper.GetExtState("Lyric8", "Y")
    reaper.SetExtState("Lyric8", "Y", "", false )
    lyrFromWeb9=reaper.GetExtState("Lyric9", "Y")
    reaper.SetExtState("Lyric9", "Y", "", false )
  
  lyrFromWeb = lyrFromWeb0..lyrFromWeb1..lyrFromWeb2..lyrFromWeb3..lyrFromWeb4..lyrFromWeb5..lyrFromWeb6..lyrFromWeb7..lyrFromWeb8..lyrFromWeb9
  reaper.SetExtState("Lyric", "Y", "", false )
  
  item = reaper.GetSelectedMediaItem(0, 0)
  track = reaper.GetMediaItem_Track(item)
  --reaper.ULT_SetMediaItemNote(item, lyrFromWeb)
  
  insertLyric2Notes(allPosNote, lyrFromWeb, track)
  end
    
    
  --qwe=reaper.GetExtState("notes", "read")
  if reaper.GetExtState("notes", "read") == "y"  then
    --read from notes
    item = reaper.GetSelectedMediaItem(0, 0)
   
    textFromNotes = reaper.ULT_GetMediaItemNote(item)
    reaper.SetProjExtState( 0, "2ZS_Lyrics", "notes", textFromNotes)
   
  end
  
  reaper.defer( main )
  
end

function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function insertLyric2Notes(allPosNote, lyrFromWeb, track)
Msg("Y")
Msg('WORK')
sep = "|"
strMidiLyr = ''

lyrFromWeb = lyrFromWeb:gsub('   ', '\n\n')
lyrFromWeb = lyrFromWeb:gsub('  ', '\n')

evBeat = split(allPosNote, sep)
evLyric = split(lyrFromWeb, sep)
Msg(evBeat)
Msg(evLyric)

--test = 
--retval,  measures, cml, fullbeats, cdenom = reaper.TimeMap2_timeToBeats(0, tpos)
rrrrrrr= #evLyric
for  j=1, #evLyric-1, 1 do

strMidiLyr = strMidiLyr .. reaper.format_timestr_pos(evBeat[j], '', 1 ) .. '\t' .. evLyric[j] .. '\t'
reaper.SetTrackMIDILyrics(track, 2, strMidiLyr)

end
Msg(strMidiLyr)
end


function Msg(variable)
  reaper.ShowConsoleMsg(tostring(variable).."\n")
end

function GetRegionName(cur_pos)
markeridx, regionidx = reaper.GetLastMarkerAndCurRegion( 0, cur_pos )
retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers2( 0, regionidx )

return name
end
 
function getMidiNotesStart ()
num_selected_items = reaper.CountSelectedMediaItems()

-- Iterate through all selected items.
for i = 0, num_selected_items - 1 do
  item = reaper.GetSelectedMediaItem(0, i)
  -- Get the active take
  take = reaper.GetActiveTake(item)
  -- Process the take IFF the take contains MIDI
  if reaper.TakeIsMIDI(take) then
    -- Get all the MIDI events for this take
    ok, buf = reaper.MIDI_GetAllEvts(take, "")
   -- ok,lyricstr=reaper.GetTrackMIDILyrics(_track,2,"")
    -- Proceed only if there are MIDI events to process
    if ok and buf:len() > 0 then
      --[[
      Since messages offsets are relative to the previous message,
      track the total offset, in order to know the position of the MIDI events
      --]]
      total_offset = 0
      pos = 1
      allPos = ''
      allPosNote = ''
      positionNote = ''
      allLyric =''
      lyrOk = 0
      while pos <= buf:len() do
        offs, flag, msg = string.unpack("IBs4", buf, pos)
        total_offset = total_offset + offs
        adv = 4 + 1 + 4 + msg:len()
        -- Determine if this event is a note message
        if msg:byte(1) == 144 and msg:byte(3) ~= 0 then
            positionNote = reaper.MIDI_GetProjTimeFromPPQPos(take, total_offset)
            allPosNote = allPosNote..positionNote.."|"
            lyrOk=lyrOk+1
        end
        -- Determine if this event is a lyric message
        if msg:byte(1) == 255 and msg:byte(2) == 5 then
          lyric = msg:sub(3)
          
           if lyrOk == 2 then 
              lyric = '*|'..lyric
              lyrOk = 0
           end
           if lyrOk == 3 then 
              lyric ='*|*|'..lyric
              lyrOk = 0
           end
           if lyrOk == 4 then 
               lyric ='*|*|*|'..lyric
               lyrOk = 0
           end
         lyrOk = 0    
          --Msg(msg:byte(3))
         -- Msg(msg)
         
            if  msg:byte(3) == 13 then
             lyric = ' '
             --Msg(13)
            end
           if  msg:byte(3) == 10 then
            lyric = ' '
            --Msg(12)
            end
          
          
          
          position = reaper.MIDI_GetProjTimeFromPPQPos(take, total_offset)
          allPos = allPos..position.."|"
          allLyric = allLyric..lyric..'|'
          -- Create the marker reaper.AddProjectMarker(0, false, position, 0, lyric, -1)
    -- Create item notes
         

        end
        pos = pos+adv
      end
    end
  end
end


--Msg(allLyric)

if allPosNote =='' then
allPosNote = 'NO-NOTES'
end
return allPosNote, allLyric
end





notes = nil

-- RUN
SetButtonState( 1 )
main()
reaper.atexit( Exit )
