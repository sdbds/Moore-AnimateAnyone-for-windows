Set-Location $PSScriptRoot

$Env:PIP_DISABLE_PIP_VERSION_CHECK = 1

if (!(Test-Path -Path "venv")) {
    Write-Output  "创建python虚拟环境venv..."
    python -m venv venv
}
.\venv\Scripts\activate

Write-Output "安装依赖..."
pip install -U -r requirements-windows.txt -i https://mirror.baidu.com/pypi/simple

Write-Output "检查模型..."

if (!(Test-Path -Path "pretrained_weights")) {
    Write-Output  "创建模型文件夹并下载模型..."
    git lfs install
    git lfs clone https://huggingface.co/patrolli/AnimateAnyone pretrained_weights
    if (Test-Path -Path "pretrained_weights/.git/lfs") {
        Remove-Item -Path pretrained_weights/.git/* -Recurse -Force
    }
}

Set-Location .\pretrained_weights

if (!(Test-Path -Path "image_encoder")) {
    Write-Output  "下载image_encoder模型..."
    git lfs install
    git lfs clone https://huggingface.co/bdsqlsz/image_encoder
    if (Test-Path -Path "image_encoder/.git/lfs") {
        Remove-Item -Path image_encoder/.git/* -Recurse -Force
    }
}

$install_SD15 = Read-Host "是否需要下载huggingface的SD15模型? 若您本地没有任何SD15模型选择y，如果想要换其他SD1.5模型选择 n。[y/n] (默认为 y)"
if ($install_SD15 -eq "y" -or $install_SD15 -eq "Y" -or $install_SD15 -eq "") {
    if (!(Test-Path -Path "stable-diffusion-v1-5")) {
        Write-Output  "下载 stable-diffusion-v1-5 模型..."
        git lfs clone https://huggingface.co/bdsqlsz/stable-diffusion-v1-5
        
    }
    if (Test-Path -Path "stable-diffusion-v1-5/.git/lfs") {
        Remove-Item -Path stable-diffusion-v1-5/.git/lfs/* -Recurse -Force
    }
}


if (!(Test-Path -Path "DWPose")) {
    Write-Output  "下载 dwpose 模型..."
    mkdir "DWPose"
    wget https://huggingface.co/yzd-v/DWPose/resolve/main/dw-ll_ucoco_384.onnx -o DWPose/dw-ll_ucoco_384.onnx
    wget https://huggingface.co/yzd-v/DWPose/resolve/main/yolox_l.onnx -o DWPose/yolox_l.onnx
}

Write-Output "安装Video_controlnet_aux..."

git submodule update --recursive --init

Set-Location $PSScriptRoot/video_controlnet_aux
pip install -r requirements.txt -i https://mirror.baidu.com/pypi/simple
pip install -r requirements-video.txt -i https://mirror.baidu.com/pypi/simple

Write-Output "安装完毕"
Read-Host | Out-Null ;
