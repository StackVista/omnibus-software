name "pyvmomi"
default_version "6.0.0"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/vmware/pyvmomi/master/LICENSE.txt"
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version}"
end
