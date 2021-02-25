
-- ror.lua
-- This is the file goes in your ~/.config/awesome/ directory
-- It contains your table of 'run or raise' key bindings for aweror.lua
-- Table entry format: ["key"]={"function", "match string", "optional attribute to match"}
-- The "key" can include "Control-", "Shift-", and "Mod1-" modifiers (eg "Control-z")
-- The "key" will be bound as "modkey + key". (eg from above would end up as modkey+Control+z)
-- The "function" is what gets run if no matching client windows are found.
-- Usual attributes are "class","instance", or "name". If no attribute is given it defaults to "class".
-- The "match string"  will match substrings.  So "Firefox" will match "blah Firefox blah"  
-- Use xprop to get this info from a window.  WM_CLASS(STRING) gives you "instance", "class".
-- WM_NAME(STRING) gives you the name of the selected window (usually something like the web page title
-- for browsers, or the file name for emacs).

table5={

   ["Shift-b"]={"xterm -title rtorrentTerm -e rtorrent","rtorrentTerm","name"}, 
   ["c"]={"code", "code-oss", "class"},

   ["g"]={'gimp-2.8', 'gimp-2.8', "class"},

   ["i"]={"firefox", "Firefox", "class"},

   -- ["Control-j"]={"xterm -title jabber -e mcabber", "jabber", "name"},

   
   ["o"]={"emacsclient -c", "Emacs", "class"},
   ["Shift-o"]={"xterm -title emacsTerm -e emacsclient -c -nw", "emacsTerm", "name"},
   ["Control-o"]={"sudo xterm -title emacsRootTerm -e emacs -nw", "emacsRootTerm", "name"},

   ["t"]={"xterm","xterm", "instance"},

   ["u"]={"nemo", "Nemo", "class"},

   ["y"]={"evince", "Evince", "class"},
   -- ["z"]={"evince", "Evince", "class"},

   -- ["["]={"xterm -title irssi -e irssi", "irssi", "name"},

   -- ['\\']={"sudo xterm -title rootTerm -class rootTerm", "rootTerm", "class"},
   -- ["#"]={"sudo xterm -title rootTerm -class rootTerm", "rootTerm", "class"},

   -- [","]={"thunderbird", "Thunderbird", "class"}
}
