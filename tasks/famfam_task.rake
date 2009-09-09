require 'open-uri'

namespace :famfam do
  version = "1.3"
  
  task :download do
    unless File.exist?("#{RAILS_ROOT}/public/icons")
      zip_name = "icons.zip"
      Dir.chdir("#{RAILS_ROOT}/vendor") do
        url = "http://extjsinaction.com/icons/icons.zip"
        puts "Downloading FamFam silk #{version} icons with extra companion set"
        open(zip_name, 'w').write(open(url).read)
        done = false
        while !done
          sleep 1
          done = File.exists?(zip_name) && File.size(zip_name) > (2.megabytes + 100.kilobytes) 
        end  
        puts "Donwload complete! "
      end
    end # unless
  end # task

  task :unzip do
    unless File.exist?("#{RAILS_ROOT}/public/icons")
      zip_name = "icons.zip"    
      unzipped_folder_name = "ext-#{version}"
      Dir.chdir("#{RAILS_ROOT}/vendor") do
        system "mkdir famfam" unless File.exists?("famfam")
        system "mv #{zip_name} famfam/" if File.exists?(zip_name)
        Dir.chdir("famfam") do
          system "unzip #{zip_name}"
        end
        # system "rm #{zip_name}"        
      end
    end # unless
  end # task
  
  task :install do    
    public_dir = "#{RAILS_ROOT}/public/"  
    css_target_dir = File.join(public_dir, "stylesheets", "famfam")    
    icons_target_dir = File.join(public_dir, "icons/famfam")    
    Dir.chdir("#{RAILS_ROOT}/public") do      
      # FileUtils.mkdir(icons_target_dir) unless File.exists?(icons_target_dir)
      system "mkdir icons" unless File.exists?("icons")            
      Dir.chdir("#{RAILS_ROOT}/public/icons") do            
        system "mkdir famfam" unless File.exists?("famfam")                    
      end
      system "mkdir stylesheets/famfam" unless File.exists?("stylesheets/famfam")            
      # FileUtils.mkdir(css_target_dir) unless File.exists?(css_target_dir)
    end
    
    Dir.chdir("#{RAILS_ROOT}/vendor/famfam") do
      # always copy core (in root of ext)
      puts "Installing famfam css" 
      files = Dir.glob("*.css")
      files.each do |file|
        FileUtils.copy(file, css_target_dir)    
      end 
      puts "Done!"

      # copy icons
      puts "Installing famfam icons" 
      Dir.chdir("icons") do      
        files = Dir.glob("*.png") + Dir.glob("*.gif")      
        files.each do |file|
          FileUtils.copy(file, icons_target_dir)    
        end
      end
      puts "Done!"      
    end        
  end
  
  # task :reinstall => [:environment, :clean, :install]
  # task :reinstall_compact => [:environment, :clean, :install_compact]
end
