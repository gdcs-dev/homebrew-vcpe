class Vcpe < Formula
  desc "Podman-based vCPE lab orchestration"
  homepage "https://github.com/gdcs-dev/vcpe"
  url "https://github.com/gdcs-dev/vcpe/archive/refs/heads/main.tar.gz"
  version "main"
  sha256 "d5f745809dde6a5436995e8b31757829e87592c3975e932b93aa5c078e6d5242"
  license "MIT"
  head "https://github.com/gdcs-dev/vcpe.git", branch: "main"

  depends_on "podman"
  depends_on "podman-compose"
  depends_on "python@3"

  def install
    libexec.install Dir["*"]

    env = { "VCPE_INSTALL_ROOT" => libexec }
    %w[vcpe bng client mv1 routerd webpa xb10 net homebrew-tap].each do |script_name|
      (bin/script_name).write_env_script libexec/"scripts/#{script_name}", env
    end
  end

  def caveats
    <<~EOS
      Run `podman machine init` and `podman machine start` on macOS before using vcpe.
      Then initialize the user config with:

        vcpe init

      The default deployment profile starts bng-7, webpa, and mv1-7.
      This formula currently tracks the main branch. Replace the branch tarball
      with a tagged release URL and fixed sha256 once release artifacts exist.
    EOS
  end

  test do
    output = shell_output("#{bin}/vcpe init")
    assert_match "VCPE_PROFILE=default", output
  end
end
