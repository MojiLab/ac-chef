bash 'install ffmpeg' do
  code <<-EOH
    sudo add-apt-repository ppa:mc3man/trusty-media -y
    sudo apt-get update -y
    sudo apt-get dist-upgrade -y
    sudo apt-get install ffmpeg -y
  EOH
end

=begin
execute 'prepare ffmpeg' do
  command 'mkdir -p ~/ffmpeg_sources'
end

package 'yasm'
package 'cmake'
package 'mercurial'

# TODO: Remove previous last_x264.tar.bz2's
bash 'install libx264' do
  code <<-EOH
    cd ~/ffmpeg_sources
    wget http://download.videolan.org/pub/x264/snapshots/last_x264.tar.bz2
    tar xjvf last_x264.tar.bz2
    cd x264-snapshot*
    PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static --disable-opencl
    PATH="$HOME/bin:$PATH"
    make
    make install
    make distclean
  EOH
end

bash 'install libx265' do
  code <<-EOH
    cd ~/ffmpeg_sources
    rm -rf ~/ffmpeg_sources/x265
    hg clone https://bitbucket.org/multicoreware/x265
    cd ~/ffmpeg_sources/x265/build/linux
    PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source
    make
    make install
    make distclean
  EOH
end

package 'libfdk-aac-dev'
package 'libmp3lame-dev'
package 'libopus-dev'

bash 'install ffmpeg' do
  code <<-EOH
    cd ~/ffmpeg_sources
    wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
    tar xjvf ffmpeg-snapshot.tar.bz2
    cd ffmpeg
    PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
      --prefix="$HOME/ffmpeg_build" \
      --pkg-config-flags="--static" \
      --extra-cflags="-I$HOME/ffmpeg_build/include" \
      --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
      --bindir="$HOME/bin" \
      --enable-gpl \
      --enable-libass \
      --enable-libfdk-aac \
      --enable-libfreetype \
      --enable-libmp3lame \
      --enable-libopus \
      --enable-libtheora \
      --enable-libvorbis \
      --enable-libvpx \
      --enable-libx264 \
      --enable-libx265 \
      --enable-nonfree
    PATH="$HOME/bin:$PATH"
    make
    make install
    make distclean
    hash -r
  EOH
end
=end
