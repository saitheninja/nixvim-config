{ ... }:

{
  plugins = {
    # Session manager
    auto-session.enable = true;
  };

  keymaps = [
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
  ];
}
