# React Testing Library クエリ優先度ガイド

## 優先度 1: アクセシビリティ重視のクエリ

### getByRole

最も推奨されるクエリ。アクセシビリティツリーに公開されるすべての要素を取得できます。

```typescript
// ボタン
screen.getByRole('button', { name: 'Submit' });
screen.getByRole('button', { name: /submit/i }); // 正規表現も可

// リンク
screen.getByRole('link', { name: 'Home' });

// 見出し
screen.getByRole('heading', { level: 1 }); // h1
screen.getByRole('heading', { name: 'Welcome' });

// フォーム要素
screen.getByRole('textbox', { name: 'Email' });
screen.getByRole('checkbox', { name: 'Remember me' });
screen.getByRole('combobox', { name: 'Country' }); // select

// リスト
screen.getByRole('list');
screen.getByRole('listitem');

// 領域
screen.getByRole('navigation');
screen.getByRole('main');
screen.getByRole('banner'); // header
screen.getByRole('contentinfo'); // footer
```

**name オプションの重要性:**
```typescript
// 悪い例: 複数のボタンがあると曖昧
screen.getByRole('button');

// 良い例: accessible name で特定
screen.getByRole('button', { name: 'Submit' });
```

### getByLabelText

フォームフィールドに最適。ユーザーがラベルテキストで要素を見つける動作をエミュレート。

```typescript
// for/id 関連付け
// <label for="email">Email</label><input id="email" />
screen.getByLabelText('Email');

// aria-label
// <input aria-label="Search" />
screen.getByLabelText('Search');

// aria-labelledby
// <span id="billing">Billing</span><input aria-labelledby="billing" />
screen.getByLabelText('Billing');

// ラップするラベル
// <label>Username <input /></label>
screen.getByLabelText('Username');
```

### getByPlaceholderText

ラベルがない場合のフォールバック (ラベルがある方がアクセシブル)。

```typescript
screen.getByPlaceholderText('Enter your email');
```

### getByText

非フォームのテキストコンテンツ。

```typescript
screen.getByText('Welcome back!');
screen.getByText(/welcome/i); // 正規表現 (大文字小文字無視)
```

### getByDisplayValue

フォームの現在値で検索。

```typescript
// <input value="john@example.com" />
screen.getByDisplayValue('john@example.com');

// <select><option selected>Japan</option></select>
screen.getByDisplayValue('Japan');
```

## 優先度 2: セマンティッククエリ

### getByAltText

画像やカスタム要素の alt 属性。

```typescript
screen.getByAltText('Company logo');
```

### getByTitle

title 属性 (ツールチップ)。スクリーンリーダーでの読み上げが一貫しないため、補助的な使用に。

```typescript
screen.getByTitle('Close');
```

## 優先度 3: テスト ID (最終手段)

### getByTestId

他の方法で取得できない場合のみ使用。

```typescript
// <div data-testid="custom-element">Content</div>
screen.getByTestId('custom-element');
```

**使用が許容されるケース:**
- 動的テキストで安定した識別子がない
- 視覚的に区別できない複数の同一要素
- サードパーティコンポーネントでセマンティックアクセスが困難

**避けるべきケース:**
- ボタン、リンク、入力フィールドなどの標準要素
- 明確なテキストやラベルがある要素

## container.querySelector を避ける理由

```typescript
// 悪い例
const { container } = render(<MyComponent />);
const button = container.querySelector('.submit-btn');

// 問題点:
// 1. 実装詳細 (CSS クラス) に依存
// 2. アクセシビリティを検証しない
// 3. リファクタリングで壊れやすい

// 良い例
screen.getByRole('button', { name: 'Submit' });
```

## 参考リンク

- [Testing Library - About Queries](https://testing-library.com/docs/queries/about/)
- [Testing Library - Priority](https://testing-library.com/docs/queries/about/#priority)
- [Which query should I use?](https://testing-library.com/docs/queries/about/#types-of-queries)
