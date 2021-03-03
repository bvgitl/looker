view: ventes_devise {
  sql_table_name: `ods.ventes_devise`
    ;;

  dimension_group: date {
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
    sql: ${TABLE}.date ;;
  }

  dimension: devise {
    type: string
    sql: ${TABLE}.devise ;;
  }

  dimension: magasin {
    type: string
    sql: ${TABLE}.magasin ;;
  }

  dimension: marge {
    type: number
    sql: ${TABLE}.marge ;;
  }

  dimension: montant {
    type: number
    sql: ${TABLE}.montant ;;
  }

  dimension: quantite {
    type: number
    sql: ${TABLE}.quantite ;;
  }

  dimension: tickets {
    type: number
    sql: ${TABLE}.tickets ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
