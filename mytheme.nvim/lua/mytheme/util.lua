-- mytheme.nvim/lua/mytheme/util.lua
local M = {}

---@param hex string
---@return number, number, number
local function hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

---@param r number
---@param g number
---@param b number
---@return string
local function rgb_to_hex(r, g, b)
  return string.format("#%02x%02x%02x", r, g, b)
end

---@param hex1 string
---@param hex2 string
---@param ratio number
---@return string
M.blend = function(hex1, hex2, ratio)
  local r1, g1, b1 = hex_to_rgb(hex1)
  local r2, g2, b2 = hex_to_rgb(hex2)
  return rgb_to_hex(
    math.floor(r1 + (r2 - r1) * ratio),
    math.floor(g1 + (g2 - g1) * ratio),
    math.floor(b1 + (b2 - b1) * ratio)
  )
end

return M
