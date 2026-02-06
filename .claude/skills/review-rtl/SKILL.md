---
name: review-rtl
description: |
  React Testing Library のベストプラクティスに基づいてテストコードをレビューします。
  使用タイミング:
  - RTL テストコードのレビュー依頼
  - テストの品質改善
  - "rtl review", "テストレビュー", "testing library レビュー" などのキーワード
  - `.test.tsx`, `.test.ts`, `.spec.tsx`, `.spec.ts` ファイルの品質確認
argument-hint: [test-file-path]
---

# React Testing Library テストコードレビュー

指定されたテストファイル `$ARGUMENTS` を以下の観点でレビューしてください。

## レビュー観点

### 1. クエリ選択 (Query Priority)

優先度の高い順にクエリを使用しているか確認:

| 優先度 | クエリ | 用途 |
|-------|--------|------|
| 1 (最優先) | `getByRole` | アクセシビリティツリーに公開されるすべての要素 |
| 2 | `getByLabelText` | フォームフィールド |
| 3 | `getByPlaceholderText` | ラベルがない場合のフォームフィールド |
| 4 | `getByText` | フォーム以外のテキストコンテンツ |
| 5 | `getByDisplayValue` | フォームの現在値 |
| 6 (セマンティック) | `getByAltText` | 画像の alt 属性 |
| 7 (セマンティック) | `getByTitle` | title 属性 |
| 8 (最終手段) | `getByTestId` | 他の方法で取得できない場合のみ |

**問題パターン:**
- `getByTestId` の過剰使用 → `getByRole` / `getByText` への置き換えを提案
- `container.querySelector` の使用 → RTL クエリへの置き換えを提案

### 2. 非同期処理 (Async Patterns)

**正しいパターン:**
```typescript
// findBy - 非同期で要素を待つ
const element = await screen.findByRole('button', { name: 'Submit' });

// waitFor - 状態変更を待つ
await waitFor(() => {
  expect(screen.getByText('Success')).toBeInTheDocument();
});
```

**問題パターン:**
- `getBy` + `waitFor` の組み合わせ → `findBy` への統合を提案
- 不要な `await waitFor` のネスト
- `waitFor` 内での副作用 (クリック等)

### 3. userEvent vs fireEvent

**推奨: userEvent**
```typescript
const user = userEvent.setup();
await user.click(button);
await user.type(input, 'text');
```

**非推奨: fireEvent**
```typescript
// fireEvent は dispatchEvent のラッパーに過ぎず、
// 実際のユーザー操作をシミュレートしない
fireEvent.click(button);  // 避けるべき
fireEvent.change(input, { target: { value: 'text' } });  // 避けるべき
```

### 4. act() の使用

**不要なケース (問題):**
- RTL の render, userEvent は既に act() でラップ済み
- 明示的な `act()` は通常不要

**必要なケース:**
- RTL 外部でのステート更新 (タイマー、手動 Promise 解決など)

### 5. アクセシビリティの考慮

**確認項目:**
- `getByRole` での `name` オプション使用
- フォームのラベル関連付け (`getByLabelText` が機能するか)
- 適切な ARIA 属性の存在

### 6. テストの可読性・保守性

**確認項目:**
- テスト名が期待される動作を明確に説明しているか
- Arrange-Act-Assert パターンの遵守
- 1 テストにつき 1 アサーション (または関連するアサーションのみ)
- マジックナンバー・マジックストリングの回避
- テストデータの意図が明確か

## 出力形式

レビュー結果は以下の形式で出力してください:

### 概要
テスト全体の品質サマリー (良い点、改善が必要な点)

### 問題点

各問題について以下の形式で報告:

#### [カテゴリ名] (例: クエリ選択)

**ファイル:** `path/to/file.test.tsx`
**行番号:** L42-45
**問題:**
```typescript
// 現在のコード
const button = screen.getByTestId('submit-button');
```
**推奨:**
```typescript
// 改善後
const button = screen.getByRole('button', { name: 'Submit' });
```
**理由:** `getByTestId` はセマンティックではなく、アクセシビリティツリーを活用していません。
**参考:** [Testing Library - About Queries](https://testing-library.com/docs/queries/about/)

### ベストプラクティス達成度

| カテゴリ | スコア | コメント |
|---------|--------|----------|
| クエリ選択 | ⭐⭐⭐☆☆ | getByTestId が 3 箇所で使用 |
| 非同期処理 | ⭐⭐⭐⭐⭐ | 適切に findBy を使用 |
| userEvent | ⭐⭐☆☆☆ | fireEvent が主に使用されている |
| act() 使用 | ⭐⭐⭐⭐⭐ | 不要な act() なし |
| アクセシビリティ | ⭐⭐⭐⭐☆ | name オプション推奨 |
| 可読性 | ⭐⭐⭐⭐☆ | テスト名は明確 |

## 詳細リファレンス

より詳細な情報が必要な場合は以下を参照:
- クエリ優先度の詳細: [references/query-priority.md](references/query-priority.md)
- 非同期パターンの詳細: [references/async-patterns.md](references/async-patterns.md)
- よくある間違いと修正方法: [references/common-mistakes.md](references/common-mistakes.md)
