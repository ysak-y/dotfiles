# React Testing Library 非同期パターンガイド

## クエリの種類と使い分け

| プレフィックス | 戻り値 | 要素がない場合 | 要素が複数ある場合 | 非同期 |
|--------------|--------|--------------|------------------|--------|
| getBy | 要素 | エラー | エラー | No |
| queryBy | 要素/null | null | エラー | No |
| findBy | Promise<要素> | エラー | エラー | Yes |
| getAllBy | 配列 | エラー | 配列 | No |
| queryAllBy | 配列 | [] | 配列 | No |
| findAllBy | Promise<配列> | エラー | 配列 | Yes |

## findBy: 非同期要素の取得

### 基本的な使用法

```typescript
// API レスポンス後に表示される要素を待つ
const successMessage = await screen.findByText('Data saved successfully');

// オプションでタイムアウトを指定 (デフォルト: 1000ms)
const element = await screen.findByRole('button',
  { name: 'Submit' },
  { timeout: 3000 }
);
```

### findBy vs getBy + waitFor

```typescript
// 悪い例: 冗長
await waitFor(() => {
  expect(screen.getByText('Loading complete')).toBeInTheDocument();
});

// 良い例: findBy は内部で waitFor を使用
const element = await screen.findByText('Loading complete');
expect(element).toBeInTheDocument();
```

## waitFor: 状態変更の待機

### 適切な使用

```typescript
// 複数の状態変更を待つ
await waitFor(() => {
  expect(mockFn).toHaveBeenCalledTimes(2);
  expect(screen.getByText('Updated')).toBeInTheDocument();
});

// DOM 以外の副作用を待つ
await waitFor(() => {
  expect(localStorage.getItem('token')).toBe('abc123');
});
```

### 避けるべきパターン

```typescript
// 悪い例 1: waitFor 内で副作用
await waitFor(() => {
  fireEvent.click(button); // 副作用は外で
  expect(result).toBeInTheDocument();
});

// 良い例
fireEvent.click(button);
await waitFor(() => {
  expect(result).toBeInTheDocument();
});

// 悪い例 2: 単一要素に waitFor
await waitFor(() => {
  screen.getByText('Hello');
});

// 良い例
await screen.findByText('Hello');

// 悪い例 3: 空の waitFor
await waitFor(() => {}); // 何も待たない

// 悪い例 4: waitFor のネスト
await waitFor(async () => {
  await waitFor(() => {
    // ...
  });
});
```

## waitForElementToBeRemoved: 要素の消失を待つ

```typescript
// ローディングインジケーターが消えるのを待つ
await waitForElementToBeRemoved(() => screen.queryByText('Loading...'));

// または getBy で (要素が存在する場合)
await waitForElementToBeRemoved(screen.getByRole('progressbar'));
```

## タイマーとの組み合わせ

### Jest の fake timers

```typescript
beforeEach(() => {
  jest.useFakeTimers();
});

afterEach(() => {
  jest.useRealTimers();
});

test('debounced search', async () => {
  const user = userEvent.setup({ advanceTimers: jest.advanceTimersByTime });

  render(<SearchInput />);

  await user.type(screen.getByRole('textbox'), 'react');

  // デバウンスを進める
  act(() => {
    jest.advanceTimersByTime(500);
  });

  await screen.findByText('Search results for: react');
});
```

### Vitest の fake timers

```typescript
import { vi } from 'vitest';

beforeEach(() => {
  vi.useFakeTimers();
});

afterEach(() => {
  vi.useRealTimers();
});

test('delayed notification', async () => {
  const user = userEvent.setup({ advanceTimers: vi.advanceTimersByTime });

  render(<Notification />);

  await user.click(screen.getByRole('button', { name: 'Show' }));

  act(() => {
    vi.advanceTimersByTime(3000);
  });

  expect(screen.queryByRole('alert')).not.toBeInTheDocument();
});
```

## デバッグのヒント

### screen.debug()

```typescript
// 現在の DOM を出力
screen.debug();

// 特定の要素のみ
screen.debug(screen.getByRole('form'));

// 出力サイズの制限を解除
screen.debug(undefined, Infinity);
```

### logRoles

```typescript
import { logRoles } from '@testing-library/dom';

const { container } = render(<MyComponent />);
logRoles(container); // アクセシブルなロールを一覧表示
```

## 参考リンク

- [Testing Library - Async Methods](https://testing-library.com/docs/dom-testing-library/api-async/)
- [Common mistakes with React Testing Library](https://kentcdodds.com/blog/common-mistakes-with-react-testing-library)
