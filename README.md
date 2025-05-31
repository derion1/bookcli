# 📚 Bookmark Manager

A lightweight, terminal-based bookmark manager for developers and power users who prefer the command line. Store, organize, and access your bookmarks without leaving your terminal.

## ✨ Features

- **Simple Storage** - All bookmarks stored in a plain text file (`bookmarks.txt`)
- **Fast Search** - Quickly find bookmarks by title, URL, or tags
- **Colorized Output** - Beautiful CLI interface with syntax highlighting
- **Browser Integration** - Open bookmarks directly in your default browser
- **Tag Support** - Organize bookmarks with custom tags
- **No Dependencies** - Pure bash script, works on any Unix-like system

## 🚀 Quick Start

```bash
# Make executable
chmod +x bookmarks.sh

# Add your first bookmark
./bookmarks.sh add https://github.com "GitHub" "dev,code"

# List all bookmarks
./bookmarks.sh list

# Search bookmarks
./bookmarks.sh search github
```

## 📋 Usage

```
bookmarks.sh add <url> [title] [tags]     # Add a new bookmark
bookmarks.sh list                         # List all bookmarks  
bookmarks.sh search <query>               # Search bookmarks
bookmarks.sh delete <line_number>         # Delete a bookmark
bookmarks.sh open <line_number>           # Open bookmark in browser
bookmarks.sh help                         # Show help message
```

## 💡 Examples

```bash
# Add bookmarks with different levels of detail
./bookmarks.sh add https://stackoverflow.com
./bookmarks.sh add https://docs.python.org "Python Docs" "python,reference"
./bookmarks.sh add https://news.ycombinator.com "Hacker News" "news,tech"

# Search and filter
./bookmarks.sh search python
./bookmarks.sh search reference

# Quick access
./bookmarks.sh open 1    # Opens first bookmark in browser
```

## 🛠️ Installation

**Option 1: Direct Download**
```bash
curl -O https://raw.githubusercontent.com/user/repo/main/bookmarks.sh
chmod +x bookmarks.sh
```

**Option 2: Clone Repository**
```bash
git clone https://github.com/user/repo.git
cd repo
chmod +x bookmarks.sh
```

**Optional: Create Alias**
```bash
echo 'alias bm="~/path/to/bookmarks.sh"' >> ~/.bashrc
source ~/.bashrc
# Now use: bm add https://example.com
```

## 📁 File Format

Bookmarks are stored in `bookmarks.txt` with pipe-separated values:
```
2024-05-31 10:30:15|https://github.com|GitHub|dev,code
2024-05-31 10:31:22|https://stackoverflow.com|Stack Overflow|reference,dev
```

## 🎨 Screenshot

```
📚 Your Bookmarks
=================

[1] GitHub
    URL: https://github.com
    Added: 2024-05-31 10:30:15
    Tags: dev,code

[2] Stack Overflow  
    URL: https://stackoverflow.com
    Added: 2024-05-31 10:31:22
    Tags: reference,dev
```

## 🔧 Requirements

- Bash 4.0+
- Unix-like system (Linux, macOS, WSL)
- `xdg-open`, `open`, or `firefox` for browser integration (optional)

## 🤝 Contributing

Contributions welcome! Feel free to:
- Report bugs
- Suggest features
- Submit pull requests
- Improve documentation

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

---

*Perfect for developers who live in the terminal and want a simple, fast way to manage bookmarks without browser dependency.*
