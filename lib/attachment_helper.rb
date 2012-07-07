# coding: utf-8
module AttachmentHelper
 
  def self.get_icon_path(attachment)
     if !((File.extname(attachment.url) =~ /(.jpg|.png|.gif)(.*)$/).nil?)
        return attachment.url
     else
       if !((File.extname(attachment.url) =~ /(.doc|.docx)(.*)/).nil?)
         return "/system/doctypes/Word.png"
       else
         if !((File.extname(attachment.url) =~ /(.xls|.xlsx)(.*)$/).nil?)
           return "/system/doctypes/Excel.png"
         else
           return "/system/doctypes/Clip.png"
         end
       end
     end
  end
end