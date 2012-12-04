require 'arg_parser.rb'

class SvnToGit


  def initialize(local_path, repo=nil, project=nil, svn_url=nil, author_file=nil, remote_origin=nil)
    @local_path = local_path
    @repo = repo
    @repo = local_path.split("/").last if @repo.nil?
    @svn_url = svn_url
    @author_file = author_file
    @remote_origin = remote_origin
    @project = project
    Dir.chdir @local_path if !@local_path.nil?
    Dir.mkdir "git.tmp" if !File.exists?"git.tmp"
    Dir.chdir "git.tmp"
    @origin = Dir.pwd
  end

  def create_project_directory(project)
    if !File.exists?project
      Dir.mkdir project
    end
  end

  def clone_or_fetch(project)
    create_project_directory project
    Dir.chdir project
    if File.exists? ".git"
      do_svn_fetch
      Dir.chdir ".."
    else
      Dir.chdir ".."
      do_svn_clone project
    end
  end

  def do_svn_fetch
    system "git svn fetch --authors-file=\"#{@author_file}\""
  end

  def do_svn_clone(project)
    system "git svn clone #{@svn_url}/#{@repo}/#{project} #{project} --authors-file=\"#{@author_file}\""
  end

  def convert(repo=@repo, project=@project)
    clone_or_fetch project

    remote_dir = "Y:\\#{project}"
    if !File.exist? remote_dir
      puts "Creating directory #{remote_dir}"
      Dir.mkdir remote_dir
      puts "Running git init"
      Dir.chdir remote_dir
      system("git init --bare")
      File.open("description", "w+") { |f| f.write(repo) }
      Dir.chdir orig
      Dir.chdir project
    end
    puts "Adding origin"
    system "git remote add origin \"#{@remote_origin}/#{project}\""

    puts "Pushing to master"
    puts "system git push --set-upstream origin master"
    system "git push --set-upstream origin master"
    
    puts
  end

  def convert_all
    Dir.glob(@local_path + "*") do |d|
      puts d
      project = d.split("/").last
      puts "#{@repo} -> #{project}"
      puts
      convert @repo, project
    end    
    Dir.chdir @local_path
    Dir.rmdir "git.tmp"
  end

end

if ARGV[0].nil?
  puts "Usage: ruby convert.rb {repo} {project} [dir=/path/to/svn/local/repo] [s=svn url] [a=author_mapping] [r=remoteorigin]"
  puts "This tool will allow you to convert a single subversion repository with many projects into individual git repos. One repository per subversion directory/project"
end


args = ArgParser.parse(ARGV)

repo = ARGV[0]
project = ARGV[1]

if !args[:dir].nil?
  path = args[:dir]
  path += "/" if !path.end_with? "/"
end

authors = "/c/author_mapping.txt"
authors = args[:a] unless args[:a].nil?
remote = args[:r] unless args[:r].nil?
svn = "svn://localhost"
svn = args[:s] unless args[:s].nil?


if path.nil?
  s = SvnToGit.new(nil, repo, project, svn, authors, remote)
  s.convert
else
  s = SvnToGit.new(path, repo, nil, svn, authors, remote)
end

#s.convert

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
