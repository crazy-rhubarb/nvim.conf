return {
  {
    dir = vim.fn.stdpath("config") .. "/mytheme.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.mytheme_palette = "baitong"
      vim.cmd.colorscheme("mytheme")
    end,
  },
}
