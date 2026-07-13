local M = {}

M.available = {
  baitong = "mytheme.palettes.baitong",
}

---@param name string
---@return table<string, string>
M.get = function(name)
  local path = M.available[name]
  if not path then
    vim.notify(("mytheme: unknown palette '%s', falling back to default"):format(name), vim.log.levels.WARN)
    path = M.available.default
  end
  return require(path)
end

return M
