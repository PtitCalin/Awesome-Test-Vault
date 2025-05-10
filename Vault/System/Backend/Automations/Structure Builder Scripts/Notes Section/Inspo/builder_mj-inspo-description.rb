#!/usr/bin/env ruby

# -----------------------------------------------------------------------------------
# 🎨 MidJourney Inspo Batch Folder Builder - Ruby Version
# -----------------------------------------------------------------------------------
# USAGE:
#   ruby builder_mj-inspo-description.rb --batch 5 --start 7                  # Normal mode
#   ruby builder_mj-inspo-description.rb --batch 5 --start 7 --dry-run        # Preview only, no changes
#
# EXAMPLE:
#   ruby builder_mj-inspo-description.rb --batch 3 --start 42
# -----------------------------------------------------------------------------------

require 'fileutils'
require 'optparse'

# -----------------------------------------------------------------------------------
# === Argument Parsing ===
# -----------------------------------------------------------------------------------

options = {}
OptionParser.new do |opts|
  opts.banner = "🎨 MidJourney Inspo Batch Folder Builder - Ruby Version"

  opts.on("--batch BATCH", Integer, "Number of inspo folders to create") do |v|
    options[:batch] = v
  end

  opts.on("--start START", Integer, "Starting number for folder naming") do |v|
    options[:start] = v
  end

  opts.on("--dry-run", "Preview actions without making changes") do
    options[:dry_run] = true
  end
end.parse!

batch = options[:batch] || (abort "❌ You must specify --batch")
start = options[:start] || (abort "❌ You must specify --start")
dry_run = options[:dry_run] || false

BASE_PATH = "./"

puts "🔢 Creating #{batch} inspo folders starting at inspo_%04d" % start

puts "🧪 DRY-RUN mode enabled. No changes will be made." if dry_run

# -----------------------------------------------------------------------------------
# === Helper Method ===
# -----------------------------------------------------------------------------------

def create_var_folder_and_file(parent, var_name, dry_run)
  folder_path = File.join(parent, var_name)
  desc_file = File.join(folder_path, "#{var_name}_description.txt")

  if dry_run
    puts "[DRY RUN] Would create folder: #{folder_path}"
    puts "[DRY RUN] Would create file: #{desc_file}"
  else
    FileUtils.mkdir_p(folder_path)
    FileUtils.touch(desc_file)
    puts "📁 Created folder: #{folder_path}"
    puts "📝 Created file: #{desc_file}"
  end
end

# -----------------------------------------------------------------------------------
# === Main Loop ===
# -----------------------------------------------------------------------------------

batch.times do |i|
  n = start + i
  inspo_folder = "inspo_%04d" % n
  full_path = File.join(BASE_PATH, inspo_folder)

  puts "➡ Processing #{inspo_folder}"

  if Dir.exist?(full_path)
    puts "⚠️ Folder already exists: #{full_path}"
  else
    if dry_run
      puts "[DRY RUN] Would create base folder: #{full_path}"
    else
      FileUtils.mkdir_p(full_path)
      puts "📂 Created base folder: #{full_path}"
    end
  end

  (1..4).each do |v|
    create_var_folder_and_file(full_path, "var#{v}", dry_run)
  end
end

# -----------------------------------------------------------------------------------
# === Completion Message ===
# -----------------------------------------------------------------------------------
if dry_run
  puts "✅ DRY-RUN complete. No files or folders created."
else
  puts "✅ All #{batch} inspo folders created successfully starting at inspo_%04d" % start
end

puts "✨ All set! Happy creating."

# -----------------------------------------------------------------------------------
# === End of Script ===
# -----------------------------------------------------------------------------------
# This script automates batch creation of MidJourney inspo folders.
# Each inspo folder contains 4 variant subfolders, each with a description file.
# Supports dry-run mode for safe previewing.
#
# Educational and creative use only. Use at your own risk.
# -----------------------------------------------------------------------------------
