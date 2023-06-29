view: web_clients {
  #sql_table_name: `Matillion_Perm_Table.Web_Inter_Client`
  sql_table_name: (SELECT * FROM `Matillion_Perm_Table.Web_Inter_Client` WHERE CodeTerritoire = 'fr_FR')
    ;;
  label: "Client"

  dimension: compound_primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${customer_id}, ${code_territoire}) ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.CustomerId ;;
    label: "Numéro Client"
  }

  dimension: type_client {
    type: string
    sql: ${TABLE}.TypeClient ;;
    label: "Type Client"
  }

  dimension: categorie_pro {
    type: string
    sql: ${TABLE}.CategoriePro ;;
    label: "Catégorie Client"
  }

  dimension: codezip_livraison {
    type: string
    sql: ${TABLE}.CodePostalLivraison ;;
    label: "Code Postal Livraison"
  }

  dimension: codezip_facturation {
    type: string
    sql: ${TABLE}.CodePostalFacturation ;;
    label: "Code Postal Facturation"
  }

  dimension: code_territoire {
    type: string
    sql: ${TABLE}.CodeTerritoire ;;
    label: "Code Territoire"
  }

  dimension_group: date_derniere_connexion {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.DateDerniereConnexion ;;
    label: "Date Dernière Connexion"
  }

  dimension_group: date_creation {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.DateCreation ;;
    label: "Date Création Client"
  }

}
