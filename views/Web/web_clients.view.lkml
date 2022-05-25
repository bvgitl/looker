view: web_clients {
  sql_table_name: `Matillion_Perm_Table.clients_web`
    ;;
  label: "Client"

  dimension: compound_primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${customer_id}) ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
    label: "Numéro Client"
  }

  dimension: type_client {
    type: string
    sql: ${TABLE}.type_client ;;
    label: "Type Client"
  }

  dimension: categorie_pro {
    type: string
    sql: ${TABLE}.categorie_pro ;;
    label: "Catégorie Client"
  }

  dimension: codezip_livraison {
    type: string
    sql: ${TABLE}.codezip_livraison ;;
    label: "Code Postal Livraison"
  }

  dimension: codezip_facturation {
    type: string
    sql: ${TABLE}.codezip_facturation ;;
    label: "Code Postal Facturation"
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
    sql: ${TABLE}.date_derniere_connexion ;;
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
    sql: ${TABLE}.date_creation ;;
    label: "Date Création Client"
  }

}
