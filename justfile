tsoobame:
    cd ~/Projects/gengo   &&     go run cmd/main.go generate --manifest ~/Projects/blog-down/gengo.yaml --manifest ~/Projects/blog-down/gengo.tsoobame.yaml --output ~/Projects/blog-down/dist --plain

serve:
    gengo serve --site ./dist --watch


tonitienda:
    gengo generate --manifest gengo.yaml --manifest gengo.tonitienda.yaml --output dist



ci:
    curl -fsSL https://raw.githubusercontent.com/saasuke-labs/gengo/main/install/install.sh | bash
    gengo generate --manifest ~/Projects/blog-down/gengo.yaml --output ~/Projects/blog-down/dist

    rm dist/index.html
    cp dist/blog/index.html dist/index.html


