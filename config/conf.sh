#!/bin/sh

# This is a sample config file, refer to ytfzf(5) for more information

# In the previous version of ytfzf this file had all the examples, with all defaults set,
# this has been changed because it made it impossible for us to change default values that were broken or causing bugs,
# as everyone used the default configuration file.
# we are now going to only have this sample config file, and the ytfzf(5) manual, which has explanation of every variable and function that can be set.

#a sample config below:
ytdl_pref='bestvideo[height<=?1080]+bestaudio/best'
sub_link_count=8
show_thumbnails=1
pages_start=1
search_again=0
log_level=0
multi_search=1
is_loop=1
url_handler_opts='--really-quiet --terminal=no'

on_opt_parse_c() {
    arg="$1"
    case "$arg" in
        SI|S)
            is_loop=1
            ;;
    esac
}

# Este scraper NO necesita término de búsqueda.
# search-ytdlp NO debe ponerse aquí, porque sí necesita la query.
custom_scrape_search_exclude="subs-ytdlp"

thumbnail_video_info_text() {
    width=$((${FZF_PREVIEW_COLUMNS:-60} - 6))
    [ "$width" -lt 20 ] && width=20

    # Título completo con saltos reales
    printf '%s\n' "$title" | fold -s -w "$width"

    # Nombre del canal, sin "Channel:" ni "Canal:"
    if [ -n "$channel" ]; then
        printf '%s\n' "$channel" | fold -s -w "$width"
    fi

    # Espacio entre texto y miniatura
    printf '\n'
}

on_no_thumbnail() {
    printf '\033_Ga=d,q=2\033\\' > /dev/tty
}
