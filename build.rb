#!/usr/bin/ruby
require 'fileutils'
require 'find'
include FileUtils

#@todo: check for -i folder 

##########
# Config #
##########

#path to yui-compressor jar
yui_jar = '~/Desktop/yuicompressor-2.4.2/build/yuicompressor-2.4.2.jar'

#change your build-folder
build_dir = './.my_webos_builds'

######## HERE THE CONFIG ENDS ############

##########
# Check for command line argument
##########
unless ARGV.length == 1 or ARGV.length == 2
  puts "Please specify a project folder name."
  puts "Usage: ruby build.rb [-i] <PROJECTFOLDER-NAME>\n"
  exit
end

##########
# Check for second arguments
##########
if ARGV.length > 1
   projectfolder = ARGV[1]
else
   if ARGV[0] == '-i'
      #@todo: check if the project lies in a folder -i

      puts "Please specify a project folder name."
      exit
   else
      projectfolder = ARGV[0]
  end
end

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

build_output = `palm-package #{build_dir}`
string = build_output.gsub(/creating package /, "")
filename_array = string.split(/ /)

puts 'Builded '+filename_array[0]+' successfully'
# installing if wanted
if ARGV[0] == '-i'
   string = 'palm-install '+filename_array[0]
   ret  = system(string)
end


puts 'Deleting temp-files'
string = 'rm -rf '+build_dir
ret  = system(string)


