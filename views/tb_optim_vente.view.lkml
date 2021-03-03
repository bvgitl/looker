view: tb_optim_vente {
  sql_table_name: `ods.tb_optim_vente`
    ;;

  dimension: an_sem {
    type: string
    sql: ${TABLE}.an_sem ;;
  }

  dimension: annee {
    type: string
    sql: ${TABLE}.annee ;;
  }

  dimension: ca_ht {
    type: number
    sql: ${TABLE}.ca_ht ;;
  }

  dimension: ca_net {
    type: number
    sql: ${TABLE}.ca_net ;;
  }

  dimension: cd_pays {
    type: string
    sql: ${TABLE}.cd_pays ;;
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

  dimension: id_magasin {
    type: number
    sql: ${TABLE}.id_magasin ;;
  }

  dimension: jour {
    type: string
    sql: ${TABLE}.jour ;;
  }

  dimension: marge_brute {
    type: number
    sql: ${TABLE}.marge_brute ;;
  }

  dimension: mois {
    type: string
    sql: ${TABLE}.mois ;;
  }

  dimension: nb_ticket {
    type: number
    sql: ${TABLE}.nb_ticket ;;
  }

  dimension: num_jour {
    type: string
    sql: ${TABLE}.num_jour ;;
  }

  dimension: qtite {
    type: number
    sql: ${TABLE}.qtite ;;
  }

  dimension: qtite_uvc {
    type: number
    sql: ${TABLE}.qtite_uvc ;;
  }

  dimension: typ_vente {
    type: number
    sql: ${TABLE}.typ_vente ;;
  }

  dimension: val_achat_gbl {
    type: number
    sql: ${TABLE}.val_achat_gbl ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
