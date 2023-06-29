view: stock_dwh_histo {
  sql_table_name: `bv-prod.Matillion_Perm_Table.Stock_DWH_Histo`
    ;;

  dimension: cd_acteur {
    type: string
    sql: ${TABLE}.cd_acteur ;;
  }

  dimension: cd_article {
    type: number
    sql: ${TABLE}.cd_article ;;
  }

  dimension: cd_statut {
    type: string
    sql: ${TABLE}.cd_statut ;;
  }

  dimension: n_stock {
    type: number
    sql: ${TABLE}.n_stock ;;
  }

  dimension_group: scd_date_debut {
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
    sql: ${TABLE}.ScdDateDebut ;;
  }

  dimension_group: scd_date_fin {
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
    sql: ${TABLE}.ScdDateFin ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  filter: date_filter {                 ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Date N"
    type: date
    view_label: "Période"
  }

  dimension: is_in_date_filter  {
    type: yesno
    hidden: yes
    sql: ${TABLE}.ScdDateDebut <= CAST ({% date_start date_filter %} AS DATETIME)
           AND ${TABLE}.ScdDateFin   >  CAST ({% date_start date_filter %} AS DATETIME)
           ;;
  }

  measure: n_stock_date_filter {
    type: sum
    sql: ${TABLE}.n_stock ;;
    filters: [is_in_date_filter: "yes"]
  }
}
