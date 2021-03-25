view: ventes_devise {
  sql_table_name: `bv-prod.Matillion_Perm_Table.ventes_devise`
    ;;

  dimension: cd_devise {
    type: string
    sql: ${TABLE}.cd_devise ;;
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.cd_magasin ;;
  }

  dimension_group: dte_vente {
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
    sql: ${TABLE}.dte_vente ;;
  }

  dimension: marge {
    type: number
    sql: ${TABLE}.marge ;;
  }

  dimension: montant {
    type: number
    sql: ${TABLE}.montant ;;
  }

  dimension: nb_ticket {
    type: number
    sql: ${TABLE}.nb_ticket ;;
  }

  dimension: quantite {
    type: number
    sql: ${TABLE}.quantite ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
