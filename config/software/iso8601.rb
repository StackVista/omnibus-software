name "iso8601"
default_version "=0.1.11"

dependency "python"
dependency "pip"

build do
  license "https://url.to.my/LICENSE.txt"
  command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
end