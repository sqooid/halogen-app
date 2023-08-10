{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };
  outputs = { self, nixpkgs, ... }@inputs:
    let
      forSystem = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      pkgsFor = forSystem (system:
        import nixpkgs { inherit system; }
      );
    in
    {
      packages = forSystem
        (system:
          let pkgs = pkgsFor."${system}";
          in
          {
            default = pkgs.stdenv.mkDerivation
              {
                buildInputs = [ ];
              };
          }
        );
      devShells = forSystem
        (system:
          let pkgs = pkgsFor."${system}";
          in
          {
            default = pkgs.mkShell {
              buildInputs = with pkgs; self.packages."${system}".default.buildInputs ++ [
                nodejs
                nodePackages.pnpm
              ];
            };
          }
        );
    };
}
