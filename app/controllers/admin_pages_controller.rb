class AdminPagesController < ApplicationController

  AMP_DIR='app/views/pages' # Directory for admin-managed pages

  before_action except: [:adm_login_form, :adm_login] do
    unless adm_session?
        logger.info("Someone tries to break in!")
        flash[:error]='Das geht jetzt nicht.'
        redirect_to(root_path)
    end
  end

  before_action only: [:adm_upload_selected, :rm_uploaded_file] do
      unless File.directory? AMP_DIR
        logger.error("Directory #{AMP_DIR} has disappeared")
        flash[:error]="Jemand hat das Directory #{AMP_DIR} gelöscht! Rufen Sie die Polizei!"
        redirect_to(root_path)
      end
  end

  # can't do after_action here, because this must happen before rendering
  # after_action :prepare_admin_home_data, only: [:adm_login,:adm_upload_selected]

  def adm_login_form
      render 'adm_login'
  end

  # params[:admpwd] contains password
  def adm_login
      # We first do only static comparision. Later, we allow
      #   a password to be stored encrypted in the database.
      if [Figaro.env.admpwd_a, Figaro.env.admpwd_7].any? { |pw| pw == params[:admpwd] }
          begin_adm_session
          prepare_admin_home_data
          logger.debug('+++++++ rendering '+admin_pages_home_path)
          render admin_pages_home_path
      else
        flash.now[:error]='Ungültiges Administratorpasswort'
      end
  end

  def adm_logout
      end_adm_session
      redirect_to root_path
  end

  def home
    @pages=Dir["#{AMP_DIR}/*"].select {|entry| !File.directory? entry}
  end

  # params[:upload].tempfile : name of temporary file
  # params[:upload].original_filename : name of original file
  def adm_upload_selected
      if params[:upload].nil?
        flash.now[:error]='Es wäre schon gut, vor dem Upload eine Datei auszuwählen'
      else
        fpath=params[:upload].tempfile
        fbasename=File.basename(params[:upload].original_filename)
        # tempf=File.open(fpath,'r:BOM|UTF-8')
        FileUtils.cp fpath, AMP_DIR+'/'+fbasename # Throws exception if it fails
        # tempf.close
        File.unlink(fpath) # Throws exception if it fails
        # Put information on it into DB.
        # Only adds to DB if not exists yet, otherwise old entry is kept
        added_info=Userpage.new_page_with_default(fbasename)
        if added_info.kind_of?(Array)
            if added_info.length == 0
                flash.now[:info]="Neue Version von #{fbasename} gespeichert."
            else
                flash.now[:error]="Fehler beim Speichern in die Datenbank: "+added_info.to_sentence
            end
        else
            flash.now[:info]="Datei #{fbasename} gespeichert."
        end
      end
      prepare_admin_home_data
      render admin_pages_home_path
  end

  # params[:name] : Name of file to be deleted (without path component)
  def rm_uploaded_file
      deleatur=params[:name]
      # Plausibility check: must not go updir
      if deleatur.nil? or deleatur.include?('..')
        flash[:error]="Suspicious file! .... "+deleatur.to_s
      else
        fpath="#{AMP_DIR}/#{deleatur}"
        if File.file?(fpath)
            begin
                up=Userpage.find_by_filename(deleatur)
                up.destroy unless up.nil?
                File.delete(fpath)
                flash[:success]="Die Datei #{deleatur} ist entfernt worden"
            rescue Errno::ENOENT
                flash[:warning]="Die Datei #{deleatur} ist in diesem Moment verschwunden"
            rescue Exception => e
                flash[:error]="Exception #{e.class.to_s} : #{e.message}"
            end
        else
            flash[:warning]="Die Datei #{deleatur} existiert nicht mehr"
        end
      end
      prepare_admin_home_data
      redirect_to admin_pages_home_path
  end

private

    def prepare_admin_home_data
        @pages=Dir["#{AMP_DIR}/*"] # dotfiles automatically excluded
        logger.debug("+++++++++++ pages #{@pages.to_s}")
    end
end
