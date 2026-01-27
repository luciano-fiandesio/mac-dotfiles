function claudem

    echo "🚀 Minimax Mode Active - Using Minimax M2.1 Model"
    echo "📡 Base URL: https://api.minimax.io/anthropic"

    claude --settings ~/.claude/minimax-settings.json $argv
end
