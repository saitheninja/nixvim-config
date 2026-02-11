{ pkgs, ... }:

{
  extraPackages = with pkgs; [
    gdtoolkit_4 # Godot gdformat, gdlint
  ];

  # code linting
  plugins.lint = {
    enable = true;

    lintersByFt = {
      # css = [ "stylelint" ]; # disabled because of annoying error message when not installed

      svelte = [ "eslint" ];

      css = [ "biomejs" ];
      javascript = [ "biomejs" ];
      javascriptreact = [ "biomejs" ];
      typescript = [ "biomejs" ];
      typescriptreact = [ "biomejs" ];

      gdscript = [ "gdlint" ];
    };
  };
}
