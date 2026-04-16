class McpGateway < Formula
  desc "MCP 统一网关 - 连接多个 MCP 服务器的统一网关"
  homepage "https://github.com/lpreterite/mcp-gateway"
  version "v1.0.0"

  depends_on "go" => :build

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.0/mcp-gateway-darwin-arm64"
      sha256 "978b7559d84e41c5b858aacd05572a0ad7009fd2ff5550c8522140a86e706ab1"
    else
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.0/mcp-gateway-darwin-amd64"
      sha256 "4e0fced2ac8a3484f6ffe0cd19ef067ba4c09cd17c5b649c83dbf8b9fca296fa"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.0/mcp-gateway-linux-arm64"
      sha256 "2a63b0502b58e4319140a15fcd031ae9138764529a4a21f48408cb80e6b580db"
    else
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.0/mcp-gateway-linux-amd64"
      sha256 "aaaf5e1c528babda9803cf5a7344951c9ed6eeacf78aeab75eeb876f07f08a29"
    end
  end

  def install
    bin.install "mcp-gateway"
  end

  test do
    system "#{bin}/mcp-gateway", "--version"
  end
end
