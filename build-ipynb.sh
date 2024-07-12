#!/bin/bash

find . -type d -name ".ipynb_checkpoints" -prune -o -type f -name "*.ipynb" -print | while read -r notebook_path; do

    output_md_path="${notebook_path%.ipynb}.md"
    mdx_path="${notebook_path%.ipynb}.mdx"
    temp_mdx_path="${notebook_path%.ipynb}_temp.mdx"

    if [ ! -f "$mdx_path" ]; then
        echo "Error: Corresponding .mdx file does not exist for $notebook_path"
        exit 1
    fi

    jupyter nbconvert --to markdown --template format-outputs.tpl --ExtractOutputPreprocessor.enabled=False "$notebook_path"

    awk -v insert_file="$output_md_path" -v pattern="---" '
        BEGIN {
            count = 0
        }
        {
            print $0
            if ($0 ~ pattern) {
                count++
                if (count == 2) {
                    while ((getline line < insert_file) > 0) {
                        print line
                    }
                    close(insert_file)
                }
            }
        }
    ' "$mdx_path" > "$temp_mdx_path"

    mv "$temp_mdx_path" "$mdx_path"
    rm "$output_md_path"
done
