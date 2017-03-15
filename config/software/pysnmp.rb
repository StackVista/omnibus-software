name "pysnmp"
default_version "4.2.5"

dependency "python"
dependency "pip"
dependency "pyasn1"

build do
  ship_license "https://gist.githubusercontent.com/remh/519324dc1b69f7488239/raw/2bbf2888194fef8ae75651e551b61f90cb49c482/pysnmp.license"
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "#{name}==#{version}"
end
