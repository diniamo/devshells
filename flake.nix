{
  inputs.nixpkgs.url = "nixpkgs/master";

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        cudaSupport = true;
      };
    };
  in {
    devShells.${system}.comfyui = pkgs.mkShell {
      packages = [
        (pkgs.python3.withPackages (pythonPackages:
          with pythonPackages; [
            torch
            torchsde
            torchvision
            torchaudio
            einops
            transformers
            tokenizers
            sentencepiece
            safetensors
            aiohttp
            pyyaml
            pillow
            tqdm
            psutil

            kornia
            # spandrel
            soundfile
          ]))
      ];
    };

    nixConfig = {
      extra-substituters = [
        "https://cache.garnix.io"

        "https://cuda-maintainers.cachix.org"
      ];
      extra-trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="

        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      ];
    };
  };
}
