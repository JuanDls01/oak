-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Toggle file explorer with Cmd+b, like VS Code (requires a terminal with the
-- kitty keyboard protocol, e.g. Ghostty, to send the Cmd/Super modifier)
vim.keymap.set("n", "<D-b>", "<leader>e", { remap = true, desc = "Toggle Explorer" })

-- Undo/redo with Cmd+z / Cmd+Shift+z, like VS Code. <C-o> runs one normal-mode
-- command without leaving insert mode, so you stay typing right after.
vim.keymap.set({ "n", "v" }, "<D-z>", "u", { desc = "Undo" })
vim.keymap.set("i", "<D-z>", "<C-o>u", { desc = "Undo" })
vim.keymap.set({ "n", "v" }, "<D-S-z>", "<C-r>", { desc = "Redo" })
vim.keymap.set("i", "<D-S-z>", "<C-o><C-r>", { desc = "Redo" })

-- Toggle comment with Cmd+/, like VS Code
vim.keymap.set("n", "<D-/>", "gcc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("v", "<D-/>", "gc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("i", "<D-/>", "<Cmd>normal gcc<CR>", { desc = "Toggle comment" })

-- Buscar archivo por nombre con Cmd+P, como el Quick Open de VS Code.
-- Reusa <leader><space> de LazyVim, así respeta la detección de root dir.
vim.keymap.set({ "n", "v" }, "<D-p>", "<leader><space>", { remap = true, desc = "Find Files" })
vim.keymap.set("i", "<D-p>", "<Esc><leader><space>", { remap = true, desc = "Find Files" })
