class McpWarden < Formula
  desc "Stdio proxy that sanitizes untrusted MCP server output before an agent reads it"
  homepage "https://github.com/AncientiCe/mcp-warden"
  license any_of: ["MIT", "Apache-2.0"]

  # The release workflow in AncientiCe/mcp-warden opens a PR here with the real
  # per-platform URLs and sha256 checksums for every tagged release. Until the
  # first release PR merges, `brew install` fails with a checksum mismatch.

  on_macos do
    on_arm do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.1/mcp-warden-0.3.1-aarch64-apple-darwin.tar.gz"
      sha256 "3f75aa09737f9d4871e4bb4d38118e20e9836309615ca7b16273aa042b5a173c"
    end

    on_intel do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.1/mcp-warden-0.3.1-x86_64-apple-darwin.tar.gz"
      sha256 "2259d8f9dbb7792e8183852b230a7000389f7e4c5d64918471c2435bcb9081db"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.1/mcp-warden-0.3.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "94a95dfd4081c20f2b01410dedf8468be9b3426cd7b3800ce9d6688c892cb1c7"
    end

    on_intel do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.1/mcp-warden-0.3.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "146847b49fcd527d7ca806b354e139c7872d75a9e12945b12316a599a9cf3661"
    end
  end

  def install
    # Homebrew auto-extracts and may strip a single top-level directory.
    if File.exist?("mcp-warden")
      bin.install "mcp-warden"
    else
      cd Dir["mcp-warden-*"].first do
        bin.install "mcp-warden"
      end
    end
  end

  def caveats
    <<~EOS
      Wrap the stdio servers in an MCP client configuration (a backup is written first):
        mcp-warden wrap <path/to/mcp-config.json>

      Or wrap a single server by hand:
        mcp-warden --server-id github -- github-mcp-server stdio

      Restart the MCP client afterwards. For more information:
        https://github.com/AncientiCe/mcp-warden
    EOS
  end

  test do
    assert_match "mcp-warden #{version}", shell_output("#{bin}/mcp-warden --version")
    assert_equal "plain text\n", pipe_output("#{bin}/mcp-warden scan", "plain text\n")
  end
end
