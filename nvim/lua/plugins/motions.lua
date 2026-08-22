return {
  -- Nags you when you spam hjkl/arrows instead of using a proper motion
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- Shows inline hints for what w/b/e/{/}/etc would jump to
  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
