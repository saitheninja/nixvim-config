{
  plugins.package-info = {
    enable = true;
    enableTelescope = true;
  };

  keymaps = [
    {
      action = "";
      key = "<leader>p";
      mode = "n";
      options = {
        desc = "+PackageInfo for NPM";
      };
    }

    {
      action = "<Cmd>PackageInfoShowForce<CR>"; # force refetch package info
      key = "<leader>ps";
      mode = "n";
      options = {
        desc = "PackageInfo: run `npm outdated --json`";
      };
    }
    {
      action = "<Cmd>PackageInfoChangeVersion<CR>";
      key = "<leader>pv";
      mode = "n";
      options = {
        desc = "PackageInfo: version picker";
      };
    }
  ];
}
