# React Testing Library よくある間違いと修正方法

## 1. getByTestId の過剰使用

### 問題

```typescript
// 悪い例
render(<button data-testid="submit-btn">Submit</button>);
const button = screen.getByTestId('submit-btn');
```

### 修正

```typescript
// 良い例
render(<button>Submit</button>);
const button = screen.getByRole('button', { name: 'Submit' });
```

### 理由

`getByTestId` はアクセシビリティを検証しません。`getByRole` を使うことで、スクリーンリーダーユーザーも同じ方法で要素を見つけられることを保証できます。

---

## 2. fireEvent の使用

### 問題

```typescript
// 悪い例
fireEvent.change(input, { target: { value: 'hello' } });
fireEvent.click(button);
```

### 修正

```typescript
// 良い例
const user = userEvent.setup();
await user.type(input, 'hello');
await user.click(button);
```

### 理由

`fireEvent` は単純に DOM イベントをディスパッチするだけですが、`userEvent` は実際のユーザー操作をシミュレートします。例えば `type` は各文字に対して keyDown, keyPress, keyUp イベントを発火します。

---

## 3. 不要な act() ラップ

### 問題

```typescript
// 悪い例
await act(async () => {
  render(<MyComponent />);
});

await act(async () => {
  await user.click(button);
});
```

### 修正

```typescript
// 良い例 - render と userEvent は既に act でラップ済み
render(<MyComponent />);
await user.click(button);
```

### 理由

RTL の `render` と `userEvent` は内部で `act()` を使用しています。二重ラップは不要であり、コードを複雑にします。

### act() が必要なケース

```typescript
// タイマーの手動進行
act(() => {
  jest.advanceTimersByTime(1000);
});

// RTL 外での状態更新
act(() => {
  store.dispatch(someAction());
});
```

---

## 4. waitFor の誤用

### 問題 1: findBy で代替可能

```typescript
// 悪い例
await waitFor(() => {
  expect(screen.getByText('Success')).toBeInTheDocument();
});
```

### 修正

```typescript
// 良い例
expect(await screen.findByText('Success')).toBeInTheDocument();
```

### 問題 2: waitFor 内での副作用

```typescript
// 悪い例
await waitFor(() => {
  fireEvent.click(button);
  expect(result).toBeVisible();
});
```

### 修正

```typescript
// 良い例
await user.click(button);
await waitFor(() => {
  expect(result).toBeVisible();
});
```

---

## 5. queryBy の誤用

### 問題

```typescript
// 悪い例 - 要素が存在するはずなのに queryBy
const button = screen.queryByRole('button');
expect(button).toBeInTheDocument();
```

### 修正

```typescript
// 良い例 - 存在するはずなら getBy
const button = screen.getByRole('button');
expect(button).toBeInTheDocument();

// queryBy は「存在しないこと」の確認に使う
expect(screen.queryByText('Error')).not.toBeInTheDocument();
```

### 理由

`queryBy` は要素が見つからない場合に `null` を返します。要素が存在するべき場合は `getBy` を使い、見つからなければ即座にエラーにすべきです。

---

## 6. 実装詳細のテスト

### 問題

```typescript
// 悪い例 - 内部状態をテスト
const { result } = renderHook(() => useCounter());
expect(result.current.count).toBe(0);

// 悪い例 - CSS クラスをテスト
expect(button).toHaveClass('btn-primary');

// 悪い例 - コンポーネントインスタンスをテスト
expect(wrapper.instance().state.isOpen).toBe(true);
```

### 修正

```typescript
// 良い例 - ユーザーが見えるものをテスト
render(<Counter />);
expect(screen.getByText('Count: 0')).toBeInTheDocument();

await user.click(screen.getByRole('button', { name: 'Increment' }));
expect(screen.getByText('Count: 1')).toBeInTheDocument();
```

### 理由

内部実装の詳細をテストすると、リファクタリング時にテストが壊れやすくなります。ユーザーの視点から見える動作をテストしましょう。

---

## 7. cleanup の手動呼び出し

### 問題

```typescript
// 悪い例
afterEach(() => {
  cleanup();
});
```

### 修正

```typescript
// 良い例 - 自動的に cleanup される
// (Jest/Vitest + @testing-library/react の場合、afterEach に自動登録)
```

### 理由

Testing Library は自動的に cleanup を行います。手動呼び出しは冗長です。

---

## 8. 非同期テストの async/await 忘れ

### 問題

```typescript
// 悪い例 - await 忘れ
test('shows success message', () => {
  render(<Form />);
  user.click(screen.getByRole('button', { name: 'Submit' }));
  screen.findByText('Success'); // Promise が無視される
});
```

### 修正

```typescript
// 良い例
test('shows success message', async () => {
  const user = userEvent.setup();
  render(<Form />);
  await user.click(screen.getByRole('button', { name: 'Submit' }));
  expect(await screen.findByText('Success')).toBeInTheDocument();
});
```

---

## 9. screen の不使用

### 問題

```typescript
// 悪い例 - render から直接クエリ
const { getByRole } = render(<MyComponent />);
const button = getByRole('button');
```

### 修正

```typescript
// 良い例 - screen を使用
render(<MyComponent />);
const button = screen.getByRole('button');
```

### 理由

`screen` を使うことで、どの render からのクエリかを気にせず、一貫したパターンでコードを書けます。また、screen.debug() も使いやすくなります。

---

## 10. within の見落とし

### 問題

```typescript
// 悪い例 - ページ全体から検索 (曖昧になりがち)
render(<ProductList products={products} />);
const price = screen.getByText('$99');
```

### 修正

```typescript
// 良い例 - 特定のコンテナ内で検索
render(<ProductList products={products} />);
const productCard = screen.getByRole('article', { name: 'iPhone' });
const price = within(productCard).getByText('$99');
```

---

## 参考リンク

- [Common mistakes with React Testing Library](https://kentcdodds.com/blog/common-mistakes-with-react-testing-library)
- [Testing Library - Cheatsheet](https://testing-library.com/docs/react-testing-library/cheatsheet/)
- [Fix the "not wrapped in act(...)" warning](https://kentcdodds.com/blog/fix-the-not-wrapped-in-act-warning)
