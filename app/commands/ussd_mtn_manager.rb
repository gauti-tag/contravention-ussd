module UssdMtnManager
  PLAFOND_TICKET = 5
  PLATFORM = '1'
  # texte des menus

  # Class variable to handle contravention fees
  #@@fees = SessionManager.fetch_parameters.first.symbolize_keys[:value].to_i

  def self.main_menu
    "Bienvenue !.\nSelectionnez votre service:\n1. Faire un paiement\n2. Verifier un paiement"
  end
  
  ###
  # Etape 2: Verifier un paiement
  ###
  # Step 1
  def self.verification_traffic_ticket_menu
    "Veuillez saisir le code de verification reçu par sms et valider :\n\n0. Accueil\n00. Precedent"
  end
  # Step 2
  def self.verification_traffic_ticket_confirmation_menu(session)
    "Votre contravention #{session[:verified_ticket_number]} du carnet #{session[:verified_notebook]} et de l’agent #{session[:verified_agent]} a été payée avec succès #{session[:payment_date]}"
  end

  def self.unknown_traffic_ticket_confirmation_menu(session)
    "Votre contravention #{session[:unverified_ticket_number]} n’apparait pas dans notre base"
  end


  ###
  # Etape 1: Faire un paiement
  ###
  
  # Step 1
  def self.traffic_ticket_group_menu
    "Veuillez saisir le code de la contravention et valider :\n\n0. Accueil\n00. Precedent"
  end
  
  # Step 2
 # def self.traffic_ticket_menu(group)
 #   ticket_types = SessionManager.fetch_contravention_types(group)
 #   tickets_tag = ''
 #   ticket_types.each_with_index { |draw, index| tickets_tag << "#{index + 1}. #{I18n.transliterate(draw['label'].to_s.strip)}\n" }
 #   #%(Veuillez selectionner la Contravention sanctionnee:\n#{tickets_tag}\n0. Accueil\n00. Precedent)
 #   "Veuillez selectionner la Contravention sanctionnee:\n#{tickets_tag}\n0. Accueil\n00. Precedent"
 # end

  #def self.traffic_ticket_menu
  #  ticket_types = SessionManager.contravention_types
  #  tickets_tag = ''
  #  ticket_types.each_with_index { |draw, index| tickets_tag << "#{index + 1}. #{draw['label']}\n" }
  #  %(Veuillez selectionner la Contravention sanctionnee:\n#{tickets_tag}\n0. Accueil)
  #end

  def self.traffic_ticket_notebook_menu
    "Veuillez saisir le numero de carnet de la contravention et valider :\n\n0. Accueil\n00. Precedent"
  end

  def self.traffic_ticket_agent_menu
    "Veuillez saisir le numero de l'agent et valider :\n\n0. Accueil\n00. Precedent"
  end

  def self.traffic_ticket_number_menu
    "Veuillez saisir le numero de la contravention et valider :\n\n0. Accueil\n00. Precedent"
  end

  def self.traffic_ticket_payment_menu(session)
    "Vous allez regler votre contravention pour #{session[:type_label]}\nMontant: #{session[:type_amount]} GNF\nFrais: #{session[:fees]} GNF\n1. Confirmer\n2. Annuler\n0. Accueil\n00. Precedent"
  end

  def self.traffic_ticket_confirmation_menu(session)
        "Veuillez patienter. Vous allez recevoir un message pour confirmer le paiement Mobile Money..."
  end

  def self.cancel_menu
        "L'operation a ete annulee."
  end

  # Création d'une nouvelle session utilisateur si elle n'existe pas ou récupération de la session si elle existe
  def self.get_or_create_session(session_object)
    # Recherche d'une session existante
    session_id = session_object[:session_id]
    ussd_session = SessionManager.find_session(session_id)

    return OpenStruct.new(status: 200, data: ussd_session) if ussd_session.present?

    if session_object[:new_request] == 1
      session_record = UssdSession.create_with(msisdn: session_object[:msisdn], status: 1, ussd_content: session_object[:ussd_input], started_at: Time.now).find_or_create_by(session_id: session_id)
      ussd_session = session_object.clone
      ussd_session[:msisdn] = session_object[:msisdn]
      ussd_session[:transaction_id] = session_record.ussd_trnx_id
      ussd_session[:confirmation] = ''
      ussd_session[:cursor] = 0
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
    
    return OpenStruct.new(status: 200, data: display_main_menu(ussd_session)) if content[:ussd_input] == '0' # Retour sur le menu principal

    ussd_session[:ussd_input] = content[:ussd_input]
    session_id = content[:session_id]
    response  = {}
    cursor = ussd_session[:cursor].to_i

    if content[:new_request] == 1
      response = display_main_menu(ussd_session)
    else
      # Menu suivant selon le curseur
      case cursor
      when 0
        # Menu saisie le code du type de la contravention
        response = display_traffic_ticket_menu(ussd_session)
      when 1
        # Menu liste des types de contravention en fonction du code classe  
        response = display_traffic_ticket_group_menu(ussd_session)
      when 11
        # Menu saisie du n° de numéro de la contravention (verification paiement contravention)
        response = display_verification_traffic_ticket_menu(ussd_session)
      #when 2
        # saisir le type de contravention  
      #  response = display_traffic_ticket_notebook_menu(ussd_session)
      when 2 #3
        # Menu saisie du n° de carnet de contravention 
        response = display_traffic_ticket_agent_menu(ussd_session)
      when 3 #4
        # Menu saisie du n° de contravention
        response = display_traffic_ticket_number_menu(ussd_session)
      when 4 #5
        # Menu paiement de la contravention
        response = display_traffic_ticket_payment_menu(ussd_session)
      when 5 #6
        # Menu message de confirmation
        response = display_traffic_ticket_confirmation_menu(ussd_session)
      end
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
    new_session[:cursor] = 0
    new_session[:confirmation] = 'NOK'
    new_session[:ussd_input] = ''
    text = main_menu
    {ussd_session: new_session, text: text, status: 1}
  end


  # Menu - Selon le choix de l'utilisateur sur le menu principal
  def self.display_traffic_ticket_menu(ussd_session)
    new_session = ussd_session.clone
    text = ''
    input = ussd_session[:ussd_input].to_i
    if input == 1
      text = traffic_ticket_group_menu
      new_session[:cursor] = 1
      new_session[:transaction_type] = 'traffic_ticket'
    elsif input == 2
      text = verification_traffic_ticket_menu
      new_session[:cursor] = 11
    else
      # Saisie invalide, l'utilisateur se voit réafficher le menu principal
      text = %(Attention, saisie invalide !\n#{main_menu})
      new_session[:cursor] = 0
    end
    
    {ussd_session: new_session, text: text, status: 1}
  end

  ###
  # Etape 2: Display menus
  ###

  # step 1
  def self.display_verification_traffic_ticket_menu(ussd_session)
    new_session = ussd_session.clone
    text= ''
    ticket_number = ussd_session[:ussd_input].to_s
    data = SessionManager.fetch_transactions_filter('success', ticket_number)
    
    if data.present?
        new_session[:verified_ticket_number] = data['ticket_number']
        new_session[:verified_notebook] = data['contravention_notebook_code']
        new_session[:verified_agent] = data['contravention_agent_identifier']
        new_session[:payment_date] = Time.parse(data['created_at']).strftime('le %d/%m/%Y a %R')
        text = verification_traffic_ticket_confirmation_menu(new_session).strip
    else
        # Retour menu précédent
        if ticket_number == '00'
           new_session[:cursor] = 0
           text = main_menu
        else
         # Message pour signifier au client que la transaction n'existe pas
          new_session[:unverified_ticket_number] = ticket_number
          text = unknown_traffic_ticket_confirmation_menu(new_session).strip
        end
    end
      {ussd_session: new_session, text: text, status: 1}
  end
  


  ###
  # Etape 1: Display menus
  ###

  # step 1
  def self.display_traffic_ticket_group_menu(ussd_session)
    new_session = ussd_session.clone
    type = ussd_session[:ussd_input].to_s.strip
    type.upcase
    data = SessionManager.fetch_contravention_type type
    text = ''
    if data.present?
        new_session[:cursor] = 2
        new_session[:type_code] = data["code"]
        new_session[:type_label] = I18n.transliterate(data["label"].to_s.strip)
        new_session[:type_label] = new_session[:type_label].truncate(30)
        new_session[:type_amount] = data["amount"]
        new_session[:operation_type] = data["code"]
        #text = traffic_ticket_menu(group)
        text = traffic_ticket_notebook_menu
    else
         # Retour menu précédent
      if ussd_session[:ussd_input] == '00'
        new_session[:cursor] = 0
        text = main_menu
      else
        # Saisie invalide, le client se voit réafficher le même menu
        new_session[:cursor] = 1
        text = %(Attention, saisie invalide !\n#{traffic_ticket_group_menu})
      end
    end
    {ussd_session: new_session, text: text, status: 1}
  end
  
  # Step 2
  # Menu - Saisie numéro carnet de contravention
=begin  
  def self.display_traffic_ticket_notebook_menu(ussd_session)
    # L'utilisateur a choisi un type de contravention à payer
    indice_value = ussd_session[:ussd_input].to_i
    new_session = ussd_session.clone
    contravention_types = SessionManager.fetch_contravention_types(ussd_session[:group])
    if (1..contravention_types.size).cover?(indice_value)
      new_session[:cursor] = 3
      operation_type = contravention_types[indice_value-1]
      new_session[:operation_type] = operation_type['code']
      new_session[:amount] = operation_type['amount']
      text = traffic_ticket_notebook_menu
    else
      # Retour menu précédent
      if ussd_session[:ussd_input] == '00'
        new_session[:cursor] = 1
        text = traffic_ticket_group_menu
      else
        # Saisie invalide, le client se voit réafficher le même menu
        new_session[:cursor] = 2
        text = %(Attention, saisie invalide !\n#{traffic_ticket_menu(ussd_session[:group])})
      end
    end
    
    
    {ussd_session: new_session, text: text, status: 1}
  end
=end  
  # Step 3
  def self.display_traffic_ticket_agent_menu(ussd_session)
    new_session = ussd_session.clone
    notebook_code = ussd_session[:ussd_input].to_s.strip

    if valid_notebook_code?(notebook_code.upcase) 
      new_session[:cursor] = 3
      new_session[:notebook] = notebook_code.upcase
      text = traffic_ticket_agent_menu
    else
      # Retour menu précédent
      if ussd_session[:ussd_input] == '00'
        new_session[:cursor] = 1
        text = traffic_ticket_group_menu
      else
        # Saisie invalide, le client se voit réafficher le même menu
        new_session[:cursor] = 2
        text = %(Attention, saisie invalide !\n#{traffic_ticket_notebook_menu})
      end
    end
    {ussd_session: new_session, text: text, status: 1}
  end

  # Step 4
  # Menu - Saisie du numéro de contravention
  def self.display_traffic_ticket_number_menu(ussd_session)
    new_session = ussd_session.clone
    agent_number = ussd_session[:ussd_input].to_s.strip

    if valid_agent_identifier?(agent_number.upcase)  
        new_session[:cursor] = 4
        #new_session[:notebook] = notebook_number.upcase
        new_session[:agent] = agent_number.upcase
        text = traffic_ticket_number_menu
    else
      # Retour menu précédent
      if ussd_session[:ussd_input] == '00'
        new_session[:cursor] = 2
        text = traffic_ticket_notebook_menu
      else
        # Saisie invalide, le client se voit réafficher le même menu
        new_session[:cursor] = 3
        text = %(Attention, saisie invalide !\n#{traffic_ticket_agent_menu})
      end
    end
    {ussd_session: new_session, text: text, status: 1}
  end


  def self.display_traffic_ticket_payment_menu(ussd_session)
    new_session = ussd_session.clone
    ticket = ussd_session[:ussd_input].to_s.strip

    if !valid_ticket?(ticket) 
        new_session[:cursor] = 5
        new_session[:ticket_input] = ticket
        #new_session[:ticket_number] = increment_number.to_s
        new_session[:amount] = new_session[:type_amount].to_i
        new_session[:fees] =  SessionManager.fetch_parameters.first.symbolize_keys[:value].to_i
        new_session[:total_amount] = new_session[:type_amount].to_i + new_session[:fees]
        text = traffic_ticket_payment_menu(new_session).strip
    else
      # Retour menu précédent
      if ussd_session[:ussd_input] == '00'
        new_session[:cursor] = 3
        text = traffic_ticket_agent_menu
      else
        # Saisie invalide, le client se voit réafficher le même menu
        new_session[:cursor] = 4
        text = %(Attention, saisie invalide !\n#{traffic_ticket_number_menu})
      end
    end

    {ussd_session: new_session, text: text, status: 1}
  end

  def self.display_traffic_ticket_confirmation_menu(ussd_session)
    new_session = ussd_session.clone
    confirmation = ussd_session[:ussd_input].to_s.strip
    new_session[:cursor] = 0
    if confirmation == '1'
      new_session[:confirmation] = 'OK'
      new_session[:ticket_number] = increment_number.to_s
      text = traffic_ticket_confirmation_menu(new_session)
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
    base_date = SessionManager.get_mtn_date_month
    if base_date.nil?
        SessionManager.set_mtn_date_month Time.now.end_of_month.to_i
        SessionManager.set_mtn_counter 1
        counter = SessionManager.get_mtn_counter 

    else
        if Time.current.to_i < base_date.to_i
            counter = SessionManager.get_mtn_counter.to_i + 1
            SessionManager.set_mtn_counter counter
        else
            SessionManager.set_mtn_date_month Time.now.end_of_month.to_i
            SessionManager.set_mtn_counter 1
            counter = SessionManager.get_mtn_counter 
        end
    end

    count_char = counter.to_s.size
    zero_size = PLAFOND_TICKET - count_char
    ticket = '0' * zero_size + counter.to_s
    "#{Time.now.strftime("%y%m")}#{PLATFORM}#{ticket}"
  end

end
