## なに？

Jupyterを立ち上げsshできるイメージ。  
想定する環境は作業PCとは別のサーバーなど外部リソース上。

`/root/pyproject`が作業ディレクトリこの直下にpoetryのプロジェクトを作成。  
作成したプロジェクトの中の`ipykernel`入りの`.venv`仮想環境に反応して自動的に
jupyter kernelに.venvをプロジェクト名で追加し再起動する。

sshできるようにしたのはリモートに建てたときにvscodeで入れるようにしたかったため。  
docker.sockをlocalforwardする方法もあるが別途sshを繋ぐのが面倒だったのでやっていない。

sshは鍵認証only事前に公開鍵をマウントする。

`/root`ディレクトリを丸ごとマウントするのでjupyterなどの設定はコンテナの中に入って変えられる。

## 使い方

```
docker-compose up -d
```

## develにした