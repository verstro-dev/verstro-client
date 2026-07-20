//go:build windows && !cgo

package main

import (
	"fmt"
	"io"
	"net"
	"strconv"

	"github.com/Microsoft/go-winio"
)

// Verstro fix: 桌面侧 (lib/core/service.dart) 已统一改用 socket + 长度帧通信,
// Windows 传来的是本地 TCP 端口号 (ServerSocket.bind 127.0.0.1, 传 serverSocket.port),
// 不再是命名管道路径。历史 dial 只走 winio.DialPipe → 把端口号当管道名 open 失败
// (panic: open <port>: The system cannot find the file specified) → 核心启动即崩,
// 表现为 Windows 上无节点 / 永远"连接中"。
// 与 dial_socket.go 对齐: 纯数字 → 连 127.0.0.1:<port> 的 TCP; 否则回退命名管道。
func dial(arg string) (io.ReadWriteCloser, error) {
	if _, err := strconv.Atoi(arg); err == nil {
		return net.Dial("tcp", fmt.Sprintf("127.0.0.1:%s", arg))
	}
	return winio.DialPipe(arg, nil)
}
