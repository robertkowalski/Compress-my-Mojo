#!/usr/bin/ruby
require 'fileutils'
require 'find'
include FileUtils


##########
# Config #
##########

#path to yui-compressor jar
yui_jar = '~/Desktop/yuicompressor-2.4.2/build/yuicompressor-2.4.2.jar'

#change your build-folder if wanted
build_dir = './.my_webos_builds'


######## HERE THE CONFIG ENDS ############

##########
# Check for command line argument
##########
unless ARGV.length == 1 or ARGV.length == 2
  puts "Please specify a project folder name."
  puts "Usage: ruby build.rb [-i|v1] <PROJECTFOLDER-NAME>\n"
  puts "options are:\n"
  puts "-i   install on device or emulator\n"
  puts "-v1  package for webOS 1.4.x devices (old format)\n"
  puts "or combinded: -iv1  to package for webOS 1.4.x devices (old format) and installing them"
  exit
end

##########
# Check for second argument
##########
if ARGV.length > 1
   projectfolder = ARGV[1]
   options = ARGV[0]
else
   projectfolder = ARGV[0]
end

##########
# processing options
##########
if options
   if options.index('v1')
      option = '-v1'
      puts 'using 1.4.5 compability mode'
   end 
   if options.index('i')
      install = true
      puts 'will install after packaging'
   end 
end

##########
# add options to palm-package commandline
##########

if option and option == '-v1'
  option = "--use-v1-format"
else
  option = ""
end

 puts 'Options are: ' + option

# pre-deleting ./.build/ for avoiding errors @ build
puts 'Deleting temp-files'
string = 'rm -rf '+build_dir
ret  = system(string)

# copy bitch, copy!
cp_r './'+projectfolder, build_dir


def compress(path, pattern, yui_jar)
   Find.find(path) do |entry|
      if File.file?(entry) and entry[pattern]
         puts 'compressing: '+entry
         #yui yeah
         string = 'java -jar '+yui_jar+' '+entry+' -o '+entry
         ret  = system(string)
      end
   end
end
 
# compress .js- then .css-files
compress(build_dir, /.+\.js$/, yui_jar)
compress(build_dir, /.+\.css$/, yui_jar)


build_output = `palm-package #{option} #{build_dir}`

string = build_output.gsub(/creating package /, "")
filename_array = string.split(/ /)

puts 'Builded '+filename_array[0]+' successfully'

# installing if wanted
if install
   string = 'palm-install '+filename_array[0]
   ret  = system(string)
end

puts 'Deleting temp-files'
string = 'rm -rf '+build_dir
ret  = system(string)


