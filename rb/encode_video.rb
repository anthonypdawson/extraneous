#!/usr/bin/ruby

file = ARGV[0]

system("/home/ayd/src/ffmpeg_src/ffmpeg -threads 1 -flags2 +fast -flags +loop -g 30 -keyint_min 1 -bf 0 -b_strategy 0 -flags2 -wpred-dct8x8 -cmp +chroma -deblockalpha 0 -deblockbeta 0 -refs 1 -coder 0 -me_range 16 -subq 5 -partitions +parti4x4+parti8x8+partp8x8 -trellis 0 -sc_threshold 40 -i_qfactor 0.71 -qcomp 0.6 -map 0.1:0.1 -map 0.0:0.0 -ss 0.0 -i '#{file}' -vf scale=720:480, pad=720:480 -aspect 720:480 -y -async 1 -f h264 -vcodec libx264 -crf 24 -qmin 24 -r 29.97 '#{file}.h264' -f adts -ar 48000 -f wav -ac 2 - | /usr/bin/faac -b 192 -c 20000 --mpeg-vers 4 -o '#{file}.aac' - ")

