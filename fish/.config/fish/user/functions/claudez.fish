function claudez
    echo "🚀 GLM Mode Active - Using Z.AI GLM-4.7 Models"
    echo "📡 Base URL: https://api.z.ai/api/anthropic"

    # Use PID-based marker so sessions don't interfere
    set -l MARKER "/tmp/.claude-glm-mode.$fish_pid"
    echo $fish_pid >"$MARKER"

    # Export marker path so statusline can find THIS session's marker
    set -lx CLAUDE_MODE_MARKER "$MARKER"

    # claude --settings ~/.claude/glm-settings.json --dangerously-skip-permissions $argv
    claude --settings ~/.claude/glm-settings.json $argv

    # Cleanup marker file
    rm -f "$MARKER"
end
