return {
  '3rd/image.nvim',
  build = false,
  cond = function()
    return vim.fn.has('nvim-0.9') == 1 and os.getenv('TERM') ~= nil
  end,
  opts = {
    processor = 'magick_cli',
  },
}
