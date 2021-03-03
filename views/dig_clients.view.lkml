view: dig_clients {
  sql_table_name: `ods.dig_clients`
    ;;

  dimension: adresse_de_livraison {
    type: string
    sql: ${TABLE}.Adresse_de_livraison ;;
  }

  dimension: adresse_de_livraison_2 {
    type: string
    sql: ${TABLE}.Adresse_de_livraison_2 ;;
  }

  dimension: code_client {
    type: number
    sql: ${TABLE}.Code_client ;;
  }

  dimension: code_magasin {
    type: string
    sql: ${TABLE}.Code_Magasin ;;
  }

  dimension: code_postal_de_livraison {
    type: string
    sql: ${TABLE}.Code_postal_de_livraison ;;
  }

  dimension: code_postal_de_livraison_2 {
    type: string
    sql: ${TABLE}.Code_postal_de_livraison_2 ;;
  }

  dimension: date_de_creation {
    type: string
    sql: ${TABLE}.Date_de_creation ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.Email ;;
  }

  dimension: enseigne {
    type: string
    sql: ${TABLE}.Enseigne ;;
  }

  dimension: nom {
    type: string
    sql: ${TABLE}.Nom ;;
  }

  dimension: nom_adresse_de_livraison {
    type: string
    sql: ${TABLE}.Nom_Adresse_de_livraison ;;
  }

  dimension: nom_adresse_de_livraison_2 {
    type: string
    sql: ${TABLE}.Nom_Adresse_de_livraison_2 ;;
  }

  dimension: numero_de_tva_intracommunautaire {
    type: string
    sql: ${TABLE}.Numero_de_TVA_intracommunautaire ;;
  }

  dimension: prenom {
    type: string
    sql: ${TABLE}.Prenom ;;
  }

  dimension: prenom_adresse_de_livraison {
    type: string
    sql: ${TABLE}.Prenom_Adresse_de_livraison ;;
  }

  dimension: prenom_adresse_de_livraison_2 {
    type: string
    sql: ${TABLE}.Prenom_Adresse_de_livraison_2 ;;
  }

  dimension: raison_sociale {
    type: string
    sql: ${TABLE}.Raison_sociale ;;
  }

  dimension: siret {
    type: string
    sql: ${TABLE}.Siret ;;
  }

  dimension: telephone_adresse_de_livraison {
    type: string
    sql: ${TABLE}.Telephone_Adresse_de_livraison ;;
  }

  dimension: telephone_adresse_de_livraison_2 {
    type: string
    sql: ${TABLE}.Telephone_Adresse_de_livraison_2 ;;
  }

  dimension: telephone_adresse_de_livraison_3 {
    type: string
    sql: ${TABLE}.Telephone_Adresse_de_livraison_3 ;;
  }

  dimension: type_de_client {
    type: string
    sql: ${TABLE}.Type_de_client ;;
  }

  dimension: ville_de_livraison {
    type: string
    sql: ${TABLE}.Ville_de_livraison ;;
  }

  dimension: ville_de_livraison_2 {
    type: string
    sql: ${TABLE}.Ville_de_livraison_2 ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
