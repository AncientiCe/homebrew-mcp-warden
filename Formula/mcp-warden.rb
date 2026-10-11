class McpWarden < Formula
  desc "Stdio proxy that sanitizes untrusted MCP server output before an agent reads it"
  homepage "https://github.com/AncientiCe/mcp-warden"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.4/mcp-warden-0.3.4-aarch64-apple-darwin.tar.gz"
      sha256 "35a883b2f1d0e9c6b5ae9275ebd910fc5f73b74505a5793231b130fd6c3109b2"
    end

    on_intel do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.4/mcp-warden-0.3.4-x86_64-apple-darwin.tar.gz"
      sha256 "0994d7e77d0c37e936c6bb5dd4c9a9177dcaa545d4da1207e34af34d04c1bdcd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.4/mcp-warden-0.3.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "87401a2a07c49e12d6e8a2f493d9d096081323ee51ec6eadc0d919ec30211fe6"
    end

    on_intel do
      url "https://github.com/AncientiCe/mcp-warden/releases/download/v0.3.4/mcp-warden-0.3.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b84b781ea20d5385d14dd8ca6262ba9c23df351f85f65804b35c8a5542919edc"
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
