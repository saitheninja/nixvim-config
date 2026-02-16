{
  # Import all configuration modules here
  imports = [
    ./options.nix

    # plugins
    ./auto-session.nix
    ./cmp.nix
    ./conform.nix
    ./dap.nix
    ./git.nix
    ./lint.nix
    ./lualine.nix
    ./oil.nix
    ./package-info.nix
    ./telescope.nix
    ./treesitter.nix
    ./trouble.nix
    ./visual-whitespace.nix
  ];

  # Install dependencies for plugins
  dependencies = {
    # Node
    # dap, treesitter (required to build treesitter grammars if not using `nixGrammars`)
    nodejs.enable = false;

    # Faster grep search
    # telescope, grug-far
    ripgrep.enable = true;
  };

  plugins = {
    # language servers
    lsp = {
      enable = true;

      inlayHints = true;
      keymaps = {
        # mappings for `vim.lsp.buf.<action>()` functions
        # can't define modes from here
        # https://github.com/nix-community/nixvim/issues/1157
        # lspBuf = {
        #   "gra" = {
        #     action = "code_action";
        #     desc = "LSP code_action";
        #   };
        #   "grd" = {
        #     action = "definition";
        #     desc = "LSP definition";
        #   };
        #   "grf" = {
        #     action = "format";
        #     desc = "LSP format";
        #   };
        #   "gri" = {
        #     action = "implementation";
        #     desc = "LSP implementation";
        #   };
        #   "grn" = {
        #     action = "rename";
        #     desc = "LSP rename";
        #   };
        #   "grr" = {
        #     action = "references";
        #     desc = "LSP references";
        #   };
        #   "grt" = {
        #     action = "type_definition";
        #     desc = "LSP type_definition";
        #   };
        #   "<C-s>" = {
        #     action = "signature_help";
        #     desc = "LSP signature_help";
        #   };
        # };
      };

      servers = {
        # from vscode-langservers-extracted
        # cssls = {
        #   enable = true;
        #   settings = {
        #     css.lint.unknownAtRules = "ignore"; # ignore tailwind `@apply`
        #   };
        # };
        # eslint.enable = true;
        html.enable = true;
        # jsonls.enable = true;

        svelte.enable = true;

        # on Windows this is slooooooooow to start
        ts_ls.enable = true; # TypeScript

        # formatter for JavaScript, TypeScript, JSX, JSON, CSS and GraphQL
        # linter for JavaScript, TypeScript, JSX, CSS and GraphQL
        # npm install --save-dev --save-exact @biomejs/biome && npx @biomejs/biome init
        biome.enable = true;

        # official tailwind LSP
        # npm install @tailwindcss/language-server
        tailwindcss.enable = true;

        # PHP
        phpactor.enable = true;

        gdscript = {
          enable = true; # Godot
          package = null; # LSP is built into Godot - connect to running engine via port 6005
        };
        lua_ls = {
          enable = true;
          settings.telemetry.enable = false;
        };
        nixd.enable = true;
        # rust_analyzer = {
        #   enable = true;
        #   installCargo = false;
        #   installRustc = false;
        # };
        #yamlls.enable = true;
        #zls.enable = true;
      };
    };
    lspkind = {
      enable = true; # add pictograms for LSP completion items

      settings.cmp = {
        enable = true; # format nvim-cmp menu

        menu = {
          nvim_lsp_signature_help = "[LSP_help]";
          nvim_lsp = "[LSP]";
          nvim_lua = "[Lua]";
          luasnip = "[LuaSnip]";
          buffer = "[Buffer]";
          emoji = "[Emoji]";
        };
      };
      settings.mode = "symbol_text"; # "text", "text_symbol", "symbol_text", "symbol"
      settings.preset = "default"; # "default" requires nerd font, "codicons" requires vscode-codicons font
    };
    inc-rename.enable = true; # preview rename while typing

    # ui
    dressing.enable = true; # use Telescope for `vim.ui.input` & `vim.ui.select`
    fidget.enable = true; # notifications & LSP progress in bottom right
    grug-far.enable = true; # find and replace
    scrollview.enable = true; # scrollbar with indicators for diagnostics
    web-devicons.enable = true; # file type icons
    which-key.enable = true; # show shortcuts
  };

  keymaps =
    # inc-rename
    [
      {
        action = "";
        key = "<leader>r";
        mode = "n";
        options = {
          desc = "+IncRename & GrugFar find and replace";
        };
      }

      {
        action = ":IncRename ";
        key = "<leader>rn";
        mode = "n";
        options = {
          desc = "IncRename: start rename";
        };
      }
    ]

    # grug-far
    ++ [
      {
        action = "<Cmd>GrugFar<CR>";
        key = "<leader>rg";
        mode = [
          "n"
          "v"
        ];
        options = {
          desc = "GrugFar: open in new vertical split buffer";
        };
      }
    ]

    # LSP
    ++ [
      {
        action = "<Cmd>lua vim.lsp.buf.code_action()<CR>";
        key = "<leader>.";
        mode = "n";
        options = {
          desc = "LSP show code actions";
        };
      }
    ];
}
