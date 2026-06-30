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

  -- show dotfiles by default in neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    },
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
        "css",
        "scss",
        "graphql",
        "html",
      })
    end,
  },

  -- css + html + graphql + emmet LSPs
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {},
        html = {},
        graphql = {},
        emmet_ls = {
          filetypes = {
            "html", "css", "scss",
            "javascript", "javascriptreact",
            "typescript", "typescriptreact",
          },
        },
      },
    },
  },
}
