name "defusedxml"
default_version "0.5.0"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/tiran/defusedxml/master/LICENSE"
  build_env = {
    "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}",
    "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
    "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include/",
  }
  pip "install defusedxml==#{version}", :env => build_env
end
