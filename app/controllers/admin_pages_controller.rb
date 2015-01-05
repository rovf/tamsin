class AdminPagesController < ApplicationController

  AMP_DIR='app/views/pages' # Directory for admin-managed pages

  before_action except: [:adm_login_form, :adm_login] do
    unless adm_session?
        logger.info("Someone tries to break in!")
        flash[:error]='Das geht jetzt nicht.'
        redirect_to(root_path)
    end
  end

  before_action only: [:adm_upload_selected] do
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
        errmsg=nil
        fpath=params[:upload].tempfile
        # tempf=File.open(fpath,'r:BOM|UTF-8')
        FileUtils.cp fpath, AMP_DIR+'/'+File.basename(params[:upload].original_filename) # Throws exception if it fails
        # tempf.close
        File.unlink(fpath)
        unless errmsg.nil?
            flash.now[:error]=errmsg
        end
      end
      prepare_admin_home_data
      render admin_pages_home_path
  end

private

    def prepare_admin_home_data
        @pages=Dir["#{AMP_DIR}/*"] # dotfiles automatically excluded
        logger.debug("+++++++++++ pages #{@pages.to_s}")
    end
end
