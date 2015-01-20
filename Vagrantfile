Vagrant.configure("2") do |config|

                config.vm.provider "docker" do |master|
                
                master.image   = "induhub/demo"
                master.name    = "demo"
               
                
end
config.vm.synced_folder "./" , "/usr/share/nginx/www"
end