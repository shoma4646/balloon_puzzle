# Balloon Puzzle - タスクリスト

## Phase 1: プロジェクトセットアップ

### 1.1 依存関係の追加
- [ ] `pubspec.yaml`に必要なパッケージを追加
  - flame
  - flame_forge2d
  - flutter_riverpod
  - shared_preferences
  - audioplayers
- [ ] `flutter pub get`を実行

### 1.2 プロジェクト構造の作成
- [ ] `lib/shared/`ディレクトリ作成
  - [ ] `constants/`
  - [ ] `theme/`
  - [ ] `utils/`
  - [ ] `widgets/`
- [ ] `lib/features/`ディレクトリ作成
  - [ ] `game/`
  - [ ] `stage_select/`
  - [ ] `result/`
  - [ ] `title/`
- [ ] `lib/models/`ディレクトリ作成
- [ ] `lib/providers/`ディレクトリ作成
- [ ] `lib/services/`ディレクトリ作成

### 1.3 基本設定ファイルの作成
- [ ] `lib/shared/constants/game_constants.dart`
- [ ] `lib/shared/constants/app_colors.dart`
- [ ] `lib/shared/theme/app_theme.dart`
- [ ] `lib/main.dart`の更新（Riverpod対応）

## Phase 2: ドメインモデルの定義

### 2.1 列挙型の定義
- [ ] `lib/models/balloon_type.dart`
  - 8種類の風船タイプ定義（Lv1〜Lv8）
  - 各タイプの色、サイズ、ポイント情報
- [ ] `lib/models/game_status.dart`
  - playing, paused, gameOver

### 2.2 データモデルの定義
- [ ] `lib/models/balloon_data.dart`
  - 風船の基本データモデル
- [ ] `lib/models/branch_config.dart`
  - 枝の配置設定モデル
- [ ] `lib/models/stage_data.dart`
  - ステージ設定モデル
- [ ] `lib/models/game_state.dart`
  - ゲーム状態モデル
- [ ] `lib/models/game_result.dart`
  - ゲーム結果モデル

## Phase 3: Flameゲームエンジンの基本実装

### 3.1 ゲームコンポーネントの基礎
- [ ] `lib/features/game/components/balloon_puzzle_game.dart`
  - FlameGameを継承したメインゲームクラス
  - Forge2Dの初期化
  - 物理世界の設定（重力を上向きに）

### 3.2 風船コンポーネント
- [ ] `lib/features/game/components/balloon_component.dart`
  - BodyComponentを継承
  - 円形の物理ボディ
  - 浮力の適用
  - 描画処理

### 3.3 枝コンポーネント
- [ ] `lib/features/game/components/branch_component.dart`
  - 静的な物理ボディ
  - 矩形の衝突判定
  - 描画処理

### 3.4 衝突処理
- [ ] `lib/features/game/components/collision_handler.dart`
  - 風船同士の衝突検知
  - 同種風船のマージ処理
  - Lv.8風船の消滅処理

## Phase 4: ゲームロジックの実装

### 4.1 風船生成システム
- [ ] `lib/services/balloon_spawn_service.dart`
  - タップ位置での風船生成
  - ランダムな風船タイプ生成
  - 次の風船プレビュー（3つ先まで）

### 4.2 物理演算の調整
- [ ] 浮力計算の実装
  - 風船サイズに応じた浮力
- [ ] 初速度の設定
  - 横方向にランダムな微小速度
- [ ] 空気抵抗のシミュレーション

### 4.3 マージ処理
- [ ] マージアニメーション
- [ ] 新しい風船の生成
- [ ] 古い風船の削除
- [ ] マージ音の再生

### 4.4 消滅処理
- [ ] Lv.8風船同士の接触検知
- [ ] 消滅アニメーション
- [ ] パーティクルエフェクト
- [ ] 消滅音の再生

## Phase 5: スコアリングシステム

### 5.1 スコア計算ロジック
- [ ] `lib/services/score_service.dart`
  - 基本ポイント計算（風船を離す）
  - マージボーナス計算
  - 消滅ボーナス計算

