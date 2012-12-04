path = ARGV[0]
authors = "/c/author_mapping.txt"
authors = ARGV[1] unless ARGV[1].nil?
svn_repo = ARGV[2]
description = "Legacy"
path += "/" if !path.end_with? "/"
orig = Dir.pwd
require_existing_dir = true
if File.directory?path
  projects = Dir.glob(path + "*")
  puts "Passed in directory: #{path}"
else
  projects = File.open(path).readlines
  require_existing_dir = false
  puts "Passed in file #{path}"
end
projects.each do |d|
  puts "Starting with #{d}"
  Dir.chdir orig  if Dir.pwd != orig
  if !File.directory?d 
    puts "Not a valid directory"
    next if require_existing_dir
    Dir.mkdir(d)
  end
  dirs = d.split("/")
  project = dirs[dirs.length-1]
  repo = svn_repo
  if repo.nil?
    repo = dirs[dirs.length-2]
  end
    
  puts "#{repo} -> #{project}"
  puts
  if File.exists?project
    Dir.chdir project
    puts "git svn fetch --authors-file=\"#{authors}\""
    system "git svn fetch --authors-file=\"#{authors}\""
  else
    puts "git svn clone \"svn://localhost/#{repo}/#{project}\" --authors-file=\"#{authors}\" \"#{project}\""
    system "git svn clone \"svn://localhost/#{repo}/#{project}\" --authors-file=\"#{authors}\" \"#{project}\""
    Dir.chdir project
  end

  remote = "Y:\\#{project}"
  if !File.exist? remote
    puts "Creating directory #{remote}"
    Dir.mkdir remote
    puts "Running git init"
    Dir.chdir remote
    system("git init --bare")
    current_description = repo if description.nil?
    File.open("description", "w+") { |f| f.write(current_description) }
    Dir.chdir orig
    Dir.chdir project
  end
  puts "Adding origin as code.oda.vcu.edu"
  puts "system git remote add origin \"https://code.oda.vcu.edu/git/#{project}\""
  system "git remote add origin \"https://code.oda.vcu.edu/git/#{project}\""
  
  puts "Pushing to master"
  puts "system git push --set-upstream origin master"
  system "git push --set-upstream origin master"
  
  puts
end

# Add some submodule repos, like 'trunk' to store everything?

# mkdir trunk
# git init --bare
# foreach project
# git submodule add https://origin/project project
# don't forget to make sure spaces are replaced with %20 in the url string but wrapped in quotes on the destination (actually just leave out the destination argument on projects without any spaces or weird characters
# git add 
# git commit -m "Added submodules"
# mkdir \\empanda-test\C$\repos\trunk (or Y:\\trunk)
# git remote add origin https://.../git/whatever
# git push --set-upstream origin master
