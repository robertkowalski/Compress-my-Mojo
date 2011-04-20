#!/usr/bin/ruby
require 'fileutils'
require 'find'
include FileUtils


##########
# Config #
##########

#path to yui-compressor jar
yui_jar = "#{File.dirname(__FILE__)}/yuicompressor-2.4.2.jar"
#path to google closure compiler
closure_jar = "#{File.dirname(__FILE__)}/compiler.jar"

#change your build-folder if wanted
build_dir = "#{File.dirname(__FILE__)}/.tmp/"


######## HERE THE CONFIG ENDS ############

##########
# Check for command line argument
##########
unless ARGV.length == 1 or ARGV.length == 2
  puts 'Please specify a project folder name.'
  puts 'Usage: ruby build.rb [-i|v1] <PROJECTFOLDER-NAME>'
  puts 'options are:'
  puts '-i   install on device or emulator'
  puts '-v1  package for webOS 1.4.x devices (old format)'
  puts '-g to use google closure compiler (default is YUI-Compressor)'
  puts 'or combined: -iv1g  to package for webOS 1.4.x devices (old format), packaging with closure compiler and installing them'
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
   puts ' '
   if options.index('v1')
      option = '-v1'
      puts '* Using 1.4.5 compability mode'
   end 
   if options.index('i')
      install = true
      puts '* Will install after packaging'
   end 
   if options.index('g')
      compiler = {:jar => closure_jar, :type => 'google'}
      puts '* Will use google closure compiler'
   else 
      compiler = {:jar => yui_jar, :type => 'yui'}
   end 
   puts ' '
else 
   compiler = {:jar => yui_jar, :type => 'yui'}
end 

##########
# add options to palm-package commandline
##########

if option and option == '-v1'
   option = "--use-v1-format"
else
   option = ""
end

# pre-deleting ./.build/ for avoiding errors @ build
if File.directory? projectfolder
   puts 'Deleting temp-files'
   string = 'rm -rf '+build_dir
   ret  = system(string)
else
   puts '*** ERROR: Please specify a valid directory'
   exit
end

# copy bitch, copy!
if File.directory? projectfolder
   cp_r './'+projectfolder, build_dir
else
   puts '*** ERROR: Please specify a valid directory'
   exit
end

def compress(path, pattern, compiler)
   Find.find(path) do |entry|
      if File.file?(entry) and entry[pattern]
         puts 'compressing: '+entry
         #yui yeah
         if(compiler[:type] == 'yui')
            string = 'java -jar '+compiler[:jar]+' '+entry+' -o '+entry
         else
            string = 'java -jar '+compiler[:jar]+' --js='+entry
         end
         ret  = system(string)
      end
   end
end
 
# compress .js- then .css-files
compress(build_dir, /.+\.js$/, compiler)
if(compiler[:type] == 'yui')
   compress(build_dir, /.+\.css$/, compiler)
end

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


