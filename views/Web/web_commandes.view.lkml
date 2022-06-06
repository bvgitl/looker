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


  ################
  ### Périodes ###
  ################

  filter: date_filter_N {                 ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période N"
    type: date
    group_label: "Périodes"
  }

  filter: date_filter_N1 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période N-1"
    type: date
    group_label: "Périodes"
  }

  filter: date_filter_N2 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période N-2"
    type: date
    group_label: "Périodes"
  }


  #############
  ### CA HT ###
  #############

  measure: ca_ht {
    type: sum_distinct
    value_format_name: eur
    sql_distinct_key: ${cd_commande} ;;
    sql: ${Total_HT} ;;
    label: "CA HT"
  }

  measure: ca_ht_periode_N {
    type: sum_distinct
    value_format_name: eur
    label: "CA HT (N)"
    sql_distinct_key: ${cd_commande} ;;
    sql: CASE
            WHEN {% condition date_filter_N %} CAST(${dte_commande_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${Total_HT}
          END ;;
    group_label: "Périodes"
  }

  measure: ca_ht_periode_N1 {
    label: "CA HT (N-1)"
    type: sum_distinct
    value_format_name: eur
    sql_distinct_key: ${cd_commande} ;;
    sql: CASE
            WHEN {% condition date_filter_N1 %} CAST(${dte_commande_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${Total_HT}
          END ;;
    group_label: "Périodes"
  }

  measure: ca_ht_periode_N2 {
    label: "CA HT (N-2)"
    type: sum_distinct
    value_format_name: eur
    sql_distinct_key: ${cd_commande} ;;
    sql: CASE
            WHEN {% condition date_filter_N2 %} CAST(${dte_commande_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${Total_HT}
          END ;;
    group_label: "Périodes"
  }

  measure: ca_ht_prog_N1_N {
    label: "CA HT (prog N-1 à N)"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${ca_ht_periode_N}-${ca_ht_periode_N1})/NULLIF(${ca_ht_periode_N1},0);;
    group_label: "Périodes"
  }

  measure: ca_ht_prog_N2_N1 {
    label: "CA HT (prog N-2 à N-1)"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${ca_ht_periode_N1}-${ca_ht_periode_N2})/NULLIF(${ca_ht_periode_N2},0);;
    group_label: "Périodes"
  }


  #######################
  ### Frais Livraison ###
  #######################

  measure: frais_livraison_ht {
    type: sum_distinct
    value_format_name: eur
    sql_distinct_key: ${cd_commande} ;;
    sql: ${Tarif_HT_livraison} ;;
    label: "Frais Livraison HT"
  }


  #######################
  ### Nombre Commande ###
  #######################

  measure: nombre_commande {
    type: count_distinct
    sql_distinct_key: ${cd_commande} ;;
    label: "Nombre Commande"
  }

  measure: nombre_commande_periode_N {
    type: count_distinct
    label: "Nombre Commande (N)"
    sql: CASE
            WHEN {% condition date_filter_N %} CAST(${dte_commande_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${cd_commande}
          END ;;
    group_label: "Périodes"
  }

  measure: nombre_commande_periode_N1 {
    label: "Nombre Commande (N-1)"
    type: count_distinct
    sql: CASE
            WHEN {% condition date_filter_N1 %} CAST(${dte_commande_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${cd_commande}
          END ;;
    group_label: "Périodes"
  }

  measure: nombre_commande_periode_N2 {
    label: "Nombre Commande (N-2)"
    type: count_distinct
    sql: CASE
            WHEN {% condition date_filter_N2 %} CAST(${dte_commande_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${cd_commande}
          END ;;
    group_label: "Périodes"
  }

  measure: nombre_commande_prog_N1_N {
    label: "Nombre Commande (prog N-1 à N)"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${nombre_commande_periode_N}-${nombre_commande_periode_N1})/NULLIF(${nombre_commande_periode_N1},0);;
    group_label: "Périodes"
  }

  measure: nombre_commande_prog_N2_N1 {
    label: "Nombre Commande (prog N-2 à N-1)"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${nombre_commande_periode_N1}-${nombre_commande_periode_N2})/NULLIF(${nombre_commande_periode_N2},0);;
    group_label: "Périodes"
  }


  ####################
  ### Panier Moyen ###
  ####################

  measure: panier_moyen {
    type: number
    value_format_name: eur
    sql: ${ca_ht} /  ${nombre_commande} ;;
    label: "Panier Moyen"
  }

  measure: panier_moyen_periode_N {
    type: number
    value_format_name: eur
    label: "Panier Moyen (N)"
    sql: ${ca_ht_periode_N} /  NULLIF(${nombre_commande_periode_N},0) ;;
    group_label: "Périodes"
  }

  measure: panier_moyen_periode_N1 {
    type: number
    value_format_name: eur
    label: "Panier Moyen (N-1)"
    sql: ${ca_ht_periode_N1} /  NULLIF(${nombre_commande_periode_N1},0) ;;
    group_label: "Périodes"
  }

  measure: panier_moyen_periode_N2 {
    type: number
    value_format_name: eur
    label: "Panier Moyen (N-2)"
    sql: ${ca_ht_periode_N2} /  NULLIF(${nombre_commande_periode_N2},0) ;;
    group_label: "Périodes"
  }

  measure: panier_moyen_prog_N1_N {
    label: "Panier Moyen (prog N-1 à N)"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${panier_moyen_periode_N}-${panier_moyen_periode_N1})/NULLIF(${panier_moyen_periode_N1},0);;
    group_label: "Périodes"
  }

  measure: panier_moyen_prog_N2_N1 {
    label: "Panier Moyen (prog N-2 à N-1)"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${panier_moyen_periode_N1}-${panier_moyen_periode_N2})/NULLIF(${panier_moyen_periode_N2},0);;
    group_label: "Périodes"
  }


}
