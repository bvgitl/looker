view: web_commandes {
  sql_table_name: `Matillion_Perm_Table.COMMANDES`
    ;;
    label: "Commande"

  dimension: compound_primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${cd_commande}) ;;
  }

  dimension: cd_commande {
    type: string
    sql: ${TABLE}.cd_commande ;;
    label: "Numéro Commande"
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
    label: "Numéro Client"
    hidden: yes
  }

  dimension: Canal_commande {
    type: string
    sql: ${TABLE}.Canal_commande ;;
    label: "Type Livraison"
  }

  dimension: Total_HT {
    type: number
    sql: ${TABLE}.Total_HT ;;
    hidden: yes
  }

  dimension: Tarif_HT_livraison {
    type: number
    sql: ${TABLE}.Tarif_HT_livraison ;;
    hidden: yes
  }

  dimension: statut {
    type: string
    sql: ${TABLE}.statut ;;
    label: "Etat Commande"
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.cd_magasin ;;
    label: "Code Magasin"
    view_label: "Magasin"
  }

  dimension_group: dte_commande {
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
    datatype: timestamp
    sql: ${TABLE}.dte_commande ;;
    label: "Date Commande"
  }


  measure: ca_ht {
    type: sum_distinct
    value_format_name: eur
    sql_distinct_key: ${cd_commande} ;;
    sql: ${Total_HT} ;;
    label: "CA HT"
  }

  measure: frais_livraison_ht {
    type: sum_distinct
    value_format_name: eur
    sql_distinct_key: ${cd_commande} ;;
    sql: ${Tarif_HT_livraison} ;;
    label: "Frais Livraison HT"
  }

}
