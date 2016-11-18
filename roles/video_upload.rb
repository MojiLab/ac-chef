name "video_upload"
description "A role to configure ffmpeg on the server"
run_list "recipe[ffmpeg]"
default_attributes "ffmpeg" => { "git_repository" => "https://git.ffmpeg.org/ffmpeg.git" },
                   "yasm" => { "install_method" => :source }
