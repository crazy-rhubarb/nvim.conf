-- install without yarn or npm
return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  ft = { 'markdown' },
  build = function() vim.fn['mkdp#util#install']() end,

  keys = {
    { '<leader>mp', '<cmd>MarkdownPreviewToggle<cr>', ft = 'markdown', desc = 'Toggle Markdown Preview' },
  },
  init = function()
    vim.g.mkdp_auto_start = 1
    vim.g.mkdp_open_to_the_world = 0
    vim.g.mkdp_refresh_slow = 0
  end,
}
