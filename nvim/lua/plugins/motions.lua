return {
  -- Nags you when you spam hjkl/arrows instead of using a proper motion
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {
      -- hardtime disables the mouse globally (vim.o.mouse = ""), so clicking
      -- the Explorer/picker search box does nothing. Keep the mouse usable.
      disable_mouse = false,
      -- Without these, hardtime keeps blocking arrows and h/j/k/l *inside* the
      -- snacks picker windows (Explorer, file search, grep...), which makes the
      -- search box feel dead. The plugin only ships neo-tree/NvimTree/oil here.
      disabled_filetypes = {
        ["snacks_picker_.*"] = true,
        ["snacks_layout_box"] = true,
        ["snacks_notif"] = true,
        ["snacks_terminal"] = true,
        ["snacks_win_backdrop"] = true,
      },
    },
  },

  -- Shows inline hints for what w/b/e/{/}/etc would jump to
  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
