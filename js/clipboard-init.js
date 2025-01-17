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
