{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  inherit (lib) optional optionals;

  elixir = beam.packages.erlangR23.elixir.override {
      version = "1.11.3";
      sha256 = "DqmKpMLxrXn23fsX/hrjDsYCmhD5jbVtvOX8EwKBakc=";
  };
in

mkShell {
    buildInputs = [ elixir git]
        ++ optional stdenv.isLinux inotify-tools # For file_system on Linux.
        ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
        # For file_system on macOS.
        CoreFoundation
        CoreServices
    ]);

    # Put the PostgreSQL databases in the project diretory.
    shellHook = ''
    mkdir -p .nix-shell
    export NIX_SHELL_DIR=$PWD/.nix-shell
    export MIX_HOME="$NIX_SHELL_DIR/.mix"
    export MIX_ARCHIVES="$MIX_HOME/archives"
  '';

  #######################################################################
  # Without  this, almost  everything  fails with  locale issues  when
  # using `nix-shell --pure` (at least on NixOS).
  # See
  # + https://github.com/NixOS/nix/issues/318#issuecomment-52986702
  # + http://lists.linuxfromscratch.org/pipermail/lfs-support/2004-June/023900.html
  #########################################################################

  LOCALE_ARCHIVE = if pkgs.stdenv.isLinux then "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
}

