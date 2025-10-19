set -e

year=2025
day=${1:-$(date +%d)}
day_name=$(printf "day%02d" "$day")
path="$year/$day_name"

if [ -d "$path" ]; then
    echo "Day already exists"
fi

mkdir "$path"
cd "$path"

cargo init --bin
zig init
touch "src/main.lua"
touch "src/main.perl"
touch "src/main.c"

cat <<EOF > "Cargo.toml"
[package]
name = "$day_name-$year"
edition = "2024"

[dependencies]

[[bin]]
name = "$day_name-$year"
path = "src/main.rs"
EOF
