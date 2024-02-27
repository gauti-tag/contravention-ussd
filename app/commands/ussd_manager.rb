module UssdManager
  PLAFOND_TICKET = 5
  PLATFORM = '2'
  # texte des menus
   
  # Class variable to handle contravention fees
  #@@fees = SessionManager.fetch_parameters.first.symbolize_keys[:value].to_i

  # Principal Menu
  def self.main_menu
    %Q[<html>
        <body>Bienvenue !. <br />S&eacute;lectionnez votre service:<br />
            <a href="/MMGG/menu?page=traffic-ticket&option=1" key="1">. Faire un paiement</a>
            <br />
            <a href="/MMGG/menu?page=traffic-ticket&option=2" key="2">. Verifier un paiement</a>
            <br />
            <a href="/MMGG/menu?page=error" default="true"></a>
            <br />
        </body>
    </html>]
  end

  def self.retry_main_menu   
    %Q[<html>
        <body>Attention, saisie invalide ! <br />Bienvenue !. <br />S&eacute;lectionnez votre service: <br />
            <a href="/MMGG/menu?page=traffic-ticket&option=1" key="1">. Faire un paiement</a>
            <br />
            <a href="/MMGG/menu?page=traffic-ticket&option=2" key="2">. Verifier un paiement</a>
            <br />
            <a href="/MMGG/menu?page=error" default="true"></a>
            <br />
        </body>
    </html>]
  end


   ###
  # Etape 2: Verifier un paiement
  ###
  # Step 1
  def self.verification_traffic_ticket_menu 
    %Q[<!DOCTYPE html>
        <html>
            <body>
            Veuillez saisir le code de verification recu par sms et valider :<br>
            <br>
            <form action="/MMGG/menu?page=verify-traffic-ticket" method="post">
                <input type="text" name="ussd_input">
            </form><a href="/MMGG/menu?page=main&amp;option=0" key="0">. Accueil</a><br>
            <a href="/MMGG/menu?page=main&amp;option=00" key="00">. Pr&eacute;c&eacute;dent</a><br>
            </body>
        </html>]
  end

  # Step 2
  def self.verification_traffic_ticket_confirmation_menu(session)
    %Q[<html>
            <body>
                <p> 
                    Votre contravention #{session[:verified_ticket_number]} du carnet #{session[:verified_notebook]} et de l&apos;agent #{session[:verified_agent]} a ete payee avec succes #{session[:payment_date]}.
                </p>
            </body>
        </html>]
  end

  def self.unknown_traffic_ticket_confirmation_menu(session)
     %Q[<html>
            <body>
                <p> 
                    Votre contravention #{session[:unverified_ticket_number]} n&apos;apparait pas dans notre base
                </p>
            </body>
        </html>]
  end

  ###
  # Etape 1: Faire un paiement
  ###

  ### Step 1
  def self.traffic_ticket_notebook_menu 
    %Q[<html>
        <body> Veuillez saisir le code de la contravention et valider:
        <br /><br />
        <form action="/MMGG/menu?page=notebook-number" method="POST">
            <input type="text" name="ussd_input">
        </form>
        <a href="/MMGG/menu?page=main&option=0" key="0">. Accueil</a> <br />
        <a href="/MMGG/menu?page=main&option=00" key="00">. Pr&eacute;c&eacute;dent</a><br />
        </body>
    </html>]
  end
  # Retry Step 1
  def self.retry_traffic_ticket_notebook_menu
    %Q[<html>
        <body> Attention, saisie invalide ! <br />Veuillez saisir le code de la contravention et valider:
        <br /><br />
        <form action="/MMGG/menu?page=notebook-number" method="POST">
            <input type="text" name="ussd_input">
        </form>
        <a href="/MMGG/menu?page=main&option=0" key="0">. Accueil</a> <br />
        <a href="/MMGG/menu?page=main&option=00" key="00">. Précédent</a><br />
        </body>
    </html>]
  end

 ### Step 2
  def self.traffic_ticket_number_menu 
    %Q[<html>
        <body> Veuillez saisir le numero de carnet de la contravention et valider:
        <br /><br />
        <form action="/MMGG/menu?page=ticket-number" method="POST">
            <input type="text" name="ussd_input">
        </form>
        <a href="/MMGG/menu?page=main&option=0" key="0">. Accueil</a> <br />
        <a href="/MMGG/menu?page=notebook-number&option=00" key="00">. Pr&eacute;c&eacute;dent</a><br />
        </body>
    </html>]
  end
  # Retry Step 2
  def self.retry_traffic_ticket_number_menu    
    %Q[<html>
        <body> Attention, saisie invalide ! <br /> Veuillez saisir le numero de carnet de la contravention et valider:
        <br /><br />
        <form action="/MMGG/menu?page=ticket-number" method="POST">
            <input type="text" name="ussd_input">
        </form>
        <a href="/MMGG/menu?page=main&option=0" key="0">. Accueil</a> <br />
        <a href="/MMGG/menu?page=notebook-number&option=00" key="00">. Pr&eacute;c&eacute;dent</a><br />
        </body>
    </html>]
  end
  
  ### Step 3
  def self.traffic_ticket_agent_menu 
    %Q[<html>
        <body>Veuillez saisir le numero de l&apos;agent et valider:
        <br /><br />
        <form action="/MMGG/menu?page=agent-number" method="POST">
            <input type="text" name="ussd_input">
        </form>
        <a href="/MMGG/menu?page=main&option=0" key="0">. Accueil</a> <br />
        <a href="/MMGG/menu?page=ticket-number&option=00" key="00">. Pr&eacute;c&eacute;dent</a><br />
        </body>
    </html>]
  end
  # Retry Step 3
  def self.retry_traffic_ticket_agent_menu 
    %Q[<html>
        <body>Attention, saisie invalide ! <br />Veuillez saisir le numero de l&apos;agent et valider:
        <br /><br />
        <form action="/MMGG/menu?page=agent-number" method="POST">
            <input type="text" name="ussd_input">
        </form>
        <a href="/MMGG/menu?page=main&option=0" key="0">. Accueil</a> <br />
        <a href="/MMGG/menu?page=ticket-number&option=00" key="00">. Pr&eacute;c&eacute;dent</a><br />
        </body>
    </html>]

  end

  ### Step 4
  def self.traffic_input_ticket_menu
    %Q[<html>
        <body>Veuillez saisir le numero de la contravention et valider
        <br /><br />
        <form action="/MMGG/menu?page=traffic-payment" method="POST">
            <input type="text" name="ussd_input">
        </form>
        <a href="/MMGG/menu?page=main&option=0" key="0">. Accueil</a> <br />
        <a href="/MMGG/menu?page=agent-number&option=00" key="00">. Pr&eacute;c&eacute;dent</a><br />
        </body>
    </html>]
  end
  
  # Retry Step 4
  def self.retry_traffic_input_ticket_menu
    %Q[<html>
        <body>Attention, saisie invalide ! <br />Veuillez saisir le numero de la contravention et valider
        <br /><br />
        <form action="/MMGG/menu?page=traffic-payment" method="POST">
            <input type="text" name="ussd_input">
        </form>
        <a href="/MMGG/menu?page=main&option=0" key="0">. Accueil</a> <br />
        <a href="/MMGG/menu?page=agent-number&option=00" key="00">. Pr&eacute;c&eacute;dent</a><br />
        </body>
    </html>]
  end
  
  ### Recap Payment
  def self.traffic_ticket_payment_menu(session) 
    %Q[<html>
        <body> Vous allez regler votre contravention pour #{session[:type_label]} :
        <br />
            Montant: #{session[:amount]} GNF<br/>
            Frais: #{session[:fees]} GNF<br/>
            <br />
            <a href="/MMGG/menu?page=traffic-ticket-confirmation&option=1" key="1">. Confirmer</a>
            <br />
            <a href="/MMGG/menu?page=traffic-ticket-confirmation&option=2" key="2">. Annuler</a>
            <br />
            <a href="/MMGG/menu?page=main&option=0" key="0">. Accueil</a> <br />
            <a href="/MMGG/menu?page=agent-number&option=00" key="00">. Pr&eacute;c&eacute;dent</a><br />
        </body>
    </html>]
  end
  
  ### Thanks Message when payment is success
  def self.traffic_ticket_confirmation_menu
    %Q[<html>
      <body>
            <p> 
                Veuillez patienter. Vous allez recevoir un message pour confirmer le paiement Mobile Money...
            </p>     
      </body>
    </html>]
  end

  ### Message When payment failed
  def self.cancel_menu
    %Q[<html>
        <head>
            <bearer>FINISH</bearer>
        </head>
        <body>
            <p> 
                L&apos;op&eacute;ration a &eacute;t&eacute; annul&eacute;e.
            </p>     
        </body>
    </html>]
  end

  # Création d'une nouvelle session utilisateur si elle n'existe pas et récupération de la session si elle existe
  def self.get_or_create_session(session_object)  
    # Recherche d'une session existante
    session_id = session_object[:session_id]
    ussd_session = SessionManager.find_session(session_id)

    return OpenStruct.new(status: 200, data: ussd_session) if ussd_session.present?

    if session_object[:page] == 'main'
      session_record = UssdSession.create_with(msisdn: session_object[:msisdn], status: 1, ussd_content: session_object[:ussd_input], started_at: Time.now).find_or_create_by(session_id: session_id)
      ussd_session = session_object.clone
      ussd_session[:msisdn] = session_object[:msisdn]
      ussd_session[:transaction_id] = session_record.ussd_trnx_id
      SessionManager.set_session(session_id, ussd_session)
      return OpenStruct.new(status: 200, data: ussd_session)
    else
      session_record = UssdSession.find_or_create_by(session_id: session_id)
      session_record.update(msisdn: session_object[:msisdn], status: 2, ussd_content: session_object[:ussd_input], ended_at: Time.now)
      SessionManager.delete_session(session_id)
      return OpenStruct.new(status: 400, message: 'Session end.')
    end
  end

  # Affichage du menu à l'utilisateur en fonction de son parcours client
  def self.display_menu(content)
    # Création d'un hash de session
    session_data = get_or_create_session(content)
    return session_data if session_data.status != 200
    
    ussd_session = session_data.data
    ussd_session.symbolize_keys!
    response  = {}
    return OpenStruct.new(status: 200, data: display_main_menu(ussd_session)) if content[:ussd_input] == '0' || content[:page] == 'main' 
    ussd_session[:ussd_input] = content[:ussd_input]
    session_id = content[:session_id]
    #ussd_session[:option] = content[:option]
   
    case content[:page] #ussd_session[:cursor]
    # Pour un message de type begin, on affiche le menu principal
    when 'main'
        # Menu principal
        response = display_main_menu(ussd_session)
    when 'traffic-ticket'
        response = display_traffic_ticket_menu(ussd_session)
    when 'verify-traffic-ticket'
        response = display_verification_traffic_ticket_menu(ussd_session)
    when 'notebook-number'
        response = display_traffic_ticket_notebook_menu(ussd_session)
    when 'ticket-number'
        response = display_traffic_ticket_number_menu(ussd_session)
    when 'agent-number'
        response = display_traffic_ticket_agent_menu(ussd_session)
    when 'traffic-payment'
        response = display_traffic_ticket_payment_menu(ussd_session)
    when 'traffic-ticket-confirmation'
        response = display_traffic_ticket_confirmation_menu(ussd_session)
    end
    
    

    if response[:status] == 1
      new_session = response[:ussd_session]
      SessionManager.set_session(session_id, new_session)
    else
      SessionManager.delete_session(session_id)
      session_record = UssdSession.find_by(session_id: session_id)
      session_record.update(ended_at: Time.now)
    end
    OpenStruct.new(status: 200, data: response)
  end


  # Menu - menu principal
  def self.display_main_menu(ussd_session)
    new_session = ussd_session.clone
    new_session[:confirmation] = 'NOK'
    new_session[:ussd_input] = ''
    text = main_menu 
    {ussd_session: new_session, text: text, status: 1}
  end

  # Menu - Selon le choix de l'utilisateur sur le menu principal
  def self.display_traffic_ticket_menu(ussd_session)
    new_session = ussd_session.clone
    input = new_session[:ussd_input].to_i
    new_session[:transaction_type] = 'traffic_ticket'
    text = ''
    if input == 1
        text = traffic_ticket_notebook_menu 
    elsif input == 2
        text = verification_traffic_ticket_menu
    elsif input == 00 
        text = main_menu
    else
        text = retry_main_menu 
    end
    
    {ussd_session: new_session, text: text, status: 1}
  end

  def self.display_verification_traffic_ticket_menu(ussd_session)
    new_session = ussd_session.clone
    text= ''
    ticket_code = ussd_session[:ussd_input].to_s
    data = SessionManager.fetch_transactions_filter('success', ticket_code)
    
    if data.present?
        new_session[:verified_ticket_number] = data['ticket_number']
        new_session[:verified_notebook] = data['contravention_notebook_code']
        new_session[:verified_agent] = data['contravention_agent_identifier']
        new_session[:payment_date] = Time.parse(data['created_at']).strftime('le %d/%m/%Y a %R')
        text = verification_traffic_ticket_confirmation_menu(new_session).strip
    else
        # Retour menu précédent
        if ticket_code == '00'
           #new_session[:cursor] = 'traffic-ticket'
           text = main_menu #(new_session)
        else
         # Message pour signifier au client que la transaction n'existe pas
          new_session[:unverified_ticket_number] = ticket_code
          text = unknown_traffic_ticket_confirmation_menu(new_session).strip
        end
    end

    {ussd_session: new_session, text: text, status: 1}
  end



  def self.display_traffic_ticket_notebook_menu(ussd_session)
    new_session = ussd_session.clone
    type = ussd_session[:ussd_input].to_s.strip
    type.upcase
    data = SessionManager.fetch_contravention_type type
    text = ''
    if data.present?
        new_session[:type_code] = data["code"]
        new_session[:type_label] = I18n.transliterate(data["label"].to_s.strip)
        new_session[:type_label] = new_session[:type_label].truncate(30)
        new_session[:type_amount] = data["amount"]
        new_session[:operation_type] = data["code"]
        #text = traffic_ticket_menu(group)
        #new_session[:cursor] = 'ticket-number' 
        text = traffic_ticket_number_menu #(new_session)
    else
         # Retour menu précédent
      if ussd_session[:ussd_input] == '00'
        #new_session[:cursor] = 'notebook-number'
        text = main_menu #(ussd_session)
      else
        text = retry_traffic_ticket_notebook_menu #(ussd_session)
      end
    end
    {ussd_session: new_session, text: text, status: 1}
  end
  
  # Menu - Selon le choix de l'utilisateur sur le menu principal
  def self.display_traffic_ticket_number_menu(ussd_session)
    new_session = ussd_session.clone
    notebook_code = ussd_session[:ussd_input].to_s.strip

    if valid_notebook_code?(notebook_code.upcase) 
      #new_session[:cursor] = 'agent-number'
      new_session[:notebook] = notebook_code.upcase
      text = traffic_ticket_agent_menu #(ussd_session)
    else
      # Retour menu précédent
      if ussd_session[:ussd_input] == '00'
        #new_session[:cursor] = 'ticket-number'
        text = traffic_ticket_number_menu #(new_session)
      else
        # Saisie invalide, le client se voit réafficher le même menu
        #new_session[:cursor] = 2
        text = retry_traffic_ticket_number_menu #(new_session)
      end
    end
    {ussd_session: new_session, text: text, status: 1}
  end

  def self.display_traffic_ticket_agent_menu(ussd_session)
    new_session = ussd_session.clone
    agent_number = ussd_session[:ussd_input].to_s.strip

    if valid_agent_identifier?(agent_number.upcase)  
        #new_session[:cursor] = 'traffic-payment'
        new_session[:agent] = agent_number.upcase
        text = traffic_input_ticket_menu #(new_session)
    else
      # Retour menu précédent
      if ussd_session[:ussd_input] == '00'
        #new_session[:cursor] = 'agent-number'
        text = traffic_ticket_agent_menu #(ussd_session)
      else
        # Saisie invalide, le client se voit réafficher le même menu
        text = retry_traffic_ticket_agent_menu #(ussd_session)
      end
    end
    {ussd_session: new_session, text: text, status: 1}
  end
 
  def self.display_traffic_ticket_payment_menu(ussd_session)
    new_session = ussd_session.clone
    ticket_input = ussd_session[:ussd_input].to_s.strip

    if valid_number?(ticket_input) != nil 
        #new_session[:cursor] = 'traffic-ticket-confirmation'
        new_session[:ticket_input] = ticket_input.upcase
        new_session[:amount] = new_session[:type_amount].to_i
        new_session[:fees] =  SessionManager.fetch_parameters.first.symbolize_keys[:value].to_i
        new_session[:total_amount] = new_session[:type_amount].to_i + new_session[:fees]
        text = traffic_ticket_payment_menu(new_session)
    else
      # Retour menu précédent
      if ussd_session[:ussd_input] == '00'
        #new_session[:cursor] = 'traffic-payment'
        text = traffic_input_ticket_menu #(new_session)
      else
        # Saisie invalide, le client se voit réafficher le même menu
        #new_session[:cursor] = 3
        text = retry_traffic_input_ticket_menu #(ussd_session)
      end
    end
    {ussd_session: new_session, text: text, status: 1}
  end


  def self.display_traffic_ticket_confirmation_menu(ussd_session)
    new_session = ussd_session.clone
    #confirmation = ussd_session[:option].to_s
    #new_session[:cursor] = 'traffic-ticket-confirmation'
    confirmation = ussd_session[:ussd_input].to_s
    
    if confirmation == "1"
        new_session[:ticket_number] = increment_number.to_s
        new_session[:confirmation] =  'OK'
        text = traffic_ticket_confirmation_menu #(new_session)
    else
        new_session[:confirmation] = 'NOK'
        text = cancel_menu
    end
    
    {ussd_session: new_session, text: text, status: confirmation.to_i}
  end

   # Vérification des numéros saisis
  def self.valid_number?(number_value)
    /^[a-zA-Z0-9\S]*$/.match(number_value.to_s)
  end

   # Method to control Agent Identifier
  def self.valid_agent_identifier?(identifier)
    agent_identifiers = []
    agents = SessionManager.contravention_agents
    agents.each { |agent| agent_identifiers << agent['identifier'].upcase }
    agent_identifiers.include?(identifier.upcase)
  end
 
 # Method to controle Notebook number
 def self.valid_notebook_code?(number)
   notebook_codes = []
   notebooks = SessionManager.contravention_notebooks
   notebooks.each { |notebook| notebook_codes << notebook['number'].upcase }
   notebook_codes.include?(number.upcase)
 end

 def self.valid_ticket?(ticket)
   ticket_numbers = []
   tickets = SessionManager.transactions
   tickets.each { |ticket| ticket_numbers << ticket['ticket_number'] }
   ticket_numbers.include?(ticket)
 end

 def self.increment_number
   counter = ''
   base_date = SessionManager.get_orange_date_month
   if base_date.nil?
       SessionManager.set_orange_date_month Time.now.end_of_month.to_i
       SessionManager.set_orange_counter 1
       counter = SessionManager.get_orange_counter 

   else
       if Time.current.to_i < base_date.to_i
           counter = SessionManager.get_orange_counter.to_i + 1
           SessionManager.set_orange_counter counter
       else
           SessionManager.set_orange_date_month Time.now.end_of_month.to_i
           SessionManager.set_orange_counter 1
           counter = SessionManager.get_orange_counter 
       end
   end

   count_char = counter.to_s.size
   zero_size = PLAFOND_TICKET - count_char
   ticket = '0' * zero_size + counter.to_s
   "#{Time.now.strftime("%y%m")}#{PLATFORM}#{ticket}"
 end

end
