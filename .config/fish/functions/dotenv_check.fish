function dotenv_check -d "List variable names defined in .env (no values)"
    if not test -f .env
        echo "no .env in cwd"
        return 1
    end
    grep -v '^#' .env | grep -v '^$' | cut -d= -f1 | sort
end
