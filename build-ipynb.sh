#!/bin/bash

output_dir="./images/notebooks"
rm -rf "$output_dir"

find . -type d -name ".ipynb_checkpoints" -prune -o -type f -name "*.ipynb" -print | while read -r notebook_path; do

    output_md_path="${output_dir}/$(basename "${notebook_path%.ipynb}.md")"
    mdx_path="${notebook_path%.ipynb}.mdx"
    temp_mdx_path="${notebook_path%.ipynb}_temp.mdx"

    if [ ! -f "$mdx_path" ]; then
        echo "Error: Corresponding .mdx file does not exist for $notebook_path"
        exit 1
    fi

    jupyter nbconvert --to markdown --template format-outputs.tpl --output-dir "$output_dir" "$notebook_path"

    sed -i 's#!\[png\](#![png]('"${output_dir#.}/"'#g' "$output_md_path"

    awk -v insert_file="$output_md_path" -v pattern="---" '
        BEGIN {
            count = 0
        }
        {
            if ($0 ~ pattern) {
                count++
                print $0
                if (count == 2) {
                    while ((getline line < insert_file) > 0) {
                        print line
                    }
                    close(insert_file)
                    exit
                }
            } else {
                print $0
            }
        }
    ' "$mdx_path" > "$temp_mdx_path"

    mv "$temp_mdx_path" "$mdx_path"
    rm "$output_md_path"

done
