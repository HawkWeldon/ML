{ pkgs ? import <nixpkgs> {} }:

let
  pythonEnv = pkgs.python314.withPackages (ps: with ps; [numpy             jupyter             ipython                 ipykernel     notebook 
                                                         pandas            matplotlib          seaborn                 torch         onnxmltools
                                                         scikit-learn      torchvision                                 kagglehub     flask
                                                         flask-sqlalchemy  flask-marshmallow   marshmallow-sqlalchemy  sqlalchemy    tqdm
                                                         onnx              onnxscript          skl2onnx                onnxruntime   xgboost    ]);
in
pkgs.mkShell {
  buildInputs = [ pythonEnv pkgs.sqlite pkgs.stdenv.cc.cc.lib pkgs.zeromq];
  shellHook = ''
    # Make C++ runtime libraries available to pip-installed packages
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
      pkgs.zeromq
    ]}:''${LD_LIBRARY_PATH:-}"

    # Create virtual environment if it doesn't exist
    if [ ! -d ".venv" ]; then
      python -m venv --system-site-packages .venv
    fi

    # Activate virtual environment
    source .venv/bin/activate
    pip install medmnist
  '';
}