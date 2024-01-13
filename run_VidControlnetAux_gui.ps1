$input_path="./assets/cai-xukun.mp4"
$output_path="./outputs/"


Set-Location $PSScriptRoot
.\venv\Scripts\activate

$Env:HF_HOME = "./huggingface"
$Env:XFORMERS_FORCE_DISABLE_TRITON = "1"
#$Env:PYTHONPATH = $PSScriptRoot
$ext_args = [System.Collections.ArrayList]::new()

if ($input_path) {
    [void]$ext_args.Add("-i=$input_path")
}

if ($output_path) {
    [void]$ext_args.Add("-o=$output_path")
}


python.exe "video_controlnet_aux/src/video_controlnet_aux.py" $ext_args
