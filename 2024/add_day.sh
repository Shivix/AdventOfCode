set -e

day_name=$(printf "day%02d" "$1")

if [ -d "$day_name" ]; then
    echo "Day already exists"
fi

mkdir "$day_name"
cd "$day_name"

cargo init --bin

cat <<EOF > Cargo.toml
[package]
name = "$day_name-2024"
edition = "2021"

[dependencies]

[[bin]]
name = "$day_name-2024"
path = "main.rs"
EOF

sed "s/day01/$day_name/g" -i Cargo.toml

mv src/main.rs ./main.rs
rmdir src
