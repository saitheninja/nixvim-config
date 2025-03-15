{
  plugins = {
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

  keymaps = [
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
  ];
}
