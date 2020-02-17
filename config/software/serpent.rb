name "serpent"
default_version "1.28"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/irmen/Serpent/master/LICENSE"
  pip "install --install-option=\"--install-scripts="\
      "#{windows_safe_path(install_dir)}/bin\" "\
      "serpent==#{version}"
end
