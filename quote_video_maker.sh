#!/bin/bash

# Input files
QUOTES_FILE="quotes.txt"
BACKGROUND_VIDEO="background.mp4"

# Output directory
OUTPUT_DIR="output_videos"
mkdir -p $OUTPUT_DIR

# Video dimensions
VIDEO_WIDTH=720
VIDEO_HEIGHT=1280

# Function to create a video from a quote
create_video() {
    local quote="$1"
    local output_file="$2"

    # Generate an image with the quote text, auto-fitting text size
    convert -background transparent -fill white -gravity center \
    -size ${VIDEO_WIDTH}x${VIDEO_HEIGHT} \
    -font Arial -pointsize 50 caption:"$quote" \
    /tmp/quote_image.png

    # Overlay the image on the background video
    ffmpeg -i "$BACKGROUND_VIDEO" -i /tmp/quote_image.png -filter_complex \
    "[1]scale=${VIDEO_WIDTH}:${VIDEO_HEIGHT}[overlay]; [0][overlay]overlay=W/2-w/2:H/2-h/2" \
    -c:a copy "$output_file"
}

# Read quotes from the file
mapfile -t quotes < $QUOTES_FILE

# Create 3 videos
for i in {1..3}; do
    quote="${quotes[$((RANDOM % ${#quotes[@]}))]}" # Pick a random quote
    output_file="${OUTPUT_DIR}/quote_video_$i.mp4"
    create_video "$quote" "$output_file"
done

echo "3 videos have been created in the $OUTPUT_DIR directory."
