# subtitle-maker
视频显示字幕是一个常见的需求。
在抖音或小红书等平台上发布视频，常常会有添加字幕的需求，故制作了该小工具。

Displaying subtitles in videos is a common requirement.
It is often necessary to add subtitles when publishing videos on platforms like TikTok or Xiaohongshu, which is why this small tool was created.

# easy to use
#### 1.首次运行(On first run).
```
需要先将ffmpeg-2025-06-17\bin\ffmpeg.zip进行解压。可直接执行ffmpeg_unzip.bat实现解压。

you need to unzip ffmpeg-2025-06-17\bin\ffmpeg.zip.You can simply run ffmpeg_unzip.bat to extract it.
```
#### 2.下载更好的模型(Downlaod a better model)
```
自带了一个最小的模型，若希望提示识别精度，可通过whisper_models_download.bat下载更大的模型，模型越大越好。

A minimal model is included by default.If you want better transcription accuracy, run whisper_models_download.bat to download a larger model — the larger, the better.
```
#### 3.字幕制作及硬烧录。(Subtitle generation and hard-burning)
```
subtitle_generate.bat myvideo.mp4
```