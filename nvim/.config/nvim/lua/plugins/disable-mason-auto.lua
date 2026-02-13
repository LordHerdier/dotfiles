return {
  -- Stop Mason from automatically installing anything.
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = {}        -- don’t auto-install packages
      opts.ui = opts.ui or {}
      opts.ui.check_outdated_packages_on_open = false
    end,
  },

  -- Also stop mason-lspconfig from auto-wiring installs.
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = {}        -- don’t auto-install servers
      opts.automatic_installation = false
    end,
  },

  -- Optional: if you want to fully prevent Mason from doing anything on startup.
  -- Comment this in if it still nags.
  { "williamboman/mason.nvim", enabled = false },
  { "williamboman/mason-lspconfig.nvim", enabled = false },
}
