-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Detect ansible stuff
vim.filetype.add {
  pattern = {
    ['.*/(tasks|handlers|roles|playbooks)/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/defaults/main%.ya?ml'] = 'yaml.ansible',
    ['.*/vars/.*%.ya?ml'] = 'yaml.ansible',
    ['.*playbook.*%.ya?ml'] = 'yaml.ansible',
  },
}
