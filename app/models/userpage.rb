class Userpage < ActiveRecord::Base

    validates :filename, presence: true, length: {minimum: 3}, format: {with: /[.]/}, uniqueness: true

    validates :linkname, presence: true, length: {minimum: 1}

    def self.new_page_with_default(fname)
        Userpage.find_by_filename(fname).nil? ? Userpage.new(filename: fname, linkname: File.basename(fname,'.*'), seqno: 0, valid_from: nil, valid_to: nil) : nil
    end

end
