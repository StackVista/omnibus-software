name "jmxfetch"

if windows?
  default_version "0.16.0"
else
  jmx_version = ENV["JMX_VERSION"]
  if jmx_version.nil? || jmx_version.empty?
    raise "Please specify a JMX_VERSION env variable to build."
  else
    default_version jmx_version
  end
end

version "0.15.0" do
  source sha256: "f735057a6e2d3cc15a0be82a1223127f73afb5857ffcf3a6d154d5c5df198ed9"
end

version "0.16.0" do
  source sha256: "f54da452af2fc5fd14a6e12281342d5ee337f70a0cb72a79dc6c62aa562cccd4"
end

source url: "https://s3-eu-west-1.amazonaws.com/sts-jmxfetch/jmxfetch-#{version}-jar-with-dependencies.jar",
       target_filename: "jmxfetch-#{version}-jar-with-dependencies.jar"

relative_path "jmxfetch"

build do
  ship_license "https://raw.githubusercontent.com/DataDog/jmxfetch/master/LICENSE"
  mkdir "#{install_dir}/agent/checks/libs"
  copy "jmxfetch-*-jar-with-dependencies.jar", "#{install_dir}/agent/checks/libs"
end
