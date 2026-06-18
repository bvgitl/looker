view: engagement {
  sql_table_name: `bv-prod.cor.engagement` ;;

  dimension: c_campagne {
    type: number
    sql: ${TABLE}.c_campagne ;;
  }
  dimension: c_enseigne {
    type: string
    sql: ${TABLE}.c_enseigne ;;
  }
  dimension: c_etat {
    type: number
    sql: ${TABLE}.c_etat ;;
  }
  dimension: c_locale {
    type: string
    sql: ${TABLE}.c_locale ;;
  }
  dimension: c_magasin {
    type: number
    sql: ${TABLE}.c_magasin ;;
  }
  dimension: c_territoire {
    type: string
    sql: ${TABLE}.c_territoire ;;
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
  dimension_group: d_engagement_debut {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.d_engagement_debut ;;
  }
  dimension_group: d_engagement_fin {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.d_engagement_fin ;;
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
  dimension: l_campagne {
    type: string
    sql: ${TABLE}.l_campagne ;;
  }
  dimension: l_enseigne {
    type: string
    sql: ${TABLE}.l_enseigne ;;
  }
  dimension: l_etat {
    type: string
    sql: ${TABLE}.l_etat ;;
  }
  dimension: l_magasin {
    type: string
    sql: ${TABLE}.l_magasin ;;
  }
  dimension: l_territoire {
    type: string
    sql: ${TABLE}.l_territoire ;;
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
