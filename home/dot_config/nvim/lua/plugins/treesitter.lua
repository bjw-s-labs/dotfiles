return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts = {
      ensure_installed = {
        "bash",
        "fish",
        "html",
        "javascript",
        "lua",
        "markdown",
        "query",
        "toml",
        "vim",
        "vimdoc",
        "yaml"
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  }
}
