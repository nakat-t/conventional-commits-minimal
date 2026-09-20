# Conventional Commits Minimal 1.0.0-beta.2

[English](./README.md) | 日本語

## TL;DR

- **この規約を作った理由:** Conventional Commits の際限なく増える type のリス
  トと省略可能な scope は、コミットのたびに迷いを生みます。Conventional
  Commits Minimal は、この2つの迷いの原因を取り除き、コミットメッセージを素早
  く一貫性を持って書けるようにします。
- **できるだけ短く言うと変更内容は:** type を `feat`、`fix`、`chore` の3つに限
  定し、破壊的変更は任意の `!` で示し、scope は完全に廃止します。
- 準拠するメッセージはすべて
  [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)
  との互換性を保ちます。
- githooks 用の `commit-msg` [linter](./hooks/README.md) と、この仕様を AI
  コーディングエージェントに教える [Agent Skill](./skills/README.md) を含みま
  す。
- Agent Skill はメッセージに使う言語を設定できます。

## 概要

Conventional Commits Minimal は
[Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)
の厳格なサブセットです。Conventional Commits のうち日常のコミットで重要な部分を
残しつつ、コミットメッセージを書く際に迷いを生む部分を取り除いています。それは、
際限なく増える _type_ のリストと _省略可能な scope_ です。

Conventional Commits Minimal に準拠したメッセージはすべて Conventional Commits
1.0.0 にも準拠するため、既存の Conventional Commits パーサーやツールはそのまま
利用できます。

コミットメッセージは次のように構成します:

---

```
<type>[!]: <description>

[optional body]

[optional footer(s)]
```
---

コミットには、プロジェクトの利用者に意図を伝えるために、次の構造要素が含まれます:

