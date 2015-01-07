source "https://supermarket.chef.io"

Dir.glob('/home/ec2-user/cookbooks/*').each do |path|
    cookbook File.basename(path), :path => path
end

