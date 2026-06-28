function nvmuse -d "Switch node version from .nvmrc/.node-version (fnm or nvm)"
    if command -q fnm; and test -f .nvmrc -o -f .node-version
        fnm use --log-level quiet
    else if command -q nvm; and test -f .nvmrc
        nvm use
    else
        echo "no .nvmrc / .node-version in current directory"
    end
end
