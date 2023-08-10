{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };
  outputs = { self, nixpkgs, ... }@inputs:
    let
      forSystem = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
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
                name = "program";
                src = self;
                buildPhase = "clang -o program ./program.c";
                buildInputs = with pkgs; [
                  nodejs_20
                  nodePackages.pnpm
                ];
                installPhase = "mkdir -p $out/bin; cp program $out/bin; chmod +x $out/bin/program";
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
              ];
            };
          }
        );
    };
}
