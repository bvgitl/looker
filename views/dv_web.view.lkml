view: dv_web {
  derived_table: {
    sql: select
        code_commande,
        code_magasin,
        date_de_commande,
          sum(c.total_ht) as total_ht
          from ods.dig_commandes
          group by 1,2
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: code_commande {
    type: number
    primary_key: yes
    sql: ${TABLE}.code_commande ;;
  }

  dimension: code_magasin {
    type: string
    sql: ${TABLE}.code_magasin ;;
  }

  dimension: total_ht {
    type: number
    sql: ${TABLE}.total_ht ;;
  }

  #dimension: quantite_commandee {
  #  type: number
  #  sql: ${TABLE}.Quantite_commandee ;;
  #}

  dimension_group: date_de_commande {
    type: time
    timeframes: [date, week, week_of_year ,month, month_name , year, raw, fiscal_month_num, fiscal_quarter, fiscal_quarter_of_year, fiscal_year]
    datatype: timestamp
    sql: ${TABLE}.date_de_commande ;;
  }

  measure: sum_total_ht {
    type: sum
    sql: ${total_ht}  ;;
  }

  filter: date_filter {                 ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période drive n"
    type: date
  }

  filter: date_filter_1 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période drive n-1"
    type: date
  }

  filter: date_filter_2 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période drive n-2"
    type: date
  }

  measure: sum_CA_drive {
    type: sum
    value_format_name: eur
    label: "CA Drive"
    sql: CASE
            WHEN {% condition date_filter %}  CAST(${date_de_commande_date} AS TIMESTAMP) {% endcondition %}
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
            WHEN {% condition date_filter_1 %} CAST(${date_de_commande_date} AS TIMESTAMP)   {% endcondition %}
            THEN ${total_ht}
          END ;;
  }

  measure: sum_CA_drive_N2 {
    type: sum
    value_format_name: eur
    label: "CA Drive n-2"
    sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${date_de_commande_date} AS TIMESTAMP)  {% endcondition %}
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


  set: detail {
    fields: [code_commande, code_magasin, total_ht]
  }

}
