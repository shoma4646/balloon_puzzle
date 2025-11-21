# Balloon Puzzle プロジェクトガイドライン

## プロジェクト概要

**説明**: 風船パズルゲーム - 上昇する風船をマージして高得点を目指すFlutterゲーム
**プラットフォーム**: Android, iOS, Web, Linux, macOS, Windows
**Dart SDK**: >=3.4.3 <4.0.0
**Flutter**: 3.24.0

---

## 言語設定

- **すべてのレビューとフィードバックは日本語で行う**
- コードレビュー、提案、説明はすべて日本語で記述する
- コミットメッセージの説明も日本語で行う

---

## ディレクトリ構造

```
balloon_puzzle/
├── lib/
│   ├── main.dart                    # アプリエントリーポイント
│   ├── features/                    # 機能モジュール
│   │   ├── game/
│   │   │   ├── components/          # Flameゲームコンポーネント
│   │   │   │   ├── balloon_puzzle_game.dart  # メインゲームクラス
│   │   │   │   ├── balloon_component.dart    # 風船物理ボディ
│   │   │   │   ├── branch_component.dart     # 木の枝（衝突オブジェクト）
│   │   │   │   └── ...
│   │   │   ├── game_screen.dart     # ゲーム画面
│   │   │   └── widgets/             # ゲームUI部品
│   │   ├── stage_select/            # ステージ選択機能
│   │   └── title/                   # タイトル画面
│   ├── models/                      # データモデル
│   │   ├── balloon_type.dart        # 風船タイプ（Lv.1-8）
│   │   ├── game_state.dart          # ゲーム状態
│   │   └── stage_data.dart          # ステージ設定
│   ├── providers/                   # Riverpod状態管理
│   │   ├── game_state_provider.dart # ゲーム状態プロバイダー
│   │   └── stage_provider.dart      # ステージプロバイダー
│   ├── services/
│   │   └── storage_service.dart     # ローカルストレージ
│   └── shared/
│       ├── constants/               # 定数
│       │   ├── app_colors.dart      # カラーパレット
│       │   ├── game_constants.dart  # ゲームバランス定数
│       │   └── stage_configs.dart   # ステージ定義
│       └── theme/
│           └── app_theme.dart       # Material 3テーマ
├── test/                            # テストファイル
├── assets/                          # アセット（画像、音声）
├── .github/workflows/               # CI/CD設定
└── .claude/
    └── CLAUDE.md                    # このファイル
```

---

## 技術スタック

### コアフレームワーク
- **Flutter** - クロスプラットフォームUIフレームワーク
- **Dart** - プログラミング言語

### 状態管理
- **flutter_riverpod** - リアクティブ状態管理
- **riverpod_generator** - コード生成

### ゲームエンジン
- **flame** - 2Dゲームエンジン
- **flame_forge2d** - 物理エンジン統合

### データ永続化
- **shared_preferences** - ローカルストレージ

---

## アーキテクチャパターン

### 状態管理
- `@riverpod`アノテーションによるコード生成を使用
- `.g.dart`ファイルは`build_runner`で自動生成
- 主要プロバイダー:
  - `GameStateNotifier`: ゲームロジック用の可変状態
  - `StorageService`: 永続化サービス
  - `stageList` / `stage`: ステージデータの非同期プロバイダー

### ゲームアーキテクチャ
- `BalloonPuzzleGame`: `Forge2DGame`を継承
- 物理ベース: Forge2Dによる衝突検出と物理演算
- コンポーネントシステム: Flameの`BodyComponent`

### 機能構造
- 機能ベースの整理（features/）
- モデル、プロバイダー、サービスの分離
- 再利用可能なウィジェット

---

## 開発ワークフロー

### セットアップ
```bash
# 依存関係の取得
flutter pub get

# コード生成の実行
flutter pub run build_runner build
```

