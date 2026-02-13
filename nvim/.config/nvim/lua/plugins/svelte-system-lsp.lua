return {
  -- Disable Mason auto wiring for svelte
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      opts.automatic_installation = false
    end,
  },

  -- Configure svelte to use system binary
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        svelte = {
          cmd = { "svelteserver", "--stdio" },
        },
      },
    },
  },
}
