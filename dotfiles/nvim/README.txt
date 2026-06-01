NVIM CONFIG — what goes here and the 3 NixOS-specific changes
=============================================================

Copy your ENTIRE existing nvim folder into this directory (dotfiles/nvim/), so
you end up with:

    dotfiles/nvim/init.lua
    dotfiles/nvim/lua/config/options.lua
    dotfiles/nvim/lua/config/statusline.lua
    dotfiles/nvim/lua/config/keymaps.lua
    dotfiles/nvim/lua/config/autocmds.lua
    dotfiles/nvim/lua/config/diagnostics.lua
    dotfiles/nvim/lua/config/plugins/blink-cmp.lua
    dotfiles/nvim/lua/config/plugins/colorscheme.lua
    dotfiles/nvim/lua/config/plugins/conform.lua
    dotfiles/nvim/lua/config/plugins/fzf-lua.lua
    dotfiles/nvim/lua/config/plugins/jdtls.lua      <- REPLACE with the one here
    dotfiles/nvim/lua/config/plugins/lsp.lua        <- REPLACE with the one here
    dotfiles/nvim/lua/config/plugins/treesitter.lua

Then apply the THREE NixOS changes:

1. lsp.lua  — REPLACED (in this folder). Mason / mason-lspconfig /
   mason-tool-installer removed; servers + formatters now come from Nix.

2. jdtls.lua — REPLACED (in this folder). Uses the Nix `jdtls` wrapper instead
   of hunting for the Mason launcher jar.

3. blink-cmp.lua — ONE-LINE EDIT (do this yourself in your copy):
   blink.cmp ships a prebuilt Rust fuzzy-matcher binary that will NOT run on
   NixOS. Build it from source instead — replace this line:

       version = "v0.*",

   with:

       build = "cargo build --release",

   (cargo is provided by dev.nix.) If a build ever fails, blink falls back to
   its pure-Lua matcher and still works, just a little slower.

Nothing else needs to change. conform.nvim, fzf-lua, treesitter, colorscheme,
and all your config/*.lua files work as-is — treesitter compiles parsers fine
because gcc + tree-sitter are on PATH (editor.nix).
