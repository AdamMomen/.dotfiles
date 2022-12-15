require("adam")

local has = function(x)
  return vim.fn.has(x) == 1
end

local is_mac = has "macunix"
local is_linux = has "win32"

if is_mac then
--  require('adam.macos')
end

if is_linux then
 -- require('adam.linux')
end
