local columns_visible = false
-- Functions
local function toggle_columns()
  local oil = require 'oil'
  columns_visible = not columns_visible
  if columns_visible then
    oil.set_columns { 'permissions', 'size' }
  else
    oil.set_columns { 'icon' }
  end
end

-- hide untracked git files and dotfiles,
-- code from: https://github.com/stevearc/oil.nvim/blob/master/doc/recipes.md#hide-gitignored-files-and-show-git-tracked-hidden-files
local function is_hidden_file(name, bufnr)
  local dir = require('oil').get_current_dir(bufnr)
  -- return not git_status[dir].tracked[name] # just use gitignore
  local is_dotfile = vim.startswith(name, '.') and name ~= '..'
  -- if no local directory (e.g. for ssh connections), just hide dotfiles
  if not dir then return is_dotfile end
  -- dotfiles are considered hidden unless tracked
  if is_dotfile then
    return not git_status[dir].tracked[name]
  else
    -- Hide if file is gitignored
    return git_status[dir].ignored[name]
  end
end

return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
  -- Optional dependencies
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  opts = {
    delete_to_trash = true,
    view_options = {
      show_hidden = false,
      is_hidden_file = is_hidden_file,
    },
    keymaps = {
      -- Mine
      ['gh'] = { 'actions.toggle_hidden', mode = 'n', desc = '[G]et [H]idden' },
      ['gd'] = { callback = toggle_columns, mode = 'n', desc = '[G]et [D]etails' },
      -- Defaults
      ['g?'] = { 'actions.show_help', mode = 'n' },
      ['<CR>'] = 'actions.select',
      ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
      ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
      ['<C-t>'] = { 'actions.select', opts = { tab = true } },
      ['<C-p>'] = 'actions.preview',
      ['<C-c>'] = { 'actions.close', mode = 'n' },
      ['<C-l>'] = 'actions.refresh',
      ['-'] = { 'actions.parent', mode = 'n' },
      ['_'] = { 'actions.open_cwd', mode = 'n' },
      ['`'] = { 'actions.cd', mode = 'n' },
      ['g~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
      ['gs'] = { 'actions.change_sort', mode = 'n' },
      ['gx'] = 'actions.open_external',
      -- ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
      ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
    },
  },
  -- Config function is called before the require("oil") step
  -- Also from hide git recipe
  config = function(_, opts)
    local function parse_output(proc)
      local result = proc:wait()
      local ret = {}
      if result.code == 0 then
        for line in vim.gsplit(result.stdout, '\n', { plain = true, trimempty = true }) do
          line = line:gsub('/$', '')
          ret[line] = true
        end
      end
      return ret
    end

    local function new_git_status()
      return setmetatable({}, {
        __index = function(self, key)
          local ignore_proc = vim.system({ 'git', 'ls-files', '--ignored', '--exclude-standard', '--others', '--directory' }, { cwd = key, text = true })
          local tracked_proc = vim.system({ 'git', 'ls-tree', 'HEAD', '--name-only' }, { cwd = key, text = true })
          local ret = {
            ignored = parse_output(ignore_proc),
            tracked = parse_output(tracked_proc),
          }
          rawset(self, key, ret)
          return ret
        end,
      })
    end

    git_status = new_git_status()

    local refresh = require('oil.actions').refresh
    local orig_refresh = refresh.callback
    refresh.callback = function(...)
      git_status = new_git_status()
      orig_refresh(...)
    end

    require('oil').setup(opts)
  end,
}
