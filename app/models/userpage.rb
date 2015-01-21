class Userpage < ActiveRecord::Base

    validates :filename, presence: true, length: {minimum: 3}, format: {with: /[.]/}, uniqueness: true

    validates :linkname, presence: true, length: {minimum: 1}

    # Creates a new Userpage object for the file fname.
    # fname is supposed to be a file name without path, but the code will work
    #       as well if a path component is present.
    # The new page is set to inactive.
    # Return value:
    #   - If the page was added, returns an integer (the id of the newly created page)
    #   - If an object for this file is already present, returns an empty array
    #   - If an error occurs (typically a validation error), return an array
    #     with all the error messages.
    def self.new_page_with_default(fname)
        retval=[]
        old_page=Userpage.find_by_filename(fname)
        if old_page.nil?
            newpage=Userpage.new(filename: fname, linkname: File.basename(fname,'.*'), seqno: 0, valid_from: nil, valid_to: nil)
            if newpage.save
                retval=newpage.id
            else
                retval=newpage.errors.full_messages
            end
        end
        retval
    end

end
