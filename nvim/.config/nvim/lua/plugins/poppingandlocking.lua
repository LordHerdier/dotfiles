return {
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- 1. Load your custom palettes
      local my_palettes = {
        all = {
          black = "#1D2021",
          red = { base = "#CC241D", bright = "#F42C3E" },
          green = { base = "#98971A", bright = "#B8BB26" },
          yellow = { base = "#D79921", bright = "#FABD2F" },
          blue = { base = "#458588", bright = "#99C6CA" },
          magenta = { base = "#B16286", bright = "#D3869B" },
          cyan = { base = "#689D6A", bright = "#7EC16E" },
          white = { base = "#A89984", bright = "#EBDBB2" },

          -- Background / foreground
          bg0 = "#181921",
          fg1 = "#EBDBB2",
        },
        -- If you care about a specific fox-variant override, add it here:
        -- nightfox = { ... },
      }

      -- 2. Tell Nightfox to use your custom palettes (no need to set specs/groups if you’re fine with defaults)
      require("nightfox").setup({
        palettes = my_palettes,
        -- you can still override styles, modules, etc. here if desired
        options = {
          transparent = true,
          terminal_colors = false,
          dim_interactive = true,
          -- If you want tree-sitter and LSP highlights to be a specific style, you can tweak styles here
          -- e.g., styles = { comments = "italic", keywords = "bold", ... },
        },
        -- specs = {},  -- only if you want to override diagnostic or git colors
        -- groups = {}, -- only if you want to override specific highlight groups
      })

      -- 3. Activate the colorscheme (pick your fox: “nightfox” or “nordfox”, etc.)
      vim.cmd("colorscheme nightfox") -- or "nordfox", "terafox", etc.
    end,
  },
}
