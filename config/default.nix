{ pkgs, ... }:

{
  # Import all your configuration modules here
  imports = [
    ./conform.nix
    ./dap.nix
    ./lualine.nix
    ./package-info.nix
    ./telescope.nix
    ./trouble.nix
    # ./ufo.nix
  ];

  # extra packages to install with nix
  extraPackages = with pkgs; [
    wl-clipboard # wayland clipboard utils
    ripgrep # fast search for grug-far
    #zls # zig LSP
    #biome # JS linter and formatter
  ];
  withNodeJs = false; # install Node and Node plugin provider npm package "neovim"
  withRuby = false; # install Ruby and Ruby plugin provider gem "neovim-ruby"

  clipboard = {
    #register = "unnamedplus"; # use system clipboard as default register
    providers.wl-copy.enable = true; # use wl-clipboard CLI utils
  };

  globals = {
    have_nerd_font = true; # Cascadia Code NF
    mapleader = " "; # set leader key to spacebar

    # disable plugin providers
    loaded_node_provider = 0; # requires npm package "neovim"
    loaded_perl_provider = 0; # requires cpan package "Neovim::Ext"
    loaded_python3_provider = 0; # requires pip package "pynvim"
    loaded_ruby_provider = 0; # requires gem "neovim-ruby"
  };

  opts = {
    # cursor
    cursorline = true; # highlight cursor line
    cursorlineopt = "number,line"; # number, line, both, screenline

    # folding
    foldenable = true;
    foldcolumn = "0"; # fold column width
    foldtext = ""; # set to empty string so that it doesn't mess with syntax highlighting
    foldlevelstart = 99; # start buffer with all folds open

    # indents
    expandtab = true; # expand tabs to spaces
    shiftwidth = 2; # number of spaces to use for each step of indent
    tabstop = 2; # number of spaces that a tab counts for
    breakindent = true; # wrapped lines will get visually indented
    showbreak = "↳"; # string to put at the start of wrapped lines

    # line numbers
    number = true;
    relativenumber = true;

    # list mode
    # (whitespace characters; see :h listchars)
    # default listchars: "tab:> ,trail:-,nbsp:+"
    # end of line (eol): ⏎ return symbol U+23CE
    # tab:
    #   start (second displayed character): <
    #   middle (fills remaining space): -
    #   end (first displayed character): >
    # trailing space: ␣ open box U+2423
    # extends: ⪼ double succeeds U+2ABC
    # precedes: ⪻ double precedes U+2ABB
    # non-breaking space: ⍽ shouldered open box U+237D
    list = true;
    listchars = "tab:<->,trail:␣,extends:⪼,precedes:⪻,nbsp:⍽";

    # scroll
    scrolloff = 999; # minimum number of screen lines to keep visible around the cursor
    sidescrolloff = 10; # minimum number of screen columns to keep visible around the cursor

    # search
    ignorecase = true; # ignore case if all lowercase
    smartcase = true; # case-sensitive if mixed-case
    inccommand = "split"; # incremental preview for substitute

    # sessions
    # auto-session suggests adding: winpos, localoptions
    sessionoptions = "blank,buffers,curdir,folds,help,tabpages,terminal,winpos,winsize";

    # ...rest
    colorcolumn = "81"; # display vertical line
    signcolumn = "yes:1"; # text shifts when column gets toggled, so just leave it on
    termguicolors = true; # enable 24-bit colours
    virtualedit = "block"; # when in visual block mode, the cursor can move freely in columns
  };

  # colours
  colorschemes = {
    cyberdream = {
      enable = true;

      settings = {
        italic_comments = true;
        transparent = true;
      };
    };
  };
  highlightOverride = {
    NonText = {
      link = "Conceal"; # override NonText with link to Conceal
    };
  };

  filetype = {
    extension = {
      "postcss" = "scss";
    };
    pattern = {
      "flake.lock" = "json";
    };
  };

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
          { name = "nvim_lua"; } # neovim Lua API, only works in lua bits
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
    friendly-snippets.enable = true;
    luasnip.enable = true; # snippet engine - required for completions

    # git diffview tabpage, merge tool, file history
    diffview.enable = true;

    # git diffs as coloured symbols in signcolumn
    gitsigns = {
      enable = true;
      settings.current_line_blame_opts.delay = 0;
    };

    # fancy git interface
    neogit = {
      enable = true;
      settings.integrations = {
        diffview = true;
        telescope = true;
      };
    };

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
        # ts_ls.enable = true; # TypeScript

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

    # linting
    lint = {
      enable = true;

      lintersByFt = {
        # css = [ "stylelint" ]; # TODO disabled annoying error message when not installed

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

    # treesitter
    comment.enable = true; # "gc{object/motion}" and "gb{object}" to comment
    indent-blankline = {
      enable = true; # show indent guides

      settings = {
        scope = {
          enabled = true; # highlight indent and underline top and bottom of scope

          show_end = true;
          show_exact_scope = true;
          show_start = true;
        };
      };
    };
    nvim-autopairs.enable = true; # pair brackets, quotes
    nvim-surround.enable = true; # add: `ys{motion}{char}`, delete: `ds{char}`, change: `cs{target}{replacement}`
    rainbow-delimiters.enable = true; # matching brackets get matching colours
    treesitter = {
      enable = true; # parse text as Abstract Syntax Tree (AST) for better understanding

      folding = true;
      nixvimInjections = true; # enable nixvim specific injections, like lua highlighting in extraConfigLua
      nixGrammars = true; # default true
      nodejsPackage = null; # required to build grammars if you are not using `nixGrammars`

      settings = {
        highlight.enable = true;
        indent.enable = true;

        # incremental_selection = {
        #   enable = true;
        #
        #   keymaps = {
        #     init_selection = "gnn"; # set to `false` to disable mapping
        #     node_incremental = "grn";
        #     scope_incremental = "grc";
        #     node_decremental = "grm";
        #   };
        # };
      };
    };
    treesitter-context = {
      enable = true; # sticky scope

      settings = {
        #enable = false; # toggle with :TSContextToggle
        max_lines = 4;
      };
    };
    treesitter-textobjects = {
      enable = true;

      lspInterop = {
        enable = true;

        border = "double";
        peekDefinitionCode = {
          "<leader>d" = {
            query = "";
            desc = "+Treesitter textobjects (TSTextobject)";
          };
          "<leader>df" = {
            query = "@function.outer";
            desc = "TSTextobject: peek function definition";
          };
          "<leader>dF" = {
            query = "@class.outer";
            desc = "TSTextobject: peek class definition";
          };
        };
      };

      move = {
        enable = true;

        gotoNextStart = {
          "]c" = {
            query = "@class.outer";
            desc = "TSTextobject: next start class outer";
          };
          "]f" = {
            query = "@function.outer";
            desc = "TSTextobject: next start function outer";
          };
          "]p" = {
            query = "@parameter.outer";
            desc = "TSTextobject: next start parameter outer";
          };

          # You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
          # "]o" = { query = { "@loop.inner", "@loop.outer" }; };
          "]o" = {
            query = "@loop.*";
            desc = "TSTextobject: next start loop inner/outer";
          };

          # You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
          # highlights.scm, locals.scm, textobjects.scm, folds.scm, injections.scm
          "]s" = {
            query = "@local.scope";
            queryGroup = "locals";
            desc = "TSTextobject: next start scope";
          };
          "]z" = {
            query = "@fold";
            queryGroup = "folds";
            desc = "TSTextobject: next start fold";
          };
        };
        gotoNextEnd = {
          "]C" = {
            query = "@class.outer";
            desc = "TSTextobject: next end class outer";
          };
          "]F" = {
            query = "@function.outer";
            desc = "TSTextobject: next end function outer";
          };
          "]P" = {
            query = "@parameter.outer";
            desc = "TSTextobject: next end parameter outer";
          };
        };

        gotoPreviousStart = {
          "[c" = {
            query = "@class.outer";
            desc = "TSTextobject: previous start class outer";
          };
          "[f" = {
            query = "@function.outer";
            desc = "TSTextobject: previous start function outer";
          };
          "[p" = {
            query = "@parameter.outer";
            desc = "TSTextobject: previous start parameter outer";
          };
        };
        gotoPreviousEnd = {
          "[C" = {
            query = "@class.outer";
            desc = "TSTextobject: previous end class outer";
          };
          "[F" = {
            query = "@function.outer";
            desc = "TSTextobject: previous end funtion outer";
          };
          "[P" = {
            query = "@parameter.outer";
            desc = "TSTextobject: previous end parameter outer";
          };
        };

        # go to either the start or the end, whichever is closer.
        gotoNext = {
          "]n" = {
            query = "@conditional.outer";
            desc = "TSTextobject: next conditional outer";
          };
        };
        gotoPrevious = {
          "[n" = {
            query = "@conditional.outer";
            desc = "TSTextobject: previous conditional outer";
          };
        };
      };

      select = {
        enable = true;

        includeSurroundingWhitespace = true;
        lookahead = true;

        keymaps = {
          # You can use the capture groups defined in textobjects.scm
          "ac" = {
            query = "@class.outer";
            desc = "TSTextobject: select outer class region";
          };
          "ic" = {
            query = "@class.inner";
            desc = "TSTextobject: select inner class region";
          };
          "af" = {
            query = "@function.outer";
            desc = "TSTextobject: select outer function region";
          };
          "if" = {
            query = "@function.inner";
            desc = "TSTextobject: select inner function region";
          };
          "ap" = {
            query = "@parameter.outer";
            desc = "TSTextobject: select outer parameter region";
          };
          "ip" = {
            query = "@parameter.inner";
            desc = "TSTextobject: select inner parameter region";
          };

          # You can also use captures from other query groups like `locals.scm`
          "as" = {
            query = "@local.scope";
            queryGroup = "locals";
            desc = "TSTextobject: select language scope";
          };
        };

        # selectionModes = {
        #   "v" = [ "@parameter.outer" ]; # charwise (default)
        #   "V" = [ "@function.outer" ]; # linewise
        #   "<C-v>" = [ "@class.outer" ]; # blockwise
        # };
      };

      swap = {
        enable = true;

        swapNext = {
          "]]" = {
            query = "@parameter.inner";
            desc = "TSTextobject: swap next parameter inner";
          };
        };
        swapPrevious = {
          "[[" = {
            query = "@parameter.inner";
            desc = "TSTextobject: swap previous parameter inner";
          };
        };
      };
    };
    ts-autotag.enable = true; # autoclose and autorename html tags using treesitter
    #ts-comments.enable = true; # multiple commentstrings detected for uncomment
    ts-context-commentstring.enable = true; # automatically use correct comment syntax for different parts of file

    # ui
    dressing.enable = true; # use Telescope for `vim.ui.input` & `vim.ui.select`
    fidget.enable = true; # notifications & lsp progress
    scrollview.enable = true; # scrollbar with indicators for diagnostics
    web-devicons.enable = true; # file type icons
    which-key.enable = true; # show shortcuts

    # ...rest
    auto-session.enable = true; # session manager
    grug-far.enable = true; # find and replace
    oil = {
      enable = true; # file explorer as a buffer

      settings = {
        columns = [
          # "type"
          "icon"
          # "size"
          # "permissions"
          # "ctime" # change timestamp
          # "mtime" # last modified time
          # "atime" # last access time
          # "birthtime" # created time
        ];

        delete_to_trash = true;
      };
    };
  };

  keymaps =
    # :h <Cmd>
    # <Cmd> does not change modes
    # command is not echoed so no need for <silent>

    # Neovim
    [
      {
        action = "<Cmd>wa<CR>";
        key = "<leader>w";
        mode = "n";
        options = {
          desc = "Neovim: write all";
        };
      }
    ]

    # Neovim move
    ++ [
      # M = alt (meta) key

      # https://vim.fandom.com/wiki/Moving_lines_up_or_down
      # :[range]m[ove] {address}
      # . = current line
      # .+1 = current line + 1 (1 line down)
      # .-2 = current line - 2 (1 line up)
      # == = re-indent line
      {
        action = "<Cmd>move .-2<CR>==";
        key = "<M-k>";
        mode = "n";
        options = {
          desc = "Neovim: move current line up";
        };
      }
      {
        action = "<Cmd>move .+<CR>==";
        key = "<M-j>";
        mode = "n";
        options = {
          desc = "Neovim: move current line down";
        };
      }

      # gi = go to last insert
      {
        action = "<Esc><Cmd>move .-2<CR>==gi";
        key = "<M-k>";
        mode = "i";
        options = {
          desc = "Neovim: move current line up";
        };
      }
      {
        action = "<Esc><Cmd>move .+<CR>==gi";
        key = "<M-j>";
        mode = "i";
        options = {
          desc = "Neovim: move current line down";
        };
      }

      # '> = mark for selection end
      # '< = mark for selection start
      # '>+1 = one line after the last selected line (1 line down)
      # '>-2 = one line after the first selected line (1 line up)
      # gv = reselect the last visual block
      # = = re-indent selection
      # have to use : instead of <Cmd> or there is a "mark not set" error
      {
        action = ":move '<-2<CR>gv=gv";
        key = "<M-k>";
        mode = "v";
        options = {
          desc = "Neovim: move selected lines up";
        };
      }
      {
        action = ":move '>+1<CR>gv=gv";
        key = "<M-j>";
        mode = "v";
        options = {
          desc = "Neovim: move selected lines down";
        };
      }
    ]

    # Neovim terminal
    ++ [
      {
        action = "<C-\\><C-n>"; # have to escape backslash
        key = "<Esc><Esc>";
        mode = "t";
        options = {
          desc = "Neovim: exit Terminal mode";
        };
      }
    ]

    # Neovim settings
    ++ [
      {
        action = "";
        key = "<leader>n";
        mode = "n";
        options = {
          desc = "+Neovim settings";
        };
      }

      {
        action = "<Cmd>lua vim.wo.wrap = not vim.wo.wrap<CR>";
        key = "<leader>nw";
        mode = "n";
        options = {
          desc = "Neovim: toggle line wrap";
        };
      }
      {
        action = "<Cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>";
        key = "<leader>nh";
        mode = "n";
        options = {
          desc = "Neovim: toggle LSP inlay hint";
        };
      }
    ]

    # Neovim buffers
    ++ [
      {
        action = "";
        key = "<leader>b";
        mode = "n";
        options = {
          desc = "+Neovim buffers";
        };
      }

      {
        action = "<Cmd>bn<CR>";
        key = "<leader>bn";
        mode = "n";
        options = {
          desc = "Neovim buffer: next";
        };
      }
      {
        action = "<Cmd>bp<CR>";
        key = "<leader>bp";
        mode = "n";
        options = {
          desc = "Neovim buffer: previous";
        };
      }

      {
        action = "<Cmd>b#<CR>";
        key = "<leader>b#"; # also <C-6>, <C-^>
        mode = "n";
        options = {
          desc = "Neovim buffer: alternate";
        };
      }

      {
        action = "<Cmd>bf<CR>";
        key = "<leader>bf";
        mode = "n";
        options = {
          desc = "Neovim buffer: first";
        };
      }
      {
        action = "<Cmd>br<CR>";
        key = "<leader>br";
        mode = "n";
        options = {
          desc = "Neovim buffer: rewind (same as first)";
        };
      }
      {
        action = "<Cmd>bl<CR>";
        key = "<leader>bl";
        mode = "n";
        options = {
          desc = "Neovim buffer: last";
        };
      }

      {
        action = "<Cmd>ba<CR>";
        key = "<leader>ba";
        mode = "n";
        options = {
          desc = "Neovim buffer: all (one window for each buffer)";
        };
      }
      {
        action = "<Cmd>bd<CR>";
        key = "<leader>bd";
        mode = "n";
        options = {
          desc = "Neovim buffer: delete";
        };
      }
    ]

    # auto-session
    ++ [
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

    # git
    ++ [
      {
        action = "";
        key = "<leader>g";
        mode = "n";
        options = {
          desc = "+Git actions";
        };
      }

      # gitsigns
      {
        action = "<Cmd>Gitsigns toggle_current_line_blame<CR>";
        key = "<leader>gb";
        mode = "n";
        options = {
          desc = "Gitsigns: toggle line blame";
        };
      }
      {
        action = "<Cmd>Gitsigns toggle_deleted<CR>";
        key = "<leader>gd";
        mode = "n";
        options = {
          desc = "Gitsigns: toggle deleted";
        };
      }

      # neogit
      {
        action = "<Cmd>Neogit<CR>";
        key = "<leader>gs";
        mode = "n";
        options = {
          desc = "Neogit: open status buffer in new tab";
        };
      }
    ]

    # oil
    ++ [
      {
        action = "";
        key = "<leader>o";
        mode = "n";
        options = {
          desc = "+Oil file browser";
        };
      }

      {
        action = "<Cmd>Oil<CR>";
        key = "<leader>oe";
        mode = "n";
        options = {
          desc = "Oil: open parent directory";
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

    # treesitter
    ++ [
      {
        action = "";
        key = "<leader>t";
        mode = "n";
        options = {
          desc = "+Treesitter features";
        };
      }

      {
        action = "<Cmd>TSContextToggle<CR>";
        key = "<leader>tc";
        mode = "n";
        options = {
          desc = "Treesitter: toggle sticky context";
        };
      }
    ];

  extraConfigLua = # lua
    ''
      -- from indent-blankline docs
      -- rainbow-delimiters integration
      -- "Setting a list of highlights for scope is currently broken" https://github.com/lukas-reineke/indent-blankline.nvim/issues/893#issuecomment-2167822070
      require("ibl").setup { scope = { highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      } } }
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    '';

  autoCmd = [
    {
      callback.__raw = # lua
        ''
          function()
            vim.highlight.on_yank({ timeout = 250 })
          end
        '';
      desc = "Highlight yanked text";
      event = "TextYankPost";
      group = "highlight_yanked";
    }
  ];

  autoGroups = {
    highlight_yanked = {
      clear = true;
    };
  };
}
