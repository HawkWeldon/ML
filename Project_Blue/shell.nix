{ pkgs ? import <nixpkgs> {} }:

let
  pythonEnv = pkgs.python314.withPackages (ps: with ps; [numpy             jupyter             ipython                 ipykernel     notebook 
                                                         pandas            matplotlib          seaborn                 torch         onnxmltools
                                                         scikit-learn      torchvision                                 kagglehub     flask
                                                         flask-sqlalchemy  flask-marshmallow   marshmallow-sqlalchemy  sqlalchemy    tqdm
                                                         onnx              onnxscript          skl2onnx                onnxruntime   xgboost    ]);
in
pkgs.mkShell {
  buildInputs = [ pythonEnv pkgs.sqlite];
  shellHook = ''
    # Create a local .venv folder so pip doesn't throw read-only errors on NixOS
    if [ ! -d ".venv" ]; then
      python -m venv .venv
    fi
    source .venv/bin/activate
    pip install medmnist
  '';
}