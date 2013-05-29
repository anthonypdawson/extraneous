# Encodes very large videos. Typically recorded from OTA or cable sources
# Run in directory where you want to encode files

Dir.glob("*.{wtv,mpeg2,mpg,ts}") do |i|
  if(!File.exist?("#{i}.mp4"))
     system("HandBrakeCLI --start-at duration:1 -i #{i} -e x264  -q 20.0 -r 29.97 --pfr  -a 1,1 -E faac,copy:ac3 -B 160,160 -6 dpl2,auto -R Auto,Auto -D 0.0,0.0 -f mp4 -4 -X 1280 --loose-anamorphic -m -o #{i}.mp4")
   end
end
