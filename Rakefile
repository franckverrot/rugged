# stolen largely from defunkt/mustache
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/extensiontask'

Rake::ExtensionTask.new('rugged') do |r|
  r.lib_dir = 'lib/rugged'
end

#
# Helpers
#

def command?(command)
  system("type #{command} > /dev/null")
end


#
# Tests
#

task :default => :test

desc "Run tests"
task :turn do
  suffix = "-n #{ENV['TEST']}" if ENV['TEST']
  sh "turn test/*_test.rb #{suffix}"
end

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

if command? :kicker
  desc "Launch Kicker (like autotest)"
  task :kicker do
    puts "Kicking... (ctrl+c to cancel)"
    exec "kicker -e rake test lib"
  end
end

desc "Update the libgit2 SHA"
task :libgit do
  sha = `git --git-dir=../libgit2/.git rev-parse HEAD`
  File.open("LIBGIT2_VERSION", 'w') do |f|
    f.puts "# git --git-dir=../libgit2/.git rev-parse HEAD"
    f.puts sha
  end
end


#
# Ron
#

if command? :ronn
  desc "Show the manual"
  task :man => "man:build" do
    exec "man man/mustache.1"
  end

  desc "Build the manual"
  task "man:build" do
    sh "ronn -br5 --organization=SCHACON --manual='Rugged Manual' man/*.ron"
  end
end


#
# Gems
#

begin
  require 'mg'
  MG.new("rugged.gemspec")

  desc "Push a new version to Gemcutter and publish docs."
  task :publish => "gem:publish" do
    require File.dirname(__FILE__) + '/lib/mustache/version'

    system "git tag v#{Rugged::Version}"
    sh "git push origin master --tags"
    sh "git clean -fd"
    exec "rake pages"
  end
rescue LoadError
  warn "mg not available."
  warn "Install it with: gem i mg"
end

#
# Documentation
#

desc "Publish to GitHub Pages"
task :pages => [ "man:build" ] do
  Dir['man/*.html'].each do |f|
    cp f, File.basename(f).sub('.html', '.newhtml')
  end

  `git commit -am 'generated manual'`
  `git checkout site`

  Dir['*.newhtml'].each do |f|
    mv f, f.sub('.newhtml', '.html')
  end

  `git add .`
  `git commit -m updated`
  `git push site site:master`
  `git checkout master`
  puts :done
end
