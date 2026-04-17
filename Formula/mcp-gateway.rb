class McpGateway < Formula
  desc "MCP 统一网关 - 连接多个 MCP 服务器的统一网关"
  homepage "https://github.com/lpreterite/mcp-gateway"
  version "v1.1.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.1.1/mcp-gateway-darwin-arm64"
      sha256 "b171b286b06dcc065672f128bf50e80c099365891e98318fc6d0ef20d872bd02"
    else
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.1.1/mcp-gateway-darwin-amd64"
      sha256 "b89834f1f624f9213e9ec570bb1ea51edbf4fab9ffbab32a6b480bcf1607d45e"
    end
  end

  def install
    on_macos do
      if Hardware::CPU.arm?
        bin.install "mcp-gateway-darwin-arm64" => "mcp-gateway"
      else
        bin.install "mcp-gateway-darwin-amd64" => "mcp-gateway"
      end
    end

    # 生成示例配置文件
    (etc/"mcp-gateway").mkpath
    (etc/"mcp-gateway/config.json").write <<~JSON
      {
        "gateway": {
          "host": "0.0.0.0",
          "port": 4298,
          "cors": true
        },
        "pool": {
          "minConnections": 1,
          "maxConnections": 5,
          "acquireTimeout": 5000,
          "idleTimeout": 30000
        },
        "servers": [
          {
            "name": "example",
            "type": "local",
            "command": ["echo", "hello"],
            "enabled": true,
            "poolSize": 1
          }
        ],
        "mapping": {}
      }
    JSON
  end

  def post_install
    ohai "MCP Gateway 安装完成！"
    ohai ""
    ohai "配置文件: #{etc}/mcp-gateway/config.json"
    ohai "日志文件: #{var}/log/mcp-gateway.log"
    ohai ""
    ohai "⚠️  重要提示："
    ohai "1. brew services 暂不支持此 formula"
    ohai "2. 推荐使用 launchd 脚本管理服务（自动解决 PATH 环境变量问题）"
    ohai ""
    ohai "📥 获取 launchd 安装脚本："
    ohai "   curl -fsSL https://github.com/lpreterite/mcp-gateway/releases/download/#{version}/install-launchd.sh -o install-launchd.sh"
    ohai "   chmod +x install-launchd.sh"
    ohai ""
    ohai "🚀 安装并启动服务："
    ohai "   ./install-launchd.sh install"
    ohai ""
    ohai "📋 常用命令："
    ohai "   ./install-launchd.sh status    # 检查服务状态"
    ohai "   ./install-launchd.sh logs      # 查看日志"
    ohai "   ./install-launchd.sh restart   # 重启服务"
    ohai "   ./install-launchd.sh uninstall # 卸载服务"
    ohai ""
    ohai "📖 完整文档："
    ohai "   https://github.com/lpreterite/mcp-gateway/blob/main/docs/brew-installation-issues.md"
    ohai ""
    ohai "请编辑 #{etc}/mcp-gateway/config.json 添加你的 MCP 服务器"
    ohai ""
    ohai "🔧 配置注意事项："
    ohai "- 使用完整路径（如 /Users/you/.nvm/versions/node/v22.21.0/bin/npx）"
    ohai "- 不支持 type='remote'，必须使用 type='local'"
  end

  test do
    assert_match /version/, shell_output("#{bin}/mcp-gateway --version")
    assert_match /mcp-gateway/, shell_output("#{bin}/mcp-gateway --help")
  end
end
