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
      -- hide git files from: https://github.com/stevearc/oil.nvim/blob/master/doc/recipes.md#hide-gitignored-files-and-show-git-tracked-hidden-files
      show_hidden = false,
      is_hidden_file = function(name, bufnr)
        local dir = require('oil').get_current_dir(bufnr)
        local is_dotfile = vim.startswith(name, '.') and name ~= '..'
        -- if no local directory (e.g. for ssh connections), just hide dotfiles
        if not dir then return is_dotfile end
        -- dotfiles are considered hidden unless tracked
        if is_dotfile then
          return not git_status[dir].tracked[name]
        else
          -- Check if file is gitignored
          return git_status[dir].ignored[name]
        end
      end,
    },
    keymaps = {
      ['gh'] = 'actions.toggle_hidden', --TODO does this need a label?
    },
  },
  -- Config function is called before the require("oil") step
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
