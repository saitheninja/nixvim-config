{ pkgs, ... }:

{
  extraPackages = with pkgs; [
    fd # better find
    fzf # fuzzy find
    ripgrep # faster grep
  ];

  # popup fuzzy finder, with previews
  plugins.telescope = {
    enable = true;

    extensions = {
      fzf-native.enable = true; # fzf sorter written in C
      media-files.enable = true; # preview media files
      ui-select.enable = true; # set vim.ui.select to telescope (used by dressing.nvim)
      undo.enable = true; # view and search undo tree
    };

    # provided to the require('telescope').setup function
    settings = {
      pickers = {
        buffers = {
          mappings = {
            # insert mode
            i = {
              "<C-d>" = {
                __raw = "require('telescope.actions').delete_buffer";
              };
            };
            # normal mode
            n = {
              "dd" = {
                __raw = "require('telescope.actions').delete_buffer";
              };
            };
          };
        };
      };
    };
  };

  keymaps = [
    {
      action = "";
      key = "<leader>f";
      mode = "n";
      options.desc = "+Telescope pickers";
    }

    # file pickers
    {
      action = "<Cmd>Telescope find_files<CR>";
      key = "<leader>ff";
      mode = "n";
      options.desc = "Telescope: find files";
    }
    {
      action = "<Cmd>Telescope live_grep<CR>";
      key = "<leader>fg";
      mode = "n";
      options.desc = "Telescope: live grep";
    }

    # vim pickers
    {
      action = "<Cmd>Telescope autocommands<CR>";
      key = "<leader>fa";
      mode = "n";
      options.desc = "Telescope: autocommands";
    }
    {
      action = "<Cmd>Telescope buffers<CR>";
      key = "<leader>fb";
      mode = "n";
      options.desc = "Telescope: buffers";
    }
    {
      action = "<Cmd>Telescope commands<CR>";
      key = "<leader>fc";
      mode = "n";
      options.desc = "Telescope: plugin/user commands";
    }
    {
      action = "<Cmd>Telescope help_tags<CR>";
      key = "<leader>fh";
      mode = "n";
      options.desc = "Telescope: help tags";
    }
    {
      action = "<Cmd>Telescope jumplist<CR>";
      key = "<leader>fj";
      mode = "n";
      options.desc = "Telescope: jump list";
    }
    {
      action = "<Cmd>Telescope keymaps<CR>";
      key = "<leader>fk";
      mode = "n";
      options.desc = "Telescope: keymaps";
    }
    {
      action = "<Cmd>Telescope loclist<CR>";
      key = "<leader>fl";
      mode = "n";
      options.desc = "Telescope: current window's location list";
    }
    {
      action = "<Cmd>Telescope marks<CR>";
      key = "<leader>fm";
      mode = "n";
      options.desc = "Telescope: marks";
    }
    {
      action = "<Cmd>Telescope oldfiles<CR>";
      key = "<leader>fo";
      mode = "n";
      options.desc = "Telescope: previously opened files (oldfiles)";
    }
    {
      action = "<Cmd>Telescope quickfix<CR>";
      key = "<leader>fq";
      mode = "n";
      options.desc = "Telescope: quickfix list";
    }
    {
      action = "<Cmd>Telescope registers<CR>";
      key = "<leader>fr";
      mode = "n";
      options.desc = "Telescope: registers";
    }
    {
      action = "<Cmd>Telescope vim_options<CR>";
      key = "<leader>fv";
      mode = "n";
      options.desc = "Telescope: vim options";
    }
    {
      action = "<Cmd>Telescope resume<CR>";
      key = "<leader>fx";
      mode = "n";
      options.desc = "Telescope: resume previous picker";
    }
    {
      action = "<Cmd>Telescope pickers<CR>";
      key = "<leader>fz";
      mode = "n";
      options.desc = "Telescope: previously opened pickers";
    }

    # lists pickers
    {
      action = "<Cmd>Telescope builtin<CR>";
      key = "<leader>ft";
      mode = "n";
      options.desc = "Telescope: all built-in pickers";
    }
  ];
}