### 実行コマンド
```bash
# 開発モードで実行
flutter run

# Web用ビルド
flutter build web --release --base-href "/balloon_puzzle/"

# 各プラットフォーム用ビルド
flutter build apk      # Android
flutter build ios      # iOS
flutter build linux    # Linux
flutter build windows  # Windows
```

### テスト
```bash
flutter test
```

### コード生成
プロバイダーを変更した後は必ず実行:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## CI/CD

### GitHub Pagesデプロイ (deploy.yml)
- トリガー: `main`ブランチへのプッシュまたは手動実行
- 自動デプロイ先: `gh-pages`ブランチ

### Claude Code統合
- **claude.yml**: イシュー/PRでの@claudeメンション対応
- **claude-code-review.yml**: PR自動レビュー

---

## ゲームメカニクス

### 風船タイプ (8レベル)
- Lv.1〜Lv.8まで進化
- `BalloonType.random()`はLv.1〜5のみ生成
- 同レベルの風船がマージで次レベルに進化

### スコアリング
- 基本リリースポイント: レベル × 10点
- マージボーナス: レベル × 50点
- Lv.8ポップボーナス: 1000点
- コンボ倍率: 1.0x〜3.0x（5秒以内にマージ継続）

### ステージ (5段階)
- Stage 1 (Tutorial): 枝1本
- Stage 2 (Basic): 枝2本
- Stage 3 (Intermediate): 枝3本
- Stage 4 (Advanced): 枝4本
- Stage 5 (Expert): 枝5本

### ゲームオーバー条件
- 風船が画面上部98%ラインに0.5秒以上滞在

---

## 主要ファイルリファレンス

| ファイル | 説明 |
|---------|------|
| `lib/main.dart` | アプリエントリーポイント |
| `lib/features/game/components/balloon_puzzle_game.dart` | メインゲームクラス |
| `lib/models/game_state.dart` | ゲーム状態モデル |
| `lib/providers/game_state_provider.dart` | 状態管理プロバイダー |
| `lib/shared/constants/game_constants.dart` | ゲームバランス定数 |
| `pubspec.yaml` | 依存関係設定 |

---

## コミットメッセージルール

すべてのコミットメッセージは以下の形式に従う：

- プレフィックスは英語、説明は日本語
- 使用可能なプレフィックス：
  - `feature:` - 新機能追加
  - `fix:` - バグ修正
  - `chore:` - ビルドプロセス、依存関係の更新など
  - `docs:` - ドキュメントのみの変更
  - `refactor:` - リファクタリング
  - `test:` - テストの追加・修正
  - `style:` - コードフォーマットなど
  - `perf:` - パフォーマンス改善

例：`feature: GitHub Pagesへの自動デプロイを追加`

---

## コードスタイル

- Dartの標準フォーマッターを使用
- コメントは日本語で記述
- ドキュメントコメント（///）も日本語で記述
- flutter_lintsルールに従う

---

## カラーパレット

### 風船カラー (8色)
- Lv.1: 赤 (#FF6B6B)
- Lv.2: オレンジ (#FFB347)
- Lv.3: 黄 (#FFE66D)
- Lv.4: 黄緑 (#B4F8C8)
- Lv.5: 緑 (#6BCF7F)
- Lv.6: シアン (#7DD3FC)
- Lv.7: 青 (#5B8DEF)
- Lv.8: 紫 (#B983FF)

### UIカラー
- 背景（空）: #87CEEB
- プライマリ: #4CAF50
- セカンダリ: #2196F3
- アクセント: #FF9800

---

## 注意事項

### プロバイダー変更時
`.dart`ファイルでプロバイダーを変更した場合、対応する`.g.dart`ファイルを再生成する必要があります。

### パフォーマンス
- `BalloonType`の`Random`インスタンスは静的に保持
- 最大風船数: 50
- ターゲットFPS: 60

### 将来の機能
- オーディオシステム（audioplayers）は準備済み（現在コメントアウト）
