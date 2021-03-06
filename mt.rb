#!/usr/bin/env ruby

require "prawn"
require "prawn/measurement_extensions"
require "trollop"


def generateMovementTray(rows, cols, filename, base)

    pdf = Prawn::Document.new

    pdf.text "Paper Movement Tray"
    pdf.stroke_horizontal_rule
    pdf.move_down 10
    pdf.text "#{base[0]}x#{base[1]}mm bases, #{rows} ranks, #{cols} models per rank"
    pdf.text "Generated by Luke's Movement Tray script"
    pdf.text "mt.rb (c) Luke Maciak: https://github.com/maciakl/MovementTray"

    pdf.move_down 30
    pdf.text "Cut along the lines below:"

    y = base[1].mm
    x = 0
    
    rows.times do
        cols.times do |i|
            
            pdf.stroke do
                pdf.rectangle [x,y], base[0].mm, base[1].mm
            end

            x += base[0].mm + 1.mm
        end
        x = 0
        y += base[1].mm + 1.mm
    end

    pdf.render_file filename
end


 opts = Trollop::options do
    version "mt.rb 0.1 (c) Luke Maciak 2013"
    banner <<-EOS
Luke's Movement Tray Tool
-------------------------

This tool generates a printable movement tray for war games which
use 20 or 25mm square bases. The tray is generated as a PDF file.

To generate your tray please provide how many --rows and --cols you
want to have in your unit. Use the --large switch to use the larger
25mm bases (the default is 20mm).

Usage:
        mt.rb --rows 5 --cols 5 --file tray.pdf

The above will generate a 5x5 tray using 20mm bases and save it into
file named tray.pdf in the current directory.

Note: the tray must fit on a single letter paper (8x11") sheet of paper.
There are following limitations with respect to unit size:

    Standard 20mm units:    10 rows x 10 cols
    Large 25mm units:       8 rows x 8 cols
    Monster 40mm units:     4 rows x 4 cols
    Cavalry 25x50mm units:  4 rows x 8 cols

Command line arguments:
    
    EOS
    opt :base, "Base size: standard (20mm), large (25mm), monster (40mm), cavalry (25x50mm)", :short => "-b", :default => "standard"
    opt :rows, "Number of rows", :short => "-r", :type => :int, :required => true
    opt :cols, "Number of collumns", :short => "-c", :type => :int, :required => true
    opt :file, "Output file", :short => "-f", :type => :string, :required => true
 end

Trollop::die :file, "must end in .pdf" if !opts[:file].end_with?(".pdf")


rows = opts[:rows]
cols = opts[:cols]
filename = opts[:file]

case opts[:base] 
when "standard"
    base = [20, 20]
    r_max = 10
    c_max = 10
when "large" 
    base = [25, 25]
    r_max = 8
    c_max = 8
when "monster"
    base = [40, 40]
    r_max = 4
    c_max = 4
when "cavalry"
    base = [25, 50]
    r_max = 4
    c_max = 8
else
    Trollop::die :base, "must be standard, large, monster or cavalry"
end

Trollop::die :rows, "For #{base[0]}x#{base[1]}mm base argument must be in the range of 1-#{r_max}" if (rows<1 or rows>r_max)
Trollop::die :cols, "For #{base[0]}x#{base[1]}mm base argument must be in the range of 1-#{c_max}" if (cols<1 or cols>c_max)


puts "Building a movement tray..."
puts "Base size is #{base[0]}x#{base[1]}mm"
puts "Tray size: #{rows}x#{cols}"

generateMovementTray(rows,cols, filename, base)

puts "Successfuly generated #{filename}"
