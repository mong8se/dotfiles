return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      local ensure_installed = {
        "bash",
        "dockerfile",
        "go",
        "lua",
        "rust",
        "css",
        "diff",
        "elvish",
        "fish",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "graphql",
        "groovy",
        "html",
        "http",
        "java",
        "javascript",
        "jq",
        "jsdoc",
        "json",
        "kotlin",
        "make",
        "markdown",
        "markdown_inline",
        "mermaid",
        "python",
        "regex",
        "ruby",
        "scss",
        "sql",
        "svelte",
        "todotxt",
        "toml",
        "tsx",
        "typescript",
        "yaml",
      }

      require("nvim-treesitter").install(ensure_installed)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = ensure_installed,
        callback = function()
          -- syntax highlighting, provided by Neovim
          vim.treesitter.start()
          -- folds, provided by Neovim
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo.foldmethod = "expr"
          -- indentation, provided by nvim-treesitter
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
}
