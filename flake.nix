{
  description = "Lancer SDDM Theme Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Your existing dev shell
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            qt6.full
            qt6.qttools
            qtcreator
            kdePackages.sddm
            qt6.qtdeclarative
            qt6.qt5compat
            qt6.qtsvg
            qt6.qtmultimedia
            kdePackages.qt6ct
            git
            cmake
            pkg-config
          ];
          
          shellHook = ''
            echo "🎨 SDDM Theme Development Environment for Hyprland (Qt6)"
            echo "Starting with where-is-my-sddm-theme as base"
            echo ""
            echo "Available commands:"
            echo "  sddm-greeter --test-mode --theme .      # Test theme"
            echo "  nix build                               # Build package"
            echo "  git push                                # Deploy to GitHub"
          '';
        };
        
        # NEW: Add the installable package
        packages.default = pkgs.stdenv.mkDerivation rec {
          pname = "lancer-sddm-theme";
          version = "1.0.0";
          
          src = ./.;
          
          dontBuild = true;
          
          installPhase = ''
            mkdir -p $out/share/sddm/themes/lancer
            cp -r Main.qml metadata.desktop theme.conf $out/share/sddm/themes/lancer/
            [ -d assets ] && cp -r assets/ $out/share/sddm/themes/lancer/ || true
            [ -d components ] && cp -r components/ $out/share/sddm/themes/lancer/ || true
          '';
          
          meta = with pkgs.lib; {
            description = "Lancer SDDM Theme - minimal dark theme with hardware key support";
            platforms = platforms.linux;
          };
        };
      });
}
