{ pkgs, ... }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    lefthook
    nixfmt
    oxfmt
  ];
}
