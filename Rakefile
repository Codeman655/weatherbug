task :default => [:install]

desc "Installs weatherbug to /usr/local/bin"
task :install  => 'weatherbug.rb' do
  sh "cp weatherbug.rb /usr/local/bin/weatherbug"
end
  
desc "Removes weatherbug from /usr/local/bin"
task :uninstall => '/usr/local/bin/weatherbug' do 
  sh "rm /usr/local/bin/weatherbug"
end
