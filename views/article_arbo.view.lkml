view: article_arbo {
  sql_table_name: `ods.article_arbo`
    ;;

  dimension: id_arbo {
    type: number
    sql: ${TABLE}.ID_ARBO ;;
  }

  dimension: id_art_arbo {
    type: number
    sql: ${TABLE}.ID_ART_ARBO ;;
  }

  dimension: id_article {
    type: number
    sql: ${TABLE}.ID_ARTICLE ;;
  }

  dimension: id_n4_n4 {
    type: number
    sql: ${TABLE}.ID_N4_N4 ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
