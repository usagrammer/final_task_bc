window.addEventListener("DOMContentLoaded", () => {
  // 商品出品・編集のフォームを取得
  const itemForm = document.querySelector('.items-sell-main');
  // 商品出品・編集のフォームがないなら実行せずここで終了
  if (!itemForm) return null;
  console.log('preview.js');

  // 画像のfile_field
  const fileField = document.querySelector('input[type="file"][name="item[image]"]')

  // 画像のfile_fieldの内容が変化（新しく選択、もしくは消える）したら発火するイベント
  fileField.addEventListener("change", (e) => {
    console.log('changed:', e.target);
    console.table(e.target.files);
    console.log('1つ目のfile:', e.target.files[0]);
    
    const previewArea = document.querySelector('.preview');
    if (previewArea){
      previewArea.remove();
    }

    const file = e.target.files[0];
    // 選択されたファイルはblobという形式でブラウザが所持している
    const blob = window.URL.createObjectURL(file);
    console.log('blob:', blob);

    // プレビュー画像の親要素を生成
    const previewWrapper = document.createElement('div');
    previewWrapper.setAttribute('class', 'preview');

    // プレビュー画像のimg要素を生成
    const previewImage = document.createElement('img');
    previewImage.setAttribute('src', blob);
    previewImage.setAttribute('class', 'preview-image');

    // プレビュー画像の親要素に子要素としてimg要素を追加する
    previewWrapper.appendChild(previewImage);

    console.log('プレビューの親要素:', previewWrapper);
    console.log('プレビューのimg要素:', previewImage);

    // プレビュー画像一覧にプレビュー画像を挿入する
    const previewsList = document.querySelector('#previews');
    previewsList.appendChild(previewWrapper);
  })
});