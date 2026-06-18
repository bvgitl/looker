view: article_fournisseur {
  sql_table_name: `bv-prod.cor.article_fournisseur` ;;

  dimension: b_fournisseur {
    type: number
    sql: ${TABLE}.b_fournisseur ;;
  }
  dimension: c_article {
    type: number
    sql: ${TABLE}.c_article ;;
  }
  dimension: c_devise {
    type: string
    sql: ${TABLE}.c_devise ;;
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
  dimension: l_devise {
    type: string
    sql: ${TABLE}.l_devise ;;
  }
  dimension: l_etat {
    type: string
    sql: ${TABLE}.l_etat ;;
  }
  dimension: l_fournisseur {
    type: string
    sql: ${TABLE}.l_fournisseur ;;
  }
  dimension: l_territoire {
    type: string
    sql: ${TABLE}.l_territoire ;;
  }
  dimension: m_pa {
    type: number
    sql: ${TABLE}.m_pa ;;
  }
  dimension: n_pcb {
    type: number
    sql: ${TABLE}.n_pcb ;;
  }
  dimension: r_fournisseur {
    type: string
    sql: ${TABLE}.r_fournisseur ;;
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
