-- mytheme.nvim/lua/mytheme/groups.lua
local colors = require("mytheme.palette.baitong-rip")

local M = {}

M.setup = function()
  return {
    Normal = { fg = colors.fg, bg = colors.bg },
    Comment = { fg = colors.comment, italic = true },
    Visual = { bg = colors.visual, fg = colors.selection_fg },
    Cursor = { fg = colors.bg, bg = colors.cursor },
    CursorLine = { bg = colors.cursorLine },
    -- LineNr = { fg = colors.comment },
    StatusLine = { fg = colors.fg_highlight, bg = colors.status_bar },
    ["@string"] = { fg = colors.string },
    ["@keyword"] = { fg = colors.keyword },
    ["@function"] = { fg = colors["function"] },
    ["@constant"] = { fg = colors.string },
    ["@number"] = { fg = colors["function"] },
    ["@boolean"] = { fg = colors.keyword },
    DiagnosticError = { fg = colors.error },
    DiagnosticWarn = { fg = colors.warn },
    NormalFloat = { fg = colors.keyword, bg = colors.menu_bg},
  }
end

return M
