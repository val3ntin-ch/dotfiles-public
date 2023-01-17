require('v.base')
require('v.highlights')
require('v.maps')
require('v.plugins')

local has = vim.fn.has
local is_mac = has "macunix"

if is_mac then
  require('v.macos')
end
