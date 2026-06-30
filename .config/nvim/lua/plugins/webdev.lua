return {
  -- Catppuccin Mocha — matches ghostty, tmux, fish, yazi
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        mini = { enabled = true },
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        treesitter = true,
        which_key = true,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },

  -- auto-close and auto-rename JSX/HTML tags
  {
    "windwp/nvim-ts-autotag",
    opts = {},
  },

  -- extra treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "graphql",
        "html",
      })
    end,
  },

  -- extra Mason tools
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "prettier",
        "eslint_d",
        "html-lsp",
        "graphql-language-service-cli",
      },
    },
  },

  -- html + graphql LSPs
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {},
        graphql = {},
      },
    },
  },
}
