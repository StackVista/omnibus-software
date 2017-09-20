#
# Copyright:: Copyright (c) 2013-2014 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "python"

if ohai["platform"] != "windows"
  default_version "2.7.13"

  dependency "ncurses"
  dependency "zlib"
  dependency "openssl"
  dependency "bzip2"
  dependency "libsqlite3"

  source :url => "http://python.org/ftp/python/#{version}/Python-#{version}.tgz",
         :sha256 => "a4f05a0720ce0fd92626f0278b6b433eee9a6173ddf2bced7957dfb599a5ece1"

  relative_path "Python-#{version}"

  env = {
    "CFLAGS" => "-I#{install_dir}/embedded/include -O2 -g -pipe",
    "LDFLAGS" => "-Wl,-rpath,#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib",
  }

  python_configure = ["./configure",
                      "--enable-universalsdk=/",
                      "--prefix=#{install_dir}/embedded"]

  if ohai["platform_family"] == "mac_os_x"
    python_configure.push("--enable-ipv6",
                          "--with-universal-archs=intel",
                          "--enable-shared")
  end

  python_configure.push("--with-dbmliborder=")

  build do
    ship_license "PSFL"
    patch :source => "python-2.7.11-avoid-allocating-thunks-in-ctypes.patch" if linux?
    patch :source => "python-2.7.11-fix-platform-ubuntu.diff" if linux?
    patch :source => "python-2.7.13-fix-ssl-leak.patch"

    command python_configure.join(" "), :env => env
    command "make -j #{workers}", :env => env
    command "make install", :env => env
    delete "#{install_dir}/embedded/lib/python2.7/test"

    # There exists no configure flag to tell Python to not compile readline support :(
    block do
      FileUtils.rm_f(Dir.glob("#{install_dir}/embedded/lib/python2.7/lib-dynload/readline.*"))
    end
  end

else
  # 2.7.13 has a mem leak that we can patch on Unix but not on Windows (since we don't build from source on Windows)
  default_version "2.7.12"

  dependency "vc_redist"
  dependency "vc_python"

  msi_name = "python-#{version}.amd64.msi"
  source :url => "https://www.python.org/ftp/python/#{version}/python-#{version}.amd64.msi",
         :sha256 => "909fded3cca65feaf9e1db943e886586eb27f0f4396c977868ad6489063a3912"

  build do
    # In case Python is already installed on the build machine well... let's uninstall it
    # (fortunately we're building in a VM :) )
    command "start /wait msiexec /x #{msi_name} /L uninstallation_logs.txt ADDLOCAL=DefaultFeature /qn"

    mkdir "#{windows_safe_path(install_dir)}\\embedded"

    # Installs Python with all the components we need (pip..) under C:\python-omnibus
    command "start /wait msiexec /i #{msi_name} TARGETDIR="\
            "\"#{windows_safe_path(install_dir)}\\embedded\" /L uninstallation_logs.txt "\
            "ADDLOCAL=DefaultFeature  /qn"

    command "SETX PYTHONPATH \"#{windows_safe_path(install_dir)}\\embedded\""
  end
end
