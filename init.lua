vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },

  -- { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)


-- Bind F6 to save and run the compiled file in Alacritty, waiting for Enter key to continue
vim.api.nvim_create_autocmd("FileType", {
    pattern = "cpp",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, "n", "<F6>", ":w<CR>:!alacritty -e sh -c './" .. vim.fn.expand("%:r") .. " && read -p \"Press enter to continue\"'<CR>", { noremap = true, silent = true })
    end,
})

-- Bind F5 to save, compile with g++, and run the file in Alacritty, waiting for Enter key to continue
vim.api.nvim_create_autocmd("FileType", {
    pattern = "cpp",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, "n", "<F5>", ":w<CR>:!g++ -o " .. vim.fn.expand("%:r") .. " " .. vim.fn.expand("%") .. " && alacritty -e sh -c './" .. vim.fn.expand("%:r") .. " && read -p \"Press enter to continue\"'<CR>", { noremap = true, silent = true })
    end,
})

-- Map F2 to open Alacritty in the current directory
vim.api.nvim_set_keymap("n", "<F2>", ":!alacritty --working-directory=\"" .. vim.fn.expand("%:p:h") .. "\"<CR>", { noremap = true, silent = true })


