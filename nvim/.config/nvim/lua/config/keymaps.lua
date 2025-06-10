-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ==================== Leader Key ====================
vim.g.mapleader = " "

-- ==================== Basic Mappings ====================
-- Semicolon to command mode
map("n", ";", ":", { desc = "Enter command mode" })

-- Quick save and quit
map("n", "Q", ":q<CR>", { desc = "Quit" })
map("n", "S", ":w<CR>", { desc = "Save" })

-- Open config files
-- map("n", "<leader>rc", ":e $HOME/.config/nvim/init.lua<CR>", { desc = "Edit nvim config" })
-- map("n", "<leader>rv", ":e .nvimrc<CR>", { desc = "Edit local nvimrc" })

-- Undo operations
map("n", "l", "u", { desc = "Undo" })

-- Insert mode mappings
map("n", "k", "i", { desc = "Insert mode" })
map("n", "K", "I", { desc = "Insert at line start" })

-- Copy to system clipboard
--map("v", "Y", '"+y', { desc = "Copy to system clipboard" })

-- Find pair
--map("n", ",.", "%", { desc = "Find matching pair" })
--map("v", "ki", "$%", { desc = "Visual select to matching pair" })

-- Search related
--map("n", "<leader><CR>", ":nohlsearch<CR>", { desc = "Clear search highlights" })
--map("n", "<leader>dw", "/\\(\\<\\w\\+\\>\\)\\_s*\\1", { desc = "Find adjacent duplicate words" })

-- Space to Tab conversion
--map("n", "<leader>tt", ":%s/    /\t/g", { desc = "Convert 4 spaces to tabs (buffer)" })
--map("v", "<leader>tt", ":s/    /\t/g", { desc = "Convert 4 spaces to tabs (selection)" })

-- Folding
--map("n", "<leader>o", "za", { desc = "Toggle fold" })

-- Insert a pair of {} and go to the next line
--map("i", "<C-y>", "<ESC>A {}<ESC>i<CR><ESC>ko", { desc = "Insert braces and new line" })

-- Go back to main dashboard
map("n", "<leader>h", "<cmd>lua Snacks.dashboard()<CR>")
-- ==================== Custom Cursor Movement ====================
-- Custom movement keys (Colemak-style)
-- u/e = up/down, n/i = left/right
map("n", "u", "k", { desc = "Move up" })
map("n", "n", "h", { desc = "Move left" })
map("n", "e", "j", { desc = "Move down" })
map("n", "i", "l", { desc = "Move right" })
map("n", "gu", "gk", { desc = "Move up (wrapped)" })
map("n", "ge", "gj", { desc = "Move down (wrapped)" })
map("n", "\\v", "v$h", { desc = "Visual select to end of line" })

-- 5x faster movement
map("n", "U", "5k", { desc = "Move up 5 lines" })
map("n", "E", "5j", { desc = "Move down 5 lines" })

-- Line navigation
map("n", "N", "0", { desc = "Go to line start" })
map("n", "I", "$", { desc = "Go to line end" })

-- Word navigation
map("n", "W", "5w", { desc = "Move 5 words forward" })
map("n", "B", "5b", { desc = "Move 5 words backward" })
map("n", "h", "e", { desc = "Move to end of word" })

-- Viewport movement
map("n", "<C-U>", "5<C-y>", { desc = "Scroll up 5 lines" })
map("n", "<C-E>", "5<C-e>", { desc = "Scroll down 5 lines" })

-- Terminal cursor movement
map("t", "<C-N>", "<C-\\><C-N>", { desc = "Exit terminal mode" })
map("t", "<C-O>", "<C-\\><C-N><C-O>", { desc = "Terminal normal mode + jump" })

-- ==================== Insert Mode Cursor Movement ====================
map("i", "<C-a>", "<ESC>A", { desc = "Go to end of line in insert" })

-- ==================== Command Mode Cursor Movement ====================
map("c", "<C-a>", "<Home>", { desc = "Go to command start" })
map("c", "<C-e>", "<End>", { desc = "Go to command end" })
map("c", "<C-p>", "<Up>", { desc = "Previous command" })
map("c", "<C-n>", "<Down>", { desc = "Next command" })
map("c", "<C-b>", "<Left>", { desc = "Move left in command" })
map("c", "<C-f>", "<Right>", { desc = "Move right in command" })
map("c", "<M-b>", "<S-Left>", { desc = "Move word left in command" })
map("c", "<M-w>", "<S-Right>", { desc = "Move word right in command" })

-- ==================== Window Management ====================
-- Window navigation with custom keys
map("n", "<leader>ww", "<C-w>w", { desc = "Next window" })
map("n", "<leader>wu", "<C-w>k", { desc = "Window up" })
map("n", "<leader>we", "<C-w>j", { desc = "Window down" })
map("n", "<leader>wn", "<C-w>h", { desc = "Window left" })
map("n", "<leader>wi", "<C-w>l", { desc = "Window right" })
map("n", "qf", "<C-w>o", { desc = "Close other windows" })

-- Disable default s key
map("n", "s", "<nop>", { desc = "Disabled" })

-- ==================== Visual Mode Movement ====================
for _, mode in ipairs({ "v", "x", "o" }) do
  map(mode, "u", "k", opts) -- up
  map(mode, "e", "j", opts) -- down
  map(mode, "n", "h", opts) -- left
  map(mode, "i", "l", opts) -- right
  map(mode, "gu", "gk", opts) -- wrapped up
  map(mode, "ge", "gj", opts) -- wrapped down
end
-- Window splitting
--map("n", "su", ":set nosplitbelow<CR>:split<CR>:set splitbelow<CR>", { desc = "Split up" })
--map("n", "se", ":set splitbelow<CR>:split<CR>", { desc = "Split down" })
--map("n", "sn", ":set nosplitright<CR>:vsplit<CR>:set splitright<CR>", { desc = "Split left" })
--map("n", "si", ":set splitright<CR>:vsplit<CR>", { desc = "Split right" })

-- Window resizing with arrow keys
--map("n", "<Up>", ":res +5<CR>", { desc = "Increase window height" })
--map("n", "<Down>", ":res -5<CR>", { desc = "Decrease window height" })
--map("n", "<Left>", ":vertical resize-5<CR>", { desc = "Decrease window width" })
--map("n", "<Right>", ":vertical resize+5<CR>", { desc = "Increase window width" })

-- Window layout changes
--map("n", "sh", "<C-w>t<C-w>K", { desc = "Change to horizontal layout" })
--map("n", "sv", "<C-w>t<C-w>H", { desc = "Change to vertical layout" })
--map("n", "srh", "<C-w>b<C-w>K", { desc = "Rotate to horizontal" })
--map("n", "srv", "<C-w>b<C-w>H", { desc = "Rotate to vertical" })

-- Close window below
--map("n", "<leader>q", "<C-w>j:q<CR>", { desc = "Close window below" })

-- ==================== Tab Management ====================
-- Note: You'll need to add tab management keybindings from the original config
-- They seem to be defined in a section that wasn't fully captured
--
-- ==================== Telescope ====================
