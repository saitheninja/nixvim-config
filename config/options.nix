{ pkgs, ... }:

{
  # extra packages to install with nix
  extraPackages = with pkgs; [
    wl-clipboard # wayland clipboard utils
  ];

  # disable plugin providers
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
    virtualedit = "block"; # in visual block mode, allow the cursor to move freely in columns
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

  # extra filetype associations
  filetype = {
    extension = {
      "postcss" = "scss";
    };
    pattern = {
      "flake.lock" = "json";
    };
  };

  # autocommands
  autoCmd = [
    {
      callback.__raw = # lua
        ''
          function()
            vim.highlight.on_yank({ timeout = 100 })
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
    ];
}