1. **feat:** _type_ が `feat` のコミットは、プロジェクトの利用者から見える新しい
   機能を導入します(Semantic Versioning の [`MINOR`](http://semver.org/#summary)
   に対応します)。
1. **fix:** _type_ が `fix` のコミットは、プロジェクトの利用者から見える動作を
   修正します(Semantic Versioning の [`PATCH`](http://semver.org/#summary) に
   対応します)。
1. **chore:** _type_ が `chore` のコミットは、プロジェクトの利用者から見える
   動作を一切変更しません。ドキュメント、テスト、リファクタリング、フォーマッ
   ト、ビルドおよびCI構成、依存関係のメンテナンスはすべて `chore` です
   (Semantic Versioning における _バージョン変更なし_ に対応します)。
1. **!:** type の直後に `!` を付けたコミットは破壊的変更を導入します
   (Semantic Versioning の [`MAJOR`](http://semver.org/#summary) に対応しま
   す)。破壊的変更はどの _type_ のコミットにも含めることができます。
1. _footer_ は任意で記載でき、
   [git trailer format](https://git-scm.com/docs/git-interpret-trailers) に似た
   規約に従います。`BREAKING CHANGE:` フッターは破壊的変更の詳細を説明するため
   に使用できますが、`!` と併用する場合に限られます。

他の _type_ は許可されません。_scope_ も許可されません。

## 例

### 新機能を含むコミットメッセージ
```
feat: add --json flag to the export command
```

### バグ修正を含むコミットメッセージ
```
fix: prevent crash when the config file is empty
```

### 利用者から見えない変更を含むコミットメッセージ
```
chore: extract request parsing into its own module
```

### 破壊的変更に注意を促す `!` を含むコミットメッセージ
```
feat!: send an email to the customer when a product is shipped
```

### `!` と `BREAKING CHANGE` フッターの両方を含むコミットメッセージ
```
feat!: drop support for Node 6

BREAKING CHANGE: use JavaScript features not available in Node 6.
```

### 複数段落の本文と複数のフッターを含むコミットメッセージ
```
fix: prevent racing of requests

Introduce a request id and a reference to latest request. Dismiss
incoming responses other than from latest request.

Remove timeouts which were used to mitigate the racing issue but are
obsolete now.

Reviewed-by: Z
Refs: #123
```

## 仕様

この文書における "MUST"、"MUST NOT"、"REQUIRED"、"SHALL"、"SHALL NOT"、
"SHOULD"、"SHOULD NOT"、"RECOMMENDED"、"MAY"、"OPTIONAL" というキーワードは、
[RFC 2119](https://www.ietf.org/rfc/rfc2119.txt) に記載されている通りに解釈さ
れるものとします。

1. コミットには type を先頭に付けなければならず(MUST)、続けて OPTIONAL な
   `!`、そして REQUIRED な終端のコロンとスペースを付けなければなりません
   (MUST)。
1. type は `feat`、`fix`、`chore` のいずれか一つでなければならず(MUST)、
   小文字で記述しなければなりません(MUST)。他の type は許可されません。
1. `feat` という type は、コミットがプロジェクトの利用者から見える新しい機能を
   追加する場合に使用しなければなりません(MUST)。
1. `fix` という type は、コミットがプロジェクトの利用者から見える動作を修正す
   る場合に使用しなければなりません(MUST)。
1. `chore` という type は、コミットがプロジェクトの利用者から見える動作を一切
   変更しない場合に使用しなければなりません(MUST)。これにはドキュメント、
   テスト、リファクタリング、フォーマット、ビルド構成、CI構成、利用者から見
   える動作を変えない依存関係の更新が含まれますが、これらに限られません。
1. scope を指定してはなりません(MUST NOT)。type の直後の文字は `!` または
   `:` のいずれかでなければなりません(MUST)。
1. type/`!` プレフィックスの後のコロンとスペースの直後には description を続
   けなければなりません(MUST)。description はコード変更の簡潔な要約です。
   例: _fix: array parsing issue when multiple spaces were contained in
   string_。
1. 短い description の後に、コード変更に関する追加の文脈情報を提供する、より
   長いコミット本文を含めてもよい(MAY)。本文は description の後に1行の空行
   を挟んで開始しなければなりません(MUST)。
1. コミット本文は自由形式であり、任意の数の改行区切りの段落から構成してもよい
   (MAY)。
1. 本文の後に1行の空行を挟んで、1つ以上のフッターを含めてもよい(MAY)。各
   フッターは word token の後に `:<space>` または `<space>#` のいずれかの区切
   り文字、続けて文字列の値から構成しなければなりません(MUST)
   ([git trailer convention](https://git-scm.com/docs/git-interpret-trailers)
   に着想を得ています)。
1. フッターの token は空白文字の代わりに `-` を使用しなければなりません
   (MUST)。例: `Acked-by`(これによりフッター部分と複数段落の本文とを区別し
   やすくなります)。ただし `BREAKING CHANGE` は例外として token に使用しても
   よい(MAY)。
1. フッターの値には空白や改行を含めてもよく(MAY)、次の有効なフッターの
   token/区切り文字の組が現れた時点でパースを終了しなければなりません
   (MUST)。
1. 破壊的変更は、type プレフィックスの `:` の直前に `!` を付けることで示さな
   ければなりません(MUST)。例: `feat!: drop support for Node 6`。
1. 破壊的変更の詳細を説明するために `BREAKING CHANGE:` フッターを含めてもよい
   (MAY)。含める場合、type プレフィックスに `!` も含めなければなりません
   (MUST)。type プレフィックスに `!` を含まないコミットに
   `BREAKING CHANGE:` フッターを含めてはなりません(MUST NOT)。
1. `BREAKING CHANGE` はフッターの token として使用する場合、大文字でなければ
   なりません(MUST)。`BREAKING-CHANGE` は `BREAKING CHANGE` と同義でなけれ
   ばなりません(MUST)。
1. type は小文字でなければなりません(MUST)。description、本文、フッターの
   値には任意の大文字小文字を使用してもよい(MAY)。
1. コミットには1つの type の変更のみを含めるべきです(SHOULD)。複数の type
   を必要とする変更の集合は、複数のコミットに分割すべきです(SHOULD)。分割
   が現実的でない場合、Semantic Versioning への影響が最も大きい type を、
   `feat` > `fix` > `chore` の順で選択しなければなりません(MUST)。
1. Conventional Commits Minimal は Conventional Commits 1.0.0 のサブセットで
   す。Conventional Commits Minimal に準拠するコミットメッセージは、
   Conventional Commits 1.0.0 にも準拠しなければなりません(MUST)。

## Conventional Commits Minimal を使う理由

Conventional Commits は最も広く使われているコミットメッセージ規約ですが、その
2つの機能がほぼ全てのコミットで迷いを生みます:

* **際限のない type。** 仕様はどんな type も許可しています。`build`、`ci`、
  `docs`、`style`、`refactor`、`perf`、`test` といった推奨セットを使っても、
  なお隙間が残り、その隙間ごとに「新しい type を追加するか、しっくりこないカ
  テゴリに押し込むか」という判断を迫られます。時間が経つにつれ type の一覧は
  増え続け、その意味は貢献者間でずれていきます。
* **省略可能な scope。** scope をいつ追加すべきか、どう命名すべきかについての
  ガイドがありません。実際には、誰にもメンテナンスされない、計画性のない一貫
  性のない scope の集まりが生まれます。

Conventional Commits Minimal は、この2つの迷いの原因を両方とも取り除きます:

* type はちょうど3つで、メンテナが実際に知る必要のある Semantic Versioning の
  結果に1対1で対応します: `feat` → MINOR、`fix` → PATCH、`chore` → リリース
  なし。type を選ぶことは単一の問いになります:「この変更は利用者にとって何を
  意味するか?」
* scope は完全に取り除かれています。ほとんどのプロジェクトには scope は不要で
  あり、必要とするプロジェクトも、コミットの subject への場当たり的な括弧書き
  よりも専用のツールの方が適しています。

Conventional Commits Minimal は Conventional Commits 1.0.0 の厳格なサブセット
であるため、Conventional Commits 向けに構築されたあらゆるツール(自動バージョ
ニング、コミットリンター、構造化された履歴の探索)は変更なく機能し続けます。

## よくある質問

### ドキュメント、テスト、リファクタリング、CI変更にはどの type を使えばよいですか?

`chore` です。これらの変更はいずれも、プロジェクトの利用者が観測できる動作を
変えません。Conventional Commits Minimal で重要な違いは _どの種類のファイルが
変更されたか_ ではなく _利用者が気づくかどうか_ です。

### `chore` コミットがリリースを引き起こすことはありますか?

いいえ。`chore` コミットは Semantic Versioning に影響しません。`chore` と分類
しようとした変更が実際には利用者から見える動作を変えるのであれば、それは
`chore` ではなく `feat`、`fix`、または破壊的変更です。

### 依存関係を更新しました。これは `chore` ですか `fix` ですか?

それは仕組みではなく効果によります。更新が利用者から見える影響のない日常的な
メンテナンスであれば `chore` を使います。更新が利用者が気づき得るバグを修正す
るのであれば `fix` を使います。利用者から見える機能を追加するのであれば
`feat` を使います。互換性のない形で動作を変更するのであれば `!` を追加しま
す。

### パフォーマンス改善についてはどうですか?

利用者がその違いを観測できる場合(応答が速くなった、メモリ使用量が減った、以
前失敗していた処理が成功するようになった)は `fix` を使います。それ以外は
`chore` を使います。

### コミットタイトルの type は大文字ですか小文字ですか?

小文字のみです。`Feat:` や `FIX:` は無効です。

### コミットが複数のコミット type に該当する場合はどうすればよいですか?

可能な限り戻って複数のコミットに分けてください。分割が現実的でない場合は、
Semantic Versioning への影響が最も大きい type を選んでください: `fix` より
`feat`、`chore` より `fix` を優先します。

### モノレポで scope をまだ使えますか?

いいえ。scope は Conventional Commits Minimal の一部ではありません。プロジェ
クトにパッケージ単位の分類が必要な場合は、コミット subject の場当たり的な区分
ではなく、変更されたパスからツールで導出してください。

### `!` なしで `BREAKING CHANGE:` を使えますか?

いいえ。`!` は subject 行における破壊的変更の唯一の情報源であり、1行のログで
も常に見えるようになっています。`BREAKING CHANGE:` フッターは任意の追加詳細で
あり、`!` が存在する場合にのみ有効です。

### 既存の Conventional Commits ツールで動作しますか?

はい。Conventional Commits Minimal に準拠する全てのメッセージは、Conventional
Commits 1.0.0 のメッセージとしても有効です。commitlint、semantic-release、
release-please などのツールは、他の Conventional Commit と同様にこれをパース
し、`feat`、`fix`、`!` はいつも通りの意味を持ちます。

### 誤ったコミット type を使ってしまった場合はどうすればよいですか?

マージやリリースの前であれば、`git rebase -i` を使ってコミット履歴を編集する
ことを推奨します。リリース後の後始末は、使用しているツールやプロセスによって
異なります。

### すべての contributor が Conventional Commits Minimal を使う必要がありますか?

いいえ。Git で squash ベースのワークフローを使用している場合、リードメンテナ
はマージ時にコミットメッセージを整えることができ、カジュアルな contributor に
負担をかけません。

### 初期開発フェーズのコミットメッセージはどう扱うべきですか?

すでに製品をリリース済みであるかのように進めることを推奨します。通常、たとえ
それが仲間の開発者だけであっても、_誰か_ があなたのソフトウェアを使っていま
す。彼らは何が修正されたか、何が壊れるかを知りたいはずです。

## ツール

* [`hooks/`](./hooks/README.md) — この仕様に照らしてメッセージを検証する
  `commit-msg` フックで、POSIX `sh` と PowerShell のスクリプトとして提供され
  ます。
* [`skills/`](./skills/README.md) — この仕様に従ったコミットメッセージの書き
  方を AI コーディングエージェントに教える Agent Skill です。description と
  本文に使用する言語はリポジトリ単位で設定できます。

## ライセンス

[MIT](./LICENSE)
