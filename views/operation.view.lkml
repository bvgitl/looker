view: operation {
  sql_table_name: `bv-prod.cor.operation` ;;

  dimension: c_article {
    type: number
    sql: ${TABLE}.c_article ;;
  }
  dimension: c_campagne {
    type: number
    sql: ${TABLE}.c_campagne ;;
  }
  dimension: c_devise {
    type: string
    sql: ${TABLE}.c_devise ;;
  }
  dimension: c_enseigne {
    type: string
    sql: ${TABLE}.c_enseigne ;;
  }
  dimension: c_etat {
    type: number
    sql: ${TABLE}.c_etat ;;
  }
  dimension: c_fournisseur {
    type: number
    sql: ${TABLE}.c_fournisseur ;;
  }
  dimension: c_locale {
    type: string
    sql: ${TABLE}.c_locale ;;
  }
  dimension: c_operation {
    type: number
    sql: ${TABLE}.c_operation ;;
  }
  dimension: c_territoire {
    type: string
    sql: ${TABLE}.c_territoire ;;
  }
  dimension: c_type {
    type: string
    sql: ${TABLE}.c_type ;;
  }
  dimension_group: d_creation {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.d_creation ;;
  }
  dimension_group: d_debut {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.d_debut ;;
  }
  dimension_group: d_fin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.d_fin ;;
  }
  dimension_group: d_modification {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.d_modification ;;
  }
  dimension_group: d_operation_debut {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.d_operation_debut ;;
  }
  dimension_group: d_operation_fin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.d_operation_fin ;;
  }
  dimension: l_article {
    type: string
    sql: ${TABLE}.l_article ;;
  }
  dimension: l_campagne {
    type: string
    sql: ${TABLE}.l_campagne ;;
  }
  dimension: l_devise {
    type: string
    sql: ${TABLE}.l_devise ;;
  }
  dimension: l_enseigne {
    type: string
    sql: ${TABLE}.l_enseigne ;;
  }
  dimension: l_etat {
    type: string
    sql: ${TABLE}.l_etat ;;
  }
  dimension: l_fournisseur {
    type: string
    sql: ${TABLE}.l_fournisseur ;;
  }
  dimension: l_operation {
    type: string
    sql: ${TABLE}.l_operation ;;
  }
  dimension: l_territoire {
    type: string
    sql: ${TABLE}.l_territoire ;;
  }
  dimension: l_type {
    type: string
    sql: ${TABLE}.l_type ;;
  }
  dimension: u_creation {
    type: string
    sql: ${TABLE}.u_creation ;;
  }
  dimension: u_modification {
    type: string
    sql: ${TABLE}.u_modification ;;
  }
  measure: count {
    type: count
  }
}
