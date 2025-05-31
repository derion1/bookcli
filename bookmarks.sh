#!/bin/bash

# BookCLI 0.8 - Bookmark Manager - A simple CLI tool for managing bookmarks
# Website: https://github.com/derion1/bookcli/
# Usage: ./bookmarks.sh [command] [arguments]

BOOKMARK_FILE="bookmarks.txt"

# Colors for better CLI presentation
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Create bookmarks file if it doesn't exist
create_file() {
    if [[ ! -f "$BOOKMARK_FILE" ]]; then
        touch "$BOOKMARK_FILE"
        echo "Created $BOOKMARK_FILE"
    fi
}

# Add a new bookmark
add_bookmark() {
    local url="$1"
    local title="$2"
    local tags="$3"
    
    if [[ -z "$url" ]]; then
        echo -e "${RED}Error: URL is required${NC}"
        echo "Usage: $0 add <url> [title] [tags]"
        return 1
    fi
    
    # If no title provided, try to extract from URL
    if [[ -z "$title" ]]; then
        title=$(echo "$url" | sed 's|https\?://||' | sed 's|www\.||' | cut -d'/' -f1)
    fi
    
    # Format: TIMESTAMP|URL|TITLE|TAGS
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$timestamp|$url|$title|$tags" >> "$BOOKMARK_FILE"
    echo -e "${GREEN}✓ Bookmark added successfully${NC}"
    echo -e "  ${CYAN}Title:${NC} $title"
    echo -e "  ${CYAN}URL:${NC} $url"
    [[ -n "$tags" ]] && echo -e "  ${CYAN}Tags:${NC} $tags"
}

# List all bookmarks with nice formatting
list_bookmarks() {
    create_file
    
    if [[ ! -s "$BOOKMARK_FILE" ]]; then
        echo -e "${YELLOW}No bookmarks found${NC}"
        return
    fi
    
    echo -e "${BLUE}📚 Bookmarks${NC}"
    echo -e "${BLUE}=================${NC}"
    echo
    
    local count=1
    while IFS='|' read -r timestamp url title tags; do
        echo -e "${GREEN}[$count]${NC} ${CYAN}$title${NC}"
        echo -e "    ${YELLOW}URL:${NC} $url"
        echo -e "    ${YELLOW}Added:${NC} $timestamp"
        [[ -n "$tags" ]] && echo -e "    ${YELLOW}Tags:${NC} $tags"
        echo
        ((count++))
    done < "$BOOKMARK_FILE"
}

# Search bookmarks
search_bookmarks() {
    local query="$1"
    
    if [[ -z "$query" ]]; then
        echo -e "${RED}Error: Search query is required${NC}"
        echo "Usage: $0 search <query>"
        return 1
    fi
    
    create_file
    
    echo -e "${BLUE}🔍 Search results for: ${YELLOW}$query${NC}"
    echo -e "${BLUE}========================${NC}"
    echo
    
    local count=0
    local line_num=1
    while IFS='|' read -r timestamp url title tags; do
        # Case-insensitive search in title, URL, and tags
        if echo "$title $url $tags" | grep -qi "$query"; then
            echo -e "${GREEN}[$line_num]${NC} ${CYAN}$title${NC}"
            echo -e "    ${YELLOW}URL:${NC} $url"
            echo -e "    ${YELLOW}Added:${NC} $timestamp"
            [[ -n "$tags" ]] && echo -e "    ${YELLOW}Tags:${NC} $tags"
            echo
            ((count++))
        fi
        ((line_num++))
    done < "$BOOKMARK_FILE"
    
    if [[ $count -eq 0 ]]; then
        echo -e "${YELLOW}No bookmarks found matching '$query'${NC}"
    else
        echo -e "${GREEN}Found $count bookmark(s)${NC}"
    fi
}

# Delete a bookmark by line number
delete_bookmark() {
    local line_num="$1"
    
    if [[ -z "$line_num" ]] || ! [[ "$line_num" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Error: Valid line number is required${NC}"
        echo "Usage: $0 delete <line_number>"
        echo "Use '$0 list' to see line numbers"
        return 1
    fi
    
    create_file
    
    local total_lines=$(wc -l < "$BOOKMARK_FILE")
    
    if [[ $line_num -gt $total_lines ]] || [[ $line_num -lt 1 ]]; then
        echo -e "${RED}Error: Line number $line_num is out of range (1-$total_lines)${NC}"
        return 1
    fi
    
    # Show the bookmark to be deleted
    local bookmark=$(sed -n "${line_num}p" "$BOOKMARK_FILE")
    IFS='|' read -r timestamp url title tags <<< "$bookmark"
    
    echo -e "${YELLOW}Are you sure you want to delete this bookmark?${NC}"
    echo -e "  ${CYAN}Title:${NC} $title"
    echo -e "  ${CYAN}URL:${NC} $url"
    echo -n "Type 'yes' to confirm: "
    read confirmation
    
    if [[ "$confirmation" == "yes" ]]; then
        sed -i "${line_num}d" "$BOOKMARK_FILE"
        echo -e "${GREEN}✓ Bookmark deleted successfully${NC}"
    else
        echo -e "${YELLOW}Deletion cancelled${NC}"
    fi
}

# Open a bookmark in the default browser
open_bookmark() {
    local line_num="$1"
    
    if [[ -z "$line_num" ]] || ! [[ "$line_num" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Error: Valid line number is required${NC}"
        echo "Usage: $0 open <line_number>"
        echo "Use '$0 list' to see line numbers"
        return 1
    fi
    
    create_file
    
    local bookmark=$(sed -n "${line_num}p" "$BOOKMARK_FILE")
    if [[ -z "$bookmark" ]]; then
        echo -e "${RED}Error: Bookmark $line_num not found${NC}"
        return 1
    fi
    
    IFS='|' read -r timestamp url title tags <<< "$bookmark"
    
    echo -e "${GREEN}Opening:${NC} $title"
    echo -e "${GREEN}URL:${NC} $url"
    
    # Try different browsers/commands
    if command -v xdg-open > /dev/null; then
        xdg-open "$url"
    elif command -v open > /dev/null; then
        open "$url"
    elif command -v firefox > /dev/null; then
        firefox "$url" &
    else
        echo -e "${YELLOW}Could not open browser automatically${NC}"
        echo -e "${CYAN}URL copied for manual opening:${NC} $url"
    fi
}

# Show usage information
show_help() {
    echo -e "${BLUE}📚 Bookmark Manager${NC}"
    echo -e "${BLUE}==================${NC}"
    echo
    echo -e "${CYAN}Usage:${NC}"
    echo "  $0 add <url> [title] [tags]     Add a new bookmark"
    echo "  $0 list                         List all bookmarks"
    echo "  $0 search <query>               Search bookmarks"
    echo "  $0 delete <line_number>         Delete a bookmark"
    echo "  $0 open <line_number>           Open bookmark in browser"
    echo "  $0 help                         Show this help message"
    echo
    echo -e "${CYAN}Examples:${NC}"
    echo "  $0 add https://example.com 'Example Site' 'reference,tools'"
    echo "  $0 add https://github.com/user/repo"
    echo "  $0 search python"
    echo "  $0 delete 3"
    echo "  $0 open 1"
}

# Main script logic
case "$1" in
    "add")
        add_bookmark "$2" "$3" "$4"
        ;;
    "list"|"")
        list_bookmarks
        ;;
    "search")
        search_bookmarks "$2"
        ;;
    "delete"|"del")
        delete_bookmark "$2"
        ;;
    "open")
        open_bookmark "$2"
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        echo -e "${RED}Error: Unknown command '$1'${NC}"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac