name "flex"
default_version "2.6.0"

relative_path "flex-#{version}"

source :url => "https://downloads.sourceforge.net/project/flex/flex-#{version}.tar.gz",
       :md5 => "afd33cb888461aae3bfd05b80c9e42a8"

env = with_standard_compiler_flags()

build do
  command "./configure --prefix=#{install_dir}/embedded", :env => env
  command "make -j #{workers}", :env => env
  command "make -j #{workers} install", :env => env
end