### 5.2 コンボシステム
- [ ] コンボタイマーの実装（5秒）
- [ ] コンボ倍率の計算（最大3.0倍）
- [ ] コンボリセット処理

### 5.3 時間管理
- [ ] 経過時間の計測
- [ ] タイマー表示

## Phase 6: ゲームオーバー処理

### 6.1 ゲームオーバー判定
- [ ] 画面上部の制限ライン設定
- [ ] 風船位置の監視
- [ ] 3秒間の猶予タイマー
- [ ] ゲームオーバー状態への遷移

## Phase 7: ステージシステム

### 7.1 ステージ設定の定義
- [ ] `lib/shared/constants/stage_configs.dart`
  - Stage 1: チュートリアル（枝1本）
  - Stage 2: 基本（枝2本）
  - Stage 3: 中級（枝3本）
  - Stage 4: 上級（枝4本）
  - Stage 5: エキスパート（枝5本）

### 7.2 ステージ読み込み
- [ ] ステージデータからの枝配置
- [ ] ステージ固有パラメータの適用

## Phase 8: 状態管理（Riverpod）

### 8.1 ゲーム状態プロバイダー
- [ ] `lib/providers/game_state_provider.dart`
  - スコア管理
  - コンボ管理
  - 経過時間管理
  - ゲームステータス管理
  - 風船リスト管理

### 8.2 ステージプロバイダー
- [ ] `lib/providers/stage_provider.dart`
  - 現在のステージ管理
  - ステージ一覧取得
  - ハイスコア管理

### 8.3 設定プロバイダー
- [ ] `lib/providers/settings_provider.dart`
  - 音量設定
  - その他の設定

## Phase 9: UI実装

### 9.1 タイトル画面
- [ ] `lib/features/title/title_screen.dart`
  - タイトルロゴ
  - STARTボタン
  - 設定ボタン

### 9.2 ステージ選択画面
- [ ] `lib/features/stage_select/stage_select_screen.dart`
- [ ] `lib/features/stage_select/widgets/stage_card.dart`
  - ステージカードウィジェット
  - ステージ番号表示
  - ハイスコア表示
  - 難易度表示

### 9.3 ゲーム画面
- [ ] `lib/features/game/game_screen.dart`
- [ ] `lib/features/game/widgets/game_canvas_widget.dart`
  - Flameゲームを表示するGameWidget
- [ ] `lib/features/game/widgets/game_hud.dart`
  - スコア表示
  - コンボ表示
  - 時間表示
  - 一時停止ボタン
- [ ] `lib/features/game/widgets/balloon_preview_widget.dart`
  - 次の風船プレビュー（3つ）
- [ ] `lib/features/game/widgets/tap_area_widget.dart`
  - タップ可能エリアの表示
  - タップ処理

### 9.4 リザルト画面
- [ ] `lib/features/result/result_screen.dart`
- [ ] 最終スコア表示
- [ ] プレイ時間表示
- [ ] 最高コンボ数表示
- [ ] マージ回数表示
- [ ] 新記録の表示（ハイスコア更新時）
- [ ] リトライボタン
- [ ] ステージ選択に戻るボタン

### 9.5 一時停止画面
- [ ] `lib/features/game/widgets/pause_dialog.dart`
  - 再開ボタン
  - リトライボタン
  - ステージ選択に戻るボタン

## Phase 10: データ永続化

### 10.1 ローカルストレージサービス
- [ ] `lib/services/storage_service.dart`
  - shared_preferencesのラッパー
  - キーの定数化

### 10.2 ハイスコア管理
- [ ] ステージ別ハイスコアの保存
- [ ] ハイスコアの読み込み
- [ ] ハイスコア更新判定

### 10.3 設定の永続化
- [ ] 音量設定の保存・読み込み
- [ ] チュートリアル完了フラグ

## Phase 11: サウンドシステム

### 11.1 サウンドサービス
- [ ] `lib/services/audio_service.dart`
  - audioplayersの初期化
  - 効果音再生メソッド
  - BGM再生メソッド
  - 音量調整

