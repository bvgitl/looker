view: dig_commandes {
  sql_table_name: `ods.dig_commandes`
    ;;

  dimension: code_client {
    type: string
    sql: ${TABLE}.Code_client ;;
  }

  dimension: code_commande {
    type: number
    sql: ${TABLE}.Code_commande ;;
  }

  dimension: code_magasin {
    type: string
    sql: ${TABLE}.Code_magasin ;;
  }

  dimension_group: date_de_commande {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.Date_de_commande ;;
  }

  dimension: email_du_client {
    type: string
    sql: ${TABLE}.Email_du_client ;;
  }

  dimension: montant_tv {
    type: number
    sql: ${TABLE}.Montant_TV ;;
  }

  dimension: nom_client {
    type: string
    sql: ${TABLE}.Nom_client ;;
  }

  dimension: prenom_client {
    type: string
    sql: ${TABLE}.Prenom_client ;;
  }

  dimension: statut {
    type: string
    sql: ${TABLE}.Statut ;;
  }

  dimension: tarif_ht_livraison {
    type: number
    sql: ${TABLE}.Tarif_HT_livraison ;;
  }

  dimension: tarif_ttc_livraison {
    type: number
    sql: ${TABLE}.Tarif_TTC_livraison ;;
  }

  dimension: total_ht {
    type: number
    sql: ${TABLE}.Total_HT ;;
  }

  dimension: total_tt {
    type: number
    sql: ${TABLE}.Total_TT ;;
  }

  dimension: type_de_livraison {
    type: string
    sql: ${TABLE}.Type_de_livraison ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: sum_total_ht {
    type: sum
    sql: ${total_ht}  ;;
  }

  filter: filter_date {                 ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période drive n"
    type: date_time
  }

  filter: filter_date_1 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période drive n-1"
    type: date_time
  }

  filter: filter_date_2 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période drive n-2"
    type: date_time
  }

  measure: sum_CA_drive {
    type: sum
    value_format_name: eur
    label: "CA Drive"
    sql: CASE
            WHEN {% condition filter_date %}  CAST(${date_de_commande_date} AS TIMESTAMP) {% endcondition %}
            THEN ${total_ht}
          END ;;
  }

  #measure: sum_quantite_commandee {
  #  type: sum
  #  sql: CASE
  #          WHEN {% condition date_filter %} CAST(${date_de_commande_date} AS TIMESTAMP)   {% endcondition %}
  #          THEN ${quantite_commandee}
  #        END ;;
  #}

  measure: sum_CA_drive_N1 {
    type: sum
    value_format_name: eur
    label: "CA Drive n-1"
    sql: CASE
            WHEN {% condition filter_date_1 %} CAST(${date_de_commande_date} AS TIMESTAMP)   {% endcondition %}
            THEN ${total_ht}
          END ;;
  }

  measure: sum_CA_drive_N2 {
    type: sum
    value_format_name: eur
    label: "CA Drive n-2"
    sql: CASE
            WHEN {% condition filter_date_2 %} CAST(${date_de_commande_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${total_ht}
          END ;;
  }

  #measure: panier_moyen_drive {
  #  label: "PM Drive"
  #  value_format_name: decimal_2
  #  type: number
  #  sql:  ${sum_CA_drive}/NULLIF(${sum_quantite_commandee},0) ;;
  #}

  measure: prog_CA_drive {
    label: "prog CA Drive"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_CA_drive}-${sum_CA_drive_N1})/NULLIF(${sum_CA_drive_N1},0);;
  }

  #measure: sum_CA_drive_select_mois_N1 {
  #  type: sum
  #  value_format_name: eur
  #  label: "CA Drive n-1"
  #  sql: CASE
  #          WHEN {% condition date_filter_1 %} CAST(${dv_web.date_de_commande_date} AS TIMESTAMP)  {% endcondition %}
  #          THEN ${dv_web.total_ht}
  #        END ;;
  #}

  #measure: prog_CA_drive_select_mois_N2 {
  #  label: "prog CA Drive n-2"
  #  value_format_name: percent_2
  #  type: number
  #  sql: 1.0 * (${sum_CA_drive_select_mois_N2}-${sum_CA_drive_select_mois_N3})/NULLIF(${sum_CA_drive_select_mois_N3},0);;
  #}
}
