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

  -- seamless navigation between tmux panes and nvim splits (Ctrl+h/j/k/l)
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft", "TmuxNavigateDown",
      "TmuxNavigateUp", "TmuxNavigateRight",
    },
    keys = {
      { "<c-h>", "<cmd>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd>TmuxNavigateRight<cr>" },
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

  -- ensure Mason tools are installed on new machines
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "markdownlint-cli2",
        "emmet-ls",
        "graphql-language-service-cli",
      },
    },
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
