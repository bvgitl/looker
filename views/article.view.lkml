view: article {
  sql_table_name: `bv-prod.cor.article` ;;

  dimension: c_article {
    type: number
    sql: ${TABLE}.c_article ;;
  }
  dimension: c_enseigne {
    type: string
    sql: ${TABLE}.c_enseigne ;;
  }
  dimension: c_etat {
    type: number
    sql: ${TABLE}.c_etat ;;
  }
  dimension: c_gamme {
    type: number
    sql: ${TABLE}.c_gamme ;;
  }
  dimension: c_locale {
    type: string
    sql: ${TABLE}.c_locale ;;
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
  dimension: l_article {
    type: string
    sql: ${TABLE}.l_article ;;
  }
  dimension: l_enseigne {
    type: string
    sql: ${TABLE}.l_enseigne ;;
  }
  dimension: l_etat {
    type: string
    sql: ${TABLE}.l_etat ;;
  }
  dimension: l_gamme {
    type: string
    sql: ${TABLE}.l_gamme ;;
  }
  dimension: l_marque {
    type: string
    sql: ${TABLE}.l_marque ;;
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
