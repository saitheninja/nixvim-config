{ pkgs, ... }:

{
  # Import all your configuration modules here
  imports = [
    ./options.nix

    # plugins
    ./conform.nix
    ./dap.nix
    ./git.nix
    ./lualine.nix
    ./oil.nix
    ./package-info.nix
    ./telescope.nix
    ./treesitter.nix
    ./trouble.nix
  ];

  # extra packages to install with nix
  extraPackages = with pkgs; [
    ripgrep # fast search for grug-far
    #zls # zig LSP
  ];

  plugins = {
    # completions
    cmp = {
      enable = true;

      settings = {
        mapping = {
          "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item())";
          "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item())";

          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";

          "<C-Space>" = "cmp.mapping.complete()"; # trigger completions
          "<C-e>" = "cmp.mapping.abort()";
          "<C-y>" = "cmp.mapping.confirm({ select = true })";
          "<CR>" = "cmp.mapping.confirm({ select = false })"; # set `select = false` to only confirm explicitly selected items

          # from kickstart.nvim
          # <C-l> move to the right of each of the expansion locations
          # <C-h> is similar, except moving backwards
          "<C-l>" = # lua
            ''
              cmp.mapping(function()
                if luasnip.expand_or_locally_jumpable() then
                  luasnip.expand_or_jump()
                end
              end, { 'i', 's' })
            '';
          "<C-h>" = # lua
            ''
              cmp.mapping(function()
                if luasnip.locally_jumpable(-1) then
                  luasnip.jump(-1)
                end
              end, { 'i', 's' })
            '';
        };

        snippets.expand = # lua
          ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';

        sources = [
          { name = "nvim_lsp_signature_help"; } # display function signature, with current parameter emphasized
          { name = "nvim_lsp"; }
          { name = "nvim_lua"; } # neovim Lua API, only works in lua sections
          { name = "luasnip"; }
          { name = "buffer"; }
          { name = "emoji"; }
        ];

        window = {
          completion = {
            border = "double";
            scrolloff = 5;
            winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,Search:None";
          };

          documentation = {
            border = "double";
            winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,Search:None";
          };
        };
      };
    };
    # snippets
    friendly-snippets.enable = true; # preconfigured snippets
    luasnip.enable = true; # snippet engine (required for completions)

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
        #ts_ls.enable = true; # TypeScript

        # formatter for JavaScript, TypeScript, JSX, JSON, CSS and GraphQL
        # linter for JavaScript, TypeScript, JSX, CSS and GraphQL
        # npm install --save-dev --save-exact @biomejs/biome && npx @biomejs/biome init
        biome.enable = true;

        # official tailwind LSP
        # npm install @tailwindcss/language-server
        tailwindcss.enable = true;

        #gdscript.enable = true; # Godot
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

      cmp = {
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
      mode = "symbol_text"; # "text", "text_symbol", "symbol_text", "symbol"
      preset = "default"; # "default" requires nerd font, "codicons" requires vscode-codicons font
    };
    inc-rename.enable = true; # preview rename while typing
    typescript-tools.enable = true; # faster & better integrated lsp as a replacement for typescript-language-server

    # linting
    lint = {
      enable = true;

      lintersByFt = {
        # css = [ "stylelint" ]; # TODO disabled because of annoying error message when not installed

        # javascript = [ "eslint" ];
        # javascriptreact = [ "eslint" ];
        # typescript = [ "eslint" ];
        # typescriptreact = [ "eslint" ];
        svelte = [ "eslint" ];

        css = [ "biomejs" ];
        javascript = [ "biomejs" ];
        javascriptreact = [ "biomejs" ];
        typescript = [ "biomejs" ];
        typescriptreact = [ "biomejs" ];

      };
    };

    # testing
    #neotest = {
    #  enable = true;
    #
    #  adapters = {
    #    vitest.enable = true;
    #  };
    #};

    # ui
    dressing.enable = true; # use Telescope for `vim.ui.input` & `vim.ui.select`
    fidget.enable = true; # notifications & lsp progress
    scrollview.enable = true; # scrollbar with indicators for diagnostics
    web-devicons.enable = true; # file type icons
    which-key.enable = true; # show shortcuts

    # ...rest
    auto-session.enable = true; # session manager
    grug-far.enable = true; # find and replace
  };

  keymaps =
    # auto-session
    [
      {
        action = "";
        key = "<leader>s";
        mode = "n";
        options = {
          desc = "+Autosession manage Neovim sessions";
        };
      }

      {
        action = "<Cmd>Autosession search<CR>";
        key = "<leader>ss";
        mode = "n";
        options = {
          desc = "Autosession: search sessions (<C-s> restore, <C-d> delete)";
        };
      }
    ]

    # inc-rename
    ++ [
      {
        action = "";
        key = "<leader>r";
        mode = "n";
        options = {
          desc = "+IncRename & GrugFar incremental find and replace";
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
