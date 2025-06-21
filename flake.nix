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
        
        # FIXED: Improved installable package
        packages.default = pkgs.stdenv.mkDerivation rec {
          pname = "lancer-sddm-theme";
          version = "1.0.0";
          
          src = ./.;
          
          dontBuild = true;
          
          installPhase = ''
            mkdir -p $out/share/sddm/themes/lancer
            
            # Copy all files to the theme directory
            cp -r * $out/share/sddm/themes/lancer/
            
            # Remove build artifacts if they exist
            rm -f $out/share/sddm/themes/lancer/flake.nix
            rm -f $out/share/sddm/themes/lancer/flake.lock
            rm -rf $out/share/sddm/themes/lancer/.git
            rm -f $out/share/sddm/themes/lancer/README.md
            rm -f $out/share/sddm/themes/lancer/result
            
            # Ensure required files are present
            if [ ! -f $out/share/sddm/themes/lancer/Main.qml ]; then
              echo "ERROR: Main.qml not found in theme directory"
              exit 1
            fi
            
            if [ ! -f $out/share/sddm/themes/lancer/metadata.desktop ]; then
              echo "ERROR: metadata.desktop not found in theme directory"
              exit 1
            fi
            
            echo "Theme installed successfully to $out/share/sddm/themes/lancer/"
          '';
          
          meta = with pkgs.lib; {
            description = "Lancer SDDM Theme - minimal dark theme with hardware key support";
            platforms = platforms.linux;
            license = licenses.gpl3;
            maintainers = [ maintainers.unfree ];
          };
        };
      });
}
