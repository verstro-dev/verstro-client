// Verstro 编译期功能开关
//
// 集中存放"对上游 FlClash 行为做裁剪"的常量, 让上游文件里的改动收敛成
// 单个 `if (kVerstroXxx)` 判断 —— 上游 rebase 时只需对齐这一行, 不必重读逻辑.
//
// 为什么用 const 而非 Riverpod Provider:
//   - 这些是产品形态决定的固定行为, 不需要运行时切换 (用户无权打开手动导入).
//   - const 让 Dart 编译器在 release build 里直接死代码消除被裁剪的分支,
//     零运行时开销, 也不需要 WidgetRef/Consumer 改造上游 StatelessWidget.

/// 隐藏 FlClash 原生的"手动添加/导入订阅"入口 (profiles 页 + 按钮 → URL/文件/扫码).
///
/// 阶段 2.3.5: Verstro 订阅由 application.dart `_verstroAutoIntegrate()` 自动 import,
/// 用户手动导入会引入非托管 profile / 破坏自动刷新, 故全部隐藏.
///
/// 仍**保留**的能力 (只读/不破坏托管订阅): profile 列表展示 / 切换 / 手动刷新订阅
/// (sync) / 预览 / 导出 / 连接按钮. 见 docs phase-2.3.5.
const kVerstroHideManualImport = true;