### 11.2 サウンドアセットの準備
- [ ] `assets/sounds/`ディレクトリ作成
- [ ] 効果音ファイルの配置
  - spawn.mp3（風船を離す音）
  - merge.mp3（マージ音）
  - pop.mp3（消滅音）
  - game_over.mp3（ゲームオーバー音）
- [ ] BGMファイルの配置
  - bgm_game.mp3

### 11.3 サウンドの統合
- [ ] 風船生成時の効果音
- [ ] マージ時の効果音
- [ ] 消滅時の効果音
- [ ] ゲームオーバー時の効果音
- [ ] BGMのループ再生

## Phase 12: エフェクトの実装

### 12.1 パーティクルエフェクト
- [ ] `lib/features/game/components/particle_component.dart`
- [ ] マージ時のパーティクル
- [ ] 消滅時のパーティクル

### 12.2 アニメーション
- [ ] 風船スポーンアニメーション（フェードイン）
- [ ] マージ時のスケールアニメーション
- [ ] 消滅時のフェードアウトアニメーション

## Phase 13: チュートリアル

### 13.1 チュートリアルシステム
- [ ] `lib/features/tutorial/tutorial_overlay.dart`
  - ゲームルール説明
  - 操作方法説明
  - 吹き出しやガイドの表示

### 13.2 初回起動時の処理
- [ ] チュートリアル完了フラグの確認
- [ ] 未完了時にチュートリアル表示

## Phase 14: バランス調整

### 14.1 パラメータ調整
- [ ] 風船のサイズ調整
- [ ] 浮力の強さ調整
- [ ] 空気抵抗の調整
- [ ] スコアバランスの調整
- [ ] コンボタイマーの調整（5秒が適切か検証）

### 14.2 ステージバランス
- [ ] 各ステージの難易度確認
- [ ] 枝の配置の最適化

## Phase 15: テスト

### 15.1 単体テスト
- [ ] `test/models/`配下のテスト
- [ ] `test/services/score_service_test.dart`
  - スコア計算のテスト
  - コンボ倍率のテスト
- [ ] `test/services/balloon_spawn_service_test.dart`

### 15.2 ウィジェットテスト
- [ ] タイトル画面のテスト
- [ ] ステージ選択画面のテスト
- [ ] リザルト画面のテスト

### 15.3 パフォーマンステスト
- [ ] 60FPS維持の確認
- [ ] メモリ使用量の確認
- [ ] 風船50個同時表示時の動作確認

## Phase 16: 最終調整

### 16.1 UI/UXの最終調整
- [ ] レスポンシブ対応の確認
- [ ] タッチ操作の最適化
- [ ] アニメーションの滑らかさ確認
- [ ] フォントサイズの調整

### 16.2 バグ修正
- [ ] 既知のバグの修正
- [ ] エッジケースのテスト

### 16.3 パフォーマンス最適化
- [ ] 不要なリビルドの削減
- [ ] メモリリークの確認

## Phase 17: リリース準備

### 17.1 アセットの準備
- [ ] アプリアイコンの作成
- [ ] スプラッシュ画面の作成
- [ ] ストア用スクリーンショットの作成

### 17.2 ドキュメント
- [ ] README.md更新
- [ ] プレイガイドの作成

### 17.3 ビルド設定
- [ ] Android向けビルド設定
- [ ] iOS向けビルド設定
- [ ] バージョン番号の設定

## 完了条件チェックリスト

- [ ] すべてのステージがプレイ可能
- [ ] 風船のマージが正しく動作
- [ ] Lv.8風船の消滅が正しく動作
- [ ] スコアリングが正しく計算される
- [ ] コンボシステムが正しく動作
- [ ] ゲームオーバー判定が正しく動作
- [ ] ハイスコアが保存・表示される
- [ ] サウンドが再生される
- [ ] 60FPSで動作する
- [ ] すべての画面遷移が正常
- [ ] 設定が永続化される
- [ ] バグがない状態
