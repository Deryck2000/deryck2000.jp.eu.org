document.addEventListener('DOMContentLoaded', (event) => {
    document.querySelectorAll('pre').forEach((block) => {
        let button = document.createElement('button');
        button.innerText = 'Copy';
        button.className = 'copy-button';
        block.style.position = 'relative';
        button.style.position = 'absolute';
        button.style.right = '10px';
        button.style.top = '10px';
        block.appendChild(button);

        button.addEventListener('click', () => {
            let codeBlock = block.querySelector('code');
            navigator.clipboard.writeText(codeBlock.textContent).then(() => {
                button.innerText = 'Copied!';
                setTimeout(() => {
                    button.innerText = 'Copy';
                }, 2000);
            }).catch((err) => {
                console.log('Something went wrong', err);
            });
        });
    });

    new ClipboardJS('.copy-button', {
        target: (trigger) => {
            return trigger.previousElementSibling;
        }
    });
});

document.getElementById("copyButton").addEventListener("click", function() {
    // ボタンのdata-copy-text属性からコピーするテキストを取得
    var button = document.getElementById("copyButton");
    // 改行文字は二重エスケープしています
    var textToCopy = button.getAttribute("data-copy-text").replace(/\\n/g, "\n");
    var textArea = document.createElement("textarea");
    textArea.value = textToCopy;
    document.body.appendChild(textArea);
    textArea.select();
    try {
        document.execCommand("copy");
        var originalButtonText = button.textContent;
        button.textContent = "コピーしました!";
        
        // 2秒後にボタンのテキストを元に戻す
        setTimeout(function() {
            button.textContent = originalButtonText;
        }, 2000);
    } catch (err) {
        console.error("コピーに失敗しました", err);
    }
    document.body.removeChild(textArea);
});
