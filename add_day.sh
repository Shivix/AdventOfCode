set -e

year=2025
day=$1
lang=$2
if [[ ! "$day" =~ ^[0-9]+$ ]]; then
    day=$(date +%d)
    lang=$1
fi
day="$((10#$day))"
day_name=$(printf "day%02d" "$day")
path="$year/$day_name"

if [[ ! -d "$path" ]]; then
    mkdir "$path"
    mkdir "$path/src"
fi

if [[ "$lang" == "rust" ]]; then
    cd $path
    cargo init --bin

    cat <<EOF > "Cargo.toml"
[package]
name = "$day_name-$year"
edition = "2024"

[dependencies]

[[bin]]
name = "$day_name-$year"
path = "src/main.rs"
EOF
elif [[ "$lang" == "zig" ]]; then
    touch "$path/src/main.zig"
    sed -i "/addDay(b, \"2025\", \"day$(printf "%02d" $(($day - 1)))\", target, optimize);/a\
        \ \ \ \ addDay(b, \"2025\", \"$day_name\", target, optimize);" build.zig
elif [[ "$lang" == "lua" ]]; then
    touch "$path/src/main.lua"
elif [[ "$lang" == "perl" ]]; then
    touch "$path/src/main.perl"
elif [[ "$lang" == "c" ]]; then
    touch "$path/src/main.c"
fi
