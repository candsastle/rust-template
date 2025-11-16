run:
    cargo run

run-release:
    cargo run-release

publish commit_msg:
    git add .
    git commit -m "{{commit_msg}}"
    git push
    
