#!/usr/bin/env ruby

OverlayRoot = '.'
ExcludeDirs = [ 'profiles' ]

class String
  def dir_entries
    output = []
    Dir.entries(self).each do |entry|
      output << entry if ! entry.match(/^\./) and File.directory?(self + '/' + entry)
    end
    return output
  end
end

# Parse overlay
overlay = {}
OverlayRoot.dir_entries.each do |category|
  if ! ExcludeDirs.include?(category) then
    overlay[category] = []
    (OverlayRoot + '/' + category).dir_entries.each do |name|
      package = {}
      package[:name] = name
      Dir.entries(OverlayRoot + '/' + category + '/' + name).each do |ebuild|
        package[:version] = [] if ! package[:version]
        package[:version] << ebuild.sub(name + '-', '').sub('.ebuild', '') if ebuild.match(name)
      end
      ebuild = "#{OverlayRoot}/#{category}/#{package[:name]}/#{package[:name]}-#{package[:version].first}.ebuild"
      File.open(ebuild, 'r').readlines.each do |line|
        package[:homepage] = line.gsub('"', '').sub('HOMEPAGE=', '').chomp if line.match('HOMEPAGE')
        package[:description] = line.gsub('"', '').sub('DESCRIPTION=', '').chomp if line.match('DESCRIPTION')
      end
      overlay[category] << package
    end
  end
end

# Generate README.md
readme = File.open(OverlayRoot + '/README.md', 'w')
readme.puts "Scrill overlay\n==============\n\n"
readme.puts "Usage:\n------\n\n"
readme.puts "Packages:\n---------\n\n"
overlay.keys.sort.each do |category|
  readme.puts "# category"
  overlay[category].each do |package|
    readme.puts "### Package:  #{package[:name]}"
    readme.puts "    Description : #{package[:description]}"
    readme.puts "    Versions: #{package[:version].join(' ')}"
    readme.puts "    Homepage: #{package[:homepage]}"
  end
  readme.puts
end

readme.close