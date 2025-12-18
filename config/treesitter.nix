{
  plugins = {
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

      settings.lsp_interop = {
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

      settings.move = {
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

      settings.select = {
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

      settings.swap = {
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

    treesj = {
      enable = true;
      settings.use_default_keymaps = false;
    };

    ts-autotag.enable = true; # autoclose and autorename html tags using treesitter

    #ts-comments.enable = true; # multiple commentstrings detected for uncomment

    ts-context-commentstring.enable = true; # automatically use correct comment syntax for different parts of file
  };

  keymaps =
    [
      {
        action = "";
        key = "<leader>t";
        mode = "n";
        options = {
          desc = "+Treesitter features";
        };
      }

      # sticky context
      {
        action = "<Cmd>TSContextToggle<CR>";
        key = "<leader>tc";
        mode = "n";
        options = {
          desc = "Treesitter: toggle sticky context";
        };
      }
    ]
    ++
    # treesj split, join, toggle
    [
      {
        action = "<Cmd>TSJSplit<CR>";
        key = "<leader>ts";
        mode = "n";
        options = {
          desc = "TSJ: Split";
        };
      }
      {
        action = "<Cmd>TSJJoin<CR>";
        key = "<leader>tj";
        mode = "n";
        options = {
          desc = "TSJ: Join";
        };
      }
      {
        action = "<Cmd>TSJToggle<CR>";
        key = "<leader>tt";
        mode = "n";
        options = {
          desc = "TSJ: Toggle";
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
}
