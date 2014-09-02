module AdminPagesHelper

    def begin_adm_session
        session[:q]='.'
    end

    def end_adm_session
        session[:q]=':'
    end

    def adm_session?
        session[:q] == '.'
    end
    
end
