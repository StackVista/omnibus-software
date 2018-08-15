name "requests"
default_version "2.19.1"

dependency "python"
dependency "pip"
dependency "pyopenssl"

build do
  ship_license "https://raw.githubusercontent.com/kennethreitz/requests/master/LICENSE"
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version}"
end
