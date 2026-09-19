enum ApplicationFirstFrameAction { attach, wait, exit }

enum ApplicationDisposeCleanup { selfAndCore, selfCoreAndExit }

/// 首帧还没有 navigator 时等待下一帧，不要 exit(0)。
ApplicationFirstFrameAction planApplicationFirstFrame({
  required bool hasNavigator,
}) {
  return hasNavigator
      ? ApplicationFirstFrameAction.attach
      : ApplicationFirstFrameAction.wait;
}

/// Application 可能被订阅门禁卸载；dispose 只清理自身与 core。
ApplicationDisposeCleanup planApplicationDispose() {
  return ApplicationDisposeCleanup.selfAndCore;
}
