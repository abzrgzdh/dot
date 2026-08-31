local mpd_control = function(command)
   hs.execute("/opt/homebrew/bin/mpc " .. command)
end

hs.hotkey.bind({}, "F7", function() mpd_control("prev") end)     -- Previous
hs.hotkey.bind({}, "F6", function() mpd_control("toggle") end)   -- Play/Pause
-- hs.hotkey.bind({}, "F8", function() mpd_control("toggle") end)   -- Play/Pause
hs.hotkey.bind({}, "F9", function() mpd_control("next") end)     -- Next

hs.hotkey.bind({}, "F8", function() hs.execute("/Users/ali/.local/bin/scripts/noise") end)   -- Background noise toggle
