local M = {}

---@class MyThemeOpts
---@field palette? string

---@param opts? MyThemeOpts
M.setup = function(opts)
  opts = opts or {}
  local palette_name = opts.palette or vim.g.mytheme_palette or "default"
  local groups = require("mytheme.groups").setup(palette_name)
  for group, settings in pairs(groups) do
    vim.api.nvim_set_hl(0, group, settings)
  end
  vim.g.colors_name = "mytheme"
end

return M
