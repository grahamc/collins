{ pkgs ? import <nixpkgs> {} }: with pkgs;
let
  sbtixDir = fetchFromGitHub {
    owner = "teozkr";
    repo = "Sbtix";
    rev = "cf610ef0e885466187bad5b61342afe9eeb1d80a";
    sha256 = "0v31hk4fzwklx03dwq4b951l1ajpkp593i3lnqjf90yy3x0kygzl";
  };
  sbtix = pkgs.callPackage "${sbtixDir}/sbtix.nix" {};
in
    sbtix.buildSbtProject {
        name = "collins";
        src = ./.;
        repo = [ (import ./manual-repo.nix)
                 (import ./repo.nix)
                 (import ./project/repo.nix)
               ];

        installPhase =''
          sbt publish-local
          mkdir -p $out/
          cp ./.ivy2/local/* $out/ -r
        '';
    }
