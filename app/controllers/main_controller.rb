class MainController < ApplicationController
  
  def index
    session_id = request.headers['X-Session-Id'] 
    msisdn =  request.headers['X-Msisdn'] 
    Rails.logger.debug("SESSIONID: #{session_id}\nMSISDN: #{msisdn}\nQUERY_STRING: #{request.headers['QUERY_STRING']}")
    Rails.logger.debug("PARAMS_APP_ENTRIES: #{params}")
    if session_id.blank?
      res = session_ended_page.html_safe
    else
      page = ""
      ussd_input = ""
      if params[:page]
        page = params[:page]
      else
        page = "main"
      end

      if(params[:ussd_input])
        ussd_input = params[:ussd_input] 
      else
        if params[:option]
            ussd_input = params[:option]
        else
            ussd_input = ""
        end
      end

      ussd_data = {
        page: page,
        session_id: session_id,
        msisdn: msisdn,
        ussd_input: ussd_input
      }
      Rails.logger.debug("USSD_ENTRIES: #{ussd_data}")
      ussd_result = UssdManager.display_menu(ussd_data)
      if ussd_result.status == 200
        data = ussd_result.data
        message = data[:text].html_safe
        current_session = data[:ussd_session]
        if current_session[:confirmation] == 'OK' #&& page.include?('confirmation')
          payment_data = {}
          payment_data[:msisdn] = current_session[:msisdn]
          payment_data[:transaction_type] = current_session[:transaction_type]
          payment_data[:amount] = current_session[:total_amount].to_f
          payment_data[:currency] = 'GNF'
          payment_data[:wallet] = 'orange_guinee'
          payment_data[:payload] = {
            description: 'USSD GUINÉE CONTRAVENTION',
            transaction_fees: current_session[:fees].to_f,
            operation_type: current_session[:operation_type],
            contravention_type: current_session[:operation_type],
            ticket_number: current_session[:ticket_number],
            agent: current_session[:agent],
            contravention_notebook: current_session[:notebook],
            sheet_number: current_session[:ticket_input]
          }

          Rails.logger.debug(payment_data)
          backend_service = PaymentProcessor.call(params: payment_data)
          @error = backend_service.response['status'] != 200
          message = backend_service.response['message'].html_safe
          SessionManager.delete_session(session_id)
        end

        if @error
          res = backend_error(backend_service.response['status']).html_safe
        else
          res = message
        end
      else
        res = error_page.html_safe
      end

    end
    Rails.logger.debug("HTML RESPONSE: ============>>\n #{res}\n <<============")
    render html: res 
  end

  private
  
  def error_page
    '<html><head><bearer>FINISH</bearer></head><body> Service indisponible.<br />Veuillez reéssayer plus tard.</body></html>'
  end

  def session_ended_page
    '<html><head><bearer>FINISH</bearer></head><body>Désolé, votre session a expiré.<br /></body></html>'
  end

  def backend_error(code)
    case code
    when 422
      "<html><head><bearer>FINISH </bearer></head><body>Désolé, les informations que vous avez fournies ne sont pas correctes.<br />Veuillez reprendre l'opération.</body></html>"
    when 424
      '<html><head><bearer>FINISH </bearer></head><body>Désolé, le paiement a échoué.<br />Veuillez reéssayer plus tard.</body></html>'
    else
      error_page
    end
  end
end
