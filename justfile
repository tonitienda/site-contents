tsoobame:
    cd ~/Projects/gengo   &&     go run cmd/main.go generate --manifest ~/Projects/blog-down/gengo.yaml --manifest ~/Projects/blog-down/gengo.tsoobame.yaml --output ~/Projects/blog-down/dist --plain

serve:
    cd ~/Projects/gengo   &&     go run cmd/main.go serve --site ~/Projects/blog-down/dist --watch


tonitienda:
    cd ~/Projects/gengo   &&     go run cmd/main.go generate --manifest ~/Projects/blog-down/gengo.yaml --manifest ~/Projects/blog-down/gengo.tonitienda.yaml --output ~/Projects/blog-down/dist



ci:
    curl -fsSL https://raw.githubusercontent.com/saasuke-labs/gengo/main/install/install.sh | bash
    gengo generate --manifest ~/Projects/blog-down/gengo.yaml --output ~/Projects/blog-down/dist

    rm dist/index.html
    cp dist/blog/index.html dist/index.html


