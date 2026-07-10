class Vcpe < Formula
  desc "Podman-based vCPE lab orchestration"
  homepage "https://github.com/gdcs-dev/vcpe"
  url "https://github.com/gdcs-dev/vcpe/archive/refs/heads/development.tar.gz"
  version "development"
  sha256 "27bf4ce2f8234bb1b378c1de1dab97aa3344d09d37216ab589fcd9c6a460f079"
  license "MIT"
  head "https://github.com/gdcs-dev/vcpe.git", branch: "development"

  depends_on "go" => :build
  depends_on "podman"
  depends_on "podman-compose"

  def install
    cd "controlplane" do
      system "go", "build",
             "-ldflags", "-s -w",
             "-o", bin/"vcpe",
             "./cmd/vcpe"
    end
    pkgshare.install "manifests"
    pkgshare.install "services"
  end

  def caveats
    <<~EOS
      Run `podman machine init` and `podman machine start` on macOS before using vcpe.

      Deployment manifests are installed to:
        \#{pkgshare}/manifests/

      To see available manifests:
        vcpe manifest list

      Apply a deployment:
        vcpe apply --manifest <name>    # by name
        vcpe apply                      # auto-select when only one manifest exists

      This formula tracks the development branch. The sha256 is a point-in-time
      snapshot; run scripts/sync-homebrew-vcpe after significant pushes to update it.
      Use `brew install --HEAD vcpe` to always install the latest development branch.
    EOS
  end

  test do
    assert_match "vcpe", shell_output("\#{bin}/vcpe --help")
  end
end
