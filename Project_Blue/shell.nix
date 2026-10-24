
{ pkgs ? import <nixpkgs> {
    config.allowUnfree = true;
    cudaSupport = true;
  }
}:

let
  pythonEnv = pkgs.python314.withPackages (ps: with ps; [
    numpy
    jupyter
    ipython
    ipykernel
    notebook
    pandas
    matplotlib
    seaborn
    torch
    onnxmltools
    scikit-learn
    torchvision
    kagglehub
    flask
    flask-sqlalchemy
    flask-marshmallow
    marshmallow-sqlalchemy
    sqlalchemy
    tqdm
    onnx
    onnxscript
    skl2onnx
    onnxruntime
    xgboost
  ]);

in
pkgs.mkShell {
  packages = [
    pythonEnv
    pkgs.sqlite
    pkgs.stdenv.cc.cc.lib
    pkgs.zeromq
    pkgs.cudaPackages.cudatoolkit
  ];

  shellHook = ''
    # Make C++ runtime libraries available
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
      pkgs.zeromq
    ]}:''${LD_LIBRARY_PATH:-}"

    # Create virtual environment if missing
    if [ ! -d ".venv" ]; then
      python -m venv --system-site-packages .venv
    fi

    # Activate virtual environment
    source .venv/bin/activate

    # Install MedMNIST only if unavailable
    if ! python -c "import medmnist" 2>/dev/null; then
      python -m pip install medmnist
    fi
  '';
}