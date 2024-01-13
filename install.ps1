Set-Location $PSScriptRoot

$Env:PIP_DISABLE_PIP_VERSION_CHECK = 1

if (!(Test-Path -Path "venv")) {
    Write-Output  "Creating venv for python..."
    python -m venv venv
}
.\venv\Scripts\activate

Write-Output "install deps..."
pip install -U -r requirements-windows.txt

Write-Output "check models..."

if (!(Test-Path -Path "pretrained_weights")) {
    Write-Output  "Downloading pretrained_weights..."
    git lfs install
    git lfs clone https://huggingface.co/patrolli/AnimateAnyone pretrained_weights
    if (Test-Path -Path "pretrained_weights/.git/lfs") {
        Remove-Item -Path pretrained_weights/.git/* -Recurse -Force
    }
}

Set-Location .\pretrained_weights

if (!(Test-Path -Path "image_encoder")) {
    Write-Output  "Downloading image_encoder models..."
    git lfs install
    git lfs clone https://huggingface.co/bdsqlsz/image_encoder
    if (Test-Path -Path "image_encoder/.git/lfs") {
        Remove-Item -Path image_encoder/.git/* -Recurse -Force
    }
}

$install_SD15 = Read-Host "Do you need to download SD15? If you don't have any SD15 model locally select y, if you want to change to another SD1.5 model select n. [y/n] (Default is y)"
if ($install_SD15 -eq "y" -or $install_SD15 -eq "Y" -or $install_SD15 -eq "") {
    if (!(Test-Path -Path "stable-diffusion-v1-5")) {
        Write-Output  "Downloading stable-diffusion-v1-5 models..."
        git lfs clone https://huggingface.co/bdsqlsz/stable-diffusion-v1-5
        
    }
    if (Test-Path -Path "stable-diffusion-v1-5/.git/lfs") {
        Remove-Item -Path stable-diffusion-v1-5/.git/lfs/* -Recurse -Force
    }
}


if (!(Test-Path -Path "DWPose")) {
    Write-Output  "Downloading dwpose models..."
    mkdir "DWPose"
    wget https://huggingface.co/yzd-v/DWPose/resolve/main/dw-ll_ucoco_384.onnx -o DWPose/dw-ll_ucoco_384.onnx
    wget https://huggingface.co/yzd-v/DWPose/resolve/main/yolox_l.onnx -o DWPose/yolox_l.onnx
}

Write-Output "Installing Video_controlnet_aux..."

git submodule update --recursive --init

Set-Location $PSScriptRoot/video_controlnet_aux
pip install -r requirements.txt
pip install -r requirements-video.txt

Write-Output "Install completed"
Read-Host | Out-Null ;
