return {
    'mong8se/actually.nvim',
    -- { dir = '~/Projects/actually.nvim'},
    'mong8se/buffish.nvim',
    -- { dir = '~/Projects/buffish.nvim' },

    'ibhagwan/fzf-lua',
    'stevearc/dressing.nvim',
    'rcarriga/nvim-notify',
    'RRethy/nvim-base16',
    'caglartoklu/borlandp.vim',
    'sainnhe/gruvbox-material',
    'tpope/vim-rsi',
    'tpope/vim-repeat',

    'hoob3rt/lualine.nvim',
    'kyazdani42/nvim-web-devicons',
    'lukas-reineke/indent-blankline.nvim',
    'folke/trouble.nvim',
    { 'tamago324/lir.nvim', dependencies = {
     'nvim-lua/plenary.nvim' } },

    'roman/golden-ratio', -- C-W \
    'unblevable/quick-scope', -- f F t T

    'danilamihailov/beacon.nvim',
    'echasnovski/mini.nvim',

    'airblade/vim-rooter',
    'tpope/vim-apathy', -- ]f
    'lewis6991/gitsigns.nvim',
    'sheerun/vim-polyglot',

    {'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},
    'nvim-treesitter/nvim-treesitter-textobjects',
    'p00f/nvim-ts-rainbow',

    'tpope/vim-abolish',
    'dyng/ctrlsf.vim', -- leader /

    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    -- For vsnip users.
    'hrsh7th/cmp-vsnip',
    'hrsh7th/vim-vsnip',
    'hrsh7th/vim-vsnip-integ',

    'vimwiki/vimwiki',
    {'itchyny/calendar.vim', cmd = 'Calendar'},
    {'mtth/scratch.vim', cmd = 'Scratch'}, -- gs

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            window = {
                border = "single",
            }
        }
    }
}
