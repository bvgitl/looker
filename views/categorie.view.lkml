view: categorie {
  sql_table_name: `bv-prod.cor.categorie` ;;

  dimension: c_categorie {
    type: number
    sql: ${TABLE}.c_categorie ;;
  }
  dimension: c_etat {
    type: number
    sql: ${TABLE}.c_etat ;;
  }
  dimension: c_locale {
    type: string
    sql: ${TABLE}.c_locale ;;
  }
  dimension: c_parent {
    type: number
    sql: ${TABLE}.c_parent ;;
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
  dimension: l_categorie {
    type: string
    sql: ${TABLE}.l_categorie ;;
  }
  dimension: l_etat {
    type: string
    sql: ${TABLE}.l_etat ;;
  }
  dimension: l_parent {
    type: string
    sql: ${TABLE}.l_parent ;;
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
