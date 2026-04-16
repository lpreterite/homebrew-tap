class McpGateway < Formula
  desc "MCP 统一网关 - 连接多个 MCP 服务器的统一网关"
  homepage "https://github.com/lpreterite/mcp-gateway"
  version "v1.0.0"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.0/mcp-gateway-darwin-arm64"
      sha256 "7e7c00c858d1fad4952bfa7dcf59a397b2cef8f7966de148858d81985c328f7b"
    else
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.0/mcp-gateway-darwin-amd64"
      sha256 "c4dccbf6125fab3529a9cdd773653f2f6ea19c9b4c13eb6cba85909fba7ac764"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.0/mcp-gateway-linux-arm64"
      sha256 "1e2d2eb70cebb74078c48e46b8f33eab43c6104aa6d77b9318282e533bba7346"
    else
      url "https://github.com/lpreterite/mcp-gateway/releases/download/v1.0.0/mcp-gateway-linux-amd64"
      sha256 "8e177868b245290e5484825429adc599cc838d0c1870ff36805c44cf70dc7967"
    end
  end

  def install
    if OS.mac?
      if Hardware::CPU.arm?
        bin.install "mcp-gateway-darwin-arm64" => "mcp-gateway"
      else
        bin.install "mcp-gateway-darwin-amd64" => "mcp-gateway"
      end
    else
      if Hardware::CPU.arm?
        bin.install "mcp-gateway-linux-arm64" => "mcp-gateway"
      else
        bin.install "mcp-gateway-linux-amd64" => "mcp-gateway"
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
          "maxConnections": 5
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
    ohai "请编辑 #{etc}/mcp-gateway/config.json 添加你的 MCP 服务器"
    ohai ""
    ohai "启动服务: brew services start #{name}"
    ohai "停止服务: brew services stop #{name}"
    ohai "查看日志: tail -f #{var}/log/mcp-gateway.log"
  end

  service do
    run opt_bin/"mcp-gateway"
    args "--config", etc/"mcp-gateway/config.json"
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path "#{var}/log/mcp-gateway.log"
    error_log_path "#{var}/log/mcp-gateway.err.log"
  end

  test do
    system "#{bin}/mcp-gateway", "--version"
  end
end
