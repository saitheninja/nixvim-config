{
  plugins = {
    # diffview tabpage, merge tool, file history
    diffview.enable = true;

    # diffs as coloured symbols in signcolumn
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
  };

  keymaps = [
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
  ];

}
