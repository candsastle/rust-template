run:
    cargo run

run-release:
    cargo run-release

publish commit_msg:
    git add -e .
    git commit -m "{{commit_msg}}"
    git push
    
