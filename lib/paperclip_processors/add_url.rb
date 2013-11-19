# encoding: UTF-8
module Paperclip
  class AddUrl < Paperclip::Processor

    def initialize(file, options = {}, attachment = nil)
      super
      @file = file
      @format = File.extname(@file.path)
      @basename = File.basename(@file.path, @format)
    end

    def make
      dst = Tempfile.new([@basename, @format].compact.join('.'))
      dst.binmode

      #command = "composite"
      #params = "-gravity SouthWest '/Users/rui/Desktop/logo_new.jpg' #{from_file} #{to_file(dst)}"

      command = 'convert'
      font_path = Rails.root.join('app', 'assets', 'fonts', 'wqy-microhei.ttc')
      params = "-gravity SouthWest -fill white -draw \"font '#{font_path}' font-size 14 text 10,5 '校园小铺 xiaoyuanxiaopu.com'\" #{from_file} #{to_file(dst)}"
      Paperclip.run(command, params)
      dst
    end

    def from_file
      "\"#{ File.expand_path(@file.path) }[0]\""
    end

    def to_file(destination)
      "\"#{ File.expand_path(destination.path) }[0]\""
    end

  end
end