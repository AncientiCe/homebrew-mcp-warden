class McpWarden < Formula
  desc "Stdio proxy that sanitizes untrusted MCP server output before an agent reads it"
  homepage "https://github.com/AncientiCe/mcp-warden"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.4.1/mcp-warden-0.4.1-aarch64-apple-darwin.tar.gz"
      sha256 "00f3f752ca938c0a07ca873b6fe403b5bcf214568085eb8456223cd46bd52a16"
    end

    on_intel do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.4.1/mcp-warden-0.4.1-x86_64-apple-darwin.tar.gz"
      sha256 "44982d85bb5df7520d133c3a46933fdcd3edb21ac035a185f9f13e99477bca00"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.4.1/mcp-warden-0.4.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "38fd5dcd3803a0ad0fdb2153d142b2a8db2250e91d56772de9eda5020b51d534"
    end

    on_intel do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.4.1/mcp-warden-0.4.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9959ce19a6c5504cba2a0f1f72fa1e8eeee602731137bd9cc5d18412072c8c98"
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
